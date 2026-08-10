# Verification: "karpathy-guidelines" (Claude Code skill/plugin)

Checked live on 2026-08-10. Every claim below cites a page/API call fetched this session.

## 0. Ground truth: official marketplace
User's belief — `github.com/anthropics/claude-plugins-official` — is **correct, confirmed live**.
Repo exists, is not archived, 33,369 stars, pushed today (2026-08-10).
[https://github.com/anthropics/claude-plugins-official — accessed 2026-08-10 via GitHub API `repos/anthropics/claude-plugins-official`]
Docs confirm it's the marketplace Claude Code auto-adds on first run.
[https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10]
No correction needed. (Community marketplace also exists, separately: `anthropics/claude-plugins-community`.)

## 1. Candidate fields

- **Queried name:** karpathy-guidelines
- **EXISTS?** YES — as a *skill* (not a top-level plugin name) named exactly `karpathy-guidelines`, bundled inside a plugin called `andrej-karpathy-skills`.
- **Real current name:** repo `multica-ai/andrej-karpathy-skills` (skill path `skills/karpathy-guidelines/SKILL.md`; marketplace id `karpathy-skills`; plugin id `andrej-karpathy-skills`). The repo was created/originally hosted at `forrestchang/andrej-karpathy-skills`; that path still resolves (GitHub transfer redirect, HTTP 200, verified via `gh api`) to the same repo now under the `multica-ai` org.
  [https://github.com/multica-ai/andrej-karpathy-skills — accessed 2026-08-10]
- **Origin:** Independent community project by GitHub user `forrestchang` (real name Jiayuan Zhang, blog jiayuanzhang.com, X @jiayuan_jy — matches repo README). **Not** made or endorsed by Anthropic, **not** made by Andrej Karpathy himself. Described as "derived from" a Karpathy X/Twitter post (`x.com/karpathy/status/2015883857489522876`) on LLM coding pitfalls — I could not fetch that post directly (X returned HTTP 402 to WebFetch this session), so its exact wording/date is corroborated only by secondary sources, not verified first-hand.
  [https://github.com/multica-ai/andrej-karpathy-skills/blob/main/README.md — accessed 2026-08-10]
- **Purpose (pt-BR):** É um conjunto de instruções (CLAUDE.md/SKILL.md) de terceiros, inspirado em observações de Andrej Karpathy, que tenta reduzir erros comuns de agentes de IA ao programar (suposições silenciosas, código inchado, edições fora do escopo).
- **Install command (verified live from the repo's own README):**
  `/plugin marketplace add forrestchang/andrej-karpathy-skills` then `/plugin install andrej-karpathy-skills@karpathy-skills`
  — or, without the plugin system: `curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md`
  [https://github.com/multica-ai/andrej-karpathy-skills/blob/main/README.md — accessed 2026-08-10]
- **In official marketplace?** NO. Code search inside `anthropics/claude-plugins-official` for "karpathy" returns zero hits; same for `anthropics/claude-plugins-community` (whose full catalog is only `quickdesign`, `testdino`, `tres-finance-plugin` as of today). This is a fully independent, self-hosted third-party marketplace the user must add manually.
  [GitHub code search API, `repo:anthropics/claude-plugins-official` and `repo:anthropics/claude-plugins-community` — accessed 2026-08-10]
- **Actively maintained:** Partially/stalled. Last commit/push: **2026-04-20** (~3.5 months before this check). Active development ran roughly Jan 27–Apr 20 2026 (i18n, Cursor support, 7 contributors, several merged PRs), then went quiet — no commits since.
  [GitHub API `repos/multica-ai/andrej-karpathy-skills/commits` — accessed 2026-08-10]
- **Content summary:** Pure instruction text, no code/hooks/MCP servers. Four rules: (1) Think Before Coding — state assumptions, surface ambiguity, ask instead of guessing; (2) Simplicity First — minimum code, no speculative abstractions; (3) Surgical Changes — touch only what the task requires, don't drive-by refactor; (4) Goal-Driven Execution — turn tasks into verifiable success criteria (tests-first loops).
  [SKILL.md, fetched via GitHub API — accessed 2026-08-10]
- **Overlap risk:** HIGH. This is generic "how should an AI coding agent behave" guidance — exactly the territory a personal method's own CLAUDE.md/rules already occupy (e.g. this project's own global rules already dictate narration style, scope discipline, and security behavior). Installing it globally would layer a second, unversioned behavioral ruleset on top of existing project rules, with real potential for redundant or conflicting instructions (e.g. its own "state a brief plan" narration vs. an existing narration policy).

## NOT VERIFIED
- Exact wording/date of Karpathy's original X post — fetch blocked (HTTP 402); only secondary-source corroboration.
- The `npx -y skills add forrestchang/andrej-karpathy-skills --skill karpathy-guidelines --agent claude-code` command some blogs cite: the `skills` npm package genuinely exists (confirmed on npm registry) but this exact invocation is **not** documented in the project's own README, so it is not confirmed to work — do not treat as a verified install path.
- Whether the rendered `claude.com/plugins` catalog page (JS app, only checked HTTP 200, not scraped) visually lists it — inferred absent from source-repo search, not visually confirmed.
- **Star/fork count anomaly, flagged not fabricated:** live API shows 201,192 stars and 20,670 forks on a 20KB, 7-contributor, markdown-only repo dormant since April — statistically inconsistent with organic growth. Treat the popularity number as an unreliable trust signal, not evidence of vetted quality.
  [GitHub API `repos/multica-ai/andrej-karpathy-skills` — accessed 2026-08-10]
- Dozens of other forks/ports exist (`swarmclawai/andrej-karpathy-skills`, Codex/OpenCode/Cursor ports, `karpathy-guidelines-plus`, etc.) — found via GitHub search, not individually vetted here.

## Sources
- https://github.com/anthropics/claude-plugins-official — accessed 2026-08-10
- https://code.claude.com/docs/en/discover-plugins — accessed 2026-08-10
- https://code.claude.com/docs/en/plugin-marketplaces — accessed 2026-08-10
- https://github.com/multica-ai/andrej-karpathy-skills — accessed 2026-08-10
- https://github.com/multica-ai/andrej-karpathy-skills/blob/main/README.md — accessed 2026-08-10
- https://github.com/multica-ai/andrej-karpathy-skills/blob/main/skills/karpathy-guidelines/SKILL.md — accessed 2026-08-10
- https://github.com/multica-ai/andrej-karpathy-skills/blob/main/.claude-plugin/marketplace.json — accessed 2026-08-10
- https://github.com/anthropics/claude-plugins-community — accessed 2026-08-10
- https://registry.npmjs.org/skills — accessed 2026-08-10
