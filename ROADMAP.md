# Clarity Initiative Roadmap (Phase 2+)

_Phase 1 (repo initialization + pain capture) is complete. Work now focuses on Phase 2 onward._

## Phase 2 -- Founder Install Journey
- **Goal:** Turn real-world failures into a "founder-mode" install guide so newcomers always see the lighthouse.
- **Deliverables:**
  - `docs/install/docker.md` (Global Compass, status decoder, reassurance copy).
  - Status/log dictionary: `docs/install/status-playbook.md`.
  - Structured pain log: keep enriching `raw_data/logs/`.
- **Key actions:** Organize real logs -> scenario scripts -> "predict + act" prompts.
- **Acceptance:** A new founder can install without live help and can self-heal known errors.

## Phase 3 -- From Patch to Protocol
- **Goal:** Promote our ad-hoc fixes into official standards (PR-ready).
- **Deliverables:**
  - This `ROADMAP.md` plus `docs/install/phase4-protocols.md` (protocol definitions and evidence).
  - Recommendation list: auth auto-sync, path guard, config lint, status decoder, etc.
  - Each recommendation links to "temporary workaround" + "official change request."
- **Key actions:** Map real incidents to config/tooling changes; prep upstream issue narratives.
- **Acceptance:** Every protocol answers "why," "how to verify," and "which component to modify."
- **Priority stability upgrades:**
  1. Credential Auto-Sync Protocol.
  2. Safe-Reload Protocol.

## Phase 4 -- Automation & Instrumentation
- **Goal:** Cement the protocols with scripts/tools so humans are no longer the bottleneck.
- **Deliverables:**
  - Auth sync checker (`auth-sync-check.sh`).
  - Docker path guard (detect wrong working dir before compose runs).
  - Config lint + rollback helper (dry-run before overwriting `openclaw.json`).
- **Key actions:** Rapid prototype -> run locally -> prepare parallel PRs.
- **Acceptance:** Tools produce real results in our environment; docs explain how to use them.

## Phase 5 -- PR Packaging & Review Campaign
- **Goal:** Bundle the docs + tooling into official-ready PRs and prep the review narrative.
- **Deliverables:**
  - PR drafts (or multiple PRs) covering docs, config safety, and tooling.
  - Reviewer briefing pack (logs, screenshots, before/after comparisons).
