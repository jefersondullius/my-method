# Audit 04 — cost measurements

Session 4 of 4 of the cost audit (see [[my-method-audit-series-rules]] / `WORKFLOW-TARGET.md`
provenance). This session MEASURES; it does not judge or recommend. Where a number is an
estimate rather than a direct measurement, it is marked ESTIMATIVA inline. Nothing was
built, changed, or installed. Repo: `C:\Users\Jeferson\Documents\dev\my-method`, plugin
`my-method` v0.3.0. Date: 2026-08-12.

Token-estimate method used throughout unless noted otherwise: **chars / 4** (a common rough
proxy for English/markdown token count, not a real tokenizer run — order-of-magnitude, not
exact). Line counts via `wc -l`, char counts via `wc -c`.

---

## a) Fixed cost per session (always-on)

Raw output of `claude plugin details my-method`:

```
my-method 0.3.0
  Executable form of method.md: the working method for building products with Claude doing the engineering.
  Source: my-method@jeferson-tools

Component inventory
  Skills (6)  friction, health-check, next-task, start-project, update-method, where-am-i
  Agents (1)  security-reviewer
  Hooks (1)  PreToolUse  (harness-only — no model context cost)
  MCP servers (0)
  LSP servers (0)

Projected token cost
  Always-on:   ~457 tok   added to every session

Per-component (rounded)
  component          always-on  on-invoke
  security-reviewer        ~70       ~790
  friction                 ~40       ~740
  health-check              ~70       ~2k
  next-task                 ~50      ~2.6k
  start-project              ~60     ~18.9k
  update-method             ~110      ~4.2k
  where-am-i                 ~50       ~610
```

**Most expensive always-on component: `update-method` (~110 tok).** Its full command
frontmatter description, transcribed verbatim:

> Full maintenance pass of the method and its plugin — re-verifies Anthropic practices,
> vulnerability sources, installed skills and agents, models and effort levels, and runs one
> open sweep for what exists today that would make part of the method obsolete. Researches
> and PROPOSES; changes nothing without explicit approval.

For comparison, the other five frontmatter descriptions (source: `kit/my-method/commands/*.md`
and `kit/my-method/agents/security-reviewer.md` YAML frontmatter):

| Component | Always-on (tool output) |
|---|---|
| update-method | ~110 |
| start-project | ~60 |
| security-reviewer | ~70 |
| health-check | ~70 |
| next-task | ~50 |
| where-am-i | ~50 |
| friction | ~40 |

---

## b) Cost of each command when typed (body size)

Source: `kit/my-method/commands/*.md`, method chars/4.

| File | Total lines | Total chars | Est. tokens | Body lines (excl. frontmatter) | Body est. tokens |
|---|---|---|---|---|---|
| friction.md | 59 | 2,237 | 559 | 54 | 509 |
| health-check.md | 133 | 5,706 | 1,427 | 129 | 1,360 |
| next-task.md | 145 | 7,331 | 1,833 | 141 | 1,784 |
| **start-project.md** | **897** | **52,143** | **13,036** | **892** | **12,969** |
| update-method.md | 242 | 12,005 | 3,001 | 237 | 2,901 |
| where-am-i.md | 43 | 1,856 | 464 | 39 | 419 |
| **Sum (6 files)** | **1,519** | **81,278** | **20,320** | **1,492** | **19,941** |

`start-project.md` alone is ~64% of the six files' combined size — ~68x the size of
`where-am-i.md`.

### start-project.md breakdown — the four embedded texts

All four are embedded **inline, literal, byte-for-byte** copies (not read-instructions
pointing at another file):

| Embedded text | Location | Lines | Est. tokens | Note |
|---|---|---|---|---|
| method.md (all STEPs + notas) | lines 34–271 | 238 | ~3,278 | copy of repo-root `method.md` |
| SECURITY-MATRIX.md (full matrix) | lines 291–505 | 215 | ~5,548 | copy of `playbook/SECURITY-MATRIX.md`; largest single block in the file — bigger than 5 of the other 6 command files *combined* |
| "Templates" — 5 inline blocks (SPEC/PLAN/TASK/CLAUDE/STATE format) | scattered, Steps 2/4/5 | 157 | ~1,102 | **not sourced from `kit/my-method/templates/*.md`** — see finding below |
| verify.ps1 skeleton | lines 832–864 | 33 | ~350 | no standalone template file exists anywhere else in the repo |
| **Sum of the four** | | **643** | **~10,278** | **72% of body lines / 79% of body chars** |

