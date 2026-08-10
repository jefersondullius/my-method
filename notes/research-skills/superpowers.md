# Plugin candidate: superpowers

**Queried name:** superpowers (believed author: Jesse Vincent / GitHub `obra`)
**EXISTS?** yes, at `github.com/obra/superpowers` [4]
**Real current name:** `superpowers` (unchanged; matches `.claude-plugin/plugin.json` `name` field) [7]
**Origin:** community plugin, not official Anthropic. Author: Jesse Vincent (`obra`); repo description "An agentic skills framework & software development methodology that works." [4]. README credits a "Commercial Services" contact at `sales@primeradiant.com`; one commit's author email is `jesse@primeradiant.com` vs `jesse@fsck.com` in plugin.json — relationship between Vincent and "Prime Radiant" not independently confirmed beyond the README text [8][5][7] (see NOT VERIFIED).

## Ground truth: official marketplace
`github.com/anthropics/claude-plugins-official` **does exist** — the user's belief was correct, no rename needed. Confirmed via GitHub API: full_name `anthropics/claude-plugins-official`, description "Official, Anthropic-managed directory of high quality Claude Code Plugins." [1]. Docs confirm Claude Code auto-adds this marketplace on first interactive start [2].
**Exact install syntax (from live docs):** `/plugin install <plugin-name>@claude-plugins-official`, e.g. `/plugin install github@claude-plugins-official`; add manually with `/plugin marketplace add anthropics/claude-plugins-official` [2].

**Purpose (pt-BR):** Superpowers é um plugin de terceiros para Claude Code que instala uma metodologia completa de desenvolvimento — brainstorming guiado, planejamento, TDD red/green obrigatório e revisão de código via subagentes — e injeta suas instruções centrais no contexto de toda sessão por meio de um hook.

