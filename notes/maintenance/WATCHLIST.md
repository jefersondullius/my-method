# WATCHLIST — what every maintenance run re-checks

Rule: any URL that `method.md`, `playbook/SECURITY-MATRIX.md`,
`research/13-testing-strategy.md` or a kit command depends on gets a
line here, in the same commit that introduces it. A citation with no
watchlist line is a citation nobody will re-check.

Second rule, learned the hard way: a row is not a URL, it is a URL
plus a RE-CHECK RECIPE. Three of the sources below return HTTP 200
while telling you nothing — a redirect shell, a meta-refresh stub, an
empty JavaScript page. "Is it live" is the wrong question; the recipe
says what to read and where.

Seeded 2026-08-11 from `notes/research-maintenance/cli-mechanics.md`
and `notes/research-maintenance/sources-baseline.md`, both verified
live that day. Nothing here was written from memory.

## Axis A — Anthropic practices

| Source | URL | Why the method depends on it | Re-check recipe |
|---|---|---|---|
| Docs changelog | https://code.claude.com/docs/en/changelog.md | The single date-ordered surface for everything below | Read the first `##` heading: it is the latest version and its date |
| Hooks | https://code.claude.com/docs/en/hooks | The commit gate is a plugin PreToolUse hook; `permissionDecision: "deny"` is its blocking mechanism | Confirm `PreToolUse` still lists "Can block it" and that `deny` is still a documented `permissionDecision` value |
| Skills (commands merged here) | https://code.claude.com/docs/en/skills | All four original commands rely on `disable-model-invocation`; `start-project` on `argument-hint` | Confirm both fields still exist in the frontmatter reference table |
| Settings | https://code.claude.com/docs/en/settings | `effortLevel`, `disableAllHooks` (the gate's escape hatch) | Confirm `effortLevel` accepts the same values and `disableAllHooks` still exists |
| Built-in commands | https://code.claude.com/docs/en/commands | `/clear`, `/model`, `/effort` are user-typed built-ins — the whole session loop assumes it | Confirm `/model` is still described as user-only |
| Plugins reference | https://code.claude.com/docs/en/plugins-reference | Plugin layout, hooks.json, agents/, `${CLAUDE_PLUGIN_ROOT}`, and the plugin cache | Read the "plugin caching and file resolution" section — it is what D-VER guards against |
| Plugin marketplaces | https://code.claude.com/docs/en/plugin-marketplaces | This repo IS a local marketplace | Confirm local-path marketplace sources are still supported |
| Subagents | https://code.claude.com/docs/en/sub-agents | `security-reviewer`'s read-only `tools:` allowlist is structural, not prose | Confirm `tools` is still an allowlist and plugin agents still honour it |
| Headless mode | https://code.claude.com/docs/en/headless | Every pilot and probe in this repo runs through `claude -p` | Confirm `-p` still loads plugins by default (only `--bare` skips them) |
| CLI: `claude plugin list --json` | https://code.claude.com/docs/en/plugins-reference#plugin-list | Health-check probe 1 | Run it; confirm `scope`, `enabled`, `installPath`, `errors` are still in the real output — the docs describe fewer fields than it emits |
| CLI: `claude plugin details` | https://code.claude.com/docs/en/plugins-reference#plugin-details | Health-check probe 1's inventory comparison | Run `claude plugin details my-method`; confirm the Skills/Agents/Hooks grouping still prints |
| CLI: `claude plugin validate` | https://code.claude.com/docs/en/plugins-reference#common-issues | Health-check probe 5 and the apply-time schema check | Run `claude plugin validate ./kit/my-method`; expect `✔ Validation passed` |

## Axis B — Vulnerabilities

| Source | URL | Rows that depend on it | Re-check recipe |
|---|---|---|---|
| OWASP Top 10 | https://owasp.org/www-project-top-ten/ | The whole matrix's framing; `research/13` cites 2025 codes | Read the "most current released version" sentence. **Never** status-check `owasp.org/Top10/` — it returns 200 for a client-side redirect shell regardless of edition |
| Semgrep CLI | https://github.com/semgrep/semgrep | Rows 1.1, 7.1 (`semgrep --config p/owasp-top-ten`) | `GET https://api.github.com/repos/semgrep/semgrep/releases/latest` → `tag_name`, `published_at`; confirm `archived: false` and the license |
| Semgrep OWASP ruleset | https://semgrep.dev/c/p/owasp-top-ten | The ruleset rows 1.1 and 7.1 name | Fetch the **`/c/p/`** config endpoint and count `- id:` entries. The human page `/p/owasp-top-ten` is an empty JS shell to a fetcher |
| gitleaks | https://github.com/gitleaks/gitleaks | Rows 2.1, 8.1 (`gitleaks git -s .`) | `GET .../releases/latest`, then re-read the top of the README: as of 2026-08-11 it declares feature-freeze, security patches only, successor **Betterleaks** |
| npm audit | https://docs.npmjs.com/cli/audit | Row 10.1 (Node projects) | Request the URL and **follow the meta-refresh inside the body** — it is a 77-byte stub. The major-version number in the resulting `/cli/vNN/` path is the signal |
| pip-audit | https://github.com/pypa/pip-audit | Row 10.1 (Python projects) | `GET https://api.github.com/repos/pypa/pip-audit/releases/latest` → `tag_name`, `published_at` |
| OWASP cheat sheets | https://cheatsheetseries.owasp.org/ | `research/13` and the matrix's Fix-direction column cite five of them | Confirm each cited cheat sheet URL still resolves to a page with that title |

