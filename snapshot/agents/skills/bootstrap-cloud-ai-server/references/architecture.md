# Architecture and decisions

## Contents

1. Target layout
2. Installation ownership
3. Network flow
4. Execution phases
5. Deliberate exclusions

## Target layout

```text
~/.local/bin/
  codex
  claude
  cc-switch

~/.codex/             Codex login, config, skills, plugins, MCP state
~/.claude/            Claude Code state and plugins
~/.claude.json        Claude Code user configuration
~/.cc-switch/         cc-switch database and backups
~/.config/clashtui/   ClashTui user profiles and overrides

/opt/clashtui/        Mihomo and ClashTui system installation
/etc/systemd/system/  Mihomo service link/drop-ins
/etc/systemd/resolved.conf.d/60-mihomo.conf

~/projects/           source code and experiments
/srv/                 production runtime and persistent service data
```

Keep development sources under `~/projects`. Keep deployed/runtime data under `/srv`. Keep AI-tool configuration in the user's home directory.

## Installation ownership

Codex, Claude Code, and cc-switch are user tools. Install them under `~/.local/bin` so they can update without root and preserve state independently of the executable.

Mihomo TUN needs network capabilities and a system service, so ClashTui installs it under `/opt/clashtui` with a dedicated `mihomo` user/group. Run the installer as the SSH user; let the installer invoke sudo.

## Network flow

Recommended steady state:

```text
application
  -> system DNS (127.0.0.53)
  -> Mihomo DNS (127.0.0.1:1053)
  -> Fake-IP answer
  -> TUN interface
  -> Rule mode
      -> CN/private traffic DIRECT
      -> selected foreign traffic proxy node
```

Loopback-only management ports:

- `127.0.0.1:7890`: mixed HTTP/SOCKS proxy
- `127.0.0.1:9090`: Mihomo controller
- `127.0.0.1:1053`: Mihomo DNS

Rule mode is the default because it preserves fast domestic access. Global mode is valid only when the `GLOBAL` group selects an actual proxy, not `DIRECT`.

## Execution phases

1. Read-only audit
2. Base packages and directories
3. User-level AI CLIs
4. Interactive authentication
5. Mihomo/ClashTui without TUN
6. Subscription and explicit proxy verification
7. TUN/DNS with timed rollback
8. End-to-end verification

Each phase must be independently verifiable. Never combine first-time TUN activation with SSH hardening or firewall changes.

## Deliberate exclusions

- No API keys or subscription URLs embedded in the skill
- No automatic SSH daemon hardening
- No automatic UFW activation
- No Docker installation unless the user requests it
- No copying of `auth.json` or other credentials without explicit authorization
- No third-party GitHub mirrors by default
