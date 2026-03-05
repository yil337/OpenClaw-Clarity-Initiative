# Auth & Config Failure Cases (Operator Notes)

## Case 1: Subagent Auth Desync
- **Phenomenon:** Root agent already has OpenAI configured, but the subagent still logs `No API key found for provider "anthropic"`.
- **Root Cause:** The subagent's `~/ .openclaw/agents/main/agent/auth-profiles.json` diverges from the main copy, so the process deadlocks.

## Case 2: Docker Path Shadowing
- **Phenomenon:** Running `docker compose` inside the data mount `~/.openclaw` returns `command not found`.
- **Root Cause:** `docker-compose.yml` lives in `/Users/yidongli/openclaw` (repo root), not inside the data directory, which misleads newcomers.

## Case 3: JSON Schema Suicide
- **Phenomenon:** Editing `openclaw.json` sends the gateway into endless `gateway restarting` loops.
- **Root Cause:** Putting the `approvals` key under `agents.defaults` triggers `Unrecognized key`; without lint/rollback the system crashes.

### Log excerpts (operator terminal captures)

#### Connection Refused Loop
```
[2026-03-05T01:32:11.021Z] control-ui WARN gateway: connect ECONNREFUSED 127.0.0.1:18789
curl: (7) Failed to connect to 127.0.0.1 port 18789: Connection refused
openclaw dashboard --no-open
  ->  Error: HTTP 599 (connection refused)
```

#### Token Mismatch Spiral
```
[2026-03-05T01:34:55.886Z] control-ui WARN websocket: disconnected (1008): token mismatch
[2026-03-05T01:34:56.112Z] control-ui INFO reconnect scheduled in 5s
browser console: WebSocket close code 1008 -- token mismatch / expired
```
