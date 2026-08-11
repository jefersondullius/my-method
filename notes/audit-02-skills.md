# Audit 02 — Skills evaluation: what would optimize WORKFLOW-TARGET.md without altering it

Session 2 of 4 · 2026-08-10 · Evaluate only — nothing was built or installed.

Method: each candidate was verified LIVE by a separate subagent against the official docs
(code.claude.com/docs) and the official marketplace; one more subagent did open discovery.
Raw findings with full per-claim citations: `notes/research-skills/*.md` (7 files, committed
with this evaluation). Key citations are repeated inline here; everything else inherits the
citation in its findings file. All URLs accessed 2026-08-10.

Constraint this evaluation is measured against (verbatim intent from the brief): a skill that
changes the order of the 14 steps, adds a second interrogation, or replaces either gate
(spec approval, plan recognition) is a FAILURE regardless of quality. Deterministic first:
if a check can be a command, a scanner, or a linter, it is not a skill.

## Ground truth (all 7 subagents converged)

- `github.com/anthropics/claude-plugins-official` EXISTS and is the official, Anthropic-managed
  marketplace — the name the user had was correct, no rename. 285 plugins in the live catalog.
  [https://api.github.com/repos/anthropics/claude-plugins-official — 2026-08-10]
- It is auto-added on first interactive run; install syntax: `/plugin install <name>@claude-plugins-official`.
  [https://code.claude.com/docs/en/discover-plugins — 2026-08-10]
- Session-start cost model, from the live skills docs: every installed skill preloads its
  `name` + `description` into the system prompt of EVERY session; the body loads only on
  trigger. So the permanent per-session cost of a skill is its description (~50–100 tokens),
  paid in every session of every project, small ones included.
  [https://code.claude.com/docs/en/skills — 2026-08-10]

## Verdict table

| Candidate | Exists? | Origin | In official mkt? | Maintained | Step it would touch | Alters flow? | Verdict |
|---|---|---|---|---|---|---|---|
| superpowers | YES | community (obra / Jesse Vincent) | YES | active (v6.2.0, 2026-07-24) | 4–7, 11 | YES — multiple | REJECTED |
| frontend-design | YES | official Anthropic | YES (standalone) | 2026-06 | 11 (UI tasks) | no | DEFER (trigger named) |
| webapp-testing | YES | official Anthropic (skills repo) | NO (bundle only) | content frozen 2025-12 | 12 (web UI verify) | no | DEFER (deterministic path first) |
| find-skills | YES (Vercel's) | community (vercel-labs) | NO (npx, not /plugin) | active | none (meta) | no, but drift risk | REJECTED |
| skill-creator | YES | official Anthropic | YES (standalone) | 2026-04 (slow) | none (kit-authoring only) | no | DEFER (trigger named) |
| karpathy-guidelines | YES | community (multica-ai / forrestchang) | NO | stalled 2026-04-20 | 11 (style rules) | authority conflict | REJECTED |

Discovery extras (not on the user's list): playwright MCP (official mkt, Microsoft) — DEFER;
security-guidance (official mkt, Anthropic) — DEFER; claude-md-management (official mkt,
Anthropic) — REJECTED; pr-review-toolkit — not relevant (solo work, no PR loop).

## Per-candidate analysis

### superpowers — REJECTED (would alter steps 4, 5, 7 and 11)

Facts (all in `research-skills/superpowers.md`): 14 skills, 1 SessionStart hook. The hook
fires on startup, `/clear` AND `/compact`, and injects the ENTIRE `using-superpowers` skill
body verbatim into context wrapped in `<EXTREMELY_IMPORTANT>` tags — full text, not a
description line — into every session of every project. Its brainstorming skill's trigger:
"You MUST use this before any creative work - creating features, building components, adding
functionality, or modifying behavior." It produces its own spec file under
`docs/superpowers/specs/` and hard-codes its only allowed next step: its own `writing-plans`
skill. TDD is enforced ("Iron Law: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST").
Claude Code cannot disable one skill inside an installed plugin — `skillOverrides` explicitly
excludes plugin skills; `/plugin disable` is all-or-nothing.
[raw.githubusercontent.com/obra/superpowers/main/... and code.claude.com/docs/en/skills — 2026-08-10]

What would be altered, concretely:
1. Step 4: brainstorming's trigger fires on exactly what `/my-method:start-project` does —
   a second interrogation protocol competing with Step 1 of the method. Named failure in the brief.
2. Step 5: its spec artifact and location compete with `SPEC.md` and Gate 1's approval loop.
3. Step 7: its `writing-plans` format competes with `PLAN.md` + cards and Gate 2's single question.
4. Step 11: TDD Iron Law restructures how every task is built.
5. Every session (including `/next-task` ones): the hook's "not negotiable... you cannot
   rationalize your way out of this" framing is a second authority in permanent conflict with method.md.

Cost if installed anyway: 14 skill descriptions + a full skill body injected per session,
in every project forever. And note the mechanism honestly: that hook injects INSTRUCTIONS —
it is Level-3 enforcement shouted louder, not Level-1 determinism. It would not raise the
enforcement ceiling of any of the 14 steps; audit-01's conclusions stand unchanged.

Brainstorming-only extraction is not possible by installation (see above). If pilots ever
show the Step-4 interrogation failing in a way command prose cannot fix (friction entries),
the move is to borrow TECHNIQUE into `start-project.md`'s own text — never to install.

### The TDD question, answered plainly (required by the brief)

Recommending superpowers = recommending TDD; there is no partial install. I am NOT
recommending TDD now. Reasoning:
- The method already requires, at planning time, a machine-verifiable definition of done per
  card ("how it will be checked... a command can prove") and, at execution time, verification
  before done with raw output and full regression re-run (method.md 5c). That is test-AFTER
  with teeth. It already delivers most of what TDD buys a non-reading user: done is proven,
  not claimed.
- TDD's residual delta over that: the check is implemented and seen FAILING before the code
  exists — which catches checks that could never fail, and forces smaller steps. Real, but modest here.
- The observed failures in the pilots (method.md notas 5c/5d) are about verification being
  SKIPPED or status files drifting — failures of execution discipline, which TDD does not fix
  and audit-01's hook does. The failure class TDD prevents (verification passed but behavior
  wrong / check unfalsifiable) has NOT been observed yet. Per the method's own rule, no
  observable trigger → does not enter.
- If that trigger ever appears, staged adoption WITHOUT installing anything:
  - Stage 1: one method.md v4 line — in Step 5b, implement the card's declared check FIRST,
    run it, show it failing raw, then build until green. One project long. Advance only if
    friction.md shows fewer end-of-task verification failures and no added stuck-protocol stops.
  - Stage 2: extend to a small regression test per behavior the SPEC names, accumulated per task.
    Advance only if Stage 1 held for a full project and the user felt no added interrogation load.
  - Stage 3 (only if 1–2 held across two projects): consider whether any external tooling adds
    anything at all. It probably does not; the method's verify step is already the harness.

### frontend-design — DEFER (compatible; no observed trigger yet)

Official Anthropic skill, standalone plugin in the official marketplace, synced copies in
anthropics/skills and claude-plugins-official (identical git blob SHA), last touched 2026-06.
Install: `/plugin install frontend-design@claude-plugins-official`. Cost: 204-char description
per session (~50 tokens); ~2k-token body only when UI work triggers it. It changes nothing
procedural — no gates, no questions, no artifacts; it improves Step 11 output quality on UI
tasks only. No deterministic substitute exists (aesthetic judgment is not scriptable), and
the plugin route is strictly cheaper than pasting its body into CLAUDE.md (description-only
vs full body every session). [research-skills/frontend-design.md]
Trigger to install: a real project's plan contains its first user-facing-screens task —
install in the minute before that session. Installing today buys nothing (no active UI
project) and costs context in every session meanwhile. Deferral is free; install-at-need is one command.

### webapp-testing — DEFER (the deterministic path must be tried first)

Official Anthropic skill, but NOT a standalone plugin: only routes are the `example-skills`
bundle (11 unrelated skills' descriptions added to every session) or a manual copy of the
skill folder (Apache-2.0 permits). Content frozen since 2025-12-01. At use time it silently
assumes Python 3 + `playwright` package + Chromium already installed — no setup step exists
anywhere in it. [research-skills/webapp-testing.md]
It addresses a REAL, already-observed failure class: pilot nota 5c (visual check labeled
"humana" without attempting automation), and `research/13-testing-strategy.md` explicitly
scopes functional testing as future work. But the method's own rule decides this one:
deterministic first. The durable answer to 5c is a COMMITTED Playwright test file in the
project, scaffolded at the first web-UI task, run by the verify step and re-run in every
regression pass — reproducible, reviewable, no skill required. The skill only helps author
ad-hoc scripts; its own strongest design idea (keep scripts as black boxes out of context)
applies equally to committed specs. Claude can write Playwright specs without it.
Trigger to revisit: a web-UI task reaches verification AND authoring committed specs proves
hard in practice (a friction.md entry saying so). Then prefer the manual copy of this single
skill over the 12-skill bundle. The official-marketplace `playwright` plugin (Microsoft's
MCP server) is the interactive-debugging alternative; as an MCP server it adds tool
definitions to every session — heavier standing cost, same trigger discipline.

### find-skills — REJECTED (foreign mechanism; the audit does its job better)

The live thing under this name is Vercel's skill inside `vercel-labs/skills`, installed via
`npx skills add ...` — a third-party package manager that bypasses Claude Code's `/plugin`
system entirely; not in the official marketplace. (The obra/superpowers-skills same-named
script is archived since 2025-10-27 and ships to no one.) Maintained by Vercel, yes — but:
its trigger ("how do I do X", "is there a skill that...") invites mid-task tool-shopping,
which the method explicitly classifies as friction to log, not follow; its benefit is
discovery, which this audit performs on schedule with subagents and citations; and the
built-in `/plugin` → Discover tab already browses catalogs with zero install.
[research-skills/find-skills.md] No trigger can make a permanently resident meta-skill
cheaper than a periodic audit for a single-user setup. Rejected, not deferred.

### skill-creator — DEFER (kit tooling, not product workflow)

Official Anthropic, standalone in the official marketplace
(`/plugin install skill-creator@claude-plugins-official`), last substantive change 2026-03/04.
319-char description per session; 485-line body + 3 subagents + 8 scripts only on trigger.
It improves NO step of the 14 — its value is authoring/eval tooling for the kit itself
(trigger-accuracy testing, A/B benchmarking that the harness genuinely lacks; plain SKILL.md
writing needs no plugin at all — confirmed no built-in scaffolding command exists either).
[research-skills/skill-creator.md]
Trigger to install: a scheduled kit task that authors or tunes a skill and wants evals
(plausible outcome of sessions 3–4). Until that task exists on a plan, its description would
ride along in every product session for nothing.

### karpathy-guidelines — EXISTS, but REJECTED (redundant ruleset, poor trust signals)

It does exist — as a skill inside the community plugin `andrej-karpathy-skills`
(multica-ai, formerly forrestchang; author Jiayuan Zhang). Not by Karpathy, not by Anthropic,
absent from both official and community Anthropic marketplaces; dormant since 2026-04-20.
Content: four generic behavior rules (think before coding; simplicity; surgical changes;
goal-driven execution). Overlap with method.md + the user's global CLAUDE.md is HIGH — it
would layer a second, unversioned authority over every session, with direct conflict
potential (its narration advice vs the user's narration policy = a Step-11 alteration by
authority conflict). Red flag kept honest: 201k stars / 20.6k forks on a 20KB, 7-contributor,
markdown-only repo dormant since April is statistically inconsistent with organic growth —
popularity is not evidence of vetting here. [research-skills/karpathy-guidelines.md]
Anything true in it that method.md lacks should enter as a method.md v4 line with a friction
trigger — never as a competing installed ruleset.

## Discovery: what exists that the user did not list

Full detail: `research-skills/discovery.md`. The decisive findings are the NEGATIVE ones:

1. **No marketplace product enforces verification-before-commit.** Nothing in 285 plugins
   gates a commit on evidence. Anthropic's own `security-guidance` docs say it "does not
   block writes or commits... for hard enforcement, pair the plugin with a hook."
   [https://code.claude.com/docs/en/security-guidance — 2026-08-10]
   → Audit-01's recommendation 2 (PreToolUse hook on `git commit`) remains the ONLY mechanism
   for the workflow's two heaviest gaps (steps 12/13 enforcement). Nothing to install instead.
2. **Step 10 (ABSENT in audit-01) is closed by nothing installable.** Model/effort choice is
   native (`/model`, `/effort`); the fix stays audit-01's recommendation 3 (card field + prose).
   [https://code.claude.com/docs/en/model-config — 2026-08-10]
3. `/code-review` and `/security-review` are BUILT-IN bundled skills — zero install, already
   available for Step 12 when a card's checks call for them.
   [https://code.claude.com/docs/en/commands — 2026-08-10]
4. `security-guidance` (Anthropic, official mkt) — DEFER: candidate mechanism for executing
   SECURITY-MATRIX rows once audit-01 rec 1 (matrix wiring, method.md v4 first) exists and a
   project triages into a login/personal-data tier. Deterministic-first order at that moment:
   Semgrep in the verify entrypoint (research/13 already names it) + built-in `/security-review`,
   and only then this always-on plugin if a gap remains.
5. `claude-md-management` (Anthropic, official mkt) — REJECTED: "captures session learnings,
   keeps project memory current" is a second memory system competing with STATE.md's
   single-source-of-truth doctrine (step 13). The method already defines where state lives.

## Recommendation

**Minimum set to install now: NOTHING — the empty set.**

Cost justification, the only kind that matters here:
- Pre-installing costs description-tokens in every session of every project forever, plus a
  new failure surface (auto-triggering skills firing mid-step in a method built to keep
  sessions lean), and buys zero benefit before each skill's trigger exists.
- Install-at-trigger costs one command and one minute, available the day the trigger fires.
  Pre-installing therefore has no option value at all. Deferral is free.
- The two gaps that actually hurt (12/13 enforcement) are closable only by the audit-01 hook;
  no purchase substitutes for it. Installing skills now would be motion, not progress.

Deferred, with the observable trigger each one waits for:
- `frontend-design` — first user-facing-screens task on a real project's plan.
- `webapp-testing` (manual copy, not the bundle) — a web-UI task reaches verification AND
  committed Playwright specs prove hard to author (friction entry). Committed specs come first.
- `playwright` MCP plugin — same trigger family, only if interactive browser debugging is needed.
- `security-guidance` — matrix wiring done (method.md v4) + a project in a login/personal-data
  tier; try Semgrep-in-verify + built-in `/security-review` first.
- `skill-creator` — a scheduled kit task that authors/tunes a skill with evals.
- TDD (staged, prose-only, no install) — first observed "check passed but behavior wrong" or
  unfalsifiable-check failure in a pilot.

Rejected, no trigger can rehabilitate them (the reason is structural, not quality):
- `superpowers` — alters steps 4, 5, 7, 11; competing authority injected every session; TDD
  and pipeline non-separable from brainstorming (individual skills cannot be disabled).
- `karpathy-guidelines` — duplicates method.md as a second unversioned authority; dormant;
  unreliable popularity signals.
- `find-skills` — foreign install mechanism outside `/plugin`; permanent cost for a need this
  periodic audit already serves with citations.
- `claude-md-management` — second memory system vs STATE.md doctrine.

## NOT VERIFIED (aggregate; per-file lists hold the detail)

- Exact tokenizer-measured token counts of any description/body (char/byte estimates only).
- The in-app `/plugin` pane's "Context cost" figures (would require an interactive install — out of scope).
- Whether a plugin can be enabled for one project only while installed at user scope — not
  needed for this verdict (nothing is being installed); must be verified before any future install.
- Size in tokens of superpowers' per-session hook injection (full `using-superpowers` body; not measured).
- Karpathy's original X post (fetch blocked, HTTP 402); secondary corroboration only.

---

## Addendum (same session) — grilling (Matt Pocock)

Added after the main evaluation at the user's request, under an explicit decision procedure:
apply the exact mechanism test that rejected superpowers' brainstorming; if it fails any
prong, reject; if it passes, do NOT install either — extract the technique and state
concretely what it adds over `start-project.md` Step 1, for the user to decide on folding
into the method's own text at zero permanent cost. Live evidence with per-claim citations:
`notes/research-skills/grilling.md`.

### Facts

EXISTS under exactly this name: skill `grilling` in `github.com/mattpocock/skills`, author
confirmed Matt Pocock (aihero.dev / Total TypeScript). In the official marketplace as the
25-skill bundle `mattpocock-skills` (pinned sha current with upstream HEAD). Actively
maintained — grilling itself was reworked 2026-07-16 and polished through 2026-07-31; repo
pushed 2026-08-07. Two user-typed front doors wrap it: `grill-me` (writes nothing) and
`grill-with-docs` (writes CONTEXT.md + ADRs). No verified way to install `grilling` alone
through `/plugin`. [research-skills/grilling.md, all accessed 2026-08-10]

### Mechanism test (the superpowers test, verbatim prongs)

- M1 always-on injection/hook: **NO** — zero hooks in the full 240-entry repo tree; no
  `hooks` key in plugin.json; ordinary name+description preload only.
- M2 own artifact competing with SPEC.md: **NO** for `grilling`/`grill-me` — primary source:
  "It is stateless. It writes no files and leaves no workspace behind." (**YES** for the
  sibling `grill-with-docs`: CONTEXT.md + ADRs — that sibling would compete with SPEC.md and
  STATE.md, and it rides along in the only Claude Code install route.)
- M3 "you MUST" authority framing: **NONE FOUND** — strongest line is process-internal
  ("Decisions are yours, and it must wait for them"), not adoption-forcing.

Verdict on mechanism: `grilling` itself PASSES — it is question heuristics, not a competing
protocol. Unlike superpowers there is no forced every-session presence and no artifact of its
own. Install verdict is still NO, per the user's own procedure and two cost facts: the only
`/plugin` route ships 25 skills (24 unwanted descriptions in every session, including the
M2-failing `grill-with-docs`), and `grilling` is model-invocable ("Grill the user relentlessly
about a plan, decision, or idea") — description-adjacent to Step 1's territory, so installed
it could be auto-selected during `/my-method:start-project` and its round-based cadence would
sit beside Step 1's one-at-a-time rule (an L3-vs-L3 conflict the method would have to win by prose).

### Technique delta vs `start-project.md` Step 1 (read from the primary sources)

Step 1 today: one question at a time, wait; recommendation embedded ("pode só confirmar se
topar"); six minimum topics; follow-up rule for newly opened decisions; stop when no decision
is open, no padding.

What grilling has that Step 1 does not — fold-in candidates, zero permanent cost:
- **D1 — dependency ordering.** Grilling never asks a question that depends on an unanswered
  one ("two questions never share a round if one depends on the other's answer"; ask only the
  settled-prerequisite frontier). Step 1 has NO ordering rule at all. Foldable as one line:
  ask next the question that unlocks the most; never ask what depends on an answer not yet given.
- **D2 — facts vs decisions split.** "Finding facts is your job, never the user's" — research
  what is researchable; only genuine decisions reach the user. Step 1's "don't pad with
  obvious questions" gestures here but never says look-it-up-yourself. For a non-programmer
  user this is the sharpest delta: it structurally prevents questions he cannot answer.
- **D3 — surface silent assumptions.** Grilling's stop is "frontier empty... nothing silently
  assumed"; Step 1's stop ("no decision open") never forces the model to list assumptions it
  made without asking. Foldable as: before closing Step 1, state any assumption made along
  the way and convert each into a question or an explicit confirmation.

What grilling has that must NOT be folded (would alter the target):
- **Rounds/batching.** Since 2026-07-16 grilling asks the whole frontier per round — multiple
  questions at once. WORKFLOW-TARGET step 4 mandates ONE question at a time. Adopt D1's
  ordering, never the batching.
- **Second confirmation gate ("shared understanding").** The method already has a stronger
  version: Gate 1 confirms a written SPEC.md summary, not a feeling. No addition needed.
- Note also: grilling's docs treat easy serial agreement ("agreed, agreed, agreed") as a
  user-side failure mode; the method deliberately designs FOR easy agreement (embedded
  recommendations exist so the user can just agree). Philosophical difference, flagged, not adopted.
- Its question format (❓/➡️ blocks) adds nothing — Step 1's phrasing already avoids a
  format bug grilling's own docs admit (recommendation sometimes contradicting the question's wording).

### Recommendation (unchanged install verdict; new fold-in decision for the user)

Install: NOTHING — unchanged. If D1–D3 are wanted, the route is a method.md v4 revision of
Step 1 first, then mirroring in `start-project.md` Step 1 AND the method copy embedded in it
(the duplication trap friction.md documents). Cost: a few lines of prose in files that load
only when the command runs — zero standing context. Honesty per the method's own rule: no
friction entry yet names bad question order, fact-questions, or silent assumptions; the
observable trigger on record is this audit's own comparison, requested explicitly by the
user — whether that counts as sufficient trigger is the user's call, not this audit's.

Addendum NOT VERIFIED: grilling's 212,551-star figure is the raw GitHub API value, unusually
high and uncorroborated (aggregator-site install counts were excluded as unverifiable); no
non-interactive solo-install command for `grilling` via `npx skills` is documented.
