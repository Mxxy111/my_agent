[CmdletBinding()]
param(
    [switch]$Push,
    [switch]$NoCommit,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$ConfigPath = Join-Path $RepoRoot 'sync.sources.json'

if (-not (Test-Path -LiteralPath $ConfigPath)) {
    throw "Missing sync config: $ConfigPath"
}

$Config = Get-Content -Raw -LiteralPath $ConfigPath | ConvertFrom-Json
$SnapshotRoot = Join-Path $RepoRoot $Config.snapshotRoot

function Get-FullPath {
    param([Parameter(Mandatory)][string]$Path)
    return [System.IO.Path]::GetFullPath($Path)
}

function Expand-ConfiguredPath {
    param([Parameter(Mandatory)][string]$Path)
    return [Environment]::ExpandEnvironmentVariables($Path)
}

function Assert-UnderPath {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Root
    )

    $fullPath = Get-FullPath $Path
    $fullRoot = (Get-FullPath $Root).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar

    if (-not $fullPath.StartsWith($fullRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to write outside snapshot root. Path: $fullPath Root: $fullRoot"
    }
}

function Get-RepoRelativePath {
    param([Parameter(Mandatory)][string]$Path)

    $fullPath = Get-FullPath $Path
    $fullRoot = (Get-FullPath $RepoRoot).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar

    if ($fullPath.StartsWith($fullRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $fullPath.Substring($fullRoot.Length).Replace('\', '/')
    }

    return $fullPath
}

function Invoke-Git {
    param([Parameter(Mandatory)][string[]]$Arguments)

    & git -C $RepoRoot @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
    }
}

function Ensure-Branch {
    $branch = (& git -C $RepoRoot branch --show-current).Trim()
    if (-not $branch) {
        Invoke-Git @('switch', '-C', 'main')
        $branch = 'main'
    }
    return $branch
}

function Copy-ConfiguredFile {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$Name
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        Write-Warning "Skipping missing file source '$Name': $Source"
        return
    }

    Assert-UnderPath -Path $Destination -Root $SnapshotRoot

    if ($DryRun) {
        Write-Host "[dry-run] file $Source -> $Destination"
        return
    }

    $parent = Split-Path -Parent $Destination
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Destination -Force
}

function Copy-ConfiguredDirectory {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$Name,
        [string[]]$ExcludeDirectories = @(),
        [string[]]$ExcludeFiles = @()
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Container)) {
        Write-Warning "Skipping missing directory source '$Name': $Source"
        return
    }

    Assert-UnderPath -Path $Destination -Root $SnapshotRoot

    $defaultExcludeDirectories = @(
        '.git',
        '.hg',
        '.svn',
        '__pycache__',
        '.pytest_cache',
        '.mypy_cache',
        '.ruff_cache',
        '.venv',
        'venv',
        'node_modules'
    )
    $effectiveExcludeDirectories = @($defaultExcludeDirectories + $ExcludeDirectories | Select-Object -Unique)

    if ($DryRun) {
        Write-Host "[dry-run] directory $Source -> $Destination"
        return
    }

    New-Item -ItemType Directory -Force -Path $Destination | Out-Null

    $robocopyArgs = @(
        $Source,
        $Destination,
        '/MIR',
        '/COPY:DAT',
        '/DCOPY:DAT',
        '/R:2',
        '/W:2',
        '/NFL',
        '/NDL',
        '/NP'
    )

    if ($effectiveExcludeDirectories.Count -gt 0) {
        $robocopyArgs += '/XD'
        $robocopyArgs += $effectiveExcludeDirectories
    }

    if ($ExcludeFiles.Count -gt 0) {
        $robocopyArgs += '/XF'
        $robocopyArgs += $ExcludeFiles
    }

    & robocopy @robocopyArgs | Out-Null
    $exitCode = $LASTEXITCODE

    if ($exitCode -ge 8) {
        throw "robocopy failed for '$Name' with exit code $exitCode"
    }
}