**Finding, first-order — not just cost, correction-blindness risk: `kit/my-method/templates/`
is orphaned, and the two copies have already diverged.** `start-project.md` contains zero
occurrences of the string `"templates"` and never reads `kit/my-method/templates/*.md` by
path. It carries its own, separately-authored inline blocks that produce structurally similar
but **not byte-identical** output (e.g. the template's `CLAUDE.md` uses `<!-- ... -->`
placeholders, the inline block uses `<...>` placeholders). This is not hypothetical: the
apply-time mechanical check run during the `update-method` maintenance pass on 2026-08-12
(`notes/maintenance/LAST-CHECK.md`, "FOUND WHILE APPLYING") already found real drift —
`kit/my-method/templates/CLAUDE.md` (69/69 lines) has **10 divergences** from the copy
`start-project.md` actually writes, and `templates/STATE.md` (32/32 lines) has **14**. That
entry left the question open ("no command in the kit reads `templates/` at all... so either
the directory is dead weight or it is the intended canonical source"). The risk this creates:
**someone edits `templates/CLAUDE.md` believing they've fixed something, ships it, and no
project ever receives the fix** — because `start-project.md` never reads that file. The
inverse is just as real: someone edits the inline block inside `start-project.md` and
`templates/` silently keeps drifting further, so anyone who *does* open `templates/` (to
understand the format, or because a future command starts reading it) sees stale content.

**Which copy should be canonical: `kit/my-method/templates/*.md`, not the inline blocks —
for two reasons, both drawn from this repo's own existing pattern, not a new opinion:**

1. **Consistency with how the other two embeds already work.** `method.md` and
   `SECURITY-MATRIX.md` follow exactly this shape today — a dedicated, single-purpose
   canonical file at a stable path, with `start-project.md` carrying a byte-for-byte embedded
   copy that `update-method`'s apply-time check mechanically diffs against the canonical file
   (method and matrix both came back at 0 divergences in the same run that found the template
   drift). The check *already treats `templates/` as the canonical side of that same
   comparison* for `CLAUDE.md` and `STATE.md` — it reports "divergences from templates/",
   not the reverse. Declaring the inline blocks canonical instead would mean rewriting that
   check's direction, against a convention the kit has already committed to twice.
2. **A dedicated file is the reviewable unit.** A one-artifact-per-file layout
   (`templates/CLAUDE.md`, `templates/STATE.md`, ...) is something a human or a future
   automated check can diff, version, and read in isolation. An inline block buried at a
   specific line range inside an 897-line command file is not — finding it at all required a
   full read of `start-project.md` in this session.

**One thing a naive fix would break, worth flagging before anyone acts on this:** the current
embedded blocks are not strictly worse copies — per LAST-CHECK, "the angle-bracket versions
carry cross-references the template files lack" (e.g. pointing back to SPEC.md's opening
line). Making `templates/` canonical by simply overwriting it with the embedded blocks, or
making `start-project.md` read `templates/` as-is today, would each lose real content one
side has and the other doesn't. Reconciling the two — carrying the embedded blocks' extra
cross-references into `templates/`, *then* pointing `start-project.md` at `templates/` — is
the shape of a correct fix, not something this measurement session is doing (out of scope per
this session's own rules: measure, don't build). Recorded here so the next session that picks
this up doesn't have to re-derive it.

### Is the embedding itself (cost #1 and #2) a forced consequence of a real boundary, or a choice?

The two threads — cost (this section) and canonical source (previous subsection) — turn out to
be the same question asked twice: **could `start-project.md` avoid embedding `method.md` and
`SECURITY-MATRIX.md` literally by having Claude *read* them from the plugin's own install
directory at write time instead?** If yes, cost items #1 and #2 (~3,278 + ~5,548 = ~8,826
tokens) are a removable design choice. If no, they are a floor, and the conversation the user
asked for — "is this necessary, or does an alternative exist" — has a real answer either way.

**Finding: it is currently forced, by a documented-but-contested platform gap, not a choice
this kit made carelessly.** Two separate mechanisms would each have to work for a
read-instead-of-embed alternative to exist, and neither is confirmed for this kit's exact
shape:

