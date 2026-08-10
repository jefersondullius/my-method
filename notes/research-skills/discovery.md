# Claude Code skills/plugins — live discovery (accessed 2026-08-10)

## Official marketplace
User's belief was CORRECT, verified live: `github.com/anthropics/claude-plugins-official` exists (GitHub API: 200, description "Official, Anthropic-managed directory of high quality Claude Code Plugins.", 285 plugins, pushed 2026-08-10).
[https://api.github.com/repos/anthropics/claude-plugins-official — accessed 2026-08-10]
- Auto-added on first interactive Claude Code start; manual: `/plugin marketplace add anthropics/claude-plugins-official`
- Install: `/plugin install <name>@claude-plugins-official` (e.g. `/plugin install github@claude-plugins-official`)
- Browse: `/plugin` → Discover tab, or claude.com/plugins
- Distinct catalogs also exist: community (`anthropics/claude-plugins-community`, add manually) and demo (`anthropics/claude-code` repo).
[https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10]

## Catalog contents (285 plugins, compressed)
Fetched live: `.claude-plugin/marketplace.json` [https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json — accessed 2026-08-10]. Full list too long for this file; by category (docs page):
- Code-intelligence LSPs (11): clangd/csharp/gopls/jdtls/kotlin/lua/php/pyright/rust-analyzer/swift/typescript-lsp.
- External integrations: github, gitlab, atlassian, asana, linear, notion, figma, vercel, firebase, supabase, slack, sentry.
- Security (Anthropic): `security-guidance` (auto in-session review), `claude-security` (deep on-demand scan). Plus many 3rd-party (42crunch, aikido, auth0, crowdstrike, pagerduty...).
- Dev workflow (Anthropic): commit-commands, pr-review-toolkit, code-review, code-simplifier, code-modernization, claude-code-setup, claude-md-management, playwright, agent-sdk-dev, plugin-dev.
- Output styles: explanatory-output-style, learning-output-style.
- Remainder (~250): vendor plugins (AWS, Azure, Databricks, Datadog, Airtable, etc.) — not exhaustively reproduced; see catalog URL above.

## anthropics/skills contents (17 skills, names + one-liners)
[https://raw.githubusercontent.com/anthropics/skills/main/README.md and per-skill SKILL.md — accessed 2026-08-10]
- algorithmic-art — generative/algorithmic art via p5.js.
- brand-guidelines — applies Anthropic brand colors/typography to artifacts.
- canvas-design — visual art (.png/.pdf) via design philosophy.
- claude-api — reference for Claude API/SDK (models, pricing, tool use).
- doc-coauthoring — structured workflow for co-authoring docs/specs.
- docx / pdf / pptx / xlsx — create/edit Word/PDF/PowerPoint/Excel files.
- frontend-design — aesthetic/UI design guidance.
- internal-comms — internal communications drafting.
- mcp-builder — guide for building MCP servers.
- skill-creator — create/optimize/benchmark skills.
- slack-gif-creator — animated GIFs for Slack.
- theme-factory — apply/generate visual themes for artifacts.
- web-artifacts-builder — complex multi-component HTML artifacts (React/Tailwind).
- webapp-testing — Playwright toolkit: verify frontend functionality, debug UI, screenshots, browser logs.
Install: `/plugin marketplace add anthropics/skills` then `/plugin install document-skills@anthropic-agent-skills` (docx/pdf/pptx/xlsx) or `/plugin install example-skills@anthropic-agent-skills` (the rest).

## Shortlist (6 items)
1. **playwright** — official marketplace (Microsoft) — browser automation/E2E-testing MCP server: screenshots, forms, clicks, automated browser workflows — *automated functional testing of web apps* — https://github.com/anthropics/claude-plugins-official (external_plugins/playwright)
2. **webapp-testing** — anthropics/skills (`example-skills` plugin) — Playwright-based local UI verification/debugging toolkit — *automated functional testing of web apps* — https://github.com/anthropics/skills/tree/main/skills/webapp-testing
3. **security-guidance** — official marketplace (Anthropic) — automatic per-edit pattern scan + end-of-turn LLM diff review + agentic commit/push review; nothing to invoke — *security checking of code changes* — https://code.claude.com/docs/en/security-guidance
4. **claude-security** — official marketplace (Anthropic) — on-demand deep multi-agent vulnerability scan, findings challenged/verified, produces patches — *security checking of code changes* (deeper tier) — https://github.com/anthropics/claude-plugins-official (plugins/claude-security)
5. **pr-review-toolkit** — official marketplace (Anthropic) — specialized PR-review agents: comments, tests, error handling, type design, quality, simplification — *code review* (supplements the free built-in `/code-review`) — https://github.com/anthropics/claude-plugins-public (plugins/pr-review-toolkit)
6. **claude-md-management** — official marketplace (Anthropic) — audits CLAUDE.md quality, captures session learnings, keeps project memory current — *keeping project state files in sync across sessions* — https://github.com/anthropics/claude-plugins-official (plugins/claude-md-management)

Needs with NO catalog match (empty is valid):
- **Enforcing verification-before-commit (evidence/gating):** none found. `security-guidance` docs explicitly say it "does not block writes or commits... for hard enforcement, pair the plugin with a hook that blocks the edit or a CI check." [https://code.claude.com/docs/en/security-guidance — accessed 2026-08-10]
- **Choosing model/effort per task:** met natively by built-in `/model` and `/effort` commands — no plugin needed. [https://code.claude.com/docs/en/model-config — accessed 2026-08-10]

## Built-in commands check
Both are BUILT-IN bundled skills (zero install), confirmed on the live commands table:
- `/code-review [low|medium|high|xhigh|max|ultra] [--fix] [--comment] [pr#|branch|path]` — "**[Skill](/docs/en/skills#bundled-skills).**" Reviews current diff/PR/branch/path for correctness + cleanup.
- `/security-review [...]` (alias `/security`) — "**[Skill](/docs/en/skills#bundled-skills).**" Same structure, security-focused.
[https://code.claude.com/docs/en/commands — accessed 2026-08-10]
Note: a separate "Code Review" product (GitHub App, Team/Enterprise, research preview, PR-triggered) exists at a different docs page — NOT required for the built-in slash commands. [https://code.claude.com/docs/en/code-review — accessed 2026-08-10]

## Deprecations/renames noticed
- Catalog's own live `"renames"` map (in marketplace.json): adlc→agentforce-adlc, airwallex→airwallex-agentos, convex-backend→convex, vals→valtown, wordpress.com→build-with-wordpress, qodo-skills→qodo, atlassian-forge-skills→forge-skills, azure-skills→azure, sonarqube-agent-plugins→sonarqube.
- `explanatory-output-style` plugin description: "mimics the **deprecated** Explanatory output style."
- `learning-output-style` plugin description: "mimics the **unshipped** Learning output style."
- `/review` is now an alias of `/code-review`; before v2.1.223 it was a separate read-only PR command.
- `/simplify` did bug-hunting before v2.1.147; from v2.1.154 it is cleanup-only (use `/code-review --fix` for bugs).

## Sources
- https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10
- https://code.claude.com/docs/en/plugin-marketplaces — accessed 2026-08-10
- https://code.claude.com/docs/en/security-guidance — accessed 2026-08-10
- https://code.claude.com/docs/en/code-review — accessed 2026-08-10
- https://code.claude.com/docs/en/commands — accessed 2026-08-10
- https://code.claude.com/docs/en/model-config — accessed 2026-08-10
- https://api.github.com/repos/anthropics/claude-plugins-official — accessed 2026-08-10
- https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json — accessed 2026-08-10
- https://api.github.com/repos/anthropics/skills/contents/skills — accessed 2026-08-10
- https://raw.githubusercontent.com/anthropics/skills/main/README.md (+ per-skill SKILL.md) — accessed 2026-08-10

## NOT VERIFIED
- All 285 plugin descriptions individually (only categories + shortlisted ones read in full; rest sampled).
- Whether the marketplace's `code-review` plugin listing is the same implementation as the separate "Code Review" GitHub App product — not explicitly stated by docs.
- Pricing/usage-credit cost of other individual plugins beyond `security-guidance`; anthropics/skills `spec/` and `template/` dirs not opened.
