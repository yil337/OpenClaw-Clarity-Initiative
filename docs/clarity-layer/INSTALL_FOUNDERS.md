# OpenClaw Clarity Layer — Founder Install Journey

_This is the "friend sitting next to you" guide. No jargon dumps, just what to expect and what to do._

## How to use this guide
1. Skim the 5-minute map below so you know the beats before you start anything.
2. Jump to your platform runbook (Apple Silicon, Intel Mac, Linux/VPS, Windows/WSL).
3. Keep the [Status Playbook](./status-playbook.md) open—every scary log message we know about is decoded there.
4. When something hurts, log it in `raw_data/logs/` so the next founder sees a brighter light.

## The first 5 minutes
| Minute | What you do | What OpenClaw does | What you should feel |
| ------ | ------------ | ------------------ | --------------------- |
| 0-1 | Grab the latest installer command from docs or repo README. | Installer checks Node, Git, disk perms. | Calm: "This is just a bootstrap script." |
| 1-2 | Paste the command, press enter. | Homebrew/apt/Scoop may appear; Node 22 gets installed if missing. | Expect fan spin + password prompts (macOS/Linux). |
| 2-3 | Onboarding wizard or Docker setup starts. | CLI writes config into `~/.openclaw`, downloads pnpm deps. | Normal to see long `pnpm install` output; don’t interrupt. |
| 3-4 | Gateway starts; Control UI token printed. | Logs show `health: starting`, `gateway restarting`. | **Do not panic**—see Status Playbook. |
| 4-5 | Paste token into Control UI → Approve device. | Browser connects, you see dashboard. | Celebrate. Then snapshot your working state (`git status`, `openclaw doctor`). |

## Global Compass — Pre-flight checklists
Use these before you touch the installer; check every box to avoid 80% 的血泪。

#### Apple Silicon (M1–M4)
- [ ] `softwareupdate --install-rosetta --agree-to-license` 已成功（只需一次）。
- [ ] Docker Desktop 打开且状态为 **Running**（Whale 图标稳定）。
- [ ] `diskutil info / | grep "Free Space"` 显示剩余 ≥ 15 GB。
- [ ] 终端已获“完全磁盘访问权”（System Settings → Privacy & Security）。
- [ ] `openclaw --version` 若不存在，已确认 PATH 不会被旧 bashrc 覆盖。

#### Intel Mac
- [ ] 执行 `brew update && brew upgrade` 无错误。
- [ ] `xcode-select --install`（若提示“already installed”即可）。
- [ ] 机器接入电源（安装期间风扇会飙）。
- [ ] Docker Desktop 已启动 + Resources 分配 ≥ 4 CPU / 6 GB RAM。
- [ ] `sysctl -n machdep.cpu.brand_string` 输出确认是 Intel（用于后续文档提示）。

#### Linux / VPS
- [ ] `whoami` 的用户具备 sudo 权限（`sudo -n true` 不报错最好）。
- [ ] `locale` 中 `LANG` 含 `UTF-8`，无 `POSIX`/`C` 残留。
- [ ] `df -h ~` 显示剩余 ≥ 10 GB。
- [ ] 如果要跑 Docker：`docker info` 返回成功且 `docker ps` 可执行。
- [ ] 开放的端口（18789/ gateway) 未被其他服务占用（`ss -ltnp | grep 18789`）。

#### Windows / WSL2
- [ ] 已安装 WSL2 (`wsl --status` 显示 version 2) 且 Ubuntu 发行版就绪。
- [ ] `wsl -l -v` 中目标发行版状态为 Running。
- [ ] Windows Terminal / VS Code 连接到 WSL 内部路径（非 `/mnt/c`）。
- [ ] Windows 端已启用 "Developer Mode" + "Long Paths"，避免 git 报错。
- [ ] 浏览器已登录 GitHub，方便稍后授权。

## Platform runbooks

### Apple Silicon (M1/M2/M3/M4)
- **Before you run anything**
  - Ensure Rosetta is installed (`softwareupdate --install-rosetta --agree-to-license`) even if you rarely need x86—it prevents random brew fallback errors.
  - Free disk ≥ 15 GB (Docker base image + pnpm cache + workspace snapshot).
