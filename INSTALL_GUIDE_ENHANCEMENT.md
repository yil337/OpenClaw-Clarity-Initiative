# Install Guide Enhancement Plan

These notes explain how the clarity content maps into the official install docs.

## Modules
1. **Global Compass:** Pre-flight checklist for every platform. Lives inside `docs/install/docker.md` under "operator install clarity pack."
2. **Platform Runbooks:** Apple/Intel/Linux/WSL highlights now embedded in the same Docker chapter.
3. **Status Decoder:** Presented inline plus mirrored in `docs/install/status-playbook.md` for deep dives.
4. **Pain -> Comfort Map:** Table appended to `docs/install/docker.md` so readers can diagnose root causes instantly.

Each chunk references the same underlying standards defined in `docs/install/automation-protocols.md`, which makes it easy to cite when opening upstream issues and PRs.
