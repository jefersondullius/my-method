# PROPOSAL — kit maintenance: `/my-method:health-check` + `/my-method:update-method`

Status: **approved and applied, 2026-08-11** ("Aprovado, com os onze itens como estão").
Kept as the record of what was proposed. Written the same day at the user's request
("Quero implementar a manutenção do plugin … ESCREVA UMA PROPOSTA, SEM APLICAR").

Outcome of the tests the user asked for (T1–T5, T8; T6–T7 deferred to a separate
session by their decision) — full detail in `CHANGELOG.md`:

- **All six PASSED.** T2 confirmed the design's most important negative: probe 3 reports
  INCONCLUSIVE in an empty folder instead of claiming a pass. T8 confirmed the health
  check can actually fail — with the agent renamed, probe 2 and probe 1 caught it
  independently.
- **T4 settled the open question this proposal was written around.** A seventh command
  file, no version bump, no `/plugin update` — a fresh session reported Skills (7). The
  harness reads this kit's source live; the documented frozen-cache behaviour does not
  govern component discovery here. **D-VER's version bump is therefore not the delivery
  mechanism**, only the record and the fallback, and `update-method.md`'s step 6 was
  corrected the same day because its original wording claimed otherwise.
- **Two numbers in this document are wrong and are left uncorrected on purpose**, so the
  estimate and the measurement stay visible side by side: the standing token cost was
  estimated at "roughly +100 tokens per session" and measured at **+186** (~271 → ~457);
  and "Skills (6)" was the right expectation, but `claude plugin list` still reports
  version 0.1.0 while `claude plugin details` reports 0.2.0 — expected, not a failure,
  which is why probe 1 compares component inventory and never version strings.

---

## Provenance — including one correction the brief needs

The brief asks to implement "a parte que a auditoria 04 diagnosticou", and to read
`notes/audit-04-maintainability.md` and `notes/audit-plan.md` first.

**Neither file exists in this repository.** Verified this session: 28 commits, one branch
(`master`), no deleted-file history matching `audit`, no other ref. `notes/` holds
`audit-01-gaps.md`, `audit-02-skills.md`, `audit-03-agents.md` and nothing else
audit-shaped. The standing memory of the audit series records session 04 as "pending":
session 4 of 4 was never run, and no audit plan was ever written.

So this proposal does **not** cite audit-04, because there is no audit-04 to cite. Its
real provenance:

1. **The user's brief of 2026-08-11**, which contains the diagnosis in the user's own
   words — including the sharpest sentence of it, which no prior audit wrote down:
   *"reverificação só reconfere o que eu já sabia perguntar."* That is the design centre
   of axis E below, and it is the user's insight, not this repo's.
2. **Open items the applied proposals left behind**, which are real and re-readable:
   audit-02's six DEFERRED-with-trigger items (nothing has ever re-checked whether a
   trigger fired); audit-02's own claim that "this audit performs discovery on schedule"
   (the schedule was never built — that is the gap this closes); every `NOT VERIFIED`
   list across audits 01–03 and the v6/v7 proposals, written once and never revisited;
   and roughly fifteen external URLs the method now depends on, all dated 2026-08-10/11
   and never re-checked.
3. **Four live findings from this session**, below — the first evidence that this pays
   for itself immediately.

If the user wants an audit-04 written before any of this is applied, this is the wrong
artifact and should be held. It is written on the assumption that the brief *is* the
diagnosis.

---

## Live findings from this session (2026-08-11)

These are local observations, reproducible by running the commands shown.

**F1 — Three of the four security tools the matrix names are ABSENT on this machine.**
`git`, `node`, `npm`, `python` present; `semgrep`, `gitleaks`, `pip-audit` **absent**.
`SECURITY-MATRIX.md` names those three in AUTOMATED rows 1.1, 2.1, 7.1, 8.1 and 10.1.
A T1+ project started today would reach its first verification with three of its four
automated security tools missing — discovered mid-task, or silently skipped.

**F2 — The installed plugin exposes exactly what the kit ships, and a token price.**
`claude plugin details my-method` (run this session):

```
Component inventory
  Skills (4)  friction, next-task, start-project, where-am-i
  Agents (1)  security-reviewer
  Hooks (1)   PreToolUse  (harness-only — no model context cost)
Projected token cost
  Always-on:   ~271 tok   added to every session
```

This is a **countable inventory of the kit, from the harness's own mouth** — the single
most useful health probe available, and it did not exist in any prior design here.

**F3 — The docs say the install is a frozen copy; the observed behaviour says otherwise.**
`claude plugin list --json` reports `installPath` under
`~/.claude/plugins/cache/jeferson-tools/my-method/0.1.0`, with
`installedAt` = `lastUpdated` = **2026-08-10T05:17:26Z**. The official docs are explicit
that marketplace plugins are *copied* to that cache "rather than using them in-place",
that version is the update cache key, and that local marketplaces have auto-update off
by default. Yet `agents/security-reviewer.md` was written 2026-08-10 23:46 local and
`hooks/hooks.json` 2026-08-11 00:18 local — both **after** that install stamp — and the
harness reports both as present (F2), matching the live tests recorded in CHANGELOG for
the reviewer (2026-08-11) and the commit gate (2026-08-11).

**Conclusion, stated honestly: the cached copy is picking up source edits by some
mechanism the docs do not describe, while `lastUpdated` and `version` never move.** It
works today; nothing documented promises it will keep working, and nothing would warn
the user the day it stops. That is precisely a maintenance blind spot, and D-VER below
is the answer to it.

**F3b — `claude plugin validate ./kit/my-method` runs and passes today.** Verified this
session: it validates the manifest and prints `✔ Validation passed`. Probe 5 and the
apply-time schema check below are therefore backed by a command already known to work on
this exact directory.

**F4 — A stale activation junction shadows the install.** `claude plugin list` reports a
second entry, `my-method@skills-dir` — a Windows junction at `.claude/skills/my-method`
pointing at `kit/my-method`, left over from the pre-marketplace era (CHANGELOG
2026-08-10) — **not loaded**, because the name is already taken. Harmless today, and
exactly the class of drift a health check should say out loud instead of leaving to be
discovered during work.

---

## What a run would already find today — the case for the command

The axis-B and axis-D research for this proposal is, in effect, the first half of run 1.
It found four things nobody was going to notice otherwise. Full detail with per-claim
URLs: `notes/research-maintenance/sources-baseline.md`.

**R1 — gitleaks is feature-frozen, and the maintainer named a successor.** README
verbatim: *"Gitleaks is feature complete. I'm not merging new features into Gitleaks.
Future releases will be security patches only. I'm shifting my focus to Betterleaks."*
Latest release v8.30.1 (2026-03-21); repo not archived, MIT, still pushed 2026-07-29.
`SECURITY-MATRIX.md` rows 2.1 and 8.1 depend on it. **Nothing is broken today** — this is
a CANDIDATE, not a DEFECT, and per D11 the default answer is no until it breaks. But the
clock is now visible instead of invisible, which is the entire point.
<https://github.com/gitleaks/gitleaks> — accessed 2026-08-11.

