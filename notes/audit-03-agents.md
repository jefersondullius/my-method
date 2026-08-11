# Audit 03 — Agent architecture for Step 12 security: four-part proposal vs current design vs official guidance

Session 3 of 4 · 2026-08-10 · Analysis only — nothing was built or installed.

Evaluated: the user's four-part agent proposal for WORKFLOW-TARGET step 12's security
half, against `playbook/SECURITY-MATRIX.md`, `research/13-testing-strategy.md`,
`notes/audit-01-gaps.md` (step 12 + recommendations 1–2), `method.md` v4,
`kit/my-method/commands/start-project.md`, `kit/my-method/commands/next-task.md`,
`kit/my-method/templates/TASK-XXX.md`, `WORKFLOW-TARGET.md`. All read in full this
session. Anthropic/Claude Code facts in section (d) were researched LIVE by one
subagent (WebSearch + WebFetch, all URLs accessed 2026-08-10); its five-line summary
and per-claim citations are reproduced there. Repo facts cite file + section/line.

## The proposal under evaluation

- **P1** — a knowledge base of attack surfaces per development stage (database, API,
  frontend, …), each with: how it works, how to avoid it, which tests verify it,
  what a successful test must and must not show, and how to fix it.
- **P2** — an agent that looks at the task being executed and determines which
  surfaces that specific task can expose.
- **P3** — an agent that executes the tests for those surfaces and returns results.
- **P4** — an agent that takes only the negative results, analyzes and fixes them,
  and sends the work back for retest.

---

## a) What already exists

### P1 field by field vs SECURITY-MATRIX.md + research/13

| P1 field | Exists? | Where |
|---|---|---|
| Catalog of surfaces | **YES** | 10 risk surfaces (matrix §1–10). Indexed by *risk surface*, not development stage — the finer cut: `authorization` spans API+DB; "frontend" alone would blur `user-input` vs `secrets-and-config`. A stage-indexed KB would misfile the cross-cutting surfaces. |
| How it works | **YES** | research/13, per class: "What it is" in plain terms. |
| How to avoid | **PARTIAL** | research/13 "Introduced by" names the causing pattern (avoidance is its inverse); matrix rows state the required property. No explicit per-row avoidance recipe — implied, not written. |
| Which tests verify it | **YES** | Matrix column "How it is performed", with named tools and exact test designs (`semgrep --config p/owasp-top-ten`, `gitleaks git -s .`, `npm audit`/`pip-audit`, written tests with concrete assertions, e.g. rows 3.3, 4.2, 6.2). |
| What success must/must not show | **YES** | Matrix column "Pass criterion" per row (e.g. 3.3: both login failures byte-identical; 4.2: 403/404, *not the data*; REVIEW rows: "no open HIGH/CRITICAL finding"). |
| How to fix | **NO** | The only genuinely missing P1 field. Partially derivable from research/13 (parameterized queries, Argon2id/bcrypt, allowlist, hosted checkout), but no per-row remediation pointer exists. |

### P2 — exists as design, absent as wiring

