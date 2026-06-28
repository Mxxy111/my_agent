#!/usr/bin/env bash
set -euo pipefail

core="mihomo"
installer_ref="main"
dry_run=false

usage() {
  cat <<'EOF'
Usage: install-proxy-stack.sh [options]

Install ClashTui and the Mihomo core. Run as the normal SSH user; the
upstream installer will call sudo for system paths.

Options:
  --core TYPE          mihomo, sing-box, or all (default: mihomo)
  --installer-ref REF  ClashTui install script ref (default: main)
  --dry-run           Print actions without changing the server
  -h, --help          Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --core)
      core=${2:?missing core}
      shift 2
      ;;
    --installer-ref)
      installer_ref=${2:?missing ref}
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

case "$core" in
  mihomo|sing-box|all) ;;
  *)
    echo "--core must be mihomo, sing-box, or all" >&2
    exit 2
    ;;
esac

if [[ $(id -u) -eq 0 ]]; then
  echo "Do not run this script with sudo. Run as the normal SSH user." >&2
  exit 1
fi

curl_args=(-fsSL --connect-timeout 10 --max-time 240)
if [[ -n "${BOOTSTRAP_PROXY:-}" ]]; then
  curl_args+=(--proxy "$BOOTSTRAP_PROXY")
fi

run() {
  if $dry_run; then
    printf '+'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

installer_url="https://raw.githubusercontent.com/JohanChane/clashtui/refs/heads/${installer_ref}/installs/install"
if [[ $installer_ref == v* ]]; then
  installer_url="https://raw.githubusercontent.com/JohanChane/clashtui/refs/tags/${installer_ref}/installs/install"
fi

export DEBIAN_FRONTEND=noninteractive
apt_proxy=()
if [[ -n "${BOOTSTRAP_PROXY:-}" ]]; then
  apt_proxy=(
    -o "Acquire::http::Proxy=$BOOTSTRAP_PROXY"
    -o "Acquire::https::Proxy=$BOOTSTRAP_PROXY"
  )
fi

run sudo apt-get "${apt_proxy[@]}" update
run sudo apt-get "${apt_proxy[@]}" install -y ca-certificates curl gzip fzf jq

if $dry_run; then
  echo "+ download ClashTui installer from $installer_url"
  echo "+ run installer with --core $core"
  exit 0
fi

installer=$(mktemp)
trap 'rm -f "$installer"' EXIT
curl "${curl_args[@]}" "$installer_url" -o "$installer"
bash -n "$installer"

# Answer "no" to optional template/rules prompts so the installer does not hang
# in non-interactive shells. We install durable overrides in later scripts.
printf 'n\nn\nn\nn\n' | bash "$installer" --core "$core"

sudo systemctl daemon-reload
if [[ $core == mihomo || $core == all ]]; then
  sudo systemctl enable clashtui_mihomo >/dev/null 2>&1 || true
fi

sudo gpasswd -a "$USER" mihomo >/dev/null 2>&1 || true

# Root-owned user config is a common symptom of running the installer with sudo.
if sudo test -d /root/.config/clashtui; then
  echo "WARNING: /root/.config/clashtui exists. It is ignored; user config must be under ~/.config/clashtui." >&2
fi

echo "proxy_stack=installed"
command -v clashtui
clashtui --version
/opt/clashtui/mihomo/mihomo -v 2>/dev/null || true
echo "Reconnect SSH before editing /opt/clashtui/mihomo/config if the current shell lacks the mihomo group."
