# Status Playbook — Real-Time Decoder Ring

When the terminal screams, read this before touching anything.

| Signal / Log | What it really means | What to do | Avg. duration |
| ------------- | -------------------- | ---------- | ------------- |
| `health: starting` | Gateway booting, waiting for services (db, browser bridge, sandbox). Common right after onboarding or Docker restart. | Wait up to 120 s (Apple Silicon) / 60 s (Intel & Linux). If it exceeds that, run `openclaw logs --lines 50` and check for config errors. | 30‑120 s |
| `gateway restarting` (loop) | Config validation failed or a fatal crash occurred; supervisor keeps trying. | Run `openclaw logs -n 200 | less` to find the first error. Most often caused by malformed `openclaw.json`. Revert the last change or run `openclaw doctor --fix`. | Until config is fixed |
| `anthropic: No API key found` (subagent) | Child agent filesystem doesn’t have your provider creds. | Copy or symlink `~/.openclaw/agents/main/agent/auth-profiles.json` into the subagent dir before spawning, or export provider env vars. | Immediate once file exists |
| `docker compose: command not found` inside `~/.openclaw` | You’re in the data directory, not the repo with `docker-compose.yml`. | `cd ~/openclaw` (or wherever you cloned the repo) and rerun the compose command; leave `~/.openclaw` for config/state only. | Instant |
| `playwright install chromium` errors inside Docker | Container lacks browsers/system deps. | Rebuild image with `OPENCLAW_DOCKER_APT_PACKAGES="ffmpeg ..."` or run install inside a persisted `/home/node`. | Rebuild time |
| `gateway pairing required (1008)` in Control UI | Browser not paired with the gateway yet. | Run `openclaw dashboard --no-open`, copy the link, approve the device from CLI or Control UI > Devices. | 1‑2 min |
| `pnpm ERR_PNPM_RECURSIVE_EXEC_FIRST_FAIL` during install | Lockfile or dependency step failed, often due to stale pnpm version. | Run `corepack enable pnpm@9 && pnpm env use --global 9`, then rerun `pnpm install`. On macOS/Linux, ensure Xcode CLT / build-essential are present. | 2‑3 min |
| `EADDRINUSE 18789` | Another gateway instance is already bound to Control UI port. | Either stop the old daemon (`openclaw stop`) or set `gateway.portControl` in `openclaw.json` before restarting. | Instant after stop |
| `sandbox docker socket permission denied` | Docker socket not mounted/accessible for sandbox. | macOS: enable "Use Virtualization framework" in Docker Desktop + share `/var/run/docker.sock`. Linux: add user to `docker` group or set `OPENCLAW_DOCKER_SOCKET`. | Depends on restart |

## Quick scripts
- **Check where compose files live**
  ```bash
  ls docker-compose*.yml
  # If empty, you’re not in the repo root.
  ```
- **Dry-run config before hot reload** (manual stopgap until Phase 4 tool is ready)
  ```bash
  jq empty ~/.openclaw/openclaw.json && openclaw doctor --non-interactive
  ```
- **Auth profile sync sanity check**
  ```bash
  diff -u ~/.openclaw/agents/main/agent/auth-profiles.json \
         ~/.openclaw/agents/*/agent/auth-profiles.json || true
  ```

_Add new rows whenever you decode a scary message. The goal is zero guesswork._
