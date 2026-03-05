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

### Log excerpts (Founder terminal captures)

#### Connection Refused Loop
```
[2026-03-05T01:32:11.021Z] control-ui WARN gateway: connect ECONNREFUSED 127.0.0.1:18789
curl: (7) Failed to connect to 127.0.0.1 port 18789: Connection refused
openclaw dashboard --no-open
  →  Error: HTTP 599 (connection refused)
```

#### Token Mismatch Spiral
```
[2026-03-05T01:34:55.886Z] control-ui WARN websocket: disconnected (1008): token mismatch
[2026-03-05T01:34:56.112Z] control-ui INFO reconnect scheduled in 5s
browser console: WebSocket close code 1008 — token mismatch / expired
```
