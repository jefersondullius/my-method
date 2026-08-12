# Audit 04 — cost plan (session 4 of 4, final)

Builds on [[my-method-audit-series-rules]] / `notes/audit-04-cost-measurements.md` (session 1),
`notes/audit-04-cost-waste.md` (session 2), `notes/audit-04-cost-guidance.md` (session 3), all
2026-08-12. This session builds nothing and changes nothing — it ranks what the first three
sessions found, states what each item costs to fix and what each fix loses, and answers the
three questions the user asked this session to settle. Every line item traces to a specific
finding in one of the three prior files; nothing new is asserted here without that trace.
Ordering rule, per the user's own instruction: **savings per unit of risk assumed, not raw
savings** — a free, zero-risk cut ranks above a bigger cut that weakens verification, security,
or STATE.md's memory of the project.

---

## FAZER AGORA — real savings, zero or negligible risk

### 1. Run the empirical `/context` test for the ~457-token "always-on" cost
**Traces to:** session 3, Target 2 (`notes/audit-04-cost-guidance.md` lines 237–284) — the
session's own "load-bearing finding," left unresolved on purpose.
**Saves:** unknown until run — potentially removes or radically downgrades the #2-ranked waste
item from session 2 (~457 tok/session, forever, every session, for the life of every project),
because all six commands already carry `disable-model-invocation: true`, and
`code.claude.com/docs/en/context-window.md` (accessed 2026-08-12) states a skill under that flag
"cost zero context until invoked." Whether that applies to *plugin* commands (not just
project-root skills) was never tested.
**Costs to implement:** one command (`/context`, before invoking any of the six commands),
near-zero.
**What is lost:** nothing — this is measurement, not a change to the kit.
**Why first:** it is the cheapest, highest-information action in this entire plan. Every other
item's ranking involving the always-on cost is provisional until this runs.

### 2. Add the `if` field to `hooks.json`, scoped to `git commit`
**Traces to:** session 2 item 4 and session 3 Target 1 (`notes/audit-04-cost-waste.md` lines
118–147; `notes/audit-04-cost-guidance.md` lines 193–234) — exact confirmed syntax:
`"if": "Bash(git commit*)"`, sibling field to `matcher`, documented at
`code.claude.com/docs/en/hooks`, accessed 2026-08-12.
**Saves:** ~296ms wall-clock (measured, session 1) per Bash/PowerShell call, on the ~99% of
calls that are not `git commit` and today still spawn `powershell.exe` to be told "allow."
**Costs to implement:** trivial — one JSON field, syntax already confirmed and worked-example
matched almost exactly to this hook's own use case.
**What is lost:** nothing detected — session 2 explicitly checked: the gate's own logic already
treats every non-`git commit` call as an immediate allow, so a call that never reaches the gate
today does not change outcome by skipping the spawn. **Caveat for whoever implements it:** this
is a latency saving, not a token saving — it does not reduce Pro-plan usage, only calendar time
per command. Worth doing because it is free and correct, not because it moves the needle on
daily task count (see Question 3 below).

### 3. Delete the third copy of the narration rule from `next-task.md`
**Traces to:** session 2 item 5 (`notes/audit-04-cost-waste.md` lines 151–177) — "redundância
paga três vezes," global `CLAUDE.md` and the project `CLAUDE.md` template both already carry the
same rule and both auto-load every session with no `/clear` between them and `next-task.md`'s own
load.
**Saves:** tens of tokens per `/next-task` invocation — small, but recurring every session,
forever, at zero cost to remove.
**Costs to implement:** trivial, delete ~2 lines.
**What is lost:** near-zero — two other copies already load automatically at the start of the
same session; this is the one duplication in the whole kit session 2 found with **no session
boundary to justify the repeat** (contrast: the same rule's scope-boundary sibling in
`update-method.md`'s Safety check is deliberate reinforcement made concrete at the point of risk,
and stays).

---

## FAZER SE O CUSTO INCOMODAR — real savings, but with a real loss attached

