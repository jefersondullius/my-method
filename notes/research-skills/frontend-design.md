# frontend-design — verification (live, 2026-08-10)

**Queried name:** frontend-design

**EXISTS?** YES, in two live, currently-synced locations.

**Real current name:** `frontend-design` in both locations — no rename found (absent from the marketplace's `renames` map).

**Origin:**
1. Canonical skill: `github.com/anthropics/skills`, path `skills/frontend-design/SKILL.md` [https://github.com/anthropics/skills/tree/main/skills/frontend-design — accessed 2026-08-10].
2. Official-marketplace plugin: `github.com/anthropics/claude-plugins-official`, path `plugins/frontend-design/` [https://github.com/anthropics/claude-plugins-official/tree/main/plugins/frontend-design — accessed 2026-08-10]. Its bundled `SKILL.md` has the identical git blob SHA (`decdff43d0…`) as copy 1 — a synced copy, not a fork.

**Purpose (pt-BR):** Ensina o Claude a tomar decisões visuais mais ousadas e específicas ao contexto — paleta, tipografia, layout — ao criar ou redesenhar uma interface, em vez de cair nos três estilos genéricos que a IA usa por padrão.

**Install command (exact):**
- Official marketplace (dedicated, single-skill plugin): `/plugin install frontend-design@claude-plugins-official` (marketplace is auto-added by Claude Code on first run; if missing, `/plugin marketplace add anthropics/claude-plugins-official` first) [https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10].
- Skills repo as secondary marketplace (bundles 11 other unrelated skills): `/plugin marketplace add anthropics/skills` then `/plugin install example-skills@anthropic-agent-skills` [https://github.com/anthropics/skills/blob/main/README.md — accessed 2026-08-10; https://raw.githubusercontent.com/anthropics/skills/main/.claude-plugin/marketplace.json — accessed 2026-08-10].
- Manual copy: generic personal-skill path is `~/.claude/skills/frontend-design/SKILL.md` [https://code.claude.com/docs/en/skills — accessed 2026-08-10]. No frontend-design-specific manual-install command is published (see NOT VERIFIED).

**In official marketplace?** YES. Confirmed entry in `claude-plugins-official/.claude-plugin/marketplace.json`: `"name": "frontend-design"`, `"category": "development"`, `"source": "./plugins/frontend-design"` [https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json — accessed 2026-08-10].

**Actively maintained (evidence + date):** Last commit touching `skills/frontend-design` in anthropics/skills: 2026-06-09, "Update frontend-design skill" (#1293) [https://api.github.com/repos/anthropics/skills/commits?path=skills/frontend-design — accessed 2026-08-10]. Last commit touching `plugins/frontend-design` in claude-plugins-official: 2026-06-15, "Update frontend-design skill" (#2540) [https://api.github.com/repos/anthropics/claude-plugins-official/commits?path=plugins/frontend-design — accessed 2026-08-10]. Both ~2 months before today; the two copies are kept in sync days apart.

**Composition & context surface:**
- Session start: only the `name` + `description` frontmatter fields load, for every installed skill ("Description always in context, full skill loads when invoked") [https://code.claude.com/docs/en/skills — accessed 2026-08-10]. This skill's description is 204 characters (~35 words).
- On trigger: the full `SKILL.md` renders as one message and stays in context for the rest of the session. Body ≈1,297 words / 55 lines / 8,260 bytes total — roughly 1,900–2,100 tokens by standard char-count estimate (not tokenizer-measured, see NOT VERIFIED).
- Via the `example-skills` bundle route, 11 other skills' descriptions also load at session start; full bodies still load only per-skill, on trigger.

**Auto-trigger (quoted, from SKILL.md frontmatter):** "Guidance for distinctive, intentional visual design when building new UI or reshaping an existing one. Helps with aesthetic direction, typography, and making choices that don't read as templated defaults." [https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/SKILL.md — accessed 2026-08-10]. No `disable-model-invocation` or `user-invocable: false` is set, so Claude can fire it automatically and a user can also invoke it directly.

**Deterministic alternative:** None built in. This is a judgment/prompting skill (an aesthetic-critique process), not a deterministic transform, so no script or existing command reproduces it. Since it's plain markdown with no bundled scripts/hooks, a team could instead paste the SKILL.md body into project CLAUDE.md or a personal skill file for the same effect without installing a plugin.

**Sources:**
- https://github.com/anthropics/claude-plugins-official — accessed 2026-08-10
- https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10
- https://code.claude.com/docs/en/plugin-marketplaces — accessed 2026-08-10
- https://code.claude.com/docs/en/skills — accessed 2026-08-10
- https://github.com/anthropics/skills — accessed 2026-08-10
- https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/SKILL.md — accessed 2026-08-10
- https://raw.githubusercontent.com/anthropics/skills/main/README.md — accessed 2026-08-10
- https://raw.githubusercontent.com/anthropics/skills/main/.claude-plugin/marketplace.json — accessed 2026-08-10
- https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json — accessed 2026-08-10
- https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/plugins/frontend-design/README.md — accessed 2026-08-10
- https://api.github.com/repos/anthropics/skills/commits?path=skills/frontend-design — accessed 2026-08-10
- https://api.github.com/repos/anthropics/claude-plugins-official/commits?path=plugins/frontend-design — accessed 2026-08-10

**NOT VERIFIED:**
- Live in-app "Context cost" / "Last updated" values shown in the actual `/plugin` detail pane (docs describe the UI field; no interactive Claude Code session was driven to read the rendered number).
- Exact tokenizer-measured token count of SKILL.md (only byte/word-based estimate given above).
- Whether claude.ai (web chat) currently ships frontend-design pre-enabled for paid plans by default — asserted in the repo README, not independently re-checked on claude.ai itself.
- That `claude-plugins-public` was this repo's prior name: inferred from a 301 redirect to the same repo ID, not from an explicit rename changelog.
