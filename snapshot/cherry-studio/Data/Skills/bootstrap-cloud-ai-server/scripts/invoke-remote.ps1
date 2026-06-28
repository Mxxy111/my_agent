[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$HostAlias,

    [Parameter(Mandatory = $true)]
    [string]$ScriptPath,

    [string[]]$ArgumentList = @(),

    [switch]$Interactive
)

$ErrorActionPreference = "Stop"

$resolved = (Resolve-Path -LiteralPath $ScriptPath).Path
$bytes = [System.IO.File]::ReadAllBytes($resolved)
$encoded = [Convert]::ToBase64String($bytes)

function Quote-BashArgument([string]$Value) {
    return "'" + $Value.Replace("'", "'""'""'") + "'"
}

$quotedArgs = ($ArgumentList | ForEach-Object { Quote-BashArgument $_ }) -join " "
$remoteCommand = "printf '%s' '$encoded' | base64 -d | bash -s -- $quotedArgs"

$sshArgs = @()
if (-not $Interactive) {
    $sshArgs += @("-o", "BatchMode=yes")
}
$sshArgs += @($HostAlias, $remoteCommand)

& ssh @sshArgs
exit $LASTEXITCODE