The matrix already mandates exactly this determination — as a *planning* act, not an
agent: tier triage T0–T3 keyed to the Step 1 answers ("Triage the project first,
using the answers already collected in Step 1 of `method.md`", matrix
"PROPORTIONALITY"), per-tier surface scoping, and a re-triage rule ("Re-triage
whenever a feature is added that turns a surface on"). Audit-01 (step 12, finding 1)
established that none of it is wired: `start-project` never triages, cards never
receive applicable rows, `next-task` never mentions the matrix, and `method.md`
itself does not reference it. Audit-01 recommendation 1 already specifies the fix,
at planning time, starting with a method.md v4 revision. **P2 is that missing wiring
re-invented as a runtime agent** — the determination is not new work; it is the same
work placed at a more expensive moment (section c).

### P3 — half-specified already; the "one agent runs the tests" framing over-reaches

The matrix already assigns REVIEW rows to "an adversarial read of the diff by a
subagent with fresh context (no memory of writing the code), returning findings
with a severity and a `file:line`" (matrix, "HOW TO READ EACH ROW"). That subagent
is specified but unbuilt. P3's framing conflates three kinds the matrix deliberately
separates: AUTOMATED rows are commands whose raw output must land on the user's
screen (`next-task` (d) visibility doctrine — delegating `npm audit` to an agent
adds cost and hides output); HUMAN DECISION rows are Portuguese yes/no questions for
the user, not tests; only REVIEW rows are subagent work.

### P4 — does not exist, and contradicts the recorded design (section b)

### Verdict for (a)

The proposal is **not a new structure**. P1 is ~80% built (missing field: fix
direction). P2 is the wiring audit-01 already identified as missing, relocated to
runtime. P3 is the matrix's own REVIEW executor, already specified, plus an
over-extension into AUTOMATED/HUMAN territory. P4 is new — and rule-breaking. What
is *genuinely* missing from the repo today is what audit-01 said: the wiring, plus
the REVIEW subagent's actual definition, plus (new, from P1) a per-row fix pointer.

**Honesty note on the maxim.** The sentence "um revisor que pode consertar para de
reportar" appears verbatim nowhere in the repo (grepped this session). What the repo
records is the design it compresses: REVIEW = read of the diff by a fresh-context
subagent (matrix, "HOW TO READ EACH ROW") and the reasoning in research/13
"Self-review weakness" ("fresh context means the reviewer did not decide the
original approach and has no stake in it being right"). This audit adopts the maxim
as an accurate compression of that recorded design — and section (d) shows the
official tooling embodies the same rule.

---

## b) P4 — what a fixing reviewer costs, and the correct loop

### Five concrete losses when the same agent detects and fixes

1. **The findings list stops being the product.** A read-only reviewer's only output
   is findings; precision is its whole job. Give it write access and its implicit
   goal becomes "zero findings remain" — and the cheapest paths there are silent
   patching, severity downgrades, or not recording the finding at all. For a user
   who does not read code, the findings list is the *only* visibility; a fixer turns
   it into internal scratch state.
2. **HUMAN DECISION rows get auto-resolved.** Rows 1.4 (DB user privileges), 5.3
   (hosted checkout), 6.3 (upload storage location), 8.3 (dev/prod secrets) are
   business calls the matrix reserves for the user. A fixer "fixes" or marks
   resolved what it was never supposed to decide — the AUTOMATED/REVIEW/HUMAN
   DECISION classification collapses into "whatever the agent did".
3. **Self-review, second edition.** The retest inside the fixer's own context is
   exactly the failure research/13 documents: the same assumptions that produced the
   fix judge the fix. A fix that silences the symptom — catch the exception,
   special-case the test payload, weaken the assertion — passes its own retest.
4. **Check-weakening enters scope.** The cheapest "fix" for a failing check is
   editing the check. A read-only reviewer physically cannot; a fixer can, and the
   pilots already documented instruction slippage under end-of-task pressure
   (method.md notas 5c/5d) — pressure is highest exactly when a red check blocks
   "done".
5. **A second writer per task.** The card contract ("Files it touches") and the
   regression discipline assume one builder. A fix agent editing beyond the card
   widens blast radius, muddies git attribution, and doubles the surfaces where
   status drift can happen.

### The correct loop — existing roles only, no new agent

- **Who fixes: the builder** — the main `/next-task` session that built the task. A
  failed security row is a failed check in step (d): task NOT complete, no status
  update, no commit; the builder fixes within the card's scope. It already has the
  context, the write access, and the obligation.
- **Visibility for the user:** findings are shown RAW on screen (visibility
  doctrine) and recorded durably — on the task card, and in STATE.md "Things that
  broke once" when cross-task — **before any fix is attempted**, so the finding
  survives even if the session dies. HUMAN DECISION rows are asked verbatim, in
  Portuguese, and never auto-answered. The closing summary states: found → fixed →
  re-verified, with the re-run's raw output.
- **Retest without fixer-as-judge:** AUTOMATED rows re-run as commands — the judge
  is the exit code, which cannot be argued with. REVIEW rows are re-judged by a
  **fresh subagent invocation** on the updated diff: new context, no memory of
  writing the code *or* of the fix conversation. The builder never declares a REVIEW
  row passed; only a fresh reviewer's "no open HIGH/CRITICAL" does (the pass
  criterion already in the matrix).
- **Bound:** the existing stuck protocol, unchanged — two failed rounds of the same
  check → stop, write STATE.md, three options to the user.
- **Enforcement note:** "reviewer is read-only" need not be prose. A subagent
  defined with a read-only tool allowlist is *structurally* unable to edit —
  the method's own doctrine ("anything that must happen reliably every time — that
  is a hook, not a rule") applied to the reviewer, and exactly how the official
  code-reviewer example is defined (section d, claim 3).

---

## c) P2 vs P3 — determination belongs to planning, execution to one agent

**Cost.** Delegation cost is fixed per invocation: a subagent starts cold and
re-reads project context before producing anything. A runtime determiner charges
that cost on *every task, forever*, to re-derive what planning already knew: the
tier axes are literally Step 1's critical block (online? login? payments? third-
party personal data?), collected by `start-project` before any card exists; the
per-task surface mapping follows from the card's own "What concretely exists" and
"Files it touches" *at the moment they are written*. Plan-time determination costs
zero extra invocations — a table lookup plus lines on the card. Official guidance
prices the difference concretely: multi-agent systems cost 3–10x the tokens of a
single agent (section d, claim 5), a price to pay only where the role separation
buys something. For determination it buys nothing — there is no adversarial benefit
in *listing* applicable checks, only in judging them.

