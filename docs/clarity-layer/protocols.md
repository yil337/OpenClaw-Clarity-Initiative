# Clarity Layer Protocols (Phase 3 Draft)

These are the standards we want upstream OpenClaw to adopt. Each protocol turns a recurring pain point into a deterministic workflow.

## 1. Credential Auto-Sync Protocol
- **Origin:** Case 1 — Subagent Auth Desync (认证隔离)。
- **Problem:** Subagents boot inside their own `~/.openclaw/agents/<agentId>/agent/` tree. If their `auth-profiles.json` diverges from the main agent, launches fail with `No API key found for provider "anthropic"` even though the root config is correct. Today the system just errors out.
- **Standard definition:**
  1. On every subagent boot (CLI spawn, `sessions_spawn`, cron, etc.), compute the SHA-256 of the parent `~/.openclaw/agents/main/agent/auth-profiles.json` and compare it with the child copy.
  2. If hashes differ or the file is missing, automatically copy/sync the main profile before any agent code runs.
  3. Only emit a warning if the sync succeeds; escalate to error only if the copy fails (bad perms, disk full, etc.). Never leave the subagent in a half-initialized state.
- **Implementation blueprint:**
  - Add a bootstrap hook (e.g., `agents.bootstrap.syncAuthProfiles`) that runs prior to tool init.
  - Support opt-out via config for advanced users, default to `on` for all first-party agents.
  - Include telemetry: record `authSyncStatus={"agentId":"<id>","result":"copied"|"skipped"|"failed"}` in gateway logs.
- **Success criteria:**
  - Founder never sees `No API key` on first launch if the main agent has creds.
  - `openclaw doctor` gains a check that asserts `synced=true` for every configured subagent.

## 2. Safe-Reload Protocol
- **Origin:** Case 3 — JSON Schema Suicide (配置自毁)。
- **Problem:** Editing `~/.openclaw/openclaw.json` with invalid keys causes the gateway to restart in a tight loop. There is no safety net; founders watch "gateway restarting" forever.
- **Standard definition:**
  1. Before applying any hot-reload, run a dry-run validator (`openclaw config lint --no-apply`).
  2. If validation fails, keep the previous config in memory, continue serving requests, and surface a blocking alert (`control-ui`, CLI, `openclaw doctor`).
  3. Only write the new config to disk snapshots after validation passes. Provide an automatic rollback pointer (`~/.openclaw/openclaw.json.bak`).
- **Implementation blueprint:**
  - Extend the gateway watcher: when the file changes, fork a validator process. Apply changes only on success.
  - Emit a structured event (`configReloadStatus`) with `source=file|cli|ui`, `result=applied|rejected`, `errorPath`.
  - CLI command `openclaw config apply` should accept `--dry-run` and `--revert-last` flags for deterministic recovery.
- **Success criteria:**
  - No more gateway crash loops from syntax errors; the running config stays healthy.
  - Control UI shows a red banner with the exact invalid path/value so a founder can fix it without tailing logs.

---
**Next steps (Phase 3):** codify additional protocols (path clarity, status UX) and bundle them into ROADMAP priorities + upstream PRs.
