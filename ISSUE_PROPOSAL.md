# Proposal: Docs-first path to unblock OpenClaw installs for founders

Hi OpenClaw team,

I’m Li Yidong — founder/operator and daily M4 laptop user — and I’ve been running your gateway full‑time to dogfood multi-agent workflows. After spending the entire morning onboarding fresh machines, three structural blind spots keep surfacing regardless of hardware or experience level:

1. **Auth isolation between main agent and subagents** silently bricks every new subagent with `No API key for provider "anthropic"` even when the root config is perfect. Today the only fix is to manually diff hidden `auth-profiles.json` copies under `~/.openclaw/agents/*`.
2. **Docker path shadowing** encourages users to run `docker compose` from `~/.openclaw` (because that’s where all generated files live), but the actual compose files sit in the repo checkout. The CLI happily runs commands in the wrong tree until bind mounts and socket paths explode.
3. **Config hot-reload suicide** treats invalid edits to `~/.openclaw/openclaw.json` as fatal. A single misplaced key loops `gateway restarting` forever with no preserved last-known-good config.

These aren’t niche “RTFM” bugs — they’re guaranteed landmines for any founder trying to put OpenClaw into production, and they can be solved at the standards/policy layer before touching code.

## Proposed standards
I drafted four lightweight protocols (see `docs/clarity-layer/protocols.md` in this repo) to turn those blind spots into deterministic behavior:
- **Credential Auto-Sync Protocol** — subagents hash + auto-sync the main `auth-profiles.json` before booting.
- **Safe-Reload Protocol** — gateway validates config changes before applying, and refuses to drop a healthy config when validation fails.
- **Execution Path Integrity Protocol** — CLI and helper scripts detect when compose is run from `~/.openclaw` and steer the user back to the repo root instead of failing silently.
- **Visual Health Dashboard Protocol** — surface a layered health graph (Docker → gateway → auth → sandbox) to kill the “health: starting” black box.

None of these require new permissions or controversial UX shifts. They formalize what advanced operators already do manually (copy auth files, dry-run configs, remind themselves where compose lives, tail logs to guess readiness). I’m proposing a docs-first pull request that introduces these standards, plus companion guides that show the human workflow today while we align on native implementations.

## What I’m asking for
1. **Feedback on the four protocols** — are there edge cases the core maintainers want to cover before we upstream issue(s) and eventual patches?
2. **Blessing for a Docs-First PR** — I have a scoped `INSTALL_GUIDE_ENHANCEMENT.md` ready that adds global pre-flight checklists, a status decoder, and explicit warnings about the three pitfalls above. Happy to submit this to `/docs/install/` as an initial pull request while we continue shaping the code-level changes.
3. **A shared channel for implementation details** — once the standards are blessed, I’ll start drafting code patches (auth sync hook, config validator, CLI path guard, health graph endpoint) and route them as focused PRs instead of one giant diff.

Thanks for building OpenClaw — these polish layers will make the project feel as sharp as its underlying engine.

— Li Yidong (@liyidong)
