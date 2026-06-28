#!/usr/bin/env bash
set -euo pipefail

live=false
allow_system_cc_switch=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --live)
      live=true
      shift
      ;;
    --allow-system-cc-switch)
      allow_system_cc_switch=true
      shift
      ;;
    -h|--help)
      cat <<'EOF'
Usage: verify-stack.sh [--live] [--allow-system-cc-switch]

Verify the cloud AI server stack. --live runs billable/usage-consuming
Codex/Claude one-shot prompts if the user is already authenticated.
By default cc-switch must resolve from ~/.local/bin. Use
--allow-system-cc-switch only when auditing an existing server that deliberately
keeps cc-switch in /usr/local/bin.
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

export PATH="$HOME/.local/bin:$PATH"
failures=0

pass() { printf 'PASS %-28s %s\n' "$1" "${2:-}"; }
fail() { printf 'FAIL %-28s %s\n' "$1" "${2:-}"; failures=$((failures + 1)); }

check_cmd() {
  local name=$1
  local expected_prefix=${2:-}
  local path
  path=$(command -v "$name" 2>/dev/null || true)
  if [[ -z $path ]]; then
    fail "$name" "missing"
    return
  fi
  if [[ -n $expected_prefix && $path != $expected_prefix* ]]; then
    fail "$name" "path=$path expected_prefix=$expected_prefix"
  else
    pass "$name" "$path"
  fi
}

check_cmd codex "$HOME/.local/bin"
check_cmd claude "$HOME/.local/bin"
if $allow_system_cc_switch; then
  check_cmd cc-switch
else
  check_cmd cc-switch "$HOME/.local/bin"
fi
check_cmd clashtui
check_cmd bwrap /usr/bin
check_cmd jq /usr/bin

for c in codex claude cc-switch clashtui; do
  "$c" --version 2>/dev/null | head -n 1 || true
done

if [[ -d /usr/lib/node_modules/@openai/codex || -d /usr/lib/node_modules/@anthropic-ai/claude-code ]]; then
  fail "root npm installs" "old global packages still exist"
else
  pass "root npm installs" "absent"
fi

if [[ -f "$HOME/.codex/auth.json" ]]; then
  mode=$(stat -c '%a' "$HOME/.codex/auth.json")
  [[ $mode == 600 ]] && pass "codex auth perms" "$mode" || fail "codex auth perms" "$mode"
fi
if [[ -d "$HOME/.cc-switch" ]]; then
  mode=$(stat -c '%a' "$HOME/.cc-switch")
  [[ $mode == 700 ]] && pass "cc-switch dir perms" "$mode" || fail "cc-switch dir perms" "$mode"
fi

if systemctl is-active --quiet clashtui_mihomo; then
  pass "mihomo service" "active"
else
  fail "mihomo service" "inactive"
fi
if systemctl is-enabled --quiet clashtui_mihomo 2>/dev/null; then
  pass "mihomo enabled" "enabled"
else
  fail "mihomo enabled" "not enabled"
fi

runtime=$(curl -fsS http://127.0.0.1:9090/configs 2>/dev/null || true)
if [[ -n $runtime ]]; then
  mode=$(jq -r '.mode' <<<"$runtime")
  tun=$(jq -r '.tun.enable' <<<"$runtime")
  [[ $mode == rule ]] && pass "mihomo mode" "$mode" || fail "mihomo mode" "$mode"
  [[ $tun == true ]] && pass "mihomo tun" "$tun" || fail "mihomo tun" "$tun"
else
  fail "mihomo controller" "unreachable"
fi

dns_answer=$(getent ahostsv4 api.openai.com | awk 'NR==1{print $1}' || true)
[[ $dns_answer == 198.18.* ]] && pass "mihomo dns" "$dns_answer" || fail "mihomo dns" "$dns_answer"

api_code=$(curl -4 -L -o /dev/null -sS --connect-timeout 8 --max-time 30 \
  -w '%{http_code}' https://api.openai.com/v1/models || true)
[[ $api_code == 401 || $api_code == 403 ]] && pass "openai direct" "$api_code" || fail "openai direct" "$api_code"

proxy_code=$(curl -4 -x http://127.0.0.1:7890 -L -o /dev/null -sS --connect-timeout 8 --max-time 30 \
  -w '%{http_code}' https://api.openai.com/v1/models || true)
[[ $proxy_code == 401 || $proxy_code == 403 ]] && pass "openai explicit proxy" "$proxy_code" || fail "openai explicit proxy" "$proxy_code"

egress=$(curl -4 -fsS --connect-timeout 8 --max-time 25 https://www.cloudflare.com/cdn-cgi/trace 2>/dev/null \
  | awk -F= '/^(ip|loc)=/{printf "%s=%s ", $1, $2}' || true)
[[ -n $egress ]] && pass "egress" "$egress" || fail "egress" "unknown"

codex login status >/tmp/codex-login-status.$$ 2>&1 && pass "codex login" "$(tail -n1 /tmp/codex-login-status.$$)" || fail "codex login" "$(tail -n1 /tmp/codex-login-status.$$)"
rm -f /tmp/codex-login-status.$$

if $live; then
  codex_out=$(codex exec --skip-git-repo-check --ephemeral 'Reply with exactly: STACK_OK' 2>&1 || true)
  grep -q 'STACK_OK' <<<"$codex_out" && pass "codex live" "STACK_OK" || fail "codex live" "$(tail -n 5 <<<"$codex_out")"

  claude_out=$(timeout 150 claude -p 'Reply with exactly: STACK_OK' --output-format text 2>&1 || true)
  grep -q 'STACK_OK' <<<"$claude_out" && pass "claude live" "STACK_OK" || fail "claude live" "$(tail -n 5 <<<"$claude_out")"
fi

if (( failures > 0 )); then
  echo "verify=failed failures=$failures"
  exit 1
fi

echo "verify=passed"
