#!/usr/bin/env bash
set -euo pipefail

LOG_PREFIX="[path-doctor]"
DATA_DIR="${OPENCLAW_DATA_DIR:-$HOME/.openclaw}"
HOME_DIR="$HOME"
COMPOSE_FILENAMES=("docker-compose.yml" "docker-compose.yaml")
DOC_LINK="https://github.com/yil337/OpenClaw-Clarity-Initiative/blob/main/docs/clarity-layer/INSTALL_FOUNDERS.md"

have_compose_here=false
for name in "${COMPOSE_FILENAMES[@]}"; do
  if [[ -f "$name" ]]; then
    have_compose_here=true
    compose_here="$PWD/$name"
    break
  fi
  if [[ -f "./$name" ]]; then
    have_compose_here=true
    compose_here="$PWD/$name"
    break
  fi
done

if $have_compose_here; then
  echo "$LOG_PREFIX OK: Found compose file at $compose_here"
else
  echo "$LOG_PREFIX WARN: No docker-compose file in $PWD"
  if [[ "$PWD" == "$DATA_DIR"* ]]; then
    echo "$LOG_PREFIX Detected data directory ($PWD). Compose files do NOT live here."
  fi
  echo "$LOG_PREFIX Searching $HOME_DIR for a checkout..."
  mapfile -t matches < <(find "$HOME_DIR" -maxdepth 4 -type f \( -name "docker-compose.yml" -o -name "docker-compose.yaml" \) 2>/dev/null)
  if (( ${#matches[@]} > 0 )); then
    preferred="${matches[0]}"
    echo "$LOG_PREFIX Found candidate repo: $preferred"
    repo_dir="$(dirname "$preferred")"
    echo "$LOG_PREFIX Run the following to jump back:" 
    echo "  cd '$repo_dir'"
    if [[ "$PWD" == "$DATA_DIR"* ]]; then
      echo "$LOG_PREFIX Tip: keep configs in $DATA_DIR but run compose commands from $repo_dir"
    fi
  else
    echo "$LOG_PREFIX ERROR: Could not locate docker-compose.yml under $HOME_DIR"
    echo "$LOG_PREFIX Please clone the repo (git clone https://github.com/openclaw/openclaw.git)"
    echo "$LOG_PREFIX Docs (Global Compass): $DOC_LINK"
  fi
fi

# Docker diagnostics
if ! command -v docker >/dev/null 2>&1; then
  echo "$LOG_PREFIX ERROR: 'docker' CLI not found. Install Docker Desktop or docker-ce first." >&2
else
  if docker info >/dev/null 2>&1; then
    echo "$LOG_PREFIX Docker daemon: OK"
  else
    echo "$LOG_PREFIX WARN: docker daemon not reachable (run Docker Desktop or start the service)." >&2
  fi
  if docker compose version >/dev/null 2>&1; then
    echo "$LOG_PREFIX docker compose: OK"
  elif command -v docker-compose >/dev/null 2>&1; then
    echo "$LOG_PREFIX docker-compose legacy binary detected; consider upgrading to 'docker compose'."
  else
    echo "$LOG_PREFIX ERROR: docker compose command not found." >&2
  fi
fi
