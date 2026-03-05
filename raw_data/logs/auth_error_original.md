# Auth & Config Failure Cases (Founder Notes)

## Case 1: Subagent Auth Desync (认证隔离)
- **Phenomenon:** 主配置已设 OpenAI，但子代理启动时仍报 `No API key found for provider "anthropic"`。
- **Root Cause:** 子代理目录 `/home/node/.openclaw/agents/main/agent/` 下的 `auth-profiles.json` 与主目录不一致，导致逻辑死锁。

## Case 2: Docker Path Shadowing (幽灵路径)
- **Phenomenon:** 在数据挂载目录 `~/.openclaw` 下执行 `docker compose` 指令报 `not found`。
- **Root Cause:** 执行文件 `docker-compose.yml` 位于物理路径 `/Users/yidongli/openclaw`，而非数据配置路径，对新手极具误导性。

## Case 3: JSON Schema Suicide (自毁逻辑)
- **Phenomenon:** 修改 `openclaw.json` 后 Gateway 陷入无限重启循环。
- **Root Cause:** 误将 `approvals` 键位放入 `agents.defaults` 导致 `Unrecognized key` 报错，系统缺乏容错直接宕机。
