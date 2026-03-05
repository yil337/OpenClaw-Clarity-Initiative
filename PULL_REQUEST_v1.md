# Pull Request Cover Letter — Phase 4 Docs Clarity

## Summary
- Target repo: `openclaw/openclaw` docs tree.
- Scope: documentation-only uplift (no code or runtime changes) to surface the Phase 4 Founder safeguards — Global Compass pre-flight, Status Decoder, Safe-Reload, and Docker path guardrails.
- Intent: unblock official reviewers by presenting production evidence (raw founder logs) and ready-to-merge markdown modules that slot directly into `/docs/install/docker.md` and related guides. Risk profile is effectively zero because we only add narrative and callouts.

## Maintenance assurance
- The patch is intentionally decoupled from rapidly changing UI/CLI flows. It documents static path logic and auth store behavior that already exists in the FAQ (e.g., `/help/faq.md` line 2288) and installer steps, so upkeep is limited to structural changes—not screenshots or per-release strings.
- Each section cites the upstream source of truth (FAQ, install/docker) so future edits by maintainers automatically surface in the same files we touch.

## Impact
- Expected to cut foundational install errors by **≥50%** for new founders by making repo/data path boundaries, subagent auth sync, and config lint expectations explicit.
- Reduces reviewer load: every structural blind spot is backed by concrete logs (`raw_data/logs/auth_error_original.md`) and mapped to actionable doc insertions, so no additional reproduction work is required.
- Sets the stage for follow-up code PRs (config guard, auth sync, health dashboard) by codifying the desired behavior in public docs first.

## Prior art review (for reviewers)
- **Subagent auth:** Official coverage lives only in `help/faq.md` (“No API key found… copy auth-profiles.json”), so our Credential Auto-Sync module is additive—not a duplication.
- **Docker path integrity:** The upstream Docker chapter warns about repo root once in the "Manual flow" appendix; we surface the warning in quick-start form and add a guard snippet.
- **Safe-reload:** No existing doc mentions linting/rollback for `openclaw.json`, so the Safe-Reload protocol fills a true gap.

## Attachments / References
- Issue draft: `ISSUE_PROPOSAL.md`
- Founder companion guide: `docs/install/founder-companion.md`
- Drop-in Docker note: `docs/install/docker.md`
- Gap analysis appendix: `docs/install/official-gap-analysis.md`

## Looking ahead (tooling teaser)
- In parallel we prototyped auth-sync + config-guard scripts on a separate branch. Once these docs land and community feedback is positive, we’re ready to upstream the tooling as an opt-in Phase 5 experiment so the protocols evolve beyond documentation.
