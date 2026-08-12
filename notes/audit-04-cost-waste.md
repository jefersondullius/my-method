# Audit 04 — cost waste (session 2 of the cost audit)

Builds on [[my-method-audit-series-rules]] / `notes/audit-04-cost-measurements.md` (session 1,
2026-08-12 — all raw numbers below are cited from there unless marked NEW). This session
IDENTIFIES AND EXPLAINS waste; it does not rank remedies or propose fixes (session 4 of the
cost audit does that). Nothing was built, changed, or installed. Two sub-agents did the heavy
reading: one re-read `friction.md`, `health-check.md`, `next-task.md`, `update-method.md`,
`where-am-i.md` in full; one researched Claude Code's hooks documentation live
(`code.claude.com/docs/en/hooks-guide`, `.../hooks`, accessed 2026-08-12).

For every item: where it is, what it costs, why it exists, and — per this session's own rule
— what is lost if it is cut.

---

## 1. `PLAN.md` / `STATE.md` growth with no hard ceiling (item f — flagged by the user as the
most important item in this audit)

**Where:** every `/next-task` and `/where-am-i` invocation reads `STATE.md` and `PLAN.md` in
full, unconditionally (method.md STEP 4/FILES THAT CARRIES STATE; `next-task.md` step a.1–a.2).

**What it costs:** ESTIMATIVA from session 1 — task 20 vs. task 2 costs **~700–900 extra
tokens** of mandatory reading, driven by `PLAN.md` gaining one index line/task and `STATE.md`'s
"Tasks completed" gaining one line/task. **New in this session:** `STATE.md` has a documented
hard cap — "max 80 lines" (`method.md`, FILES THAT CARRY STATE) — but `PLAN.md` has **no stated
cap anywhere in method.md STEP 4** ("an index only: one line per task"). `STATE.md`'s growth is
therefore bounded by design; `PLAN.md`'s is not. For a 100-task project, `PLAN.md` alone could
be ~5x the size measured at task 20, and it is read in full, every session, forever — this is
the one item in the whole audit whose per-session cost has no ceiling as the project scales.

**Why it exists:** `PLAN.md` is deliberately "index only" (method.md STEP 4) specifically to
stay cheap — the design already tried to keep this small by excluding task detail (that lives
in the per-task card, read one at a time). The uncapped growth is a side effect of a correct
decision (one line per task, however many tasks exist), not a careless one.

**What is lost if cut:** `PLAN.md` is the only file that gives a session-spanning, at-a-glance
view of "what exists, what's done, what's next" across the whole project — `STATE.md`'s cap
forces it to summarize/drop old detail, so `PLAN.md`'s full per-task line is the only place a
long project's full history survives. Capping or truncating it risks losing exactly the
continuity `STATE.md`'s "if it's not in this file, it doesn't exist" rule was written to
protect.

---

## 2. Always-on component menu — paid every session regardless of what that session invokes
(item a)

**Where:** `claude plugin details my-method` — six skills + one agent description are added to
**every session's** context, ~457 tokens total (session 1, measured). Breakdown:
security-reviewer ~70, friction ~40, health-check ~70, next-task ~50, start-project ~60,
update-method ~110, where-am-i ~50.

