#!/usr/bin/env bash
set -uo pipefail

export PATH="${HOME:-}/.local/bin:$PATH"

fatal=0
proxy_args=()
if [[ -n "${BOOTSTRAP_PROXY:-}" ]]; then
  proxy_args=(--proxy "$BOOTSTRAP_PROXY")
fi

section() {
  printf '\n=== %s ===\n' "$1"
}

curl_probe() {
  local label=$1
  local url=$2
  local result rc
  result=$(curl "${proxy_args[@]}" -L -o /dev/null -sS \
    --connect-timeout 6 --max-time 20 -w '%{http_code}' "$url" 2>&1)
  rc=$?
  printf '%-24s rc=%-3s result=%s\n' "$label" "$rc" "$result"
}

section "IDENTITY"
printf 'user=%s uid=%s home=%s shell=%s\n' \
  "$(id -un)" "$(id -u)" "${HOME:-}" "${SHELL:-}"
id

if [[ $(id -u) -eq 0 ]]; then
  echo "FATAL: run as the normal SSH user, not root."
  fatal=1
fi

if sudo -n true 2>/dev/null; then
  echo "sudo_nopasswd=yes"
else
  echo "sudo_nopasswd=no"
  echo "NOTE: interactive sudo is acceptable, but unattended phases will pause."
fi

section "SYSTEM"
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  printf 'os_id=%s version_id=%s pretty=%s\n' \
    "${ID:-}" "${VERSION_ID:-}" "${PRETTY_NAME:-}"
  if [[ ${ID:-} != ubuntu ]]; then
    echo "FATAL: this skill currently targets Ubuntu."
    fatal=1
  fi
else
  echo "FATAL: /etc/os-release is missing."
  fatal=1
fi

printf 'kernel=%s arch=%s\n' "$(uname -r)" "$(uname -m)"
printf 'systemd='
systemd --version 2>/dev/null | head -n 1 || true
printf 'memory:\n'
free -h
printf 'disk:\n'
df -h / "$HOME" | awk 'NR==1 || !seen[$1]++'
printf 'swap:\n'
swapon --show 2>/dev/null || true

section "SSH AND NETWORK"
printf 'ssh_connection=%s\n' "${SSH_CONNECTION:-not-an-ssh-session}"
ss -tnp 2>/dev/null | awk 'NR==1 || /:22[[:space:]]/' | head -n 20
ip -br addr
ip route | head -n 20
printf 'resolv_conf=%s\n' "$(readlink -f /etc/resolv.conf 2>/dev/null || true)"
resolvectl status 2>/dev/null | sed -n '1,70p' || cat /etc/resolv.conf

section "CONNECTIVITY"
curl_probe "github" "https://github.com"
curl_probe "github-release" "https://github.com/MetaCubeX/mihomo/releases/latest"
curl_probe "codex-installer" "https://chatgpt.com/codex/install.sh"
curl_probe "claude-installer" "https://claude.ai/install.sh"
curl_probe "cc-switch-installer" \
  "https://github.com/SaladDay/cc-switch-cli/releases/latest/download/install.sh"
curl_probe "openai-api" "https://api.openai.com/v1/models"
curl_probe "anthropic-api" "https://api.anthropic.com"

section "EXISTING STACK"
for command_name in codex claude cc-switch clashtui mihomo node npm git jq fzf bwrap; do
  path=$(command -v "$command_name" 2>/dev/null || true)
  printf '%-12s %s\n' "$command_name" "${path:-missing}"
done

codex --version 2>/dev/null || true
claude --version 2>/dev/null || true
cc-switch --version 2>/dev/null || true
clashtui --version 2>/dev/null || true
/opt/clashtui/mihomo/mihomo -v 2>/dev/null || true

if systemctl list-unit-files 2>/dev/null | grep -q '^clashtui_mihomo\.service'; then
  printf 'mihomo_enabled=%s\n' "$(systemctl is-enabled clashtui_mihomo 2>/dev/null || true)"
  printf 'mihomo_active=%s\n' "$(systemctl is-active clashtui_mihomo 2>/dev/null || true)"
fi

section "DIRECTORY OWNERSHIP"
for path in \
  "$HOME/.local/bin" "$HOME/.codex" "$HOME/.claude" "$HOME/.cc-switch" \
  "$HOME/.config/clashtui" /opt/clashtui /srv "$HOME/projects"; do
  if [[ -e $path ]]; then
    stat -c '%A %U:%G %n' "$path"
  fi
done

section "RESULT"
if [[ $fatal -ne 0 ]]; then
  echo "preflight=failed"
  exit 1
fi
echo "preflight=passed"
