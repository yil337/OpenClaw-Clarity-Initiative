# Issue: Phase 4 Docs-First Safety Net for Founder Installs

## Summary
- **Persona:** Li Yidong — founder/operator running OpenClaw full time on an Apple Silicon (M4) laptop.
- **Problem:** Fresh installs hit three structural blind spots that the current docs never warn about. Each pitfall is guaranteed to brick a new deployment even when the core software is healthy.
- **Goal:** Land a docs-first pull request that codifies the mitigations while Phase 4 ships native enforcement (auth sync, config guard, path integrity, health dashboard).

## Structural Blind Spots (with evidence)

### 1. Subagent auth isolation silently desyncs credentials
- **Observed behavior:** Subagents inherit stale `auth-profiles.json` snapshots under `~/.openclaw/agents/*`, producing `No API key for provider "anthropic"` the moment a new helper boots.
- **Evidence:** `raw_data/logs/auth_error_original.md` → *Case 1: Subagent Auth Desync* (lines 4-8) captures the exact failure and path.
- **Impact:** Every fresh subagent spawn fails regardless of the root config, forcing founders to spelunk hidden directories or retry installs they believe are broken.
- **Current official coverage:** `/app/docs/help/faq.md` ("No API key found for provider after adding a new agent") only offers a reactive fix: manually copy `auth-profiles.json` after the error occurs.
- **Gap:** No proactive warning or hash-sync workflow exists in install/onboarding docs, so founders repeatedly fall into the trap.
- **Requested remedy:** Ship a "Credential Auto-Sync Protocol" section in the docs plus a status checklist that tells users to hash-compare the per-agent `auth-profiles.json` files until the gateway performs the sync automatically.

### 2. Docker path shadowing trains users to run compose in the wrong tree
- **Observed behavior:** The CLI encourages running `docker compose` from `~/.openclaw`, but the actual compose files remain in the repo checkout (e.g., `~/code/openclaw`). Running from the data directory produces `docker compose: not found` or mount explosions.
- **Evidence:** `raw_data/logs/auth_error_original.md` → *Case 2: Docker Path Shadowing* (lines 10-15) documents the mismatch.
- **Impact:** Install success becomes a coin flip because bind mounts break silently. Founders spend hours debugging Docker instead of onboarding agents.
- **Current official coverage:** `/app/docs/install/docker.md` mentions “run docker compose ... from the repo root” once in the "Manual flow" appendix, after hundreds of lines of other content.
- **Gap:** Quick-start steps, troubleshooting, and requirements never reiterate repo vs data root; there is no guard snippet to stop the mistake proactively.
- **Requested remedy:** Update `/docs/install/docker.md` to spell out "repo root vs data root" with a guardrail snippet that bails if `pwd` equals `~/.openclaw`.

### 3. Config hot-reload suicide bricks healthy gateways
- **Observed behavior:** Editing `~/.openclaw/openclaw.json` with an unknown key loops `gateway restarting` forever. There is no lint or rollback hook.
- **Evidence:** `raw_data/logs/auth_error_original.md` → *Case 3: JSON Schema Suicide* (lines 17-23) plus the connection-refused log excerpts below it.
- **Impact:** One stray key nukes production; founders cannot recover without manual file surgery.
- **Current official coverage:** No current doc mentions linting `openclaw.json`, keeping rolling backups, or mapping `gateway restarting` loops to schema errors.
- **Gap:** Founders have zero guidance once the loop starts; the only workaround is ad-hoc manual edits.
- **Requested remedy:** Publish the Safe-Reload protocol (dry-run lint + limited backup history) while code work for `openclaw config lint` ships. The docs should instruct users to run `scripts/config-guard.sh` (from this repo) or equivalent before editing configs.

## Proposed Resolution (Docs-First)
1. **Credential Auto-Sync Protocol** — add a dedicated section under "Auth" docs explaining the hash-compare workflow and pointing to the forthcoming automation plan.
2. **Execution Path Integrity Protocol** — update Docker installation docs with repo/data split callouts, shell snippets, and pre-flight checks.
3. **Safe-Reload Protocol** — incorporate the dry-run validator + rolling backup process into the install/operations docs, referencing the demo script included in this repo.
4. **Visual Health Dashboard Protocol** — summarize the stacked status view so founders know how to interpret `gateway restarting`, `token mismatch`, etc.

## Acceptance Criteria
- Maintainers review and acknowledge the three blind spots as P0 doc issues.
- Docs PR (referenced in this repo) is accepted or feedback is provided on structure/placement.
- Follow-up code issues can reuse the same evidence so implementation owners are unblocked.

## Links
- Supporting logs: [`raw_data/logs/auth_error_original.md`](./raw_data/logs/auth_error_original.md)
- Draft mitigation guides: `docs/clarity-layer/INSTALL_FOUNDERS.md`, `docs/clarity-layer/status-playbook.md`, `docs/clarity-layer/protocols.md`
