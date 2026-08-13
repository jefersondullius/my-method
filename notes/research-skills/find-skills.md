# Verification: "find-skills" (Claude Code skill/plugin)

Checked live on 2026-08-10. Every claim below cites a page/API call fetched this session.

## 0. Ground truth: official marketplace
User's belief — `github.com/anthropics/claude-plugins-official` — is **correct, confirmed live**: repo exists, not archived, 33,369 stars, pushed today (2026-08-10T20:13:25Z).
[https://github.com/anthropics/claude-plugins-official — accessed 2026-08-10, via GitHub API `repos/anthropics/claude-plugins-official`]
Docs confirm Claude Code auto-adds it on first interactive run; manual fallback `/plugin marketplace add anthropics/claude-plugins-official`. Exact install syntax: `/plugin install <name>@claude-plugins-official` (e.g. `/plugin install github@claude-plugins-official`).
[https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10]
No correction needed.

## 1. Candidate fields

- **Queried name:** find-skills
- **EXISTS?** YES — but as TWO unrelated same-named things. Neither is a standalone top-level plugin; both are sub-items inside larger repos.
- **Real current name (multiple entries):**
  1. **Most likely what a user heard of:** skill `find-skills` at `vercel-labs/skills`, path `skills/find-skills/SKILL.md`. Part of Vercel's "Skills CLI" (`npx skills`, skills.sh) — an open, multi-agent skills package manager, separate from Claude Code's own plugin system.
     [https://github.com/vercel-labs/skills/tree/main/skills/find-skills — accessed 2026-08-10]
  2. **Unrelated, defunct:** a bash *script* (not a skill) also named `find-skills`, at `obra/superpowers-skills` path `skills/using-skills/find-skills`. That repo is **archived/read-only since 2025-10-27**. The live `superpowers` plugin (per `obra/superpowers-marketplace`'s marketplace.json) sources skills from the separate, active `github.com/obra/superpowers.git`, whose equivalent `skills/using-superpowers/` folder has no find-skills file — this variant ships to no one today.
     [https://github.com/obra/superpowers-skills — accessed 2026-08-10; marketplace.json at https://github.com/obra/superpowers-marketplace/blob/main/.claude-plugin/marketplace.json — accessed 2026-08-10; https://github.com/obra/superpowers/tree/main/skills/using-superpowers — accessed 2026-08-10]
  3. A claudepluginhub.com page slugged "dan323-find-skills..." turned out, on inspection, to be about a different marketplace (`dan323/easier-life-skills`) with a generic multi-marketplace browser feature — not an independent find-skills entity. Not counted as a third variant.
     [https://www.claudepluginhub.com/plugins/dan323-find-skills-plugins-find-skills — accessed 2026-08-10]
- **Origin:** #1 = Vercel (vercel-labs GitHub org); contributors include `quuu`/Andrew Qu and `crskzn`. #2 = Jesse Vincent (`obra`), archived side-repo of his "Superpowers" methodology.
- **Purpose (pt-BR):** É uma skill que instrui o Claude a pesquisar o ecossistema aberto de skills (via `npx skills find`) quando o usuário pergunta algo como "como faço X" ou "existe uma skill para X", e a recomendar/instalar a opção mais confiável antes de reinventar a solução.
- **Install command (exact):** `npx skills add vercel-labs/skills --skill find-skills --agent claude-code` — composed from the README's documented flag syntax (`--skill <name>`, `-a`/`--agent <agent>`) applied to the confirmed repo/skill path. The README itself has no line naming "find-skills" verbatim (see NOT VERIFIED). Discovery command confirmed verbatim: `npx skills find [query]`.
  [https://raw.githubusercontent.com/vercel-labs/skills/main/README.md — accessed 2026-08-10]
- **In official marketplace?** NO. Not distributed via Claude Code's `/plugin` system at all — `npx skills` is a separate third-party CLI/registry. Also absent from the official marketplace's documented plugin categories (LSP, integrations, security-guidance, commit-commands/pr-review-toolkit/agent-sdk-dev/plugin-dev, output styles) and from the skills doc's own cited official plugin (`skill-creator`).
  [https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10; https://code.claude.com/docs/en/skills — accessed 2026-08-10]
- **Actively maintained:** #1 YES — parent repo pushed today (2026-08-10); last commit touching the find-skills path 2026-07-10 ("remove redundant check command"), earlier substantive edit 2026-03-13 (added quality-verification/leaderboard step), history back to 2026-01-26. #2 NO — archived 2025-10-27, read-only.
  [GitHub API `repos/vercel-labs/skills/commits?path=skills/find-skills` — accessed 2026-08-10]
- **Composition & context surface:** Single-file skill, `SKILL.md` = 5,472 bytes, no bundled scripts/hooks/MCP in that subfolder. Per Claude Code's own skill lifecycle, once installed its `description` stays in context every turn; the full body loads only when triggered.
  [https://code.claude.com/docs/en/skills — accessed 2026-08-10]
- **Auto-trigger (quoted):** "Helps users discover and install agent skills when they ask questions like 'how do I do X', 'find a skill for X', 'is there a skill that can...', or express interest in extending capabilities. This skill should be used when the user is looking for functionality that might exist as an installable skill."
  [https://raw.githubusercontent.com/vercel-labs/skills/main/skills/find-skills/SKILL.md — accessed 2026-08-10]
- **Deterministic alternative:** Partial. Claude Code's built-in `/plugin` → **Discover** tab browses every added marketplace's catalog with no third-party install step; `/plugin marketplace update` run periodically plus a manual skim of Discover is a no-new-dependency substitute for "what's available." It does **not** replicate find-skills' cross-registry keyword search (`npx skills find <query>`) or its automatic recommend-on-request behavior — no built-in Claude Code command searches the web/skills.sh for a skill matching a described task. The closest official plugin, `skill-creator` (`/plugin install skill-creator@claude-plugins-official`), evaluates/authors skills; it does not discover third-party ones.
  [https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10; https://code.claude.com/docs/en/skills — accessed 2026-08-10]

## Sources
- https://github.com/anthropics/claude-plugins-official (+ GitHub API) — accessed 2026-08-10
- https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10
- https://code.claude.com/docs/en/plugin-marketplaces — accessed 2026-08-10
- https://code.claude.com/docs/en/skills — accessed 2026-08-10
- https://github.com/vercel-labs/skills (+ API: contents, commits) — accessed 2026-08-10
- https://raw.githubusercontent.com/vercel-labs/skills/main/skills/find-skills/SKILL.md — accessed 2026-08-10
- https://raw.githubusercontent.com/vercel-labs/skills/main/README.md — accessed 2026-08-10
- https://github.com/obra/superpowers-skills (archived) — accessed 2026-08-10
- https://github.com/obra/superpowers-marketplace/blob/main/.claude-plugin/marketplace.json — accessed 2026-08-10
- https://github.com/obra/superpowers/tree/main/skills/using-superpowers — accessed 2026-08-10
- https://www.claudepluginhub.com/plugins/dan323-find-skills-plugins-find-skills — accessed 2026-08-10
- https://mcpmarket.com/tools/skills/find-skills — accessed 2026-08-10 (secondary, corroborating only)

## NOT VERIFIED
- The install command is composed from the README's documented flag pattern, not copy-pasted from a line naming "find-skills" verbatim — pattern confirmed, exact literal example not found.
- "2.5M installs, 26k stars" claimed for this specific skill by mcpmarket.com — not independently confirmed against a primary skills.sh metrics page; the 26k roughly matches the repo's real 28,578 GitHub stars, but the 2.5M install figure has no primary-source citation here.
- Full-tree grep of `anthropics/claude-plugins-official` for "find-skills" — GitHub API was rate-limited and GitHub code search requires login; absence is inferred from the live docs' explicit category/plugin listing, not a raw repo-wide search.
- Why claudepluginhub.com's URL slug contains "find-skills" for the dan323/easier-life-skills page — not resolved; likely a site-internal tag, not a Claude-side fact. Not chased further given scope.

## Addendum (live, 2026-08-13) — manual-copy question and a correction

**Correction to Q1:** the `vercel-labs/skills` repository's own `skills/` folder packages only **1 skill** (`find-skills`) — not several. Confirmed via `https://api.github.com/repos/vercel-labs/skills/contents/skills — accessed 2026-08-13`. The repo is mostly the `npx skills` CLI's own code (`cli/`, `plugin/`, `extension/`, `src/`); the large multi-skill "catalog" lives on the external site skills.sh, referenced by the README, not as content of this git repository. (A sibling repo, `vercel-labs/agent-skills`, does hold multiple skills in its own `skills/` folder, but that is a different package, not counted here.) This does not change the practical answer (find-skills is not distributed via Claude Code's own `/plugin` system at all), only the earlier open question of "how many" inside this specific repo.

**Q2 — license and manual copy:** MIT, reconfirmed live via both the raw `LICENSE` file and the GitHub API's `license.spdx_id: MIT` field [https://api.github.com/repos/vercel-labs/skills — accessed 2026-08-13]. (An older open issue, #946, complained the API returned `license: null` — that appears resolved today; the issue's closure status was not independently confirmed.) The `find-skills` folder holds only `SKILL.md` (5,472 bytes) — no scripts/agents/hooks bundled, though the skill's own text instructs Claude to shell out to the external `npx skills` CLI at run time (a runtime dependency, not a bundled file).

**Q3 — trade-off:** `npx skills add vercel-labs/skills --skill find-skills --agent claude-code` already writes a plain, editable local Markdown file into `.claude/skills/` or `~/.claude/skills/` — this **is**, in practice, a form of manual copy, just automated by the tool instead of done by hand, with no `/plugin` involvement. Since nothing is bundled beyond the one file, there is no functional loss either way.

**Decision 2026-08-13:** not installed. The reason for rejecting it was never the always-on description cost — it was being outside the auditable `/plugin` system (no marketplace entry, no version-pinned source, install flows through a third-party npx registry instead) — and that has not changed.