### 4. Cap or restructure `PLAN.md`'s per-task growth
**Traces to:** session 2 item 1, ranked #1 by that session (`notes/audit-04-cost-waste.md` lines
16–42) — the only cost item in the whole audit with **no ceiling**. `STATE.md` has a documented
80-line cap (`method.md`, FILES THAT CARRY STATE); `PLAN.md` does not.
**Saves:** ESTIMATIVA ~700–900 extra tokens of mandatory reading at task 20 vs. task 2 (session
1, section d), growing **linearly** with completed-task count, forever, every session — for a
100-task project, ESTIMATIVA ~5x the size measured at task 20. This is the one item that
compounds with **project size**, not just session count.
**Costs to implement:** real design work, not a one-line fix — needs a decision about where a
completed task's history goes if trimmed out of `PLAN.md`'s unconditional full-file read.
**What is lost:** `PLAN.md` is currently the only file that preserves a full, session-spanning
per-task history — `STATE.md`'s cap already forces it to summarize and drop old detail. A naive
truncation of `PLAN.md` risks losing exactly the continuity `STATE.md`'s own rule ("if it's not
in this file, it doesn't exist") was written to protect. **Not yet measured on a real project —
no pilot exists on disk (session 1, section d).** This belongs in the "measure first" bucket
below, not in an immediate fix.

### 5. Split `update-method.md` MODE 2 (apply) out of the always-loaded body
**Traces to:** session 2 item 2, secondary finding (`notes/audit-04-cost-waste.md` lines 73–79)
— MODE 2 is ~995 tok, 33% of the file's body, and the sub-agent's estimate is it fires on well
under half of the command's own invocations.
**Saves:** ~995 tok on invocations that never reach apply mode — but `/update-method` itself is
a rare, maintenance-only command (this repo has run it twice in its whole history per
`notes/maintenance/LAST-CHECK.md`), so the **absolute daily impact is small** regardless of the
per-invocation percentage.
**Costs to implement:** nontrivial — splitting MODE 1 (research) and MODE 2 (apply) into two
separate commands changes the maintenance workflow's UX and would need its own approval step,
plus session 3's platform finding that a command's whole body loads as one prompt the moment it
is typed (no partial-load mechanism exists) means this only saves anything if MODE 2 becomes a
genuinely separate command, not a conditional section of the same one.
**What is lost:** the current single-sitting shape ("research, then apply, same command,
same approved proposal") — splitting risks a MODE 1 proposal and its MODE 2 apply drifting across
a `/clear` boundary, the exact class of bug `method.md` STEP 5d was already hardened against
once, in a different command.

### 6. `health-check.md` Probe 5 — dev-checkout-only, but its body still loads every time
**Traces to:** session 2 item 2, secondary finding (`notes/audit-04-cost-waste.md` lines 80–86)
— ~96–184 tok, relevant only inside this repo's own dev checkout (checks for
`kit/my-method/.claude-plugin/plugin.json`), never in an end-user project — estimated ~0% real
use for the plugin's actual audience.
**Saves:** ~96–184 tok, only on `/health-check` invocations (also rare).
**Costs to implement:** effectively unfixable within confirmed platform limits today — a
command's whole body loads as one prompt regardless of which branch executes (same platform fact
as item 5); moving Probe 5 to a separate, conditionally-read file is untested and unconfirmed to
actually avoid the cost.
**What is lost if mishandled:** the self-check capability this repo's own maintainers rely on to
verify the kit's own dev checkout — small blast radius, but not zero.

---

## NÃO FAZER — the savings do not cover the loss

### 7. Trim `start-project.md`'s `SECURITY-MATRIX.md` embed to only the triaged tier's rows
**Traces to:** session 2 item 3 (`notes/audit-04-cost-waste.md` lines 90–115).
**Would save:** ~5,548 of the ~13,036 one-time tokens `start-project.md` costs per project — the
single largest content block in the whole kit.
**Why not:** session 2 checked this and found it **deliberate, not an oversight** — `method.md`
STEP 5c's re-triage rule (a task that turns on a risk surface the plan didn't declare pulls
additional matrix rows without re-fetching) depends on the full matrix already being embedded in
every project, at every tier, from the start. Cutting it to the initial tier's rows only would
remove exactly the rows that mechanism needs the moment a project's real risk surface grows past
its starting tier — a real, already-relied-upon behaviour, not a hypothetical one. Revisit only
if STEP 5c's own design changes.

