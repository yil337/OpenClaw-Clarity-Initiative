# Clarity Initiative Roadmap (Phase 2+)

_Phase 1 (Repo initialization + pain capture) 已完成；下列阶段从 Phase 2 开始。_

## Phase 2 — Clarity Layer / Founder Install Journey
- **目标**：把真实踩坑转化为「创始人式安装体验」，让新人能“看得见灯塔”。
- **交付物**：
  - `docs/install/founder-companion.md`（创始人首小时体验、状态对照表、及时安抚文案）。
  - 状态/日志词典：`docs/install/status-playbook.md`（health: starting、gateway restarting 等）。
  - 结构化痛点速查：`raw_data/logs/` 持续补充现场案例。
- **关键动作**：整理真实日志 → 场景化脚本 → 插入“预判 + 操作”提示。
- **验收标准**：新人跟着文档可 0 依赖交互完成安装，遇到已知报错也能自救且心态稳定。

## Phase 3 — From Patch to Protocol
- **目标**：把我们临时补丁升级为官方应采纳的标准，形成 PR-ready 的论证。
- **交付物**：
  - `ROADMAP.md`（当前文件）+ `docs/install/phase4-protocols.md`：列出每条“官方应采纳的标准”。
  - 建议清单：Auth 自同步、路径指示、配置热校验、状态对照表等。
  - 每条建议附「我们已实现的临时方案」+「官方需要修改的点」。
- **关键动作**：把真实案例映射到配置/脚本改动建议；准备对官方 repo 的 issue/PR 论据。
- **验收标准**：每条标准都能回答「为何必要」「如何验证」「官方改哪里」。
- **核心稳定性增强（最高优先级）**：
  1. 《认证自动同步协议》— 子代理唤醒先校验+自动拉取主 `auth-profiles.json`。
  2. 《配置热加载安全协议》— Gateway 先 dry-run 验证，失败则保持旧配置并推告警。

## Phase 4 — Automation & Instrumentation
- **目标**：用脚本/工具巩固标准，让修复不靠手工口述。
- **交付物**：
  - Auth 同步脚本或检测（`scripts/auth-sync-check.sh`）。
  - Docker 路径自检工具（执行前确认当前目录 & 映射情况）。
  - `openclaw.json` 热校验 CLI（dry-run + lint + rollback 提示）。
- **关键动作**：快速原型 → 在我们 repo 里演示 → 准备并行的 PR patch。
- **验收标准**：工具可在本地跑出真实结果；README/Clarity Layer 引导用户使用这些脚本。

## Phase 5 — Pull Request Packaging & Review Campaign
- **目标**：把文档 + 工具打包成官方可接受的 PR/多 PR，并准备 Review 话术。
- **交付物**：
  - PR 草稿（或多 PR）：
    1. Docs：Founder Install + 状态词典 + Path 警告。
    2. Gateway config safety（热校验提示）。
    3. CLI/脚本改动（Auth 同步、Path 检测）。
  - Review FAQ：列出可能的 reviewer 质疑 & 预置回答。
- **关键动作**：按官方贡献指南建分支、写 commit message、跑 lint/tests、生成对比截图或日志。
- **验收标准**：PR 模板填完整、所有检查通过、我们能 24h 内回应 reviewer。

## Phase 6 — Adoption, Launch & Closeout
- **目标**：推动官方合并并验证真实用户能用，最后收官。
- **交付物**：
  - 合并后复测报告：记录官方主仓行为是否符合新标准。
  - 对外宣讲材料（博客草稿/社区帖子提纲）。
  - 项目总结：哪些痛点已解决、下一波可以延伸的课题。
- **关键动作**：跟进官方 issue/PR、回答反馈、在社区/Discord 分享成果。
- **验收标准**：PR 被接受或明确排期；已有新人验证新文档/工具有效；输出总结并 archive 项目。

---
**权限提醒**：如果后续需要额外权限（GitHub secrets、CI access 等），我会即时报告，避免阻塞以上阶段。