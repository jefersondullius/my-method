# skill-creator — verification (live, 2026-08-10)

**Marketplace ground truth check (requested first):** `github.com/anthropics/claude-plugins-official` EXISTS and IS the real official Claude Code plugin marketplace — the user's belief is CORRECT, no rename/correction needed. Confirmed via GitHub API (HTTP 200; description "Official, Anthropic-managed directory of high quality Claude Code Plugins") and live docs, which state Claude Code auto-adds this marketplace on first interactive start [https://api.github.com/repos/anthropics/claude-plugins-official — accessed 2026-08-10] [https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10].

**Queried name:** skill-creator

**EXISTS?** YES, in two live, currently-synced locations.

**Real current name:** `skill-creator` in both locations — no rename found (absent from the official marketplace's `renames` map).

**Origin:**
1. Canonical skill: `github.com/anthropics/skills`, path `skills/skill-creator/SKILL.md` [https://github.com/anthropics/skills/tree/main/skills/skill-creator — accessed 2026-08-10].
2. Official-marketplace plugin: `github.com/anthropics/claude-plugins-official`, path `plugins/skill-creator/` [https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator — accessed 2026-08-10]. Its `SKILL.md` has the identical git blob SHA (`65b3a402db…`) as copy 1, and the sync commit is explicit (see Maintained, below) — a synced copy, not an independent fork.

**Purpose (pt-BR):** Ajuda a criar uma skill nova, editar ou otimizar uma já existente, e automatiza um ciclo de avaliação — rodar testes, comparar versões lado a lado e medir a taxa de acerto do gatilho automático — para provar que a skill funciona antes de você confiar nela.

**Install command (exact):**
- Official marketplace (dedicated, single-skill plugin): `/plugin install skill-creator@claude-plugins-official` (marketplace is auto-added by Claude Code on first run; if missing, `/plugin marketplace add anthropics/claude-plugins-official` first). This exact command is given in the live skills docs itself, section "Run evals with skill-creator" [https://code.claude.com/docs/en/skills — accessed 2026-08-10].
- Skills repo as secondary marketplace (bundles 11 other unrelated example skills, not standalone): `/plugin marketplace add anthropics/skills` then `/plugin install example-skills@anthropic-agent-skills` [https://raw.githubusercontent.com/anthropics/skills/main/README.md — accessed 2026-08-10] [https://raw.githubusercontent.com/anthropics/skills/main/.claude-plugin/marketplace.json — accessed 2026-08-10].

**In official marketplace?** YES — as its own standalone, single-skill plugin (not folded into a bundle). Confirmed live at `plugins/skill-creator/.claude-plugin/plugin.json` inside `claude-plugins-official` [https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/plugins/skill-creator/.claude-plugin/plugin.json — accessed 2026-08-10].

**Actively maintained (evidence + date):** Added to the official marketplace 2026-02-18 ("Add skill-creator plugin", #1). Official Anthropic blog post announcing its eval/benchmark features published 2026-03-03 [https://claude.com/blog/improving-skill-creator-test-measure-and-refine-agent-skills — accessed 2026-08-10]. Upstream (`anthropics/skills`) last substantive change 2026-03-06, "drop ANTHROPIC_API_KEY requirement" (#547). That change was mirrored into the official marketplace 2026-04-23, "skill-creator: sync from anthropics/skills" (#1523) [gh api repos/anthropics/claude-plugins-official/commits?path=plugins/skill-creator — accessed 2026-08-10]. Both parent repos received fresh pushes within days of today (claude-plugins-official 2026-08-10; anthropics/skills 2026-08-07), but neither push touched the skill-creator path itself — so as of today, ~3.5 months since the last skill-creator-specific commit: maintained, not high-frequency.

**Composition & context surface:**
- Session start: only the plugin's short `description` loads into context for every installed skill ("Description always in context, full skill loads when invoked") [https://code.claude.com/docs/en/skills — accessed 2026-08-10]. This skill's frontmatter `description` is 319 characters.
- On trigger: `SKILL.md` itself is 485 lines / 5,205 words / 33,168 bytes — unusually large (docs recommend keeping SKILL.md under 500 lines; this sits right at that ceiling).
- Beyond SKILL.md, the skill bundles (loaded only on demand, not at trigger time): 3 subagent definitions in `agents/` (analyzer, comparator, grader — 10.4KB/7.3KB/9.0KB), `references/schemas.md` (12KB), 8 Python scripts in `scripts/` (eval runner, benchmark aggregator, description optimizer, packager, validator — 1.7–14.4KB each), and an HTML eval viewer (`eval-viewer/viewer.html`, 45KB, plus `assets/eval_review.html`, 7KB).

**Auto-trigger (quoted, from SKILL.md frontmatter, identical in both copies):** "Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy." [https://raw.githubusercontent.com/anthropics/skills/main/skills/skill-creator/SKILL.md — accessed 2026-08-10]. No `disable-model-invocation` or `user-invocable: false` set, so Claude can fire it automatically and a user can also invoke it directly.

**Built-in redundancy (what the harness already does without it):** None found. The live commands reference lists no `/create-skill`, `/init-skill`, or equivalent — Claude Code has no built-in skill-scaffolding command at all [https://code.claude.com/docs/en/commands — accessed 2026-08-10]. The harness's only native support is documentational: a manual "Create your first skill" walkthrough in the skills docs (`mkdir ~/.claude/skills/<name>`, hand-write YAML frontmatter + markdown body) — pure instructions, zero tooling [https://code.claude.com/docs/en/skills — accessed 2026-08-10]. So the redundancy is partial: any Claude Code session can already draft a working `SKILL.md` unassisted with its normal Read/Write/Edit tools, matching the bare "create a skill" case. What is NOT replicated natively is the eval/benchmark apparatus — per-test-case subagent runs, pass/fail grading, with-vs-without-skill benchmarking, blind A/B version comparison, automated description-trigger tuning — none of that exists in the harness; it is exactly what skill-creator's 3 subagents and 8 scripts add.

**Deterministic alternative:** `anthropics/skills/template/SKILL.md` — a static 4-line stub (`name`/`description` placeholders + "Insert instructions below") to hand-copy, with no agentic workflow, scripts, or evals attached [https://raw.githubusercontent.com/anthropics/skills/main/template/SKILL.md — accessed 2026-08-10]. For validation only (not creation), `scripts/quick_validate.py` inside skill-creator itself is a deterministic (non-agentic) frontmatter/structure checker, usable standalone once the plugin is installed.

**Sources (all accessed 2026-08-10):**
- https://github.com/anthropics/claude-plugins-official ; https://api.github.com/repos/anthropics/claude-plugins-official
- https://code.claude.com/docs/en/discover-plugins ; https://code.claude.com/docs/en/plugin-marketplaces
- https://code.claude.com/docs/en/skills ; https://code.claude.com/docs/en/commands
- https://github.com/anthropics/skills ; https://github.com/anthropics/skills/tree/main/skills/skill-creator
- https://raw.githubusercontent.com/anthropics/skills/main/skills/skill-creator/SKILL.md
- https://raw.githubusercontent.com/anthropics/skills/main/README.md ; https://raw.githubusercontent.com/anthropics/skills/main/template/SKILL.md
- https://raw.githubusercontent.com/anthropics/skills/main/.claude-plugin/marketplace.json
- https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator
- https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/plugins/skill-creator/.claude-plugin/plugin.json
- https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/plugins/skill-creator/README.md
- https://claude.com/blog/improving-skill-creator-test-measure-and-refine-agent-skills
- GitHub commit history via `gh api` (authenticated): repos/anthropics/skills/commits?path=skills/skill-creator ; repos/anthropics/claude-plugins-official/commits?path=plugins/skill-creator

**NOT VERIFIED:**
- Live in-app "Context cost" / "Last updated" values shown in the actual `/plugin` detail pane (docs describe the UI field; no interactive Claude Code session was driven to read the rendered number).
- Exact tokenizer-measured token count of SKILL.md (only byte/word/line counts given above).
- Full byte-for-byte diff of every supporting file (agents/, references/, scripts/, eval-viewer/) between the two copies — only the SKILL.md blob SHA was directly compared.
- Download/install counts or user ratings for the plugin (no such live metric was found/published).
