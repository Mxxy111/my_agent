---
name: bootstrap-cloud-ai-server
description: Provision, migrate, repair, or audit a fresh Ubuntu cloud server for AI coding work. Use when Codex needs to configure SSH-accessed Ubuntu 22.04/24.04 with safe base packages and workspace directories; install user-owned Codex CLI, Claude Code, and cc-switch CLI; install Mihomo plus ClashTui; import a private Clash/Mihomo subscription; configure Rule-mode TUN and DNS without breaking SSH; preserve existing ~/.codex, ~/.claude, and ~/.cc-switch state; or diagnose proxy, DNS, OAuth, root-owned npm, and MCP connectivity problems.
---

# Bootstrap Cloud AI Server

Build the server in reversible phases. Never paste credentials, subscription tokens, API keys, OAuth caches, or private keys into chat, command arguments, logs, or source control.

## Supported target

- Ubuntu 22.04 or 24.04 with systemd, OpenSSH, and passwordless or interactive sudo
- x86_64 or arm64
- A non-root SSH user
- A control machine that can reconnect if networking changes

For layout and design decisions, read [references/architecture.md](references/architecture.md). For secrets and login pauses, read [references/credentials-and-auth.md](references/credentials-and-auth.md).

## Workflow

### 1. Establish control and inventory

1. Identify the SSH alias or `user@host`.
2. Keep the current SSH session open during network changes.
3. Run `scripts/preflight.sh` remotely.
4. Record existing paths, versions, services, configs, DNS, routes, and open SSH connections.
5. Stop if the target is root, unsupported, lacks sudo, or has unrelated user changes that would be overwritten.

Use `scripts/invoke-remote.ps1` from Windows when PowerShell quoting would otherwise expand Bash variables.

### 2. Solve bootstrap connectivity first

Test normal access to GitHub, GitHub release assets, OpenAI, Anthropic, and the subscription host.

If ordinary pages work but GitHub release assets fail, use a temporary reverse SSH tunnel to a trusted proxy on the control machine. Example:

```powershell
ssh -N -R 127.0.0.1:17890:127.0.0.1:7890 cloud-server
```

Then set `BOOTSTRAP_PROXY=http://127.0.0.1:17890` only for installation commands. Bind the remote side to `127.0.0.1`; never expose it publicly. Remove the tunnel after Mihomo works. See [references/troubleshooting.md](references/troubleshooting.md).

### 3. Apply base initialization

Run `scripts/bootstrap-base.sh` before enabling Fake-IP/TUN.

The script installs small operational dependencies, configures the requested timezone, and creates:

```text
~/projects/{sites,apps,agents,experiments}
/srv/{sites,apps,agents,data,backups}
```

Do not change SSH authentication or firewall rules automatically. Audit them, then make such changes only with explicit authorization and a second verified SSH session.

### 4. Install AI CLIs as the normal user

Run `scripts/install-ai-clis.sh`.

Required installation model:

- Claude Code native installation in `~/.local/bin`
- Codex standalone installation in `~/.local/bin`
- cc-switch official user installation in `~/.local/bin`; if auditing an older server that intentionally keeps `/usr/local/bin/cc-switch`, use `verify-stack.sh --allow-system-cc-switch`, but prefer user-owned installs for new servers
- `bubblewrap` from the OS package manager

Never install Codex or Claude Code with `sudo npm install -g`. Preserve `~/.codex`, `~/.claude`, `~/.claude.json`, and `~/.cc-switch`. Remove old root-owned npm installations only after the user-owned commands and authentication state pass verification.

### 5. Pause for authentication and provider secrets

Ask the user to complete interactive login in their own terminal:

```bash
codex login --device-auth
claude
cc-switch
```

Use cc-switch TUI for provider/API-key entry. Do not request keys in chat. Validate with:

```bash
cc-switch env tools
cc-switch --app claude env check
cc-switch --app claude provider current
```

### 6. Install Mihomo and ClashTui

