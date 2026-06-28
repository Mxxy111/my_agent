# my_agent

Personal agent configuration backup for Codex, Claude Code, shared `.agents`
skills/plugins, and selected Cherry Studio user settings.

The sync is intentionally whitelist-based. It copies the paths listed in
`sync.sources.json` into `snapshot/`, scans the copied text files for
credential-like values, commits changes, and optionally pushes them.

## First run

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-agent-settings.ps1 -Push
```

## Daily use

Run without `-Push` to make a local commit only:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-agent-settings.ps1
```

Run with `-DryRun` to see what would be copied:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-agent-settings.ps1 -DryRun
```

## Synced by default

- `%USERPROFILE%\.agents\skills`
- `%USERPROFILE%\.agents\plugins`
- `%USERPROFILE%\.agents\.skill-lock.json`
- `%USERPROFILE%\.codex\skills`, excluding bundled/system skills
- `%USERPROFILE%\.codex\rules`
- `%USERPROFILE%\.codex\config.toml`
- `%USERPROFILE%\.codex\AGENTS.md`
- `%USERPROFILE%\.codex\plugins\cache\local`
- `%USERPROFILE%\.claude\settings.json`
- `%USERPROFILE%\.claude\config.json`
- Selected Cherry Studio config, agents, and skills

## Not synced by default

Auth files, credentials, sessions, shell history, logs, sqlite databases, browser
caches, Electron storage, and other runtime state are excluded. If the secret
scanner finds something suspicious in `snapshot/`, the script stops before
commit/push.

To add a new source, edit `sync.sources.json` and run the script again.