### 8. Stop embedding `method.md` and `SECURITY-MATRIX.md` literally; read them live instead
**Traces to:** session 1, section b (`notes/audit-04-cost-measurements.md` lines 145–212).
**Would save:** ~8,826 of the one-time `start-project.md` tokens, in theory.
**Why not:** confirmed **currently forced**, not a careless choice — the only mechanism that
could even name the files' path at runtime (`${CLAUDE_PLUGIN_ROOT}` substitution inside a
command's own markdown prompt text) is documented-but-contested specifically for
`disable-model-invocation: true` commands (GitHub issue #9354, open since 2025-10-11 — exactly
this kit's own flag, on all six commands), never empirically settled for this kit's shape. And
even if it worked, a Read-then-Write pass still pays the same token cost — only an untested,
unconfirmed shell-level copy would actually avoid it. Do not attempt until that mechanism is
empirically tested for this kit (session 1 already names the exact one-shot test that would
settle it, in the same spirit as the 2026-08-11 T4 test).

### 9. Trim `security-reviewer`'s three inputs (REVIEW rows, file list, raw diff)
**Traces to:** session 2 item 6 (`notes/audit-04-cost-waste.md` lines 180–203); session 3 topic
c confirms no official numeric threshold exists to check against either
(`notes/audit-04-cost-guidance.md` lines 59–86).
**Would save:** a share of ~1,200–2,400 tok/invocation (ESTIMATIVA), doubled on a failed first
pass.
**Why not:** all three inputs are load-bearing, checked explicitly by session 2 against the
agent's own procedure. REVIEW rows verbatim are the bar the reviewer judges against; the file
list only scopes what it *may* read on demand, it does not pre-load content; the raw diff is the
object being judged and has no smaller faithful representation. This is the item the whole audit
found the **least** room to cut, not the most — nothing here is padding.

---

## Not part of this cost ranking: the `templates/` divergence

Session 1 elevated `kit/my-method/templates/CLAUDE.md` and `templates/STATE.md` diverging from
the copies `start-project.md` actually writes (10 and 14 line-level divergences respectively,
per `notes/maintenance/LAST-CHECK.md`, "FOUND WHILE APPLYING") to a first-order,
correction-blindness risk: a fix applied to the unread `templates/` copy never reaches a real
project. This is a **correctness/verification risk, not a cost item** — reconciling it does not
save tokens (it may cost a few, to add cross-references `templates/` currently lacks), so it does
not fit this session's own required "economia" measurement and is intentionally excluded from
the three ranked buckets above. It is flagged here so it is not lost, and because the user's own
instruction for this audit is to downgrade any savings that weakens verification — the inverse
also holds: a correctness fix with no token savings still deserves a session of its own, just not
this one.

---

## Question 1 — what does a typical task cost today, small project vs. T2?

**Cannot be answered as a real total — no pilot project exists on disk to measure end-to-end**
(session 1, section d, confirmed by grep/glob/git-log sweep: "the only hits anywhere, past or
present, are the template files themselves"). What can be stated is the **mandatory-overhead
floor** before any actual build/reasoning tokens are spent — everything below is cited from
session 1, ESTIMATIVA where marked:

**Small project, `/next-task` to commit:**
- `next-task.md` body, typed once: ~1,833 tok (measured, session 1 section b).
- Mandatory unconditional reading: `STATE.md` + `PLAN.md` + one task card, baseline
  ESTIMATIVA in the low thousands, growing ~700–900 tok by task 20 (session 1 section d,
  ESTIMATIVA).
- Always-on component menu: ~457 tok — **contested**, pending item 1 above (session 3 Target 2).
- Actual build + narration + reasoning tokens for the task itself: **unmeasured, no basis to
  estimate** — depends entirely on the task's own size and is exactly the part the method's own
  "one task, one session" rule tries to bound, not something this audit can put a number on.
- `scripts/verify.ps1` raw output on screen: size unmeasured (session 1, section c, only its
  file-skeleton size was measured, ~346 tok — its actual run output was never captured, since no
  pilot task exists to run it against).

**T2 project, same task plus security lines and reviewer:**
- Adds `security-reviewer` invocation: ~1,200–2,400 tok/invocation (session 1 section f,
  ESTIMATIVA), doubled if the first pass fails (session 1: "a task that fails review once pays
  this cost twice").
- May add a `SECURITY-MATRIX.md` re-triage read (~5,419 tok, session 1 section c) if the diff
  turns on an undeclared risk surface — conditional, not guaranteed every task.
- Adds AUTOMATED security-row raw output (gitleaks/semgrep/pip-audit stdout) — size **never
  measured**; T1 (`notes/maintenance/LAST-CHECK.md`, 2026-08-12) only confirmed `gitleaks git .`
  runs clean and prints a few lines on this repo's own history, not on a real project's diff.

**What the first real T2 project would measure, to close this gap:** actual build+narration
token count for one real task; actual `scripts/verify.ps1` raw output size; actual
`security-reviewer` invocation size against a real diff (not the agent's fixed-overhead estimate
alone); actual AUTOMATED-row stdout size (semgrep/gitleaks/pip-audit against real project code,
not this repo); and `PLAN.md`/`STATE.md`'s real per-task growth rate past task 2, since every
number above task 2 is currently inferred from template structure, not observed.

## Question 2 — does per-task cost grow with project size, and does this plan fix that?

**Yes, for exactly one item: `PLAN.md`'s unconditional full-file read, item 4 above.** It grows
linearly with completed-task count and has **no cap**, unlike `STATE.md`'s documented 80-line
cap (session 2 item 1). Every other item in this plan is either a **one-time** cost paid once per
project regardless of its eventual size (`start-project.md`'s embeds, items 7–8) or a **flat,
per-session** cost that does not compound with project size (the always-on menu, item 1; the
narration triplication, item 3; the hook spawn, item 2 — all recur per session or per call, not
per completed task).

**This plan does not fix the growth — it only flags it.** Item 4 sits in "FAZER SE O CUSTO
INCOMODAR," not "FAZER AGORA," precisely because no fix is proposed here: the real design
question (where does completed-task history live if not in full in `PLAN.md`) is unresolved, and
per this session's own instruction, an economia that would weaken `STATE.md`'s "if it's not in
this file, it doesn't exist" continuity guarantee must be downgraded, not adopted casually. A
cost that grows without bound matters more than a cost that is high but fixed — this is the one
item in the whole audit that fits that description, and it remains open.

## Question 3 — what happens, concretely, if none of this plan is done?

**Approximately nothing, today — measured against actual daily task count.** The reason is
structural, not that the findings are wrong: **no real project has run through this kit yet**
(session 1, section d). Every item large enough to matter is either:
- **one-time**, paid once per project regardless (`start-project.md`'s ~13k tokens, items 7–8) —
  it does not recur per task, so it does not cost "N fewer tasks per day";
- **contested and possibly not a real cost at all** (the ~457 tok always-on menu, item 1) — until
  the `/context` test runs, its true size is unknown, so its true daily impact is unknown;
- **latency, not token budget** (the hook spawn, item 2) — ~296ms per Bash/PowerShell call does
  not consume Pro-plan usage limits, it only adds calendar time; it would need to recur
  thousands of times in a session to add up to a visibly slower day, and even then it costs
  wall-clock, not the token/message budget that actually caps daily throughput on a Pro plan;
- **not yet felt** (`PLAN.md` growth, item 4) — its cost is real but currently small (task 2–20
  range); it does not become a visible daily-task-count problem until a project runs long enough
  for the linear growth to matter, and no project has reached that point.

**The honest answer: doing nothing today costs close to zero measurable tasks per day, because
almost every number in this plan is either one-time, unconfirmed, latency-only, or not yet
triggered by a real project's scale.** The actual risk of doing nothing is not today's
productivity — it is that the one unbounded item (`PLAN.md`) keeps growing silently and is not
noticed until a real, long-running project is deep enough into its task list (session 2's own
estimate: ESTIMATIVA ~5x the task-20 overhead by task 100) that it becomes a visible tax on every
single session for the rest of that project's life, at which point fixing it also becomes harder
because more history has to be reconciled into whatever the new design turns out to be.

---

## What can be decided now vs. what only a real T2 project reveals

**Decidable now, from the measured/ESTIMATIVA numbers already in hand:** all nine ranked items
above — their savings, fix cost, and loss are already established by sessions 1–3's own
reading of the kit's source files, not by running a project.

**Only a first real T2 project would reveal:**
1. Whether the always-on ~457 tok is real for plugin commands (item 1) — testable *without* a
   real project, via `/context`, but has never been run.
2. Actual build+narration+reasoning token count for one real task (Question 1) — cannot be
   inferred from source alone.
3. Actual `security-reviewer` invocation size against a real diff, vs. the agent's fixed-overhead
   estimate (Question 1) — session 1's ~1,200–2,400 tok figure is order-of-magnitude reasoning
   over sample REVIEW rows, not a real invocation.
4. Actual AUTOMATED security-row stdout size (gitleaks/semgrep/pip-audit against real project
   code) — T1 only ran gitleaks against this repo's own history, not a T2 project's diff.
5. `PLAN.md`/`STATE.md`'s real per-task growth rate past task 2 (Questions 1–2) — every number
   above task 2 anywhere in this whole audit is ESTIMATIVA, inferred from template structure.

**Do not optimize any of these five before measuring them** — this plan already declines to (item
4 is explicitly parked pending measurement, and items 7–9 are declined specifically because their
real cost or real necessity is already known well enough to say the cut isn't worth it, which is
a different situation from these five, where the cost itself is simply unknown).