## Axis C — Skills and agents: DEFERRED items and their triggers

Source for every row: `notes/audit-02-skills.md` (2026-08-10). The
triggers are verbatim from that evaluation.

| Item | Origin | Trigger recorded | Observable from this repo? |
|---|---|---|---|
| `frontend-design` | Official Anthropic, official marketplace | First user-facing-screens task on a real project's plan | **No** — depends on another project's PLAN.md. Ask the user |
| `webapp-testing` (manual copy, not the bundle) | Official Anthropic, skills repo | A web-UI task reaches verification AND committed Playwright specs prove hard to author (a friction entry says so) | **Partly** — a friction entry would be in that project's `friction.md`. Ask the user |
| `playwright` MCP plugin | Microsoft, official marketplace | Same family as above, only if interactive browser debugging is needed | **No** — ask the user |
| `security-guidance` | Official Anthropic, official marketplace | Matrix wiring done (it is, since v5) **and** a project triages into a login/personal-data tier. Try Semgrep-in-verify + built-in `/security-review` first | **Partly** — the wiring half is now MET; the tier half needs a real T2 project. Ask the user |
| `skill-creator` | Official Anthropic, official marketplace | A scheduled kit task that authors or tunes a skill with evals | **Yes** — visible in this repo's own plans and notes |
| TDD (staged, prose-only, no install) | audit-02 §"The TDD question" | First observed "check passed but behaviour wrong", or an unfalsifiable check, in a pilot | **Partly** — pilot records live in `CHANGELOG.md` and `friction.md` here |
| Official marketplace itself | https://github.com/anthropics/claude-plugins-official | n/a — re-checked for renames | `GET .../main/.claude-plugin/marketplace.json`; read `len(plugins)` and check the **`renames`** map for any plugin named above. Plugin names in that catalog are not permanently stable |

## Axis D — Models and mechanisms

| Fact the kit relies on | URL | Where it is relied on | Re-check recipe |
|---|---|---|---|
| `/model` is user-only; the model cannot switch itself | https://code.claude.com/docs/en/commands | method v7 STEP 5a; the entire "recommend, don't switch" design | Confirm the user-only wording still stands |
| `/effort` values and per-model support | https://code.claude.com/docs/en/model-config | v7 card lines name an effort level | Diff the "Adjust effort level" table against what the ledger recorded |
| Model aliases and provider-dependent resolution | https://code.claude.com/docs/en/model-config | v7 card lines name a model | Diff the "Model aliases" table. A card naming an alias that no longer exists is a defect |
| `${CLAUDE_EFFORT}` substitution | https://code.claude.com/docs/en/skills | `next-task` (b) uses it to skip a pointless ask | Confirm it is still in the substitutions table |
| Frontmatter `model:`/`effort:` are turn-scoped | https://code.claude.com/docs/en/skills | Why v7 does NOT use them | Confirm the turn-scoped wording still stands |
| Fable 5 falls back on flagged domains | https://code.claude.com/docs/en/model-config | v7's UP trigger fires on security REVIEW rows — the one place this matters | Confirm whether the cybersecurity-domain fallback is still documented |

## Axis E — Open sweep sources

The sweep answers one question: *what exists today that did not exist
when this method was written, and that would make some part of it
obsolete or unnecessary?* Every candidate must name the step, row,
command, template or file it targets, or it is discarded.

| Source | URL | Window | Re-check recipe |
|---|---|---|---|
| Claude Code docs changelog | https://code.claude.com/docs/en/changelog.md | Since axis E's last-check date | Read every `##` entry newer than that date |
| Claude Code GitHub Releases | https://api.github.com/repos/anthropics/claude-code/releases/latest | Same | Cheapest version probe: one JSON object with `tag_name` and `published_at` |
| Anthropic news | https://www.anthropic.com/news | Same | Read post titles + dates until you pass the window. **Company/policy/safety skew** |
| Claude blog | https://claude.com/blog | Same | Read post titles + dates until you pass the window. **Product/how-to skew — a SEPARATE feed from anthropic.com/news, confirmed 2026-08-11; checking one misses about half** |
