#!/usr/bin/env bash
set -euo pipefail

MASTER="${OPENCLAW_MASTER_AUTH:-$HOME/.openclaw/auth-profiles.json}"
AGENTS_ROOT="${OPENCLAW_AGENTS_ROOT:-$HOME/.openclaw/agents}"
DRY_RUN=false
LOG_PREFIX="[auth-sync]"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      ;;
    --help|-h)
      cat <<'EOF'
Usage: auth-sync.sh [--dry-run]

Synchronize ~/.openclaw/auth-profiles.json to every subagent directory under ~/.openclaw/agents/*/agent/.
Set OPENCLAW_MASTER_AUTH or OPENCLAW_AGENTS_ROOT to override defaults.
EOF
      exit 0
      ;;
    *)
      echo "$LOG_PREFIX ERROR: unknown flag $1" >&2
      exit 1
      ;;
  esac
  shift
done

if [[ ! -f "$MASTER" ]]; then
  echo "$LOG_PREFIX ERROR: master auth profile not found at $MASTER" >&2
  echo "$LOG_PREFIX Hint: run 'openclaw configure' or add provider credentials first." >&2
  exit 1
fi

if [[ ! -d "$AGENTS_ROOT" ]]; then
  echo "$LOG_PREFIX WARN: $AGENTS_ROOT does not exist; nothing to sync." >&2
  exit 0
fi

ts="$(date +%Y%m%d-%H%M%S)"
main_hash="$(sha256sum "$MASTER" | awk '{print $1}')"
echo "$LOG_PREFIX master hash $main_hash"

declare -i synced=0
shopt -s nullglob
for agent_dir in "$AGENTS_ROOT"/*; do
  if [[ ! -d "$agent_dir/agent" ]]; then
    continue
  fi
  target="$agent_dir/agent/auth-profiles.json"
  target_dir="$(dirname "$target")"
  printf '%s syncing to %s\n' "$LOG_PREFIX" "$target"

  if [[ -f "$target" ]]; then
    backup="$target.bak.$ts"
    if $DRY_RUN; then
      echo "$LOG_PREFIX [dry-run] would backup $target -> $backup"
    else
      cp "$target" "$backup"
      echo "$LOG_PREFIX backup created: $backup"
    fi
  fi

  if $DRY_RUN; then
    echo "$LOG_PREFIX [dry-run] would copy $MASTER -> $target"
  else
    mkdir -p "$target_dir"
    rsync -a "$MASTER" "$target"
    synced+=1
  fi

done
shopt -u nullglob

echo "$LOG_PREFIX completed. synced=$synced dry_run=$DRY_RUN"
