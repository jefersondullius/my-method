# PROPOSAL — method.md changes from logtech's real-project friction

Status: **proposed, nothing applied.** Written 2026-08-13, reading
`method.md` (v8) and `friction-logtech.md` (copied verbatim from the
logtech project's own `friction.md`, all entries dated 2026-08-12). This
is the first proposal in this repo sourced from a real project's
friction rather than from comparison or scheduled maintenance.

Two items below (1 and 4) trace to a different source: not
`friction-logtech.md`, but this repo's own `friction.md`, `MINE`,
2026-08-13 — real friction confirmed live by the user in this same
session, after asking what the two concepts meant. Provenance kept
separate on purpose, matching this repo's existing discipline of never
blending friction sources (see `friction.md`'s own history of
distinguishing pilot friction from conscious exceptions from external
change).

Nothing below has been applied. Each item states the exact change, the
literal friction entry that justifies it, what it costs, what is lost,
and how to undo it. Items are numbered in the order they appear in
`method.md`, not in the order they were analyzed.

---

## PARTE 1 — Análise por causa raiz

`friction-logtech.md` has 6 dated entries, all 2026-08-12: 2 in `YOURS`,
4 in `MINE`.

**A. Cost blindness in the stack decision (STEP 3) — MINE, 1 entry**
Right as STEP 3 began, the user objected that "decide the stack
yourself... with plain-language reasoning and what the runner-up would
have cost" was read and executed without pricing the decision in money
(hosting/DB/auth free-tier limits) or in Pro-plan sessions (a heavier
stack burns more sessions for the same result). **STEP 3's existing
"cost" clause did not hold the ceiling here — it was empty ceremony.**
The step already used the word "cost," so it looked satisfied, but the
word was never pinned to money or sessions, so an LLM executing it in
good faith produced exactly the gap the user is complaining about. This
is a wording gap, not a missing step.

**B. No step searches for a stack skill after STEP 3 — MINE, 2 entries
(reinforcing each other) + YOURS, 1 entry (unblocks it)**
After the stack (Supabase) was picked, no step asked "does an official
skill exist for this, and is it worth adding?" — flagged once when the
plan and first commit were already done, and flagged again one message
later by the user noting that "remembering" isn't a strategy, this needs
to be a step. The `YOURS` entry from the same day resolves the
prerequisite this friction itself named as blocking: whether
project-scoped skill install exists (so adding a Supabase skill doesn't
tax every future non-Supabase project). It does — confirmed against
`code.claude.com/docs/en/skills` and `code.claude.com/docs/en/discover-plugins`
(both accessed 2026-08-12). **This is a flat gap, not ceremony — there
is nothing between STEP 3 and STEP 4 for this to fail at.**

**C. Commit gate scope undocumented — YOURS, 1 entry**
A config-only commit (skill install, no `TASK-XXX` in progress) was
blocked by the commit gate. `method.md` STEP 5d describes the gate
inside the per-task loop, naming it as denying "a task commit" missing
evidence. Reading `kit/my-method/hooks/verify-gate.ps1` directly (this
session) confirms the hook denies **any** `git commit` past the
project's first one whenever `.claude/last-verify.json` is missing,
stale, or failing — the "must stage all three status files together"
rule is the *only* part that is task-commit-specific (triggered by
`STATE.md`/`PLAN.md`/a task card being staged). **The gate itself held
the ceiling correctly** (it did exactly what a "no commit without fresh
verification" gate should do, including for tooling commits). **The
method.md text describing it is what failed** — narrower than the
mechanism it describes, so a reader has no way to predict the block
before hitting it.

**D. Functional-first, visual-later task separation — MINE, 1 entry**
Noted once, after TASK-004 shipped functional-but-unstyled screens with
no warning the visual pass was deferred. The user explicitly did not
ask for a method.md change yet: *"Ainda não sei se isso deveria ser
regra fixa ou só uma prática recomendada — quero ver como o restante do
logtech se comporta antes de propor a mudança."* Reported here for
visibility; **not turned into a recommendation**, per the user's own
stated preference to wait for more signal.

**E. Legal/regulatory constraints named but never asked — this repo's
`friction.md`, `MINE`, 2026-08-13**
Two items the request asked for special attention on had no backing
entry in `friction-logtech.md` when first checked: a missing question
about legal restrictions in STEP 1, and a missing step for reopening the
SPEC mid-project. Checked directly: `STEP 1` names "legal exposure" as
one of five classes that must always be asked alone whenever it comes
up, but only four of those five (offline/online, login, payment,
personal data) are actually given a concrete opening question — "legal
exposure" is protected if it comes up, but nothing in STEP 1 makes it
come up. Confirmed as real friction by the user this session, after
asking what the gap would concretely mean — recorded in this repo's own
`friction.md`, not `friction-logtech.md`, since it is friction about the
method itself, not about the logtech project. See Item 1.

**F. No mechanism for the SPEC to reopen mid-project — this repo's
`friction.md`, `MINE`, 2026-08-13**
Same session, same confirmation. `method.md` STEP 5c already has a named
mechanism for a task discovering an *undeclared risk surface*
mid-build ("Drift first," pulling new `SECURITY-MATRIX.md` rows into the
card). There is no equivalent for a task discovering that `SPEC.md`
itself is wrong or incomplete — only *behavior*, not security. The
`Approved: <date>` append-only re-approval marker exists (added by the
rec4 patch bundle) but only in the embedded copy inside
`commands/start-project.md` — it describes how to record a re-approval,
not when a task should trigger one. See Item 4.

---

## PARTE 2 — Custo

`friction-logtech.md` records no explicit "scope change" event, so this
answers the closest measurable proxy: session boundaries visible in the
log (each preceded by an instructed `/clear`, per STEP 5d) from SPEC
confirmation through the entry after TASK-004.

Visible session boundaries, in order: (1) SPEC confirmed → STEP 3 begins
→ cost friction logged; (2) first commit made (scaffolding: `method.md`,
`SECURITY-MATRIX.md`, `SPEC.md`, `STATE.md`, `CLAUDE.md`, `PLAN.md`, task
cards, `verify.ps1`) → skill-search friction logged twice in the same
breath → `/clear` instructed; (3) a later session resolves the
project-scope NOT VERIFIED question from `audit-02-skills.md`; (4) a
later session installs the stack skills, hits the commit-gate block,
works around it by running `verify.ps1` first; (5) TASK-004 built,
verified, committed → visual/functional friction logged.

That is at least 4 sessions of visible effort before/around a single
feature task (TASK-004) landing, and of the 6 total friction entries, 4
are about process/tooling (cost wording, skill search ×2, commit gate)
against 1 about an actual product concern (visual polish) and 1 that
retroactively answers an open audit question. Effort in the visible
window skews toward fixing and re-registering method-level friction, not
toward building beyond TASK-004 — consistent with A and B above being
real, repeated costs rather than one-off complaints.

---

## Item 1 — STEP 1: give "legal exposure" its own opening question

**Traces to:** this repo's `friction.md`, `MINE`, 2026-08-13 (verbatim):
*"sim, trate as duas como friction real."* — confirming, after the
assistant explained the gap, that STEP 1 names "legal exposure" as a
protected class but never gives it a concrete opening question the way
it does for the other four (offline/online, login, payment, personal
data).

**File:** `method.md`, STEP 1

**Current:**
```
Open with the critical block, ONE question at a time, one message
each: does it run offline/local or online/hosted; does it need login;
does it involve payment; does it store other people's personal data.
Any question in these classes — money, other people's data,
access/login, hosting, legal exposure — is always asked alone,
whenever it comes up, even late in the interview.
```

**Proposed:**
```
Open with the critical block, ONE question at a time, one message
each: does it run offline/local or online/hosted; does it need login;
does it involve payment; does it store other people's personal data;
does it operate under legal or regulatory constraints tied to its
domain (e.g. labor law for a workforce-management tool, health-data
rules, financial regulation). Any question in these classes — money,
other people's data, access/login, hosting, legal exposure — is always
asked alone, whenever it comes up, even late in the interview.
```

**Saves:** closes the gap between naming "legal exposure" as protected
and actually surfacing it — today a domain with real regulatory
constraints (e.g. logtech's own employee-management scope, which touches
labor law) can go through the whole interview without the topic ever
coming up to be protected.

**Costs to implement:** one clause added to the opening list, matching
the four that already exist.

**What is lost:** nothing — the class was already named as protected;
this only gives it the same concrete question the other four classes
have.

**Rollback:** revert the clause. Single-sentence change.

---

## Item 2 — STEP 3: pin "cost" to money and Pro-plan sessions

**Traces to:** `friction-logtech.md`, `MINE`, 2026-08-12, first entry
(verbatim): *"isso deveria ser parte da justificativa da stack em todo
projeto, não algo que eu preciso lembrar de pedir."*

**File:** `method.md`, STEP 3

**Current:**
```
Decide the stack yourself. Present the decision already made, in
Portuguese, with plain-language reasoning and what the runner-up would
have cost. Do not ask the user to choose between things they cannot
evaluate. Write it into `STATE.md` with the reason, not just the name.
```

**Proposed:**
```
Decide the stack yourself. Present the decision already made, in
Portuguese, with plain-language reasoning and what the runner-up would
have cost — cost stated on two axes: money (hosting, database, auth —
what starts charging once the free tier ends) and sessions (a stack
that needs more code and more configuration spends more of the user's
Pro-plan sessions for the same result). Do not ask the user to choose
between things they cannot evaluate. Write it into `STATE.md` with the
reason, not just the name.
```

**Saves:** removes the specific gap the user hit — a stack decision the
user cannot veto on the two axes that matter to them (real money, real
session budget) without remembering to ask every time.

**Costs to implement:** one clause added to an existing sentence.

**What is lost:** nothing — STEP 3 already required "what the runner-up
would have cost"; this only says which currencies count.

**Rollback:** revert the clause. Single-sentence change.

---

## Item 3 — new STEP 3b: search for a stack skill before planning

**Traces to:** `friction-logtech.md`, `MINE`, 2026-08-12, second and
third entries (verbatim, second): *"o momento certo dessa busca seria
logo após o passo 3 (stack decidida), antes do passo 4 (plano) —
porque se uma skill for adotada, ela pode mudar como as tarefas são
construídas e verificadas"*; third entry: *"'lembrar' não basta;
reforça que isso precisa ser um passo do method.md, não hábito meu."*
Unblocked by `friction-logtech.md`, `YOURS`, 2026-08-12, first entry,
which resolves the scope question this same friction had flagged as a
precondition.

**Modified on approval (2026-08-13):** the user asked the search also
use the `find-skills` mechanism, and cover community skills, not only
official ones. `find-skills` is a third-party skill from
`vercel-labs/skills` (npx-based, `npx skills find <query>`) — **not**
Claude Code's own marketplace, researched and verified live in
`notes/research-skills/find-skills.md` (2026-08-10). Its search reaches
the open community-skills ecosystem that Claude Code's own `/plugin`
Discover tab does not.

**File:** `method.md`, new section between STEP 3 and STEP 4

**Proposed (new STEP 3b):**
```
## STEP 3b — SKILLS FOR THE STACK

After the stack is decided, search for a skill for it in two passes:
first the official/first-party one (the vendor's own documented skill,
or Claude Code's own marketplace via `/plugin`), then the wider
community ecosystem via the `find-skills` mechanism (`npx skills find
<stack-name>`, from `vercel-labs/skills` — a third-party registry,
separate from Claude Code's own marketplace). Community results are
optional, judged on usefulness, not preferred by default — official
still wins when both exist. Tell the user what was found, in
Portuguese, and whether any of it is worth adding to this project. If
yes, install it at project scope (`.claude/skills/` for a loose skill;
`--scope project` for a plugin) — never user scope, which would load
stack-specific context into every future project regardless of stack.
Record the decision (skill name, source, scope, reason) in `STATE.md`.
This runs once, right after STEP 3, before STEP 4 — the plan's task
cards should already know whether a skill's conventions shape how they
get built and verified, the same way they already know the security
tier.
```

**Saves:** removes a gap the user hit twice in the same project, the
second time despite already knowing the "correct" moment — their own
words, this needs to be structural, not remembered. The two-pass search
also catches a case official-only search would miss: a stack with no
first-party skill but a useful community one.

**Costs to implement:** one new section, two searches per project
(bounded — official pass, then `find-skills` pass, one yes/no to the
user per candidate worth surfacing).

**What is lost:** nothing existing changes; STEP 4 gains an input it did
not have (whether a skill applies) the same way it already gains the
security tier from `SECURITY-MATRIX.md`. Worth flagging, not blocking:
`find-skills` is a third-party CLI dependency (`npx`, network access to
`skills.sh`/npm at run time) — a different trust surface than Claude
Code's own marketplace; the step still requires the user's yes/no before
anything from either pass is installed, same gate as before.

**Rollback:** delete the new section.

---

## Item 4 — STEP 5c: a behavior-drift trigger to reopen SPEC.md

**Traces to:** this repo's `friction.md`, `MINE`, 2026-08-13 (verbatim):
*"sim, trate as duas como friction real."* — confirming the gap: STEP 5c
already reopens `SECURITY-MATRIX.md` rows when a task turns on an
undeclared risk surface ("Drift first"), but nothing plays the same role
for `SPEC.md` when a task reveals the spec itself is wrong or
incomplete. The `Approved: <date>` re-approval marker already exists
(embedded in `commands/start-project.md`, from the rec4 patch bundle)
but only describes how to record a re-approval — not when a task should
trigger one.

**File:** `method.md`, STEP 5c, immediately before "The card's security
rows run inside this step, by kind:"

**Proposed (new bullet, own paragraph):**
```
   Behavior drift: if building or verifying the task reveals that
   `SPEC.md` itself is wrong or incomplete for what the product
   actually needs — not a security surface, a behavior the SPEC never
   described — stop before continuing the task. Summarize the change
   to the user in Portuguese and wait for confirmation, the same gate
   as STEP 2. On confirmation, append a new `Approved: <YYYY-MM-DD>`
   line to `SPEC.md` — never edit or remove an earlier one — and
   update STATE.md's settled decisions before resuming the task.
```

**Saves:** gives task work a defined move when the spec turns out wrong,
instead of silently building past it or silently patching `SPEC.md`
without the same confirmation gate STEP 2 already requires.

**Costs to implement:** one new paragraph, mirroring the shape of the
existing "Drift first" security bullet.

**What is lost:** nothing — this adds a stopping condition, it does not
remove or loosen any existing check.

**Rollback:** delete the new paragraph.

**Note:** `method.md`'s canonical STEP 2 does not itself mention the
`Approved:` marker convention today — only the embedded copy in
`commands/start-project.md` does. This proposal does not fix that
duplication (out of scope, already flagged in this repo's own
`friction.md`, 2026-08-10 entry on embedded copies); it only makes STEP
5c point at the convention that already exists.

---

## Item 5 — STEP 5d: document the commit gate's real scope

**Traces to:** `friction-logtech.md`, `YOURS`, 2026-08-12, second entry
(verbatim): *"o hook, na prática, aplica a mesma exigência a QUALQUER
commit no projeto, não só a commits de tarefa."* Confirmed this session
by reading `kit/my-method/hooks/verify-gate.ps1` lines 30–44: past the
project's first commit, every `git commit` is denied without a fresh,
matching-HEAD, PASS `.claude/last-verify.json` — the "stage all three
status files together" rule is the only part scoped to task commits
(triggered when `STATE.md`/`PLAN.md`/a task card is staged).

**File:** `method.md`, STEP 5, item d

**Current:**
```
   The staged set must include `.claude/last-verify.json` together
   with the three status files — the commit gate denies a task commit
   missing any of them, and denies any commit without fresh PASS
   evidence.
```

**Proposed:**
```
   The staged set must include `.claude/last-verify.json` together
   with the three status files — the commit gate denies a task commit
   missing any of them.
   This gate is not scoped to task commits: after the project's first
   commit, it denies ANY `git commit` in this repo — including
   config-only or tooling commits made with no `TASK-XXX` in progress —
   unless `.claude/last-verify.json` shows a fresh PASS. Before a commit
   like that, run the verify entrypoint (`scripts/verify.ps1`) even when
   nothing new needs checking; it re-runs the existing regression set
   and refreshes the evidence file.
```

This is the doc-fix direction: the hook already behaves correctly (a
commit with no fresh verification is exactly what the gate exists to
block, tooling commit or not); the text was narrower than the mechanism.
The alternative — changing `verify-gate.ps1` to detect "no task in
progress" and skip the check — is not proposed: it would weaken the "no
commit without fresh evidence" guarantee for the sake of a narrower
case, and the workaround already used in logtech (`run verify.ps1
first`) costs nothing extra once documented.

**Saves:** the next out-of-task commit anywhere in this kit's projects
does not surprise the user; the workaround they already found by hand
becomes the documented path.

**Costs to implement:** one sentence split, one clause added.

**What is lost:** nothing — this changes no behavior, only what the text
promises.

**Rollback:** revert to the current wording.

---

## Not proposed

- **Functional vs. visual task separation** (`friction-logtech.md`,
  `MINE`, 2026-08-12, fourth entry) — real friction, but the user
  explicitly asked to wait for more signal from the rest of logtech
  before turning it into a method.md rule. Left as an open watch item,
  not a recommendation.

---

## Approval

Each item is independent and separately vetoable. On approval, apply in
this order: item 1 (STEP 1), item 2 (STEP 3), item 3 (new STEP 3b),
item 4 (STEP 5c), item 5 (STEP 5d) — this is also their order of
appearance in `method.md`. After applying, bump `method.md`'s own
version note per this repo's convention for a method change. Two
provenance classes land in the same version bump for the first time:
items 2, 3 and 5 trace to `friction-logtech.md` (a real project, the
first proposal of this kind in this repo); items 1 and 4 trace to this
repo's own `friction.md` (friction about the method itself, confirmed
live in this session). The version note should name both sources, not
collapse them into one.