**What it costs:** any given session almost always invokes exactly **one** of these six
commands (the method's own contract, WORKFLOW-TARGET.md section C: "I only ever type
`/start-project` once, then `/next-task` repeatedly"). So a typical `/next-task` session pays
~457 tok always-on, of which only the ~50 tok for `next-task` itself is used that session —
**the other ~407 tok (≈89% of the always-on budget) describe commands that session will not
run.** This is paid on literally every session, forever, for the life of every project using
the plugin — unlike the one-time `start-project.md` cost, this one compounds with session
count, not project size.

**Why it exists:** this is how Claude Code's plugin system routes slash commands — the harness
needs every command's name+description in context to know the command exists and decide when
to suggest/route to it. This is a platform mechanism, not a my-method design choice (NOT
independently re-verified against docs this session — carried from session 1's framing of the
plugin-details output as harness-level).

**What is lost if cut:** if a command's description were removed from a session's context, that
command could not be discovered or routed to in that session — the practical impact of the
current design is low per-session (a few hundred tokens) but it is the only item on this list
that both (a) recurs every session unconditionally and (b) is >85% unused in the typical case.

**Within this category, two more specific dead-weight blocks (NEW, second sub-agent):**
- `update-method.md` MODE 2 ("apply", lines 166–242, ~995 tok, **33% of the file's body**) —
  only runs after a MODE 1 research pass already produced an approved proposal, and MODE 1's own
  text defaults to "no" for candidates; the sub-agent's estimate is this fires well under half
  of the command's invocations. Paid every time `/update-method` is typed, not every session
  (the command is rare) — total impact small, but proportionally a third of this file is dead
  weight on the majority of its own invocations.
- `health-check.md` Probe 5 (lines 109–119, ~96–184 tok depending on how the surrounding branch
  is scoped, ~7–13% of the file) — only runs "if `kit/my-method/.claude-plugin/plugin.json`
  exists here," i.e. only inside this repo's own dev checkout, never in a real end-user project
  that merely has the plugin installed. Estimated real-use fraction: ~0% for the plugin's actual
  audience. **Why it exists:** this repo is simultaneously the product's source and its own
  first "project" — the probe exists to let the method's own maintainers self-check, a
  legitimate dual-role this repo plays that an ordinary consumer project doesn't share.

---

## 3. `start-project.md`'s four embedded texts fire together, unconditionally, regardless of
the project's actual needs (items b/c, session 1's numbers)

**What it costs:** ~13,036 tokens, once per project, of which ~10,278 tok (72% of lines / 79%
of chars) is literal copy-paste of `method.md`, `SECURITY-MATRIX.md`, five template blocks, and
a `verify.ps1` skeleton (session 1, section b). **Confirmed this session:** because a command's
markdown body is the entire prompt sent to the model the moment the command is typed, there is
no mechanism to load only part of it — every `/start-project` run pays for all four blocks
together, even a project that will never need most of `SECURITY-MATRIX.md`'s T1–T3 rows (a
purely offline, no-login, no-personal-data T0 project still gets the full T0–T3 matrix written
into its own `SECURITY-MATRIX.md`, per method.md STEP 4's "copy every in-scope row" — the
*in-scope* rows are a small subset of what's paid to embed and write).

**Why it exists:** two independent reasons, both legitimate. (1) The four blocks share one
command because `/start-project` performs the entire project bootstrap in one sitting — there
is no natural second invocation to split them across without changing the workflow contract.
(2) The full (not tier-filtered) matrix is written so that a later re-triage (method.md STEP
5c: "the matrix's own re-triage rule," when a task turns on a risk surface the plan didn't
declare) can pull additional rows without re-fetching or re-embedding anything — the T0 project
paying for T1–T3 rows today is the cost of not having to re-pay to fetch them if the project's
risk surface grows later.

**What is lost if cut:** trimming the matrix to only the triaged tier's rows would remove
exactly the rows STEP 5c's drift-detection depends on for any project that later grows past its
initial tier — a real, not hypothetical, mechanism this kit already relies on.

---

## 4. Hook: one process spawn per Bash/PowerShell call, ~99% of them unnecessary — and a
documented fix already exists unused (item d)

**What it costs:** ~296ms wall-clock per Bash/PowerShell call (session 1, measured), on every
such call in every project with the plugin enabled — the highest-**frequency** waste on this
list, though it is a latency cost, not a token cost (session 1 already established the allow
path surfaces 0 tokens to the model). The script's own internal checks (tool name, `git...
commit` regex, file existence, HEAD probe) already filter cheaply — but only **after** a full
`powershell.exe` process has already been spawned to run them.

**Why it exists, and what's new this session:** `hooks.json`'s `matcher: "Bash|PowerShell"`
fires the process for every matching tool call because, per live research today
(`code.claude.com/docs/en/hooks-guide`, accessed 2026-08-12), **`matcher` filters on tool name
only — it cannot see command content.** But the same docs, same date, document a **second,
narrower field, `if`, that filters on tool name *and arguments together*, specifically so "the
hook process only spawns when the tool call matches" — and give `"if": "Bash(git *)"` as a
worked example, i.e. almost exactly this hook's own use case. This capability is
**documented and already shipped**, not a feature request or an unconfirmed platform gap (unlike
the `${CLAUDE_PLUGIN_ROOT}`-in-command-markdown question from session 1, which remains
genuinely contested). The same research also confirmed, verified-absent: no in-process/no-spawn
hook type exists (only `command`, `http`, `mcp_tool`, `prompt`, `agent`), so the ~296ms itself
cannot be eliminated by a different hook *type* — only avoided for calls that don't need it.

**What is lost if cut (i.e., if `if` were adopted to skip the spawn for non-`git commit`
calls):** nothing detectable from this session's reading — the gate's own logic already treats
every non-`git commit` Bash/PowerShell call as an immediate allow, so a call that never reaches
the gate today would not have changed outcome. This is the one item on this list where the
research found a shipped, documented mechanism whose absence looks like an oversight rather
than a deliberate tradeoff — recorded here as a finding, not adopted (out of this session's
scope).

---

## 5. Rule stated three times: narration style (item e)

**Where all three copies live:**
- Global `CLAUDE.md` (`C:\Users\Jeferson\.claude\CLAUDE.md`): *"Never narrate mechanics ('now I
  will open the file'). That is noise."*
- Project `CLAUDE.md` template (`kit/my-method/templates/CLAUDE.md`, Narration rule section):
  near-identical wording and the same example.
- `next-task.md` (lines 64–65): *"never mechanics ('agora vou abrir o arquivo')"* — same
  example, translated to Portuguese.

**What it costs:** small in isolation (tens of tokens per copy) but the three copies are never
separated by anything that would justify a re-statement — global `CLAUDE.md` and the project
`CLAUDE.md` both load automatically at the start of the very same session in which
`next-task.md`'s body would also load, with no `/clear` between them. **Verdict: redundância
paga três vezes**, not reforço deliberado — per this session's own distinction rule (some
repetition exists to survive a session boundary the other copy can't survive), there is no
session boundary here for the third copy to survive.

**Contrast — a duplication that *is* deliberate reinforcement:** global `CLAUDE.md`'s scope
boundary ("Never read, write, or delete files outside the current project folder") reappears in
`update-method.md`'s Safety check (lines 16–22) not as a repeated sentence but translated into a
concrete, checkable gate ("this command only runs inside the my-method repository... must never
reach outside the current folder," backed by a 3-file existence check and a STOP instruction).
This is the abstract rule made actionable at the exact point of risk (a command that edits the
kit's own canonical files) — a different thing from restating the same sentence a third time,
and this session does not count it as the same kind of waste.

---

## 6. `security-reviewer` inputs — already close to the minimum needed; the dangerous item to
cut further (item c, the user's own caution)

**Where:** `kit/my-method/agents/security-reviewer.md`, invoked per method.md STEP 5c with
three inputs: the task's REVIEW rows verbatim, the list of touched files, and the raw diff.

**What it costs:** ~1,200–2,400 tok/invocation (session 1, ESTIMATIVA), doubled on a failed
first pass (a fresh invocation is structurally required — "a prior pass can't be reused").
Recurs once per task that carries REVIEW rows, so it scales with task count, not with project
size the way `PLAN.md` does.

**Checked this session against the agent's own procedure:** all three inputs are load-bearing,
not padding. REVIEW rows verbatim are what the reviewer is told to hunt violations of — trimming
them risks the reviewer judging against the wrong bar. The file list scopes which files it may
open with Read/Grep/Glob for "surrounding context (call sites, schema, config) as needed" — it
does not pre-load those files' contents; it reads them on demand only if needed, so this input
is already minimal, not a bulk pre-fetch. The raw diff is the object being judged — there is no
smaller representation of "what changed" that would let the reviewer do its job. **Nothing found
in this session's reading suggests the reviewer receives more than it needs.** Per this
session's own instruction: if cutting were proposed here, it should say exactly what detection
capability would be lost — this session's finding is that there is currently no slack to cut
without naming a real loss (e.g., trimming the diff would mean judging code the reviewer never
saw).

---

## Summary — ordered by estimated cost (highest first)

1. **`PLAN.md`/`STATE.md` per-task growth (item f)** — the only cost with no ceiling; compounds
   with project size, every session, forever. `STATE.md` is capped at 80 lines; `PLAN.md` is
   not.
2. **Always-on component menu, ~457 tok/session, ~89% unused in a typical single-command
   session** — compounds with session count across a project's whole life, not with project
   size.
3. **`start-project.md`'s full-tier `SECURITY-MATRIX.md` embed** (~5,548 of the ~13,036 tok
   one-time cost) — paid once per project, but the single largest content block in the kit; a
   deliberate cost for STEP 5c's re-triage, not an oversight.
4. **Hook process-spawn, ~296ms on ~99% of Bash/PowerShell calls that don't need the gate** —
   zero token cost, highest call-frequency of anything on this list, and the one item where a
   documented, shipped fix (`if` field) exists and is simply not used.
5. **`update-method.md` MODE 2 (33% of file, minority of invocations) and `health-check.md`
   Probe 5 (~0% relevant outside this repo's own dev checkout)** — small in absolute terms,
   rare commands.
6. **Triplicated narration rule** (global CLAUDE.md / project CLAUDE.md template /
   `next-task.md`) — smallest in tokens, but a clean case of redundancy with no session boundary
   to justify the third copy.
7. **`security-reviewer` inputs** — checked and found already near-minimal; flagged as the item
   this audit found the *least* room to cut, not the most.