**Install command (exact, from plugin's own README):** official → `/plugin install superpowers@claude-plugins-official`; author's own marketplace → `/plugin marketplace add obra/superpowers-marketplace` then `/plugin install superpowers@superpowers-marketplace` [8].

**In official marketplace?** YES. Confirmed by fetching the live `.claude-plugin/marketplace.json` from `anthropics/claude-plugins-official`: entry `"name": "superpowers"`, `"category": "development"`, source `https://github.com/obra/superpowers.git` pinned at sha `44c9b2d6e8899...` [16]. That pinned sha is identical to the latest commit sha on `obra/superpowers` main fetched independently [5][16] — the official catalog is current with upstream as of this check.

**Actively maintained (evidence + date):** Last commit `44c9b2d` on 2026-07-27T18:43:14Z (author Jesse Vincent), committed 2026-07-28T19:25:36Z — 13-14 days before today (2026-08-10) [5]. Latest release `v6.2.0`, published 2026-07-24T00:28:17Z, with a substantive changelog describing structural SDD changes "developed against live eval campaigns" [6]. `plugin.json` version field matches release (6.2.0) [7].

**Composition & context surface:** 14 skills, 0 custom commands directory, 0 registered agents directory, 1 hook. Skills (each a `SKILL.md`): brainstorming, dispatching-parallel-agents, executing-plans, finishing-a-development-branch, receiving-code-review, requesting-code-review, subagent-driven-development, systematic-debugging, test-driven-development, using-git-worktrees, using-superpowers, verification-before-completion, writing-plans, writing-skills [9]. (A third-party search summary claimed "20+ skills" — contradicted by this direct file-tree count; treat 14 as the verified figure and 20+ as NOT VERIFIED.) Hook: `SessionStart`, matcher `"startup|clear|compact"` — fires on every session start, `/clear`, and `/compact` [10]. What it injects: the hook script reads the **entire** `skills/using-superpowers/SKILL.md` file verbatim and returns it as `additionalContext`, wrapped in `<EXTREMELY_IMPORTANT>` tags — i.e., full skill text (not just name/description) lands in every session unconditionally [10][14]. No named subagents ship; task-specific prompts (e.g. `implementer-prompt.md`) are dispatched via Claude's generic Task tool at runtime.

**Auto-trigger (brainstorming, exact frontmatter):** `description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."` [11]. Produces: a written, user-approved design/spec doc at `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`, committed to git, after a self-review pass. Hands off to exactly one next skill: "The terminal state is invoking writing-plans... Do NOT invoke frontend-design, mcp-builder, or any other implementation skill." [11], which itself feeds subagent-driven-development/executing-plans for execution [15].

**TDD implications:** Enforced, not optional-by-default. Primary skill `test-driven-development` states an "Iron Law: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST," mandates Red-Green-Refactor, rejects listed rationalizations, allows exceptions only by asking the human partner (prototypes/generated code/config) [12]. `writing-plans` bakes the same cycle directly into every task template ("Write the failing test" → "Run to verify it fails" → "minimal implementation" → "verify it passes" → commit) [15]. `subagent-driven-development`'s dispatched implementers execute those TDD-shaped tasks [16-repo][5]. README: "It emphasizes true red/green TDD, YAGNI... and DRY" [8].

**Standalone-brainstorming feasibility:** Technically yes — `brainstorming/SKILL.md` is self-contained and produces a concrete standalone artifact (the spec file); nothing at runtime forces the next skill to fire. But the skill's own text is hard-wired to treat `writing-plans` as the only allowed next step, and the plugin-wide `using-superpowers` hook (injected every session, see above) instructs Claude that any applicable skill "is not negotiable... you cannot rationalize your way out of this" [14]. So a user must actively resist that pressure each session to use brainstorming in isolation, and installing the plugin at all applies that mandatory-skill-use framing to every conversation, not just design work.
**Can a user disable one skill inside an installed plugin?** No. Live docs are explicit: the `skillOverrides` setting (which can hide/collapse individual skills) "are not affected by `skillOverrides`. Manage those through `/plugin` instead" for plugin-provided skills [17]. Plugin-level controls (`/plugin disable`, `claude plugin disable`) only toggle the whole plugin [18].

**Deterministic alternative:** Claude Code ships a built-in Plan Mode (`Shift+Tab` twice, or `--permission-mode plan`) that is read-only, explores first, and proposes a plan for approval before any edit — docs recommend it explicitly for "explore before implementing" [19]. For a lighter-weight substitute for brainstorming alone, a project-local custom skill/command (`.claude/skills/`) with similar instructions gives the same "pause, ask, write a spec" effect without the 14-skill install, the forced-every-session hook injection, or the inability to disable parts of it. Replicating the TDD *enforcement* (not just the practice) with comparable rigor is harder without a similar hook/skill combo; a CLAUDE.md rule ("always write a failing test first") is the closest deterministic, install-free approximation but lacks runtime enforcement.

## NOT VERIFIED
- Exact nature/legal relationship of "Prime Radiant" to Jesse Vincent/obra beyond the README's own commercial-services blurb and differing commit-vs-manifest email domains [8][5][7].
- GitHub star/fork/download counts for either repo (hit GitHub API rate limit mid-session; not re-queried to avoid guessing).
- The "20+ skills" figure from a third-party search-engine summary (contradicted by direct count of 14 — see above).
- Whether `obra/superpowers-marketplace` (the author's own, separate marketplace) has any submission/vetting relationship to the official Anthropic marketplace — treated here as an independent, non-official channel based on docs' own official/community/demo taxonomy [2][3].

## Sources
[1] api.github.com/repos/anthropics/claude-plugins-official — accessed 2026-08-10
[2] code.claude.com/docs/en/discover-plugins — accessed 2026-08-10
[3] code.claude.com/docs/en/plugin-marketplaces — accessed 2026-08-10
[4] api.github.com/repos/obra/superpowers — accessed 2026-08-10
[5] api.github.com/repos/obra/superpowers/commits (latest: 44c9b2d) — accessed 2026-08-10
[6] github.com/obra/superpowers/releases/tag/v6.2.0 — accessed 2026-08-10
[7] raw.githubusercontent.com/obra/superpowers/main/.claude-plugin/plugin.json — accessed 2026-08-10
[8] raw.githubusercontent.com/obra/superpowers/main/README.md — accessed 2026-08-10
[9] api.github.com/repos/obra/superpowers/git/trees/main?recursive=1 (full file tree) — accessed 2026-08-10
[10] raw.githubusercontent.com/obra/superpowers/main/hooks/hooks.json and /hooks/session-start — accessed 2026-08-10
[11] raw.githubusercontent.com/obra/superpowers/main/skills/brainstorming/SKILL.md — accessed 2026-08-10
[12] raw.githubusercontent.com/obra/superpowers/main/skills/test-driven-development/SKILL.md — accessed 2026-08-10
[13] raw.githubusercontent.com/obra/superpowers/main/skills/subagent-driven-development/SKILL.md — accessed 2026-08-10
[14] raw.githubusercontent.com/obra/superpowers/main/skills/using-superpowers/SKILL.md — accessed 2026-08-10
[15] raw.githubusercontent.com/obra/superpowers/main/skills/writing-plans/SKILL.md — accessed 2026-08-10
[16] raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json — accessed 2026-08-10
[17] code.claude.com/docs/en/skills, "Override skill visibility from settings" section — accessed 2026-08-10
[18] code.claude.com/docs/en/settings and /docs/en/plugins-reference — accessed 2026-08-10
[19] code.claude.com/docs/en/how-claude-code-works — accessed 2026-08-10