Run `scripts/install-proxy-stack.sh` as the normal user, not with `sudo`. The upstream installer invokes sudo internally. Install only the Mihomo core unless the user explicitly requests sing-box.

After installation, reconnect SSH so the user receives the new `mihomo` supplementary group. Confirm:

```bash
id -nG | tr ' ' '\n' | grep -x mihomo
```

Do not start TUN yet.

### 7. Import the subscription safely

Have the user create a mode-0600 URL file without echoing the URL:

```bash
install -d -m 700 ~/.config/cloud-ai-bootstrap
read -rsp 'Mihomo subscription URL: ' SUB_URL; echo
printf '%s' "$SUB_URL" > ~/.config/cloud-ai-bootstrap/mihomo-subscription.url
unset SUB_URL
chmod 600 ~/.config/cloud-ai-bootstrap/mihomo-subscription.url
```

Run `scripts/register-clashtui-profile.py` with that file. This helper is intended for a fresh ClashTui profile database and refuses to replace a non-empty database unless explicitly forced. It backs up state, downloads without printing the URL, validates the YAML shape, selects the profile, starts Mihomo without TUN, and verifies the explicit proxy at `127.0.0.1:7890`.

### 8. Enable Rule-mode TUN and DNS with rollback

Run `scripts/configure-tun-dns.sh`.

The script must:

- force `mode: rule`;
- enable Mihomo DNS on `127.0.0.1:1053`;
- enable Fake-IP, TUN, auto-route, interface detection, and DNS hijacking;
- preserve current upstream DNS servers as fallback;
- schedule an automatic systemd rollback before changing routes;
- reselect the ClashTui profile so overrides merge into the active config;
- validate Mihomo syntax before restart;
- cancel rollback only after direct OpenAI/ChatGPT TLS tests succeed.

Never use Global mode with `GLOBAL -> DIRECT` and expect proxying. In Global mode explicitly select a proxy node.

### 9. Verify end to end

Run `scripts/verify-stack.sh`.

Success requires:

- `codex`, `claude`, and `cc-switch` resolve from `~/.local/bin`;
- Codex and Claude Code are not root-owned npm installations;
- `clashtui_mihomo` is enabled and active;
- runtime mode is `rule`, TUN is enabled, and DNS listens on `127.0.0.1:1053`;
- OpenAI returns an expected unauthenticated HTTP response without `curl -x`;
- explicit proxy and transparent TUN paths both work;
- the public egress is outside an unsupported region;
- Codex and Claude login state remain intact;
- private state files remain mode 0600/0700.

Use live one-token CLI tests only after the user has authenticated and accepts account usage.

### 10. Hand off operations

Explain:

```bash
clashtui                       # interactive proxy management
clashtui mode rule             # recommended mode
clashtui profile update --all  # update subscriptions
cc-switch                      # provider/MCP/skill manager
codex                          # Codex CLI
claude                         # Claude Code
```

Give the user backup locations and any remaining warnings. Remove temporary proxy tunnels and secret staging files only after confirming the user no longer needs them.

## Safety rules

- Do not disable password SSH before key login is verified in a second session.
- Do not enable UFW without preserving the active SSH port and checking the cloud security group.
- Do not expose Mihomo `7890`, controller `9090`, DNS `1053`, or a bootstrap tunnel beyond loopback.
- Do not run ClashTui's system installer with `sudo`; doing so places user config under `/root`.
- Do not overwrite an existing ClashTui database, active Mihomo config, or resolved config without timestamped backups.
- Do not claim success from `systemctl active` alone; test TLS and egress.
- Do not interpret OpenAI `401 Missing bearer authentication` as failure; it proves network reachability.
- Do not leave Global mode on `DIRECT`.

## References

- Read [references/operations.md](references/operations.md) for updates, backups, daily commands, and removal.
- Read [references/troubleshooting.md](references/troubleshooting.md) when downloads, DNS, TLS, OAuth, APT, MCP, or SSH fail.
- Read [references/sources.md](references/sources.md) before changing installation URLs or version assumptions.