1. **`${CLAUDE_PLUGIN_ROOT}` substitution inside a command's own markdown *prompt text*** —
   the only way `start-project.md` could even name the path to
   `kit/my-method/templates/CLAUDE.md` or the repo's canonical `method.md` at runtime, since a
   plugin's installed location is an opaque, versioned cache path
   (`~/.claude/plugins/cache/...`), not something the command can know without it.
   `notes/research-maintenance/cli-mechanics.md` §7 (sources:
   <https://code.claude.com/docs/en/plugins-reference#environment-variables>, accessed
   2026-08-11; GitHub issue
   [#9354](https://github.com/anthropics/claude-code/issues/9354), open since 2025-10-11)
   found this **documented-but-contested**: the docs assert it resolves "anywhere the
   placeholder appears" in skill/agent content, but #9354 remains open claiming it does not,
   for command markdown specifically — and the research narrows the open gap further, to
   `disable-model-invocation: true` commands (per issue #44057's repro), which is **the exact
   frontmatter flag all six of this kit's commands use**, `start-project.md` included. Every
   *other* `${CLAUDE_PLUGIN_ROOT}` gap adjacent to #9354 (statusLine, MCP `headersHelper`,
   hook-execution injection, the Windows/Cowork case) has since closed — only the
   command-markdown one, in this kit's own invocation shape, remains open and unresolved.
   `notes/maintenance/LAST-CHECK.md`'s own NOT VERIFIED list (item 22) already flags this as
   never empirically tested inside a command body for this kit — only confirmed working in
   `hooks/hooks.json`, a different mechanism (§7's own table: hook commands substitute, but
   that is a distinct row from skill/agent content).
2. **Even granting (1), reading the file into the model's context to copy it out (Read tool,
   then Write tool) does not avoid the token cost — the full content still has to pass through
   context once to be written.** The only mechanism that would avoid the cost entirely is a
   shell-level copy (`Copy-Item`/`cp`) that never touches the model's context — but the docs
   are explicit that `${CLAUDE_PLUGIN_ROOT}` "is exported as environment variables to **hook
   processes and to MCP and LSP server subprocesses**" (same source as above) — not to an
   ordinary Bash/PowerShell tool call a command's own prompt text asks the model to run mid-
   session. That path is unconfirmed in either direction; nothing in this repo's research has
   tested it.

**So: no working alternative is currently confirmed to exist, and the one alternative that
*would* actually save tokens (shell-level copy) depends on a mechanism this kit has never
tested and the docs don't extend to this use case. Given that, the framing the user asked
for is the right one: this is not about eliminating the duplication — it may not be eliminable
today — it is about making it cheap to keep correct.** Concretely, "cheap to keep correct"
already has a working, low-cost mechanism in this kit: the apply-time mechanical diff check
inside `update-method` that already caught the `CLAUDE.md`/`STATE.md` drift (LAST-CHECK,
2026-08-12) is itself near-zero additional token cost (a line-count diff, not a content
re-embed) and already covers all four artifacts — it just was not, in that run, given the
authority to force a fix, only to report one (LAST-CHECK: "NOT force-fixed here... out of the
approved proposal's scope"). The gap this measurement session surfaces is not "duplication
exists" (forced, per above) but **"the drift-detector that already exists found real drift and
nothing closed the loop"** — that is a process question for a future session, not a cost
question, and not something this measurement session is deciding or building.

**One cheap, concrete next step this session is not taking (recording it, not doing it):** the
disputed mechanism in (1) has never actually been tested for this kit's own command shape —
only inferred from docs and issue trackers. A single empirical test, in the same spirit as the
2026-08-11 T4 test that settled the live-read-vs-frozen-cache question, would tell whether
`disable-model-invocation: true` command markdown in *this* kit gets `${CLAUDE_PLUGIN_ROOT}`
substituted or not — and would turn "documented-but-contested, ESTIMATIVA" into a measured
fact for this specific repo, one way or the other.

---

## c) Cost of what start-project writes into each project

Source: `start-project.md` read in full to confirm what writes what and from where; then
grepped `kit/my-method/commands/*.md` and `kit/my-method/agents/*.md` for every reference to
each written filename to classify read frequency.

**Confirmed mechanism:** none of these seven files are copied live from
`kit/my-method/templates/`, `method.md`, or `playbook/SECURITY-MATRIX.md` at project-creation
time — every byte written comes from a hardcoded block already inside `start-project.md`
(see finding in section b). Those external files are the canonical, hand-maintained source;
the command's embedded copy is what actually ships to a new project.

| File in new project | Lines | Est. tokens | Read-frequency bucket | Why |
|---|---|---|---|---|
| `method.md` | 236 | ~3,120 | **NEVER READ, only written** | No command reads its content back. `next-task`/`update-method` only check its *existence*, never its content. |
| `SECURITY-MATRIX.md` | 213 | ~5,419 | **READ ONLY WHEN A COMMAND SAYS TO** | `next-task.md` opens it only on a "drift" (undeclared risk surface) check; otherwise excluded from minimum reading. |
| `CLAUDE.md` | 69 | ~632 | **READ EVERY SESSION AUTOMATICALLY** | Loaded by the Claude Code harness itself at session start (project-root convention) — no command instruction needed. |
| `STATE.md` | 32 (baseline; grows, capped ~80 lines per method.md) | ~198 (baseline) | **READ EVERY SESSION AUTOMATICALLY** | `next-task.md` step a.1 and `where-am-i.md` step a.1: "Read STATE.md in full," unconditional. |
| `PLAN.md` | 7 (baseline; +1 line/task) | ~67 (baseline) | **READ EVERY SESSION AUTOMATICALLY** | `next-task.md` step a.2 / `where-am-i.md` step a.2: "Read PLAN.md in full," unconditional. |
| `plan/TASK-XXX.md` (1 per task) | 29 (baseline/card) | ~193 (baseline/card) | **READ EVERY SESSION AUTOMATICALLY, but scoped to exactly one card** | "Open ONLY that one task's card. Do not open any other card." — N tasks = N files on disk, but 1 read per invocation, always. |
| `scripts/verify.ps1` | 32 (skeleton) | ~346 (baseline) | **READ ONLY WHEN A COMMAND SAYS TO** — and even then, executed as a subprocess, not loaded as context text; only its stdout enters context | Runs during the Verify step (d), not the unconditional minimum-reading step (a). |

---

## d) Read cost per task, and how it grows

Source: `next-task.md` read in full; `kit/my-method/templates/{PLAN,STATE,TASK-XXX}.md` read
in full; repo-wide search (Grep + `git log --all --diff-filter=A --name-only` + Glob) for any
real pilot project instance.

**Mandatory read set, every `/next-task` invocation (step "a — minimum reading"):**
1. `STATE.md`, in full — one file.
2. `PLAN.md`, in full ("index only, one line per task") — one file.
3. Exactly one `plan/TASK-XXX.md` — the instruction explicitly forbids opening any other card.

No glob/loop over `plan/*.md` exists anywhere in the command. `SECURITY-MATRIX.md` and
`method.md` are excluded from this mandatory set (see section c); prior task cards are never
read (explicitly forbidden).

**No real pilot project exists on disk.** Grep for "pilot", "calculo-investimento", "TASK-0";
`git log` for any historically-added `STATE.md`/`PLAN.md`/task card; Glob for
`**/STATE.md`, `**/PLAN.md`, `**/plan/TASK-*.md` — the only hits anywhere, past or present,
are the template files themselves. **Every number below is ESTIMATIVA, inferred from
template structure, not measured from an accumulating project.**

**What stays constant:** the task card. Always exactly one file per invocation, sized by that
task's own complexity — independent of total project task count.

**What grows, linearly, per completed task:**
- `PLAN.md` gains one index line/task (ESTIMATIVA ~15–25 tok/line).
- `STATE.md`'s "Tasks completed" section gains one line/task, same shape (ESTIMATIVA
  ~15–25 tok/line).
- `STATE.md`'s "Settled decisions" / "Things that broke once" may also grow, but irregularly
  (only on new decisions/failures) — not a per-task guarantee.

**Concrete answer — task 20 vs. task 2 (ESTIMATIVA):** roughly **+700–900 tokens** of extra
mandatory reading (PLAN.md growth + STATE.md "Tasks completed" growth combined), against a
per-invocation baseline of a few thousand tokens. Growth is **linear** in completed-task
count, driven by exactly those two artifacts — not unbounded (no glob-all-cards) and not flat
(both files are read in full every time and both accumulate one row per task).

---

## e) Hook cost

Source: `kit/my-method/hooks/hooks.json` and `verify-gate.ps1` read in full; script actually
executed and timed.

- **Script size:** 73 lines, 4,005 chars → ~1,000 tokens *if the script text itself ever
  reached the model* — it doesn't (see below); this is only the source-file size.
- **Fires on:** `PreToolUse`, matcher `Bash|PowerShell` — every Bash/PowerShell tool call, in
  every project with the plugin enabled. Confirms the user's claim about frequency.
- **Model context cost:**
  - Allow path (the vast majority — anything that isn't a `git commit`, or a commit outside a
    my-method project): `exit 0`, **empty stdout**. Confirmed empirically (`out=[]]` on every
    test run). **Zero tokens reach the model.** Cost is pure wall-clock.
  - Deny path (only a `git commit` that fails the verify/staging gate): stdout carries a JSON
    `permissionDecisionReason` string, ~90–260 chars (**~25–65 tokens**) that Claude Code
    surfaces to the model per its documented PreToolUse hook contract. (This surfacing
    behavior is inference from Claude Code's published hook contract, not independently
    re-verified by invoking Claude itself against a live deny in this session.)
- **Real measured timing:** 5 runs, synthetic `PreToolUse` JSON payload for `git status`
  piped into the exact command line `hooks.json` invokes, timed with a `Stopwatch`:
  321.3 / 294.0 / 294.6 / 290.6 / 279.9 ms → **average ~296 ms** (min ~280, max ~321).
  Dominated by `powershell.exe` cold-start (new process per call), not gate logic.

**Net: near-zero model-context cost on the allow path (the overwhelming majority of calls);
~296 ms of real wall-clock time paid on every single Bash/PowerShell call, everywhere the
plugin is enabled.**

---

## f) security-reviewer invocation cost — ESTIMATIVA (never run against a real diff)

Source: `kit/my-method/agents/security-reviewer.md`, `kit/my-method/templates/TASK-XXX.md`,
`playbook/SECURITY-MATRIX.md`, all read in full. **No actual invocation was made — this
entire section is order-of-magnitude reasoning, not measurement.**

Inputs a single invocation receives, per the agent's own body and `next-task.md` step (d)(3):
REVIEW rows (verbatim from the task card) + list of touched files + raw diff, on top of the
agent's fixed system-prompt overhead.

| Component | Estimate | Basis |
|---|---|---|
| Agent fixed overhead | ~790 tok | cited from `claude plugin details my-method` (section a), not re-derived |
| REVIEW rows (2–4 rows, typical single-surface task) | ~125–300 tok | sample rows from `SECURITY-MATRIX.md`, ~230–330 chars each |
| File list (~5 touched paths) | ~40–75 tok | ~20–60 chars/path |
| Raw diff (task sized to fit one session) | ~250–1,250 tok | assumed ~1,000–5,000 chars, a range not a bound |
| **Total, single invocation** | **~1,200–2,400 tokens** | sum of the above |

**Order of magnitude: roughly one to a few thousand tokens per invocation.** Note per
`next-task.md` step (d)(5): a failed review triggers a second, fresh invocation against the
updated diff — a task that fails review once pays this cost **twice**. This doubling is
structural (a fresh reviewer verdict is required, a prior pass can't be reused), not itself
an estimate.

---

## Summary table — main numbers

| Item | Value | Status |
|---|---|---|
| Always-on, every session | ~457 tok | measured (tool output) |
| Most expensive always-on component | update-method, ~110 tok | measured |
| Most expensive command body when typed | start-project.md, ~13,036 tok (897 lines) | measured (chars/4) |
| Fraction of start-project.md that is copy-pasted from elsewhere | ~72% lines / ~79% chars | measured |
| Files written per project, never read back | method.md (~3,120 tok) | measured |
| Files read every session unconditionally | CLAUDE.md, STATE.md, PLAN.md, 1 task card | measured |
| Extra mandatory reading, task 20 vs task 2 | ~700–900 tok | ESTIMATIVA |
| Hook wall-clock cost, per Bash/PowerShell call | ~296 ms | measured |
| Hook model-context cost, allow path | 0 tok | measured |
| security-reviewer, per invocation | ~1,200–2,400 tok | ESTIMATIVA |

## Three most expensive things found

1. **`start-project.md` itself** — ~13k tokens typed once per project, ~79% of it literal
   copies of `method.md` and `SECURITY-MATRIX.md` embedded byte-for-byte rather than
   referenced.
2. **The `SECURITY-MATRIX.md` embed inside `start-project.md`** — ~5,548 tokens, the single
   largest content block in the whole kit, bigger than 5 of the other 6 command files
   combined.
3. **`method.md` written into every project (~3,120 tok) but never read again by any
   command** — pure write cost with no measured read-side return within the kit's own flows.

**Elevated finding, first-order (not just cost — see section b):** `kit/my-method/templates/*.md`
is not referenced by `start-project.md` at all, and the two copies have already diverged for
real (`CLAUDE.md` 10 lines, `STATE.md` 14 lines, per `notes/maintenance/LAST-CHECK.md`). This
is correction-blindness risk: a fix applied to the unread copy never reaches a project.
`templates/*.md` should be the canonical side (matches how `method.md` and
`SECURITY-MATRIX.md` already work in this kit); the embedded blocks currently carry extra
content (cross-references) that must be preserved, not discarded, when reconciling. See
section (b) for the full reasoning — recorded for the next session to act on, not acted on
here.
