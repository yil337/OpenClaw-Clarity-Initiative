# Founder Install Companion (Phase 4 Clarity Layer)

_This is the “friend on the next seat” companion to the official docs. It mirrors the `/docs/install/docker.md` structure so maintainers can copy/paste modules without hunting for context._

## Module 0 — How to Read This
| Official doc chapter | Companion module | What you get here |
| --- | --- | --- |
| Prerequisites / Before you begin | **Module 1 – Global Compass** | Cross-platform pre-flight checklists so you don’t start with a broken shell, Docker daemon, or PATH. |
| Install / Platform specific | **Module 2 – Platform Runbooks** | Step-by-step expectations for Apple Silicon (M1–M4), Intel Mac, Linux/VPS, and Windows/WSL. |
| Post-install verification | **Module 3 – Status Decoder** | A mini version of the Status Playbook you can embed near the official health table. |
| Troubleshooting appendix | **Module 4 – Pain → Comfort Map** | Direct mapping between the three Phase 4 blind spots and their current mitigations. |
| Doc callouts | **Module 5 – Drop-in Note for Apple Silicon/M4** | A ready-made paragraph that can be inserted immediately after the Docker section in `/docs/install/docker.md`. |

Keep `docs/clarity-layer/status-playbook.md` open alongside this file; Module 3 only lists the beats you must surface inline in the upstream docs.

---

## Module 1 — Global Compass (Pre-flight)
**Goal:** match the official “Before you begin” subsections. Each checklist item is phrased so maintainers can copy directly into platform callouts.

### Apple Silicon (M1–M4)
- [ ] Rosetta installed once via `softwareupdate --install-rosetta --agree-to-license`.
- [ ] Docker Desktop running (whale icon steady) with ≥15 GB free disk (`diskutil info / | grep "Free Space"`).
- [ ] Terminal has Full Disk Access (System Settings → Privacy & Security).
- [ ] PATH sanity confirmed (`command -v openclaw` or explicit note that it’s not yet installed).

### Intel Mac
- [ ] `brew update && brew upgrade` succeeds; no legacy Node 18 residue.
- [ ] `xcode-select --install` already ran (or reports “installed”).
- [ ] Docker Desktop resources ≥4 CPU / 6 GB RAM; laptop on power.

### Linux / VPS
- [ ] User has sudo (`sudo -n true` passes or prompts).
- [ ] `locale` shows `UTF-8` (no `POSIX/C`).
- [ ] `df -h ~` free space ≥10 GB.
- [ ] Docker daemon healthy (`docker info`, `docker ps`).

### Windows / WSL2
- [ ] WSL2 installed and distro set to version 2 (`wsl --status`).
- [ ] Working directory located inside WSL ext4 (avoid `/mnt/c`).
- [ ] Developer Mode + Long Paths enabled.

> **Why surface this upstream?** 80% of install failures we logged were pre-flight omissions. Copying Module 1 into `/docs/install/` lets founders self-diagnose before running any script.

---

## Module 2 — Platform Runbooks
Each runbook mirrors the structure in `/docs/install/docker.md`: **Before you run anything → While installer runs → If it stalls**.

### Apple Silicon (M1/M2/M3/M4)
- **Before:** confirm Rosetta + disk space, and wait for Docker to fully start even if it sits on “starting” for 90 s.
- **During:** expect macOS permission prompts, long `pnpm install` output, and `health: starting` logs for up to 120 s because Rosetta warms cold binaries.
- **If stalled:** run `openclaw logs --lines 50` and cross-check the Status Decoder (Module 3) before killing anything.

### Intel Mac
- **Before:** update Homebrew, keep machine on power.
- **During:** expect slower docker pulls; `install.sh` skips Rosetta logic.
- **If stalled:** watch for outdated Command Line Tools errors (`xcode-select --install`).

### Linux / VPS
- **Before:** verify sudo + UTF-8 locale; note the repo root vs data root split (repo under `~/projects/openclaw`, data under `~/.openclaw`).
- **During:** script may install NodeSource repos; allow `curl/tar` bootstrap.
- **If stalled:** `systemctl --user status openclaw-gateway` + `journalctl --user -u openclaw-gateway -n 100` give clearer answers than rerunning install.

### Windows / WSL2
- **Before:** ensure Ubuntu (or target distro) runs under WSL2 and set VS Code/Terminal to connect inside WSL.
- **During:** run installers inside WSL; running from PowerShell re-prompts for toolchains.
- **If stalled:** confirm `openclaw` binary lives inside WSL (`which openclaw`). Missing PATH? add `export PATH="$HOME/.npm-global/bin:$PATH"` to `~/.bashrc`.

---

## Module 3 — Status Decoder (Mini Status Playbook)
Embed these bullets right after the official health table so founders know what each layer means:
- `gateway restarting` (loop) → malformed `openclaw.json`. Action: lint config first, then run rollback (Safe-Reload protocol).
- `health: starting` for >90 s on Apple Silicon → Rosetta warm-up; safe to wait unless logs show schema errors.
- `No API key for provider "anthropic"` → subagent auth desync; copy or symlink `auth-profiles.json` from root.
- `docker compose` errors when run inside `~/.openclaw` → you’re in the data directory, rerun from repo root.
- `token mismatch / WebSocket 1008` → Control UI token expired; rerun `openclaw dashboard --no-open` to fetch a fresh token.

For the full matrix, link to `docs/clarity-layer/status-playbook.md`.

---

## Module 4 — Pain → Comfort Map
| Pain (from raw logs) | Root cause | Mitigation founders can apply today |
| --- | --- | --- |
| **Subagent auth desync** – `No API key for provider "anthropic"`. | Each subagent keeps its own `auth-profiles.json`. | Hash-compare root vs subagent files before spawning, or symlink them; Phase 4 automation will enforce this. |
| **Docker compose run in `~/.openclaw`.** | Repo root ≠ data root; Compose files live with the repo. | Add a guard snippet in docs (`[[ "$PWD" == "$HOME/.openclaw" ]] && echo "move to repo" && exit 1`). |
| **Gateway loops after JSON typo.** | No dry-run validation/rollback. | Use `scripts/config-guard.sh apply <file>` (Safe-Reload protocol) until native `openclaw config lint` lands. |

---

## Module 5 — Drop-in Note for Apple Silicon / M4 Users (after `/docs/install/docker.md`)
> ### Note for Apple Silicon / M4 Users
> - Keep Docker Desktop open until the whale icon stops pulsing — Apple Silicon needs ~90 s after updates before bind mounts are reliable.
> - Run the **Global Compass** checks first: Rosetta installed, ≥15 GB free disk, Terminal granted Full Disk Access.
> - If the Control UI shows `gateway restarting`, do **not** rerun Docker. Run `scripts/config-guard.sh lint ~/.openclaw/openclaw.json` and consult the [Status Playbook](../clarity-layer/status-playbook.md) entry titled “Gateway loops after editing openclaw.json.”
> - Subagent credentials are isolated; after the Docker step, copy `~/.openclaw/auth-profiles.json` into each `~/.openclaw/agents/<name>/` directory or create a symlink so new agents don’t launch without keys.
> - Keep the [Global Compass](../clarity-layer/INSTALL_FOUNDERS.md#module-1--global-compass-pre-flight) and [Status Decoder](../clarity-layer/INSTALL_FOUNDERS.md#module-3--status-decoder-mini-status-playbook) tabs open during install; they reflect the most recent founder-tested edge cases.

_Once maintainers approve, Modules 1, 3, and 5 can be inline-copied into the upstream `/docs/install/` tree, while Modules 2 and 4 stay here as the deep-dive appendix._
