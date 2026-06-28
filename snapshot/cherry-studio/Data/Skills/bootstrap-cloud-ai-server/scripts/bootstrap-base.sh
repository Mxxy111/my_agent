#!/usr/bin/env bash
set -euo pipefail

timezone="Asia/Shanghai"
swap_gb=0
dry_run=false

usage() {
  cat <<'EOF'
Usage: bootstrap-base.sh [options]

Options:
  --timezone ZONE   Timezone to configure (default: Asia/Shanghai)
  --swap-gb N       Create /swapfile with N GiB when no swap exists (default: 0)
  --dry-run         Print actions without changing the server
  -h, --help        Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --timezone)
      timezone=${2:?missing timezone}
      shift 2
      ;;
    --swap-gb)
      swap_gb=${2:?missing size}
      [[ $swap_gb =~ ^[0-9]+$ ]] || {
        echo "--swap-gb must be a non-negative integer" >&2
        exit 2
      }
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

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
fi
if [[ ${ID:-} != ubuntu ]]; then
  echo "This script supports Ubuntu only." >&2
  exit 1
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

packages=(
  ca-certificates curl git jq fzf unzip zip gzip tar file
  sqlite3 python3 locales bubblewrap
)

apt_proxy=()
if [[ -n "${BOOTSTRAP_PROXY:-}" ]]; then
  apt_proxy=(
    -o "Acquire::http::Proxy=$BOOTSTRAP_PROXY"
    -o "Acquire::https::Proxy=$BOOTSTRAP_PROXY"
  )
fi

export DEBIAN_FRONTEND=noninteractive
run sudo apt-get "${apt_proxy[@]}" update
run sudo apt-get "${apt_proxy[@]}" install -y "${packages[@]}"

if [[ -n $timezone ]]; then
  run sudo timedatectl set-timezone "$timezone"
fi

if ! locale -a 2>/dev/null | grep -qi '^en_US\.utf8$'; then
  run sudo locale-gen en_US.UTF-8
fi

for directory in sites apps agents experiments; do
  run install -d -m 0755 "$HOME/projects/$directory"
done

for directory in sites apps agents data backups; do
  run sudo install -d -m 0755 "/srv/$directory"
done

run install -d -m 0755 "$HOME/.local/bin" "$HOME/.local/state"

path_line='export PATH="$HOME/.local/bin:$PATH"'
if ! grep -Fqx "$path_line" "$HOME/.bashrc" 2>/dev/null; then
  if $dry_run; then
    printf '+ append to %q: %s\n' "$HOME/.bashrc" "$path_line"
  else
    printf '\n%s\n' "$path_line" >> "$HOME/.bashrc"
  fi
fi

if (( swap_gb > 0 )) && [[ -z $(swapon --noheadings --show=NAME 2>/dev/null) ]]; then
  if [[ -e /swapfile ]]; then
    echo "/swapfile exists but is not active; refusing to overwrite it." >&2
    exit 1
  fi
  run sudo fallocate -l "${swap_gb}G" /swapfile
  run sudo chmod 600 /swapfile
  run sudo mkswap /swapfile
  run sudo swapon /swapfile
  if $dry_run; then
    echo "+ append /swapfile to /etc/fstab"
  elif ! grep -qE '^/swapfile[[:space:]]' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab >/dev/null
  fi
fi

if ! $dry_run; then
  echo "base_setup=complete"
  echo "timezone=$(timedatectl show -p Timezone --value)"
  echo "workspace=$HOME/projects"
  echo "runtime=/srv"
fi