**Failure.** The runtime determiner is nondeterministic (same task, different day,
different surface list), leaves no durable record (the next session cannot audit
what was decided, violating the STATE doctrine "if information exists only in this
conversation, it does not exist"), and is skippable by the same L3 fragility
audit-01 documented everywhere else. Plan-time lines are versioned, visible to the
user on the card (L4 evidence), and cannot be forgotten at run time because
`next-task` (d) already mandates following the card's "How we will check it".

**The one real weakness of plan-time: drift.** Implementation can turn on a surface
the plan did not declare (card said frontend-only; the build added an endpoint, a
dependency, an upload path). The matrix already has the rule — "Re-triage whenever
a feature is added that turns a surface on" — it just needs one wired instruction in
`next-task` (d): *before verifying, compare the actual diff against the card's
declared surfaces; if a new surface turned on, pull its matrix rows now and say so.*
A sentence inside the existing verify step — not an agent.

**Verdict for (c):** determination is a planning output (audit-01 rec 1, unchanged),
with a one-line drift check at verify time. P2 and P3 collapse from two agents to
one: the REVIEW executor. Tasks whose applicable rows contain no REVIEW kind pay
zero delegation that round.

---

## d) What Anthropic recommends today (live research, one subagent)

Subagent's five-line summary (rendered in English; claims below are its verified
findings, all URLs accessed 2026-08-10):

> Anthropic's /security-review and GitHub Action report vulnerabilities only — they
> do not auto-fix, and the Action filters false positives. Verification subagents
> are defined read-only (tools: Read, Grep, Glob) and run in isolated context.
> Multi-agent systems cost 3–10x the tokens of a single agent. "Building Effective
> Agents" (Dec 2024) says prefer the simplest architecture, and the
> evaluator-optimizer pattern keeps generator and evaluator as separate roles in a
> loop; official best practices recommend writer/reviewer separation.

Claims, each with source:

1. The official security reviewer **reports and does not fix** — findings are
   surfaced (e.g. as PR comments), remediation is a separate step.
   https://github.com/anthropics/claude-code-security-review/blob/main/README.md — accessed 2026-08-10.
2. That Action includes **false-positive filtering** by design (excludes classes
   like DoS/rate-limiting noise) — same URL, accessed 2026-08-10. (The matrix's
   equivalent is severity gating: pass = "no open HIGH/CRITICAL"; row 10.1 logs
   moderate/low without blocking.)
3. The official **code-reviewer subagent example is read-only**:
   `tools=["Read", "Grep", "Glob"]` —
   https://code.claude.com/docs/en/agent-sdk/subagents.md — accessed 2026-08-10.
4. Official best practices recommend **separating writer from reviewer**, with
   fresh context improving the review —
   https://code.claude.com/docs/en/best-practices — accessed 2026-08-10.
5. **Multi-agent systems cost 3–10x the tokens** of a single agent —
   https://claude.com/blog/building-multi-agent-systems-when-and-how-to-use-them —
   accessed 2026-08-10. (The 4x/15x figures previously associated with the
   multi-agent research post: NOT VERIFIED this session.)
6. **"Prefer the simplest solution possible"**; add agentic complexity only when it
   demonstrably improves outcomes —
   https://www.anthropic.com/engineering/building-effective-agents — Dec 19, 2024.
7. The **evaluator-optimizer pattern**: a generator produces, a *separate* evaluator
   judges in a loop until pass —
   https://platform.claude.com/cookbook/patterns-agents-evaluator-optimizer —
   accessed 2026-08-10.

### Comparison

| Axis | Official guidance | Proposal (P1–P4) | Current repo design | Third design (e) |
|---|---|---|---|---|
| Reviewer fixes? | No — report only [1] | **P4: yes — violates** | No (matrix REVIEW is read-of-diff) | No; builder fixes |
| Reviewer tooling | Read-only allowlist [3] | Unspecified | Prose only ("read of the diff") | Read-only allowlist, structural |
| Writer/reviewer split | Yes, fresh context [4] | Split exists, then P4 merges judge+fixer at retest | Yes (specified, unbuilt) | Yes, fresh invocation per round |
| Generator/evaluator loop | Separate roles until pass [7] | P4 merges them | Absent (no loop wired) | Builder ⇄ fresh reviewer, capped by stuck protocol |
| Agent count | Simplest possible [6]; 3–10x cost [5] | 3 runtime roles per task | 0 (nothing runs) | 0–1 per verify round |

