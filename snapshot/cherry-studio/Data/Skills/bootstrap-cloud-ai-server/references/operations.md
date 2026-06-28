# Operations

## Contents

1. Daily commands
2. Updates
3. Backups
4. Service control
5. Removal

## Daily commands

```bash
codex
claude
cc-switch
clashtui
```

Recommended proxy mode:

```bash
clashtui mode rule
```

Inspect:

```bash
systemctl status clashtui_mihomo
journalctl -u clashtui_mihomo -f
clashtui profile list
clashtui profile update --all
curl -s https://www.cloudflare.com/cdn-cgi/trace | grep -E '^(ip|loc)='
```

## Updates

User-owned installations should update without sudo:

```bash
claude update
cc-switch update
```

Codex standalone updates through its installed updater/installer. If needed, rerun:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

Check versions:

```bash
claude --version
codex --version
cc-switch --version
clashtui --version
/opt/clashtui/mihomo/mihomo -v
```

For ClashTui/Mihomo, review upstream release notes before rerunning the installer because config/database formats can change.

## Backups

Back up configuration, not caches or session logs by default:

```bash
tar -C "$HOME" -czf "ai-config-$(date +%Y%m%d-%H%M%S).tar.gz" \
  .codex/config.toml \
  .codex/auth.json \
  .claude/settings.json \
  .claude.json \
  .cc-switch \
  .config/clashtui
```

Treat the archive as a secret and set mode 0600.

## Service control

```bash
sudo systemctl enable --now clashtui_mihomo
sudo systemctl restart clashtui_mihomo
sudo systemctl stop clashtui_mihomo
```

Stopping Mihomo can briefly delay DNS while systemd-resolved falls back to upstream DNS.

In ClashTui, `q` exits the TUI without stopping Mihomo. Use CoreSrvCtl or systemctl to stop the service.

## Removal

Do not delete config when only replacing binaries.

User binaries:

```bash
rm -f ~/.local/bin/codex ~/.local/bin/claude ~/.local/bin/cc-switch
```

Remove config only with explicit user confirmation:

```text
~/.codex
~/.claude
~/.claude.json
~/.cc-switch
~/.config/clashtui
```

Use the ClashTui upstream uninstall path for `/opt/clashtui` and its systemd units.