**R2 — the OWASP 2025 list contains two categories this repo covers nowhere.**
`research/13-testing-strategy.md` already cites 2025 codes (A01, A02, A04, A05, A07), so
the repo is not stale on the edition. But the full 2025 list includes **A03 Software
Supply Chain Failures** (broadened well past the old "vulnerable and outdated components"
that row 10.1 checks) and **A10 Mishandling of Exceptional Conditions** (new in 2025) —
and neither research/13's nine classes nor the matrix's ten surfaces address A10 at all.
That is a real coverage gap, found by asking a question nobody had asked since the matrix
was written. <https://owasp.org/Top10/2025/> — accessed 2026-08-11.

**R3 — Fable 5 silently falls back on security-flavoured prompts.** The docs state that
requests Fable 5's safety classifiers flag — "most often in cybersecurity and biology
domains" — trigger automatic model fallback, described as "expected routing for these
domains, not an account flag". Method v7's UP trigger recommends a stronger model exactly
when a card carries REVIEW security rows on authentication, authorization or payments —
so v7's strongest recommendation lands on the one class of task where that model may not
be the model that answers. <https://code.claude.com/docs/en/model-config> — accessed
2026-08-11. Also relevant to v7: **the effort scale is calibrated per model**, so the same
level name is not the same amount of reasoning across models, and default effort is
`high` almost everywhere — which is what makes v7's silence rule correct.

**R4 — three of the watchlist's own sources defeat a naive liveness check.**
`owasp.org/Top10/` returns HTTP 200 for a client-side redirect shell; `docs.npmjs.com/cli/audit`
returns 200 for a 77-byte meta-refresh stub (the real page is now on the `/cli/v12/`
shelf, with `/cli/v11/` labelled "Legacy"); `semgrep.dev/p/owasp-top-ten` returns 200 for
an empty JavaScript shell. A maintenance command that checked status codes would report
all three healthy while learning nothing. The watchlist therefore stores a **re-check
recipe** per source, not just a URL — and the research file already contains one for each.

**None of R1–R4 is part of what this proposal asks approval for.** They are what run 1
would put in *its* proposal, for a separate decision. They are here as evidence that the
command finds real things on its first pass, before any of it exists.

## Verified mechanism (live research by subagents, 2026-08-11)

Full findings, one URL + access date per claim: `notes/research-maintenance/cli-mechanics.md`
(verified independently twice) and `notes/research-maintenance/sources-baseline.md`.
The claims this proposal builds on, all accessed 2026-08-11:

1. **`claude plugin list --json` is documented for scripting** — "non-interactive plugin
   management, useful for scripting and automation"; documented output is version,
   source marketplace, enable status.
   <https://code.claude.com/docs/en/plugins-reference#plugin-list>
   **Observed this session, beyond the docs:** the real JSON also carries `scope`,
   `enabled`, `installPath`, `installedAt`, `lastUpdated`, and an `errors` array. The
   docs undersell it; the probe uses the observed fields and says so.
2. **`claude plugin details <name>` prints the component inventory non-interactively** —
   Skills, Agents, Hooks, MCP, LSP, plus projected token cost; "The Skills group includes
   both `skills/` and `commands/` entries."
   <https://code.claude.com/docs/en/plugins-reference#plugin-details>
3. **`claude plugin validate <dir>` checks `plugin.json`, skill/agent/command frontmatter
   and `hooks/hooks.json`** for syntax and schema errors; prints `✔ Validation passed`.
   <https://code.claude.com/docs/en/plugins-reference#common-issues>
4. **Marketplace plugins are copied to `~/.claude/plugins/cache`, not used in-place**;
   version is the cache key for updates; local development marketplaces have auto-update
   **disabled by default**.
   <https://code.claude.com/docs/en/plugins-reference#plugin-caching-and-file-resolution>,
   <https://code.claude.com/docs/en/plugin-marketplaces>,
   <https://code.claude.com/docs/en/discover-plugins#configure-auto-updates>
5. **Plugin `hooks/`, `agents/`, `.mcp.json` changes need `/reload-plugins` or a restart**;
   only a skill's own `SKILL.md` takes effect immediately.
   <https://code.claude.com/docs/en/plugins-reference>
6. **`PreToolUse` + `permissionDecision: "deny"` is still the documented blocking
   mechanism** — "Claude Code reads the JSON decision, blocks the tool call, and shows
   Claude the reason." `/hooks` exists but is an **interactive read-only browser**.
   <https://code.claude.com/docs/en/hooks>
7. **No CLI or slash command enumerates skills and agents as data.** `/agents` prints a
   reminder as of v2.1.198; `claude agents` is the background-session view, not a
   definition lister; `/plugin`, `/hooks`, `/skills` are interactive panels.
   `claude plugin details` is the closest non-interactive inventory (claim 2).
   <https://code.claude.com/docs/en/cli-reference>, <https://code.claude.com/docs/en/sub-agents>
8. **`claude -p` loads plugins by default** (only `--bare` skips them), and
   `--output-format stream-json` emits a `system/init` event carrying `plugins[].name/.path`
   and `plugin_errors[]`. Suitable for scripted probes.
   <https://code.claude.com/docs/en/headless>
9. **Plugin agents support a `tools:` allowlist** — "Inherits every tool available to
   subagents if omitted"; restricting via `tools` is documented. Also documented:
   **project/user `.claude/agents/` definitions override same-named plugin agents.**
   <https://code.claude.com/docs/en/sub-agents#supported-frontmatter-fields>
