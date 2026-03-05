---
summary: "Phase 4 addition: Apple Silicon / M4 note for Docker installs"
title: "Docker — Apple Silicon Note"
---

## Note for Apple Silicon / M4 Users
- **Run the Global Compass first:** Confirm Rosetta, disk space (≥15 GB), Docker Desktop running, and Terminal Full Disk Access (see [Global Compass](./founder-companion.md#module-1--global-compass-pre-flight)).
- **Wait for Docker to settle:** After updates the whale icon pulses for ~90 s—running compose before it stabilizes causes mount failures unique to M4 laptops.
- **Protect the gateway from JSON typos:** Before editing `~/.openclaw/openclaw.json`, run `scripts/config-guard.sh lint <file>`; if it fails, consult the [Status Decoder](./founder-companion.md#module-3--status-decoder-mini-status-playbook) for recovery steps instead of restarting Docker.
- **Keep subagent auth in sync:** Copy or symlink `~/.openclaw/auth-profiles.json` into each `~/.openclaw/agents/<name>/` directory right after the Docker step. This prevents the `No API key for provider "anthropic"` loop captured in [`raw_data/logs/auth_error_original.md`](../../raw_data/logs/auth_error_original.md).
- **Bookmark the Status Playbook:** If you see `token mismatch` or `gateway restarting`, jump to `./status-playbook.md` — it decodes every log referenced in this note.
