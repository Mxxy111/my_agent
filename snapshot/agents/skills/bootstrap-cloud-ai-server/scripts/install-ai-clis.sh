#!/usr/bin/env bash
set -euo pipefail

dry_run=false
force=false
remove_root_npm=false
remove_system_cc_switch=false

usage() {
  cat <<'EOF'
Usage: install-ai-clis.sh [options]

Install user-owned Claude Code, Codex, and cc-switch into ~/.local/bin.

Options:
  --force                    Force cc-switch replacement/update
  --remove-root-npm          Remove root-owned npm Codex/Claude after validation
  --remove-system-cc-switch  Remove /usr/local/bin/cc-switch after validation
  --dry-run                  Print actions without downloading or changing files
  -h, --help                 Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      force=true
      shift
      ;;
    --remove-root-npm)
      remove_root_npm=true
      shift
      ;;
    --remove-system-cc-switch)
      remove_system_cc_switch=true
      shift
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

export PATH="$HOME/.local/bin:$PATH"
install -d -m 0755 "$HOME/.local/bin"
install -d -m 0700 "$HOME/.local/state/cloud-ai-bootstrap"

path_line='export PATH="$HOME/.local/bin:$PATH"'
if ! grep -Fqx "$path_line" "$HOME/.bashrc" 2>/dev/null; then
  if $dry_run; then
    printf '+ append to %q: %s\n' "$HOME/.bashrc" "$path_line"
  else
    printf '\n%s\n' "$path_line" >> "$HOME/.bashrc"
  fi
fi

stamp=$(date +%Y%m%d-%H%M%S)
state_dir="$HOME/.local/state/cloud-ai-bootstrap/cli-install-$stamp"

if $dry_run; then
  echo "+ create state directory $state_dir"
else
  install -d -m 0700 "$state_dir"
  {
    echo "date=$(date -Is)"
    echo "codex_path=$(command -v codex 2>/dev/null || true)"
    echo "claude_path=$(command -v claude 2>/dev/null || true)"
    echo "cc_switch_path=$(command -v cc-switch 2>/dev/null || true)"
    echo "codex_files=$(find "$HOME/.codex" -maxdepth 2 -type f 2>/dev/null | wc -l)"
    echo "claude_files=$(find "$HOME/.claude" -maxdepth 2 -type f 2>/dev/null | wc -l)"
    echo "cc_switch_files=$(find "$HOME/.cc-switch" -maxdepth 2 -type f 2>/dev/null | wc -l)"
  } > "$state_dir/before.txt"
  chmod 600 "$state_dir/before.txt"
fi

curl_args=(-fsSL --connect-timeout 10 --max-time 180)
if [[ -n "${BOOTSTRAP_PROXY:-}" ]]; then
  curl_args+=(--proxy "$BOOTSTRAP_PROXY")
fi

download_and_run() {
  local label=$1
  local url=$2
  local shell_name=$3
  shift 3

  if $dry_run; then
    printf '+ download %s from %s and run with %s' "$label" "$url" "$shell_name"
    if [[ $# -gt 0 ]]; then
      printf ' %q' "$@"
    fi
    printf '\n'
    return
  fi

  local temp_file
  temp_file=$(mktemp)
  curl "${curl_args[@]}" "$url" -o "$temp_file"
  "$shell_name" "$temp_file" "$@"
  rm -f "$temp_file"
}

download_and_run \
  "Claude Code native installer" \
  "https://claude.ai/install.sh" \
  bash

download_and_run \
  "Codex standalone installer" \
  "https://chatgpt.com/codex/install.sh" \
  sh

if $dry_run; then
  echo "+ install cc-switch into $HOME/.local/bin"
else
  cc_installer=$(mktemp)
  curl "${curl_args[@]}" \
    "https://github.com/SaladDay/cc-switch-cli/releases/latest/download/install.sh" \
    -o "$cc_installer"
  if $force; then
    CC_SWITCH_INSTALL_DIR="$HOME/.local/bin" CC_SWITCH_FORCE=1 bash "$cc_installer"
  else
    CC_SWITCH_INSTALL_DIR="$HOME/.local/bin" bash "$cc_installer"
  fi
  rm -f "$cc_installer"
fi

if $dry_run; then
  exit 0
fi

for command_path in \
  "$HOME/.local/bin/claude" \
  "$HOME/.local/bin/codex" \
  "$HOME/.local/bin/cc-switch"; do
  if [[ ! -x $command_path ]]; then
    echo "Installation failed: missing executable $command_path" >&2
    exit 1
  fi
done

"$HOME/.local/bin/claude" --version
"$HOME/.local/bin/codex" --version
"$HOME/.local/bin/cc-switch" --version

if $remove_root_npm && command -v npm >/dev/null 2>&1; then
  codex_real=$(readlink -f "$(type -P codex 2>/dev/null || true)" 2>/dev/null || true)
  claude_real=$(readlink -f "$(type -P claude 2>/dev/null || true)" 2>/dev/null || true)
  if [[ $codex_real == /usr/lib/node_modules/* || $claude_real == /usr/lib/node_modules/* ]] ||
     [[ -d /usr/lib/node_modules/@openai/codex ||
        -d /usr/lib/node_modules/@anthropic-ai/claude-code ]]; then
    sudo npm uninstall -g @openai/codex @anthropic-ai/claude-code
  fi
fi

if $remove_system_cc_switch && [[ -e /usr/local/bin/cc-switch ]]; then
  if cmp -s "$HOME/.local/bin/cc-switch" /usr/local/bin/cc-switch; then
    sudo rm -f /usr/local/bin/cc-switch
  else
    echo "Refusing to remove a different /usr/local/bin/cc-switch binary." >&2
  fi
fi

{
  echo "date=$(date -Is)"
  echo "claude_path=$HOME/.local/bin/claude"
  echo "claude_version=$("$HOME/.local/bin/claude" --version | head -n 1)"
  echo "codex_path=$HOME/.local/bin/codex"
  echo "codex_version=$("$HOME/.local/bin/codex" --version | head -n 1)"
  echo "cc_switch_path=$HOME/.local/bin/cc-switch"
  echo "cc_switch_version=$("$HOME/.local/bin/cc-switch" --version | head -n 1)"
  echo "codex_files=$(find "$HOME/.codex" -maxdepth 2 -type f 2>/dev/null | wc -l)"
  echo "claude_files=$(find "$HOME/.claude" -maxdepth 2 -type f 2>/dev/null | wc -l)"
  echo "cc_switch_files=$(find "$HOME/.cc-switch" -maxdepth 2 -type f 2>/dev/null | wc -l)"
} > "$state_dir/after.txt"
chmod 600 "$state_dir/after.txt"

echo "cli_install=complete"
echo "state_dir=$state_dir"
"$HOME/.local/bin/codex" login status 2>/dev/null || true
"$HOME/.local/bin/claude" auth status 2>/dev/null || true
"$HOME/.local/bin/cc-switch" env tools 2>/dev/null || true
