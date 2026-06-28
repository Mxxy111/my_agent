#!/usr/bin/env bash
set -euo pipefail

profile="wazhua"
rollback_delay=180
dry_run=false

usage() {
  cat <<'EOF'
Usage: configure-tun-dns.sh [options]

Persist ClashTui/Mihomo Rule-mode TUN and DNS settings with automatic rollback.

Options:
  --profile NAME          ClashTui profile to select (default: wazhua)
  --rollback-delay SEC    Seconds before rollback fires if validation hangs (default: 180)
  --dry-run               Print actions without changing files
  -h, --help              Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)
      profile=${2:?missing profile}
      shift 2
      ;;
    --rollback-delay)
      rollback_delay=${2:?missing seconds}
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ $(id -u) -eq 0 ]]; then
  echo "Run as the normal SSH user, not root." >&2
  exit 1
fi

export HOME=${HOME:-/home/"$(id -un)"}
export PATH="$HOME/.local/bin:$PATH"
export CLASHTUI_CONFIG_DIR="${CLASHTUI_CONFIG_DIR:-$HOME/.config/clashtui}"

override="$CLASHTUI_CONFIG_DIR/mihomo/core_override_config.yaml"
active="/opt/clashtui/mihomo/config/config.yaml"
resolved_dir="/etc/systemd/resolved.conf.d"
resolved_conf="$resolved_dir/60-mihomo.conf"

if [[ ! -f $override ]]; then
  echo "Missing ClashTui override: $override" >&2
  exit 1
fi

ts=$(date +%Y%m%d-%H%M%S)
backup_dir="$HOME/.local/state/cloud-ai-bootstrap/tun-dns-$ts"

if $dry_run; then
  echo "+ would back up $override, $active, and $resolved_conf to $backup_dir"
  echo "+ would write Rule-mode DNS/TUN override and systemd-resolved config"
  echo "+ would schedule rollback in $rollback_delay seconds"
  exit 0
fi

install -d -m 0700 "$backup_dir"
cp -a "$override" "$backup_dir/core_override_config.yaml"
if sudo test -f "$active"; then
  sudo cp -a "$active" "$backup_dir/config.yaml"
fi
if sudo test -f "$resolved_conf"; then
  sudo cp -a "$resolved_conf" "$backup_dir/60-mihomo.conf"
fi

rollback_script="$backup_dir/rollback.sh"
cat > "$rollback_script" <<EOF
#!/usr/bin/env bash
set -euo pipefail
cp -a '$backup_dir/core_override_config.yaml' '$override'
if [[ -f '$backup_dir/config.yaml' ]]; then
  sudo cp -a '$backup_dir/config.yaml' '$active'
fi
if [[ -f '$backup_dir/60-mihomo.conf' ]]; then
  sudo cp -a '$backup_dir/60-mihomo.conf' '$resolved_conf'
else
  sudo rm -f '$resolved_conf'
fi
sudo systemctl restart systemd-resolved
sudo systemctl restart clashtui_mihomo
EOF
chmod 700 "$rollback_script"

rollback_unit="cloud-ai-tun-rollback-${ts}.service"
rollback_timer="cloud-ai-tun-rollback-${ts}.timer"
sudo tee "/etc/systemd/system/$rollback_unit" >/dev/null <<EOF
[Unit]
Description=Rollback cloud AI Mihomo TUN/DNS change $ts

[Service]
Type=oneshot
ExecStart=$rollback_script
EOF

sudo tee "/etc/systemd/system/$rollback_timer" >/dev/null <<EOF
[Unit]
Description=Rollback cloud AI Mihomo TUN/DNS change $ts after delay

[Timer]
OnActiveSec=${rollback_delay}
Unit=$rollback_unit

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now "$rollback_timer" >/dev/null

tmp=$(mktemp)
awk '
  /^dns:/ {exit}
  /^mode:/ {if (!mode_written) {print "mode: rule"; mode_written=1}; next}
  {print}
  /^mixed-port:/ {if (!mode_written) {print "mode: rule"; mode_written=1}}
' "$override" > "$tmp"
cat >> "$tmp" <<'EOF'

dns:
  enable: true
  listen: 127.0.0.1:1053
  ipv6: false
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  fake-ip-filter-mode: blacklist
  fake-ip-filter:
    - '*.lan'
    - '*.local'
    - 'localhost'
  default-nameserver:
    - 223.5.5.5
    - 119.29.29.29
  nameserver:
    - https://1.1.1.1/dns-query
    - https://8.8.8.8/dns-query
  proxy-server-nameserver:
    - https://223.5.5.5/dns-query
    - https://1.12.12.12/dns-query
  direct-nameserver:
    - https://223.5.5.5/dns-query
  respect-rules: true

tun:
  enable: true
  stack: gvisor
  auto-route: true
  auto-detect-interface: true
  dns-hijack:
    - any:53
    - tcp://any:53
EOF
install -m 0644 "$tmp" "$override"
rm -f "$tmp"

clashtui mode rule
clashtui profile select --name "$profile"
sudo -u mihomo /opt/clashtui/mihomo/mihomo -t -d /opt/clashtui/mihomo/config
sudo systemctl restart clashtui_mihomo

sudo mkdir -p "$resolved_dir"
sudo tee "$resolved_conf" >/dev/null <<'EOF'
[Resolve]
DNS=127.0.0.1:1053 183.60.83.19 183.60.82.98
FallbackDNS=183.60.83.19 183.60.82.98
Domains=~.
DNSSEC=no
EOF
sudo systemctl restart systemd-resolved
sudo resolvectl flush-caches || true

sleep 3

runtime=$(curl -fsS http://127.0.0.1:9090/configs)
echo "$runtime" | jq -e '.mode == "rule" and .tun.enable == true' >/dev/null

answer=$(getent ahostsv4 api.openai.com | awk 'NR==1{print $1}')
if [[ $answer != 198.18.* ]]; then
  echo "DNS did not return Mihomo Fake-IP for api.openai.com: $answer" >&2
  sudo systemctl start "$rollback_unit" || true
  exit 1
fi

api_code=$(curl -4 -L -o /dev/null -sS --connect-timeout 8 --max-time 30 \
  -w '%{http_code}' https://api.openai.com/v1/models || true)
chatgpt_code=$(curl -4 -L -o /dev/null -sS --connect-timeout 8 --max-time 30 \
  -w '%{http_code}' https://chatgpt.com/backend-api/codex/responses || true)

if [[ $api_code != 401 && $api_code != 403 ]]; then
  echo "OpenAI direct-through-TUN validation failed: $api_code" >&2
  sudo systemctl start "$rollback_unit" || true
  exit 1
fi
if [[ $chatgpt_code != 405 && $chatgpt_code != 401 && $chatgpt_code != 403 ]]; then
  echo "ChatGPT direct-through-TUN validation failed: $chatgpt_code" >&2
  sudo systemctl start "$rollback_unit" || true
  exit 1
fi

sudo systemctl disable --now "$rollback_timer" >/dev/null || true
sudo rm -f "/etc/systemd/system/$rollback_timer" "/etc/systemd/system/$rollback_unit"
sudo systemctl daemon-reload

echo "tun_dns=complete"
echo "backup_dir=$backup_dir"
echo "api_openai=$api_code"
echo "chatgpt=$chatgpt_code"