function Redact-SecretTextFile {
    param([Parameter(Mandatory)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return
    }

    $text = Get-Content -Raw -LiteralPath $Path -ErrorAction SilentlyContinue
    if ($null -eq $text) {
        return
    }

    $redactions = @(
        @{ Regex = '(?i)\bsk-(proj-|ant-)?[A-Za-z0-9_-]{20,}\b'; Replacement = '[REDACTED_SECRET]' },
        @{ Regex = '\b(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9_]{20,}\b'; Replacement = '[REDACTED_SECRET]' },
        @{ Regex = '\bgithub_pat_[A-Za-z0-9_]{20,}\b'; Replacement = '[REDACTED_SECRET]' },
        @{ Regex = '\bAKIA[0-9A-Z]{16}\b'; Replacement = '[REDACTED_SECRET]' },
        @{ Regex = '\bAIza[0-9A-Za-z_-]{30,}\b'; Replacement = '[REDACTED_SECRET]' },
        @{ Regex = '\bxox[baprs]-[A-Za-z0-9-]{20,}\b'; Replacement = '[REDACTED_SECRET]' },
        @{ Regex = '(?i)(Bearer\s+)[A-Za-z0-9._~-]{30,}\b'; Replacement = '${1}[REDACTED_SECRET]' }
    )

    foreach ($redaction in $redactions) {
        $text = [regex]::Replace($text, $redaction.Regex, $redaction.Replacement)
    }

    Set-Content -LiteralPath $Path -Value $text -Encoding UTF8
}

function Test-IsAllowedSecretFixture {
    param([Parameter(Mandatory)][string]$Text)

    return $Text -match '(?i)(should-not-appear|placeholder|dummy|example|changeme|your[_-]?(api[_-]?)?key|your[_-]?token|sk-test|token123)'
}

function Test-SnapshotSecrets {
    if (-not (Test-Path -LiteralPath $SnapshotRoot)) {
        return
    }

    $textExtensions = @(
        '.bat', '.cmd', '.conf', '.css', '.env', '.ini', '.json', '.jsonl',
        '.md', '.mjs', '.ps1', '.py', '.rs', '.sh', '.toml', '.ts', '.tsx',
        '.txt', '.yaml', '.yml'
    )

    $patterns = @(
        @{ Name = 'OpenAI/Anthropic style key'; Regex = '(?i)\bsk-(proj-|ant-)?[A-Za-z0-9_-]{20,}\b' },
        @{ Name = 'GitHub token'; Regex = '\b(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9_]{20,}\b|\bgithub_pat_[A-Za-z0-9_]{20,}\b' },
        @{ Name = 'AWS access key'; Regex = '\bAKIA[0-9A-Z]{16}\b' },
        @{ Name = 'Google API key'; Regex = '\bAIza[0-9A-Za-z_-]{30,}\b' },
        @{ Name = 'Slack token'; Regex = '\bxox[baprs]-[A-Za-z0-9-]{20,}\b' },
        @{ Name = 'Bearer token'; Regex = '(?i)\bBearer\s+[A-Za-z0-9._~-]{30,}\b' },
        @{ Name = 'Named secret assignment'; Regex = '(?i)(api[_-]?key|access[_-]?token|refresh[_-]?token|secret|password|authorization)["''\s]*[:=]\s*["'']?[A-Za-z0-9._~+/=-]{20,}' }
    )

    $files = Get-ChildItem -LiteralPath $SnapshotRoot -File -Recurse -Force |
        Where-Object { $textExtensions -contains $_.Extension.ToLowerInvariant() }

    foreach ($file in $files) {
        $text = Get-Content -Raw -LiteralPath $file.FullName -ErrorAction SilentlyContinue
        if ($null -eq $text) {
            continue
        }

        foreach ($pattern in $patterns) {
            $matches = [regex]::Matches($text, $pattern.Regex)
            foreach ($match in $matches) {
                $hit = $match.Value
                if (Test-IsAllowedSecretFixture $hit) {
                    continue
                }

                if ($pattern.Name -eq 'Named secret assignment') {
                    $isSecretReference = $hit -match '\$\{\{\s*secrets\.'
                    $isEnvironmentReference = $hit -match '(?i)(process\.env|os\.environ|env\.|\$env:|\$\{|\$[A-Za-z_][A-Za-z0-9_]*|%[A-Za-z_][A-Za-z0-9_]*%)'

                    if ($isSecretReference -or $isEnvironmentReference) {
                        continue
                    }
                }

                $relative = Get-RepoRelativePath $file.FullName
                throw "Secret scan stopped the sync. Pattern '$($pattern.Name)' matched in $relative"
            }
        }
    }
}

function Write-Manifest {
    if ($DryRun) {
        return
    }

    New-Item -ItemType Directory -Force -Path $SnapshotRoot | Out-Null

    $manifest = [ordered]@{
        generatedAt = (Get-Date).ToString('o')
        computer = $env:COMPUTERNAME
        user = $env:USERNAME
        sources = @($Config.sources | ForEach-Object {
            [ordered]@{
                name = $_.name
                kind = $_.kind
                source = $_.source
                target = $_.target
            }
        })
    }

    $manifestPath = Join-Path $SnapshotRoot 'MANIFEST.json'
    $manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
}

function Invoke-Sync {
    New-Item -ItemType Directory -Force -Path $SnapshotRoot | Out-Null

    foreach ($sourceConfig in $Config.sources) {
        $name = [string]$sourceConfig.name
        $kind = [string]$sourceConfig.kind
        $source = Expand-ConfiguredPath ([string]$sourceConfig.source)
        $destination = Join-Path $SnapshotRoot ([string]$sourceConfig.target)

        $excludeDirectories = @()
        if ($sourceConfig.PSObject.Properties.Name -contains 'excludeDirectories') {
            $excludeDirectories = @($sourceConfig.excludeDirectories | ForEach-Object { [string]$_ })
        }

        $excludeFiles = @()
        if ($sourceConfig.PSObject.Properties.Name -contains 'excludeFiles') {
            $excludeFiles = @($sourceConfig.excludeFiles | ForEach-Object { [string]$_ })
        }

        switch ($kind) {
            'file' {
                Copy-ConfiguredFile -Source $source -Destination $destination -Name $name
                if (($sourceConfig.PSObject.Properties.Name -contains 'redactSecrets') -and [bool]$sourceConfig.redactSecrets) {
                    Redact-SecretTextFile -Path $destination
                }
            }
            'directory' {
                Copy-ConfiguredDirectory -Source $source -Destination $destination -Name $name -ExcludeDirectories $excludeDirectories -ExcludeFiles $excludeFiles
            }
            default {
                throw "Unknown source kind '$kind' for '$name'"
            }
        }
    }

    Write-Manifest

    if ($DryRun) {
        Write-Host 'Dry run finished. No files were changed.'
        return
    }

    Test-SnapshotSecrets

    if ($NoCommit) {
        Write-Host 'Sync finished. Skipping git commit because -NoCommit was supplied.'
        return
    }

    $branch = Ensure-Branch
    Invoke-Git @('add', '.')

    $status = (& git -C $RepoRoot status --porcelain)
    if (-not $status) {
        Write-Host 'No changes to commit.'
        return
    }

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Invoke-Git @('commit', '-m', "Sync agent settings $timestamp")

    if ($Push) {
        Invoke-Git @('push', '-u', 'origin', $branch)
    }
}

Invoke-Sync
