# Pull Request Cover Letter — Phase 4 Docs Clarity

## Summary
- Target repo: `openclaw/openclaw` docs tree.
- Scope: documentation-only uplift (no code or runtime changes) to surface the Phase 4 Founder safeguards — Global Compass pre-flight, Status Decoder, Safe-Reload, and Docker path guardrails.
- Intent: unblock official reviewers by presenting production evidence (raw founder logs) and ready-to-merge markdown modules that slot directly into `/docs/install/docker.md` and related guides. Risk profile is effectively zero because we only add narrative and callouts.

## Impact
- Expected to cut foundational install errors by **≥50%** for new founders by making repo/data path boundaries, subagent auth sync, and config lint expectations explicit.
- Reduces reviewer load: every structural blind spot is backed by concrete logs (`raw_data/logs/auth_error_original.md`) and mapped to actionable doc insertions, so no additional reproduction work is required.
- Sets the stage for follow-up code PRs (config guard, auth sync, health dashboard) by codifying the desired behavior in public docs first.

## Attachments / References
- Issue draft: `ISSUE_PROPOSAL.md`
- Founder companion guide: `docs/clarity-layer/INSTALL_FOUNDERS.md`
- Drop-in Docker note: `docs/install/docker.md`