- **When running `install.sh` or `docker-setup.sh`**
  - Expect macOS to prompt for terminal permissions. Approve them once to avoid silent failures.
  - Docker Desktop on Apple Silicon may display "starting" for ~90s after updates; wait until the whale icon is steady before running scripts.
- **Normal log patterns**
  - `health: starting` for up to 120 s on M4 laptops because Rosetta warms up; the Status Playbook explains why.
  - `docker compose ... openclaw-cli` will fan-spin; ignore until CPU drops back under 100%.
- **If things stall**
  - Run `openclaw logs --lines 50` in another tab—if you only see repeating `gateway restarting`, check config syntax first (Phase 3 standard: hot validation will eventually prevent this).

### Intel Mac (pre-Apple Silicon)
- **Before run**
  - Update Homebrew first (`brew update && brew upgrade`) to avoid legacy Node 18 installs.
  - Intel fans spike sooner; keep machine on power.
- **During install**
  - `install.sh` may download Rosetta-free binaries; no Rosetta prompts expected.
  - Docker pulls are slower; expect `docker-setup.sh` to take 3‑5 minutes even on wired networks.
- **Known traps**
  - Missing Rosetta? irrelevant. Real hazard is old Xcode Command Line Tools—run `xcode-select --install` if clang errors appear.

### Linux / VPS (Ubuntu/Debian/RHEL/Alma/etc.)
- **Before run**
  - Confirm the host user has passwordless sudo or be ready to type your password multiple times.
  - Ensure the locale is UTF-8 (`locale` command) to avoid weird pnpm warnings.
- **During install**
  - `install.sh` may add NodeSource repos; if you’re on RHEL-alikes, allow the script to install `curl`, `tar`, `gcc`.
  - On Docker-only setups, remember: repo root != data mount. Clone `openclaw/openclaw`, run compose from there, and let config live in `~/.openclaw`.
- **After install**
  - `systemctl --user status openclaw-gateway` should show `running`. If it flaps, run `journalctl --user -u openclaw-gateway -n 100` and check Status Playbook entries.

### Windows / WSL2
- **Before run**
  - Install WSL2 Ubuntu and set it as default (`wsl --install -d Ubuntu`). Native PowerShell install works but WSL2 is significantly smoother.
  - Enable "Long Paths" in Windows if you plan to edit the repo via VS Code.
- **During install**
  - Run everything inside WSL. If you insist on PowerShell, expect prompts for winget/Chocolatey.
  - WSL file systems mounted under `/mnt/c` are slower; place the repo under `~/projects` inside the WSL ext4 filesystem.
- **After install**
  - Use `wsl.exe -d <distro> openclaw dashboard` to open Control UI.
  - If `openclaw` command is missing after install, append `export PATH="$HOME/.npm-global/bin:$PATH"` to `~/.bashrc`.

## Pain map → comfort map
| Pain we hit | What it means | Mitigation baked into this guide |
| ------------ | ------------- | -------------------------------- |
| Subagent auth desync (`No API key for provider "anthropic"`). | Subagents keep their own `auth-profiles.json`. | Phase 4 will add automatic sync checks; for now, duplicate credentials or symlink the file before spawning subagents. |
| Docker compose run from `~/.openclaw` instead of repo root. | Config lives in `~/.openclaw`, but compose files live wherever you cloned the repo. | Every platform section now states the repo/data split + the Status Playbook links to a quick sanity check snippet. |
| Gateway loops after editing `openclaw.json`. | Schema validation rejects unknown keys and restarts gateway indefinitely. | Short-term: keep a clean backup + run `openclaw doctor` after every edit. Mid-term: Phase 4 introduces `config lint` before hot reload. |

## Checkpoints before moving to Phase 3
- [ ] Apple + Intel + Linux + Windows founders can follow their runbook without asking “where do I run compose?”
- [ ] Status Playbook has entries for every log we mention here.
- [ ] Log every new pain in `raw_data/logs/` with reproduction notes.
- [ ] Control UI token + device pairing described in friendly terms (no browser surprises).

_This document is living. Every time you survive a new failure, add it here so the next founder doesn’t._
