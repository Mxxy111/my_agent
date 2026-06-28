# Troubleshooting

## Contents

1. GitHub pages work but release downloads hang
2. OpenAI returns unsupported region
3. TUN is active but TLS fails
4. Global mode bypasses the proxy
5. APT fails with Fake-IP addresses
6. Codex or Claude cannot update
7. ClashTui writes config under root
8. Mihomo group is missing
9. MCP warnings
10. Rollback

## GitHub pages work but release downloads hang

GitHub HTML and `release-assets.githubusercontent.com` can behave differently. Test the exact release URL.

If the control machine has a trusted local proxy, create a loopback-only reverse tunnel:

```powershell
ssh -N -R 127.0.0.1:17890:127.0.0.1:7890 cloud-server
```

On the server:

```bash
curl -x http://127.0.0.1:17890 https://www.google.com/generate_204 -I
export BOOTSTRAP_PROXY=http://127.0.0.1:17890
```

Remove the tunnel after Mihomo succeeds.

## OpenAI returns unsupported region

Mihomo being active only means a proxy port exists. Without TUN or proxy environment variables, a process can still connect directly.

Compare:

```bash
curl https://api.openai.com/v1/models
curl -x http://127.0.0.1:7890 https://api.openai.com/v1/models
```

An unauthenticated `401` is expected and proves reachability.

## TUN is active but TLS fails

Compare DNS:

```bash
getent ahostsv4 api.openai.com | head
dig +short @127.0.0.1 -p 1053 api.openai.com A
resolvectl status
```

With Fake-IP enabled, the system answer should usually be in `198.18.0.0/16`. If Mihomo DNS returns Fake-IP but the system returns public/polluted addresses, systemd-resolved is not using `127.0.0.1:1053`.

## Global mode bypasses the proxy

Inspect:

```bash
curl -s http://127.0.0.1:9090/proxies | jq -r '.proxies.GLOBAL.now'
```

If it says `DIRECT`, Global mode is direct. Switch back:

```bash
clashtui mode rule
```

Or select a real node in the `GLOBAL` group.

## APT fails with Fake-IP addresses

APT and HTTP mirrors can be awkward with Fake-IP. Prefer running base package installation before TUN.

For a one-time install, use an HTTPS Ubuntu source or explicit proxy. Do not permanently replace the user's software sources without permission.

## Codex or Claude cannot update

Check ownership:

```bash
command -v codex claude
readlink -f "$(command -v codex)"
readlink -f "$(command -v claude)"
```

Root-owned `/usr/lib/node_modules` installations cannot self-update as the SSH user. Install user-owned native/standalone versions first, verify login/config, then remove old npm packages.

## ClashTui writes config under root

Cause: the upstream installer was launched with `sudo`.

Run it as the normal user; the installer calls sudo internally. User config must live in `~/.config/clashtui`, not `/root/.config/clashtui`.

## Mihomo group is missing

The installer adds the user to the `mihomo` group, but the current shell may not refresh supplementary groups. Reconnect SSH, then check:

```bash
id -nG
```

## MCP warnings

An MCP server can require separate OAuth even when Codex works:

```bash
codex mcp list
codex mcp login SERVER_NAME
```

Treat `AuthRequired` as an MCP authorization issue, not automatically as a network failure.

## Rollback

Before TUN/DNS changes, retain timestamped backups of:

```text
~/.config/clashtui/mihomo/core_override_config.yaml
/opt/clashtui/mihomo/config/config.yaml
/etc/systemd/resolved.conf.d/60-mihomo.conf
```

The TUN script schedules a transient systemd rollback. Do not cancel it until DNS, direct TLS, explicit proxy, and the current SSH session are all healthy.