Official guidance disagrees with the proposal exactly where this audit does (P4;
P2-as-agent) and agrees with it where it matches the matrix (surface KB, separate
executor, loop-until-pass shape).

---

## e) Verdict

**Neither the proposal as stated, nor today's state.** Today's state has the right
knowledge base and the right principles wired to nothing — zero cost, zero
coverage: as of this session, *no security check runs by any mechanism*. The
proposal wires it with three runtime roles per task — the most expensive design on
the table — and P4 reintroduces the exact failure (self-judged fixes) the matrix's
fresh-context clause was written to prevent. The best design is a **variation of
the proposal folded into the method's existing skeleton** — concretely:

- **D1 — Knowledge base:** SECURITY-MATRIX.md as-is, plus the one P1 field it
  lacks: a one-line **"Fix direction"** per row (e.g. 1.1 "switch to parameterized
  queries/ORM"; 3.1 "hash with Argon2id/bcrypt via the auth library"). Cheapest
  added at wiring time, since the file is edited once then anyway.
- **D2 — Determination at planning** (audit-01 rec 1, unchanged): method.md v4
  first — Step 1 answers → tier recorded in STATE.md settled decisions; Step 4
  cards receive the applicable matrix rows inside "How we will check it"; Step 5c
  includes them in verification. Then mirrored into `start-project` (including the
  embedded method copy — the duplication trap friction.md documents) and
  `next-task`. Plus the drift line in `next-task` (d): diff turned on a new surface
  → pull its rows now, say so.
- **D3 — Execution split by kind, at verify time:** AUTOMATED rows run as commands
  in the main session, raw output on screen; REVIEW rows go to **one fresh,
  read-only reviewer subagent invocation per verify round** (all applicable REVIEW
  rows in that one invocation, not one agent per row), returning findings with
  severity + `file:line`, shown raw and recorded on the card; HUMAN DECISION rows
  are asked verbatim in Portuguese. The reviewer ships in the plugin as an agent
  definition with a read-only tool allowlist — the read-only rule enforced
  structurally, not by prose (d, claim 3).
- **D4 — Fix loop:** the builder fixes in-session, only after findings are
  displayed and recorded; retest = AUTOMATED re-run + a **new** fresh reviewer
  invocation on the updated diff. Reviewer never writes; builder never judges a
  REVIEW row. Two failed rounds of the same check → stuck protocol, unchanged.
- **D5 — Deterministic floor** (audit-01 rec 2, unchanged): the PreToolUse
  commit-gate hook is what makes D3/D4 unskippable. Without it, this whole loop is
  L3 prose — better-shaped prose, same enforcement ceiling audit-01 measured.

**Cost per task and failures prevented:**

| Design | Extra invocations per task | What it fails to prevent |
|---|---|---|
| Today (unwired) | 0 | Everything — no security check runs at all |
| Proposal P1–P4 | 3 (determine + test + fix) + 2/retest round | Self-judged fixes (P4); HUMAN DECISION bypass; unrecorded per-task determination; check-weakening |
| Third design | 0 when no REVIEW row applies; else 1 + 1 per fix round | Residual only: LLM-review blind spots (research/13), and L3 slippage until D5's hook exists |

**What survives from the proposal:** P1's framing (as the matrix, + the Fix
direction field — a real gap it caught); P3 exactly as the matrix's REVIEW executor,
now with a structural read-only definition; P4's *loop shape* (fix → retest) with
the roles corrected per the evaluator-optimizer pattern — builder generates, fresh
reviewer evaluates; P2 demoted from agent to plan-time wiring plus a drift check.
The proposal's real contribution is that it independently re-derived the need
audit-01 identified — evidence the gap is real — and added one field and one loop
worth keeping in corrected form.

---

## NOT VERIFIED (kept honest)

- The maxim "um revisor que pode consertar para de reportar" as a verbatim repo
  quote — it is not one; adopted as compression of matrix "HOW TO READ EACH ROW" +
  research/13 "Self-review weakness".
- The 4x / 15x token-multiplier figures from the multi-agent research system post —
  the subagent could not verify them; the verified current figure is 3–10x (d,
  claim 5).
- Whether `/security-review` (the built-in skill, distinct from the GitHub Action)
  can also *apply* fixes when explicitly asked — only "reports, does not auto-fix"
  was verified this session.
- Token cost of one reviewer invocation under this repo's real cards — not
  measured; the 3–10x figure is the general official estimate, not a local
  measurement.
- Whether a plugin-shipped agent definition's tool allowlist is enforced by the
  harness identically to the Agent SDK's `tools` field — the read-only example in
  (d) claim 3 is Agent SDK documentation; the plugin-agents equivalent was not
  separately verified this session.