10. **`disable-model-invocation`, `argument-hint`, `allowed-tools`, `model`, `effort` all
    still exist**; `/slash-commands` now resolves to the skills page ("Custom commands
    have been merged into skills").
    <https://code.claude.com/docs/en/skills#frontmatter-reference>
11. **`${CLAUDE_PLUGIN_ROOT}` is documented-but-contested.** The plugins reference says
    it resolves "anywhere the placeholder appears" in skill and agent content; the skills
    page's own substitution table omits it entirely; GitHub issue #9354 is **OPEN** since
    2025-10-11 reporting it expands to empty in command markdown. Four sibling
    substitution bugs have since closed; this one has not.
    <https://code.claude.com/docs/en/plugins-reference#environment-variables>,
    <https://github.com/anthropics/claude-code/issues/9354>

---

## Design decisions — veto each one independently

### D1 — Two commands, not one

`/my-method:health-check` (seconds, read-only, runs anywhere) and
`/my-method:update-method` (heavy, runs only inside this repo). They differ in cost,
frequency, blast radius and precondition. Merging them would force the instant check to
carry the heavy one's constraints, and the user would stop running the one that matters
most — the one before every project.

### D2 — `update-method` refuses to run outside this repo

Safety check mirroring `start-project`'s: if `method.md`,
`kit/my-method/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` are not
all present in the current directory, STOP and say so. Reason: it edits kit files, and
the user's global Boundaries rule forbids reading or writing outside the current project
folder. A maintenance command that reached into `dev/my-method` from a product folder
would break that rule on every run.

### D-VER — Version discipline, and the staleness probe (new; comes from F2/F3)

This is the decision F3 forces, and it did not exist in the original brief.

`plugin.json` still says `version: 0.1.0` — never bumped across v4, v5, v6 and v7. The
docs say version is the cache key that decides whether an update is available (claim 4).
Today the cache picks up edits anyway (F3), by an undocumented path. The kit is therefore
relying on undocumented behaviour for **every applied change**, with no warning if it
stops.

Two parts:

1. **`update-method apply` bumps `version` in `kit/my-method/.claude-plugin/plugin.json`
   on every applied run**, and the CHANGELOG entry records the new number. This makes the
   documented update mechanism work as documented, instead of depending on a behaviour
   nobody promised.
2. **The health check compares the harness's inventory against the kit source.**
   `claude plugin details my-method` reports counts and names (claim 2, F2); inside this
   repo the command counts `kit/my-method/commands/*.md`, `agents/*.md` and the hook
   entries and compares. A mismatch means the loaded plugin is not the kit on disk — and
   the fix is stated: `/plugin update my-method@jeferson-tools`, or reinstall, then
   `/reload-plugins`.

Outside this repo the comparison is impossible (Boundaries), so the health check compares
against the counts written literally in its own body — see D5, which is the same
mirroring mechanism.

**This is the decision that makes every other applied change trustworthy.** Without it,
"I applied it" and "the harness runs it" are two different claims and nothing tells them
apart.

### D3 — The watchlist is a file, not something to remember

New `notes/maintenance/WATCHLIST.md`: the standing list of *what gets checked*, grouped by
the five axes, plus the deferred-with-trigger table and the tool list. This is the concrete
form of "sem eu precisar lembrar do que verificar".

Each row carries three things, not one: the canonical URL, **why the method depends on
it**, and a **re-check recipe** — the specific thing to read, in the specific place. R4 is
why the recipe column exists: three of this repo's own sources return HTTP 200 for a
redirect shell, a meta-refresh stub, or an empty JavaScript page, so "is the URL live" is
a question that answers itself wrongly. The recipe says, for example, "read the *most
current released version* sentence at `owasp.org/www-project-top-ten/`, never trust a
status check on `/Top10/`", or "`GET api.github.com/repos/<x>/releases/latest` and read
`tag_name`". The research files written this session already contain a recipe per source,
so the first watchlist is transcribed, not invented.

Standing rule that keeps it honest: **any URL the method, the matrix, the research notes
or a kit command depends on gets a line here in the same commit that introduces it.** A
citation with no watchlist line is a citation nobody will ever re-check.

### D4 — The ledger is append-only and holds the dates, per axis

New `notes/maintenance/LAST-CHECK.md`: one entry per run — date, axes covered with their
windows, what was applied, what was rejected and why, and the full NOT VERIFIED list
carried to the next run. **The date of last verification lives here, per axis**, not
globally: a run may legitimately skip an axis, and one global date would then lie about
the skipped one.

### D5 — What the health check reports about dates and counts is mirrored literal text

`health-check.md` carries, as literal lines in its body:

```
Last full maintenance run: <YYYY-MM-DD>
Kit inventory at that run: 6 skills, 1 agent, 1 hook
```

and `update-method`'s apply phase rewrites both as its final edit.

Why not read the ledger at runtime: the health check runs in *product* folders, where
reading this repo is forbidden (Boundaries, D2); `${CLAUDE_PLUGIN_ROOT}` is
documented-but-contested inside command markdown (claim 11); and — decisively — even if
it did expand, the file it would read lives in the **frozen cache copy** (claim 4), so it
would carry the install-time value anyway. The literal line has the same staleness
property with none of the machinery.

Cost, stated plainly: this is a **fifth mirrored text** in a kit that already carries
four, feeding the duplication trap `friction.md` records. Mitigation: it is two lines,
and rewriting them is a numbered, checkable step in the apply order.

*If vetoed:* the health check reports the date and the inventory comparison only inside
this repo, and says "data da última manutenção: desconhecida" elsewhere — cheaper, but it
removes the reminder from the exact place the user needs it: a new project's folder.

### D6 — Research is delegated; the window never holds it

Five subagents, one per axis. Each writes exactly one file
(`notes/research-maintenance/<YYYY-MM-DD>-<axis>.md`) and returns **five lines**. The main
session reads the five summaries and opens a research file only to quote a claim it is
putting in the proposal. Same pattern as audits 02 and 03, for the same reason: raw
research is large and would fill the window before the thinking starts.

Honest note from this session: the two research subagents run for this proposal consumed
roughly 125k and 255k tokens **in their own windows** and returned five lines each. That
is the mechanism working — but it is also the true cost of a run, and it is why D14's
cadence is monthly and not weekly.

### D7 — Five axes, fixed, matching the brief

- **A — Anthropic practices.** What changed in the official Claude Code docs since axis
  A's last-check date, and what of it touches this method or this plugin.
- **B — Vulnerabilities.** OWASP Top 10 edition and revisions; the four matrix tools
  (Semgrep, gitleaks, `npm audit`, `pip-audit`) — alive, renamed, abandoned, or changed
  interface.
- **C — Skills and agents.** Versions of what is installed; renames; abandonment; and
  every audit-02 DEFERRED item re-read against its recorded trigger.
- **D — Models and mechanisms.** New or retired models and effort levels — this hits v7
  directly, since a task card may name a model that no longer exists.
- **E — The open sweep.** Below.

### D8 — The open sweep asks one question and discards findings with no target

Axis E's subagent gets one verbatim question:

> What exists today that did not exist when this method was written, and that would make
> some part of it obsolete or unnecessary?

Bounded by **date and source list**, not by imagination: Claude Code changelog entries
since axis E's last-check date, Anthropic's news and blog posts in that window, and the
docs pages the watchlist names. And bounded by **a required target**: every candidate must
name the specific step, row, command, template or file of this repository it would make
obsolete. A candidate with no named target is discarded as noise — that rule is what keeps
a "what's new" sweep from returning marketing.

"Nothing found" is a valid and expected answer, stated explicitly with the window it
covered. A sweep that always finds something is a sweep that is inventing.

### D9 — The run proposes and stops; applying is a second, fresh session

`update-method` with no argument researches and writes
`notes/proposals/maintenance-<YYYY-MM-DD>.md`, presents the decisions in Portuguese, and
ends the turn telling the user to `/clear`. `update-method apply` reads the most recent
such proposal, re-confirms, and only then edits.

Why two sessions: five subagents plus a written proposal already fills a session, and the
apply phase edits `method.md` **and** the ~450-line method copy embedded in
`start-project.md`. Doing both in one session is exactly the context-degradation failure
the method's own task-sizing rule exists to prevent.

### D10 — Confirmable, or NOT VERIFIED. No middle ground.

Every proposed change carries a URL and an access date. Anything not confirmed live goes
to the run's NOT VERIFIED list in the ledger and **cannot become a method change**. Stated
in the command text: the model's own knowledge is never a source, and "probably" is not an
answer.

### D11 — "External change" is named as a fourth provenance class

The method's rule is to change only on observed pilot friction; three conscious exceptions
are on record (v4/grilling, v5/security, v7/model-effort). Maintenance findings are a
fourth, standing class: **an external fact changed**. Recorded in `friction.md`'s YOURS
section per the existing ritual.

With a distinction the command must apply, because it decides how much the method grows
over years:

- An external change that **breaks** something the method depends on — a cited tool gone,
  a documented mechanism changed, a named model retired, a dead URL — is a **defect**,
  proposed as a fix.
- An external change that merely **enables** something new is a **candidate**, not a
  defect. Proposed with its cost, and **the default answer is no**. A candidate is adopted
  only if it removes something the method currently does, or closes a gap an audit already
  named. Otherwise the method grows a feature every month because the industry shipped one.

### D12 — Five probes for the health check, each with what it actually proves

1. **Inventory and install.** `claude plugin list --json` (scope, enabled, installPath,
   errors — observed fields, claim 1) and `claude plugin details my-method` (Skills,
   Agents, Hooks counts and names — claim 2). Compare against the expected counts: the kit
   source when inside this repo, the mirrored literal line otherwise (D5, D-VER). Report
   any second entry shadowing the name — it caught the stale junction today (F4).
2. **The agent registers.** Invoke `security-reviewer` once with a trivial prompt and
   expect one fixed line back. Registration is what is proved — the v5 test's method
   (CHANGELOG 2026-08-11). Note per claim 9: a same-named agent in `.claude/agents/`
   would override the plugin's, so the probe also says which definition answered if it can.
3. **The hook fires.** `git commit --dry-run --allow-empty -m "health probe"`. If the hook
   is live and the folder is a my-method project with at least one commit, the call is
   **DENIED** with the gate's own reason — that denial is the proof. If the folder is not a
   my-method project, the gate allows by design and the probe is **INCONCLUSIVE**, never
   "passed". The dry run changes nothing either way.
4. **Dependencies exist.** `git`, then each matrix tool (`semgrep`, `gitleaks`,
   `npm audit`, `pip-audit`): PRESENT with its version line, or ABSENT — **reported, never
   installed**.
5. **Schema validity (inside this repo only).** `claude plugin validate ./kit/my-method`
   (claim 3) — catches a malformed frontmatter or `hooks.json` before a session ever loads
   it. Skipped elsewhere.

### D13 — The health check writes nothing, installs nothing, fixes nothing

Read-only, like `/where-am-i`. It runs in a folder that is *about to become* a project; a
probe that left a file behind would trip `start-project`'s safety check and refuse the very
project it was run to protect.

### D14 — Nothing is installed or enabled by either command

Both propose; the user types the install command. This keeps audit-02's install-at-trigger
doctrine intact: a deferred skill whose trigger fired becomes a recommendation with its
one-line install command, not an installation.

---

## Changes, file by file — exact text

### 1. NEW `kit/my-method/commands/health-check.md`

````markdown
---
description: Instant health check of the my-method kit — the plugin loads, the commands resolve, the security reviewer registers, the commit gate fires, the security tools exist. Read-only, runs in seconds, changes nothing.
disable-model-invocation: true
---

You are checking that the my-method kit is intact and operational in
THIS session, before real work starts. This command is READ-ONLY: it
writes no file, installs nothing, fixes nothing, changes no setting.
If a probe fails you report it — you do not repair it.

Last full maintenance run: 2026-08-11
Kit inventory at that run: 6 skills, 1 agent, 1 hook

Run the five probes below in order, then summarize. Show the RAW
OUTPUT of every command you run — the actual result, not a sentence
about it.

## Probe 1 — is the right plugin loaded, and is it the current one?

1. This command executing at all proves the plugin loaded in this
   session. Say so in one line.
2. Run `claude plugin list --json` and show its raw output. Check:
   `my-method@jeferson-tools` is present, `scope` is `user`, `enabled`
   is true, and `errors` is empty. Report any OTHER entry carrying the
   name `my-method` — a leftover `.claude/skills/my-method` link is
   known to appear as `my-method@skills-dir`, not loaded, and is
   harmless; say it is there.
3. Run `claude plugin details my-method` and show its raw output.
   Compare its component inventory against the expected one:
   - If `method.md` and `kit/my-method/.claude-plugin/plugin.json`
     both exist here, you are in the method repo: compare against the
     kit on disk — count `kit/my-method/commands/*.md`,
     `kit/my-method/agents/*.md`, and the hook entries in
     `kit/my-method/hooks/hooks.json`.
   - Otherwise compare against the line "Kit inventory at that run" at
     the top of this file.
   A MISMATCH means the plugin the harness is running is not the kit
   that was last applied. Report it as FAILED and say the fix:
   `/plugin update my-method@jeferson-tools` (or reinstall), then
   `/reload-plugins`. Do not run either — report only.

## Probe 2 — does the security reviewer register?

Invoke the `security-reviewer` subagent ONCE, with a trivial prompt:
ask it to reply with the single line `HEALTH: reviewer alive` and
nothing else, giving it no diff to judge.

- If it replies, the agent is registered, and read-only by definition
  (its allowlist is `Read, Grep, Glob`).
- If the invocation fails with "agent type not found", report FAILED:
  the kit cannot run REVIEW security rows in this state.
- If a file named `security-reviewer.md` exists under `.claude/agents/`
  in this folder, say so: a project or user agent of the same name
  overrides the plugin's, so the reviewer that answered may not be the
  kit's.

## Probe 3 — does the commit gate fire?

Conclusive only inside a my-method project. Decide first:

- If `method.md`, `PLAN.md` and `STATE.md` all exist here AND
  `git rev-parse HEAD` succeeds (at least one commit), the gate is
  armed — run the probe.
- Otherwise report probe 3 as INCONCLUSIVE and say why in one line:
  the gate deliberately allows everything outside a my-method project
  and exempts a repository's first commit. Never report it as passed.

The probe, when armed:

```
git commit --dry-run --allow-empty -m "health probe"
```

- **DENIED by the gate** — the expected result and the proof the hook
  is live. Show the gate's reason raw. Nothing was committed.
- **Git's own output came back** (branch/status text) — the hook is
  NOT firing. Report FAILED: this is the kit's only Level-1
  mechanism, and without it verification-before-commit is back to
  being prose. Note that plugin hook changes need `/reload-plugins`
  or a restart to take effect.

Judge by WHICH text came back — the gate's reason, or git's own
output. Do not judge by the exit code: with nothing staged, a dry run
exits non-zero while having done nothing wrong. A dry run changes
nothing in either case; verified this session, HEAD unchanged.

## Probe 4 — do the dependencies exist?

Run each and show the raw output; report PRESENT with the version
line, or ABSENT. Install nothing, ever:

```
git --version
semgrep --version
gitleaks version
npm --version
pip-audit --version
```

`git` ABSENT is fatal — nothing in the method works without it. The
four scanners are needed only by the AUTOMATED rows of
`SECURITY-MATRIX.md` that a project's tier actually pulls in: a T0
project needs none of them; a project that stores anything, calls an
API, or has login needs the ones its rows name. Report what is missing
and which rows it would block. An absent scanner is not a failure of
the kit — it is a fact the user needs BEFORE a project starts, not
during its first verification.

## Probe 5 — is the kit itself well-formed? (method repo only)

Only if `kit/my-method/.claude-plugin/plugin.json` exists here, run:

```
claude plugin validate ./kit/my-method
```

Show the raw output. This checks `plugin.json`, the frontmatter of
every command and agent, and `hooks/hooks.json` for schema errors.
Outside the method repo, skip this probe and say it was skipped.

## Summary — Portuguese, at most 10 lines

One line per probe: PASSOU / FALHOU / INCONCLUSIVO, each with its
concrete consequence in plain language ("o revisor de segurança não
registrou — linhas REVIEW não vão rodar neste estado").

Then one closing line: how old the last full maintenance run is,
counting from the date at the top of this file to today — and, only if
that is more than 30 days, the sentence:
"Vale rodar `/my-method:update-method` antes de começar."

Add nothing else: no recommendations beyond that line, no offer to
fix, no questions. This command only reports.
````

### 2. NEW `kit/my-method/commands/update-method.md`

````markdown
---
description: Full maintenance pass of the method and its plugin — re-verifies Anthropic practices, vulnerability sources, installed skills and agents, models and effort levels, and runs one open sweep for what exists today that would make part of the method obsolete. Researches and PROPOSES; changes nothing without explicit approval.
argument-hint: [apply]
disable-model-invocation: true
---

You are running the maintenance pass for the my-method kit itself.
Two modes, selected by the argument:

- **no argument** — RESEARCH AND PROPOSE. Ends with a written proposal
  and a `/clear` instruction. Changes no method, command, template,
  matrix or manifest file.
- **`apply`** — apply a proposal the user has already approved.

## Safety check — before anything, in both modes

If `method.md`, `kit/my-method/.claude-plugin/plugin.json` and
`.claude-plugin/marketplace.json` are not ALL present in the current
directory, STOP. Say, in Portuguese, that this command only runs
inside the my-method repository, because it edits the kit's own files
and must never reach outside the current folder. Point at
`/my-method:health-check`, which runs anywhere.

---

# MODE 1 — research and propose (no argument)

## Step 1 — read what is already known

Read in full: `notes/maintenance/WATCHLIST.md` (what gets checked, and
the canonical URL of each source) and `notes/maintenance/LAST-CHECK.md`
(per-axis last-check dates and the previous run's NOT VERIFIED list).
Read `method.md` and the most recent `CHANGELOG.md` entry. Do not read
the audits or the applied proposals — the watchlist carries forward
whatever still matters from them.

Note each axis's last-check date. That date is the lower bound of every
"since when" question below. An axis with no date recorded uses the
repository's first commit date.

## Step 2 — delegate the five axes, in parallel

Launch FIVE subagents in a single batch. Give every one of them these
standing rules verbatim:

> Research only — install nothing, change no setting, and modify no
> file except the one output file named in your prompt. Every claim
> needs a URL and "accessed <today's date>". Anything you cannot
> confirm from a live source goes under NOT VERIFIED with the reason.
> Your own prior knowledge is NEVER a source, and "probably" is not an
> answer. An HTTP 200 is not evidence a source is alive — pages in
> this watchlist are known to return 200 for redirect shells,
> meta-refresh stubs and empty JavaScript pages; read the CONTENT.
> For every source you check, record the re-check recipe you used:
> the exact thing to read, in the exact place, for next time. Write
> your findings to the file named below, then reply with EXACTLY five
> lines summarizing what is decisive. No more.

Each writes to `notes/research-maintenance/<YYYY-MM-DD>-<axis>.md`.

**Axis A — Anthropic practices.** What changed in the official Claude
Code documentation since axis A's last-check date. Cover at minimum
the docs pages listed under A in the watchlist, plus the docs
changelog. For each change, say whether it touches this method or this
plugin, and name the file and step it touches. Changes touching
neither get one line each and are dropped.

**Axis B — Vulnerabilities.** Is the OWASP Top 10 edition named in
`research/13-testing-strategy.md` still current; has a revision or a
new category appeared. For each of `semgrep`, `gitleaks`, `npm audit`
and `pip-audit`: still maintained (latest release + date), still the
same command-line invocation the matrix's rows type, still free and
installable, or deprecated/renamed/abandoned. A tool that changed how
it is invoked is a defect in the matrix, not a note.

**Axis C — Skills and agents.** For everything installed
(`claude plugin list --json`): current version, renamed, deprecated or
abandoned. Then re-read each DEFERRED-with-trigger item in the
watchlist against its recorded trigger and report, per item, whether
the trigger is MET, NOT MET, or UNKNOWABLE-FROM-HERE. A trigger that
depends on the user's other projects cannot be observed from this
repository — say so, and the main session will ask the user.

**Axis D — Models and mechanisms.** Which Claude models and effort
levels exist today in Claude Code, and which the docs list as
deprecated or retired. Then: is `/model` still user-only, is `/effort`
still user-only, is `${CLAUDE_EFFORT}` still a documented
substitution. Any model named anywhere in this repository that no
longer exists is a defect — method v7 lets a task card name a model,
and a card naming a dead model sends the user to type a command that
fails.

**Axis E — The open sweep.** Answer exactly one question:

> What exists today that did not exist when this method was written,
> and that would make some part of it obsolete or unnecessary?

Read the Claude Code changelog entries since axis E's last-check date,
Anthropic's official news and blog posts in that same window, and the
docs pages the watchlist names. Two hard rules: (1) every candidate
must name the specific step, row, command, template or file of this
repository it would make obsolete or unnecessary — a candidate with no
named target is noise, discard it; (2) "nothing found" is a valid and
expected answer — if that is the answer, say it plainly and state the
window covered. Do not pad the list to look productive.

## Step 3 — read the five summaries, then write the proposal

Read only the five five-line summaries. Open a research file only to
quote a specific claim you are putting in the proposal.

Sort every finding into exactly one of three buckets:

- **DEFECT** — something the method or kit depends on changed or
  broke: a cited tool gone or renamed, a documented mechanism changed,
  a named model retired, a dead URL. Proposed as a fix.
- **CANDIDATE** — something new exists that could improve or replace
  part of the method. Proposed with its cost, and **the default answer
  is no**. A candidate is adopted only if it removes something the
  method currently does, or closes a gap an audit already named.
- **NOT VERIFIED** — could not be confirmed live. Never becomes a
  proposed change. Goes to the ledger so the next run starts from it.

Write `notes/proposals/maintenance-<YYYY-MM-DD>.md` in this
repository's existing proposal format: provenance; verified mechanism
with one URL and date per claim; decisions the user can veto one by
one; exact text per file; application order; test plan; what it does
NOT guarantee; NOT VERIFIED.

If every axis came back clean, write the proposal anyway saying so — a
run that found nothing is a result worth dating, and it is what
updates the ledger.

## Step 4 — present, in Portuguese, and STOP

At most 40 lines. Per axis: one line for what was checked and the
window; then the DEFECTS, each with its consequence in plain language;
then the CANDIDATES, each with its cost and your recommendation, which
is "no" unless it removes something; then the NOT VERIFIED count.

If axis C reported any UNKNOWABLE-FROM-HERE trigger, ask about those
here as ONE grouped question — these are not critical-class questions,
so grouping is allowed and the answers stay separable one by one.

Then end the turn with exactly this text and nothing else:

> Proposta escrita em `notes/proposals/maintenance-<data>.md`. Rode
> `/clear` e depois `/my-method:update-method apply` para aplicar
> depois de ler.

Do not apply anything in this session. Do not offer to.

---

# MODE 2 — apply (`apply`)

## Step 1 — load and re-confirm

Read the most recent `notes/proposals/maintenance-*.md`. Summarize in
Portuguese, in at most 10 lines, exactly what will change, file by
file. Ask for explicit confirmation and WAIT. If the user vetoes an
item, drop it and restate what remains before proceeding.

## Step 2 — apply, in this order

1. `method.md` — only if a DEFECT requires it. If its text changes,
   bump the version in the header, add the origin nota, and record the
   provenance in `friction.md`'s YOURS section: maintenance findings
   are the **external-change** class, distinct from pilot friction and
   from the recorded conscious exceptions.
2. `playbook/SECURITY-MATRIX.md` — tool, row or source changes.
3. `research/13-testing-strategy.md` — OWASP edition or reasoning.
4. The kit's commands, agents and templates.
5. **The embedded copies inside `kit/my-method/commands/start-project.md`.**
   That file embeds four texts: the method, the matrix, the templates
   and the `verify.ps1` skeleton. Any change to a canonical file above
   touches its embedded copy in the SAME commit.
6. **`kit/my-method/.claude-plugin/plugin.json` — bump `version`.**
   Version is the cache key the harness uses to decide whether an
   update is available; a change applied without a bump relies on
   undocumented behaviour to reach the installed copy.
7. `notes/maintenance/WATCHLIST.md` — add a line for every new URL the
   changes introduce; remove lines for sources that died.
8. `notes/maintenance/LAST-CHECK.md` — append this run's entry: date,
   axes covered with their windows, what was applied, what was
   rejected and why, and the full NOT VERIFIED list.
9. `kit/my-method/commands/health-check.md` — rewrite the two literal
   lines `Last full maintenance run:` and `Kit inventory at that run:`
   to today's date and the new counts. This is what the health check
   reports in every project folder; skip this and it lies from now on.
10. `CHANGELOG.md` — one entry, in Portuguese, in the existing style,
    naming the new plugin version.

## Step 3 — the mechanical checks, before committing

Both must pass; either failing blocks the commit:

1. Compare, byte for byte, each canonical file against its embedded
   copy in `start-project.md` (method, matrix, templates, verify
   skeleton). Report line counts and the number of divergences. This
   repository has recorded that duplication trap in `friction.md`
   since 2026-08-10 and has checked it mechanically on every method
   revision since v5.
2. Run `claude plugin validate ./kit/my-method` and show the raw
   output. It checks `plugin.json`, every command's and agent's
   frontmatter, and `hooks/hooks.json` for schema errors.

## Step 4 — commit, verify the harness picked it up, close

One commit, in English. Then show `git show --stat` raw.

Then run `claude plugin details my-method` and show the raw output.
If its component inventory does not match what was just applied, say
so plainly and tell the user to run
`/plugin update my-method@jeferson-tools` and then `/reload-plugins` —
applied on disk and loaded by the harness are two different things,
and only this output tells them apart.

End with exactly:

> Manutenção aplicada e commitada. Rode `/clear` antes de continuar.
````

### 3. NEW `notes/maintenance/WATCHLIST.md`

Structure below; the rows are filled at apply time from this proposal's own verified
research, so the file never carries a URL nobody confirmed.

````markdown
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

## Axis A — Anthropic practices
| Source | URL | Why the method depends on it | Re-check recipe |
|---|---|---|---|

## Axis B — Vulnerabilities
| Source | URL | Rows that depend on it | Re-check recipe |
|---|---|---|---|

## Axis C — Skills and agents: DEFERRED items and their triggers
| Item | Origin | Trigger recorded | Observable from this repo? |
|---|---|---|---|

## Axis D — Models and mechanisms
| Fact the kit relies on | URL | Where it is relied on | Re-check recipe |
|---|---|---|---|

## Axis E — Open sweep sources
| Source | URL | Window | Re-check recipe |
|---|---|---|---|
````

Seeding, all transcribed from files that exist rather than invented:

- **Axis A** — the docs pages already cited across audits 01–03 and the v6/v7 proposals,
  plus the CLI commands probe 1 depends on (`claude plugin list/details/validate`), whose
  output format is itself something a run has to re-check.
- **Axis B** — the five sources in `notes/research-maintenance/sources-baseline.md`
  (OWASP, Semgrep, gitleaks, npm audit, pip-audit), each with the re-check recipe that
  file already records.
- **Axis C** — audit-02's six deferred items with their verbatim triggers
  (`frontend-design`, `webapp-testing`, `playwright` MCP, `security-guidance`,
  `skill-creator`, staged TDD), each marked observable-from-here or not.
- **Axis D** — the mechanism facts v7 depends on (`/model` user-only, `/effort`
  user-only, `${CLAUDE_EFFORT}` substitution, turn-scoped frontmatter overrides, the
  alias list and its provider-dependent resolution, the per-model effort table).
- **Axis E** — the four windows R4 identified: the docs changelog, the repo's GitHub
  Releases, `anthropic.com/news` and `claude.com/blog` — the last two confirmed this
  session to be **separate feeds with different newest posts**, so checking one misses
  roughly half the announcements.

### 4. NEW `notes/maintenance/LAST-CHECK.md`

````markdown
# LAST CHECK — maintenance ledger

Append-only. One entry per run of `/my-method:update-method`. The
per-axis dates here are the lower bound of the next run's "since when"
questions.

| Axis | Last checked | Run |
|---|---|---|
| A — Anthropic practices | — | — |
| B — Vulnerabilities | — | — |
| C — Skills and agents | — | — |
| D — Models and mechanisms | — | — |
| E — Open sweep | — | — |

---

## <YYYY-MM-DD> — run N

Axes covered, with windows:
Applied:
Rejected, and why:
NOT VERIFIED, carried to the next run:
````

Its first entry, written at apply time, records **this proposal's own research as run 1**:
axes A and D partially covered (the CLI-mechanics research above), with its NOT VERIFIED
list carried forward.

### 5. `README.md` — two lines in the command list

Added after `/my-method:friction`:

```markdown
- `/my-method:health-check` — checagem instantânea, antes de começar
  um projeto: o plugin certo está carregado e atualizado, os comandos
  resolvem, o revisor de segurança registra, a trava de commit
  dispara, as ferramentas de segurança existem. Só reporta — não
  conserta e não instala nada.
- `/my-method:update-method` — manutenção completa do método e do
  plugin: reverifica documentação da Anthropic, fontes de
  vulnerabilidade, skills e agentes instalados, modelos e níveis de
  esforço, e faz uma varredura aberta do que existe hoje que tornaria
  parte do método obsoleta. Escreve uma proposta; não muda nada sem a
  sua aprovação. Só roda dentro do repositório do método.
```

### 6. `friction.md` — provenance entry, in THIS proposal's commit

A YOURS entry recording: the two maintenance commands proposed; that the brief cited an
audit-04 which does not exist, so the brief itself is the diagnosis; the four live
findings (F1–F4), with F3 called out as the reason D-VER exists; and that **external
change** enters as a fourth provenance class alongside pilot friction and the three
conscious exceptions.

### 7. NOT changed by this proposal

`method.md` is **not touched** and its version is **not bumped**. This is kit tooling —
two commands and two notes files — exactly as rec 4 was. The method describes how to build
a product; it does not describe how to maintain its own plugin, and a maintenance step
inside it would land in every project's `method.md` copy, where nothing ever runs it.

The four embedded texts in `start-project.md` therefore do not change either, and the
byte-comparison ritual is not needed for *this* application — only for future maintenance
runs that touch a canonical file.

`kit/my-method/.claude-plugin/plugin.json` **is** touched, for the version bump (D-VER):
`0.1.0` → `0.2.0`, since this adds two commands.

---

## Application order (after the user approves this text)

1. `kit/my-method/commands/health-check.md` (new).
2. `kit/my-method/commands/update-method.md` (new).
3. `kit/my-method/.claude-plugin/plugin.json` — `version` `0.1.0` → `0.2.0`.
4. `notes/maintenance/WATCHLIST.md` (new), seeded as described in item 3 above.
5. `notes/maintenance/LAST-CHECK.md` (new), first entry dated today as run 1.
6. `README.md` — the two command lines.
7. `friction.md` — the provenance entry.
8. `CHANGELOG.md` — one entry naming plugin version 0.2.0.
9. `claude plugin validate ./kit/my-method` — must print validation passed.
10. One commit.
11. **`claude plugin details my-method` — must now report Skills (6).** If it still
    reports 4, the harness has not picked up the new commands: run
    `/plugin update my-method@jeferson-tools`, then `/reload-plugins`, and re-check. This
    step is not optional — without it, the two new commands exist on disk and do not
    exist as commands.
12. Then the test plan.

---

## Test plan

**T1 — `/my-method:health-check` in a fresh session, inside a real my-method project.**
Use the disposable pilot from the v5+v6 run (it has `method.md`, `PLAN.md`, `STATE.md`,
commits and `scripts/verify.ps1`). Expected: probe 1 reports 6 skills / 1 agent / 1 hook
and scope `user`; probe 2 returns `HEALTH: reviewer alive`; probe 3 is **DENIED** by the
gate with its own reason text; probe 4 reports `git` present and the three absent
scanners; probe 5 is skipped. The only test that exercises probes 1–4 conclusively.

**T2 — `/my-method:health-check` in an empty folder, fresh session.** Expected: probes 1,
2 and 4 as in T1; probe 3 **INCONCLUSIVE** with its one-line reason and no claim of a
pass; probe 5 skipped. This is the test that catches the most likely design bug: a probe
that reports success because nothing denied it.

**T3 — `/my-method:health-check` in this repo.** Expected: probe 1 compares against the
kit on disk; probe 3 INCONCLUSIVE (no `PLAN.md`/`STATE.md` here); probe 5 runs
`claude plugin validate` and passes.

**T4 — the staleness probe, forced.** Add a throwaway sixth command file to
`kit/my-method/commands/` without bumping the version, start a fresh session, run the
health check. Expected: probe 1 reports a MISMATCH between the kit on disk and the
harness's inventory — or reports a match, which would be evidence that the undocumented
sync of F3 is still working. **Either outcome is a real answer**, and it settles F3's open
question empirically. Delete the throwaway file afterwards.

**T5 — the safety check.** Run `/my-method:update-method` in a folder that is not this
repo. Expected: refusal in Portuguese pointing at `health-check`; nothing read, nothing
written.

**T6 — one real research run.** `/my-method:update-method` in this repo, fresh session,
end to end. What is being tested is the shape, not the findings: five subagents in one
batch, five files under `notes/research-maintenance/`, five five-line summaries, a
proposal written, and the turn ending with the literal `/clear` text and no applied
change. Record the wall-clock time and whether the main session's window survived — that
number is what tells the user whether a monthly cadence is affordable.

**T7 — the apply path on a deliberately trivial change.** After T6, run
`/my-method:update-method apply` on the smallest real item the run found (if it found
nothing, apply only the ledger, version bump and mirrored-line updates). What is tested:
that step 9 rewrites both literal lines in `health-check.md`, that both mechanical checks
run, that the version bumped, and that step 4's `claude plugin details` confirms the
harness sees it. Then re-run `/my-method:health-check` and confirm it reports the new
date.

**T8 — the honest negative.** In a scratch copy of the kit, rename
`agents/security-reviewer.md`, and confirm probe 2 reports FAILED rather than passing
quietly. A health check that cannot fail is decoration.

---

## Cost — what this adds, forever

**Standing context cost, every session, every project.** `claude plugin details my-method`
reports the kit's current always-on cost at **~271 tokens** (F2). Two more commands add
their descriptions to that: roughly **+100 tokens per session**, permanently, in every
project including small ones — the same accounting audit-02 used to reject pre-installing
skills. That is the honest price of having the commands exist at all. Their bodies (~2k
and ~4k tokens) load only when typed.

**Health check, per run:** seconds, five commands, one trivial subagent invocation.

**Full maintenance, per run:** five subagents. This session's two research subagents
consumed roughly 125k and 255k tokens inside their own windows and returned five lines
each; five axes would be of that order. The main session pays only the summaries. This is
the number the cadence has to justify — see below.

---

## How often this pays, and what triggers a run

**Health check — before every project start, and after any Claude Code update you
notice.** It costs seconds. Its value is asymmetric: the failures it catches (an agent
that stopped registering, a hook that stopped firing, a missing scanner, a plugin the
harness never picked up) are exactly the failures that otherwise surface *mid-task*, when
the session is long, the context is full, and the user cannot tell a kit failure from a
model failure. Run today, it would already have reported three missing security tools
(F1) and a shadowed install (F4).

**Full maintenance — a 30-day timer, plus event triggers.** The reasoning, so it can be
argued with: Claude Code ships releases at roughly one version per day, and this
repository now depends on some fifteen external URLs. Weekly is more than the yield
justifies for a single-user kit; quarterly lets a broken tool reference sit through
several projects. Thirty days is the compromise, and runs 2 and 3 should adjust it: if
they find nothing, stretch it; if they find a defect that was already breaking work,
shorten it.

**Event triggers, any one of which beats the calendar:**

- The health check failed any probe.
- A security tool errors, disappears, or changes its output during a project.
- You saw Claude Code update and behave differently.
- `/model` or `/effort` offers something the kit has never heard of, or stops offering
  something a card names.
- A project's verify step failed for a reason that had nothing to do with that project.
- You are about to start a project of a shape you have never built — the first T2 with
  login, the first with payments. Those matrix rows have never been exercised, and this is
  the cheapest moment to find out whether the tools they name still work that way.

**Honest note on yield:** it is front-loaded. The first run finds the most, because
nothing has ever been re-checked. If runs 3 and 4 come back empty, that is evidence to
lengthen the interval — not evidence the command was a waste.

---

## What this does NOT guarantee

- **It cannot detect a silent behavioural change in the model.** If instruction-following
  degrades, or an update makes the interrogation sloppier, no URL changes and no probe
  fails. Only pilots and `friction.md` catch that class. This does not replace them.
- **It cannot tell you the method is still *good*.** It verifies that what the method
  cites still exists and still works. Whether the method still produces good products is
  a question only real projects answer.
- **The open sweep is bounded by its source list.** It reads the changelog, the blog, the
  news page and the watchlist's docs pages. Something that changed outside those — a
  community practice, a tool the method never cited, a technique nobody wrote a release
  note about — is invisible to it. Bounding the sweep by a date and a source list is what
  makes it affordable and repeatable, and it is also exactly what keeps it incomplete.
  That trade is the honest limit of the brief's own framing.
- **It cannot see your other projects.** The Boundaries rule means a run inside this repo
  cannot check whether a deferred item's trigger fired somewhere else on disk. That is why
  axis C reports UNKNOWABLE-FROM-HERE and the command asks you instead.
- **Probe 3 is conclusive only where the gate is armed** — in an empty folder it proves
  nothing, by design, and says so.
- **Probe 2 proves registration, not correctness.** A reviewer that registers and answers
  can still miss findings; `research/13-testing-strategy.md` documents what a reading
  review cannot see, and none of that changes because a health check passed.
- **Probe 1 proves the harness's inventory matches a count, not that the content is
  right.** A command file that loaded but whose text is wrong counts the same as a correct
  one.
- **A commit typed in a terminal outside Claude Code is still unguarded**, and no probe
  here changes that — hooks only see tool calls (CHANGELOG 2026-08-11).
- **It cannot verify that a proposed change is correct**, only that its sources are live
  and quoted. The approval gate is yours, and it is the only real check.
- **The whole design assumes the CLI keeps working the way it does today.** If
  `claude plugin list --json` changes its fields, probe 1 degrades silently — a health
  check that depends on tooling is itself something the maintenance run has to check,
  which is why the CLI commands go on the watchlist under axis A.

---

## NOT VERIFIED

- **Why the cached plugin copy reflects edits made after `installedAt` (F3).** The
  behaviour is observed and consistent with the CHANGELOG's live tests, but the mechanism
  is undocumented, the docs say the opposite ("copies … rather than using them in-place"),
  and `lastUpdated`/`version` never move. T4 is designed to settle it empirically. Until
  then, D-VER treats it as unreliable rather than as a feature.
- **Whether `claude plugin list --json`'s extra fields (`scope`, `installPath`,
  `installedAt`, `lastUpdated`, `errors`) are stable.** They are observed live this
  session, not documented — the docs list only version, source marketplace and enable
  status. Probe 1 must degrade gracefully if a field disappears.
- **Whether `${CLAUDE_PLUGIN_ROOT}` expands inside command markdown.** Docs say yes
  "anywhere the placeholder appears"; the skills page's substitution table omits it;
  issue #9354 is open since 2025-10-11 saying no. This proposal avoids depending on it
  entirely (D5).
- **Whether an interactive session's `/plugin update` can be triggered from a `-p` probe**
  — not investigated; both commands only ever *tell the user* to run it.
- **Whether five parallel subagents in one batch hit any concurrency limit** — audits 02
  and 03 used up to seven, but never five plus a long main-session write in the same turn.
  T6 measures it.
- **Whether the Semgrep `owasp-top-ten` ruleset is keyed to the 2021 or the 2025 OWASP
  edition.** The served YAML carries per-rule OWASP metadata, but the fields were not
  parsed. "Still 2021-aligned" is a strong suspicion, not a fact — and it is exactly the
  kind of question a run should resolve rather than inherit.
- **The Betterleaks project** named as gitleaks' successor — existence, maturity,
  license, suitability. Cited only because the gitleaks README names it; the repository
  was not fetched.
- **Which models this account can actually select.** All model facts come from public
  docs; account tier and organization policy can restrict the real set, and none of that
  was inspected. This session hit a live instance of exactly that class: a research
  subagent terminated with "Fable 5 requires usage credits".
- **The OWASP Top 10:2025 publication date and any next-revision plan** — neither is
  stated on any canonical OWASP page. The ~4-year historical cadence points at ~2029,
  but that is an inference, not a published plan.
