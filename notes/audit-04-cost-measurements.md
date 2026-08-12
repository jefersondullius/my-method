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

**Finding (measurement, not recommendation): `kit/my-method/templates/` appears orphaned.**
`start-project.md` contains zero occurrences of the string `"templates"` and never reads
`kit/my-method/templates/*.md` by path. It carries its own, separately-authored inline blocks
that produce structurally similar but **not byte-identical** output (e.g. the template's
`CLAUDE.md` uses `<!-- ... -->` placeholders, the inline block uses `<...>` placeholders).
The two copies (template file vs. inline block) are kept in sync by hand via
`update-method.md`, not by a live read. So roughly four-fifths of `start-project.md`'s
character count is literal copies of other canonical files, not start-project-specific
orchestration prose — and one of those "canonical" sources (`templates/`) is not actually
consulted at runtime at all.

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

Side finding (measurement, not recommendation): `kit/my-method/templates/*.md` is not
referenced by `start-project.md` at all — it appears to be an orphaned, hand-synced duplicate
of the inline blocks that actually ship.
