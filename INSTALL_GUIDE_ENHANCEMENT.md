# Install Guide Enhancement Pack (Docs-first PR draft)

This file distills the Clarity Layer work into actionable chunks for `docs/install/` in the upstream repo.

## 1. Global Compass (Pre-flight checklists)
- **Placement:** `/install/index.md` right after “System requirements”.
- **Content:** four checkbox lists (Apple Silicon, Intel Mac, Linux/VPS, Windows/WSL2) covering Rosetta, Docker readiness, disk space, locale, WSL status, etc.
- **Goal:** eliminate 80% of environment surprises before the installer runs.

## 2. Path integrity warning
- **Placement:** `/install/docker.md` under the “Quick start” instructions and again in the Manual flow.
- **Content:** bold callout: “Do not run `docker compose` from `~/.openclaw`. Always run from the repo root (`<clone>/`), while config lives in `~/.openclaw`.” Include a one-line check (`ls docker-compose*.yml || echo "not in repo"`).
- **Goal:** kill the Docker Path Shadowing class of support tickets.

## 3. Status decoder sidebar
- **Placement:** `/install/docker.md` and `/start/getting-started.md` sidebar/Admonition.
- **Content:** mini table explaining `health: starting`, `gateway restarting`, `pairing required`, plus expected wait times and next actions.
- **Goal:** calm founders during the first boot; point them to the Visual Health Dashboard once it ships.

## 4. Auth sync reminder
- **Placement:** `/gateway/security/index.md` or `/gateway/configuration-examples.md` near the auth profile explanation.
- **Content:** short tip: “Subagents have their own `auth-profiles.json`. Before launching subagents, copy the main profile or run the upcoming `auth-sync` helper. Missing keys cause `No API key` errors.”

## 5. Troubleshooting quick scripts appendix
- **Placement:** `/install/troubleshooting.md`.
- **Content:** add the `curl -vk 127.0.0.1:18789/health`, `diff auth-profiles`, and `openclaw doctor --non-interactive` snippets pulled from Status Playbook.

Each chunk references the same underlying standards defined in `docs/clarity-layer/protocols.md`, making it easy to cite when opening upstream issues/PRs.
