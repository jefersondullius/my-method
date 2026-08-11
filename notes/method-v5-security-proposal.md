# PROPOSAL — method.md v5, security wiring (audit-03 third design)

Status: **proposed, awaiting the user's approval of this text. Nothing applied.**
Design approval: granted in session 3, 2026-08-10 ("Aprovo o terceiro desenho") —
this document is the text-level proposal that decision asked for; application
happens only after the user approves the text below.

Provenance: audit-01 step-12 finding 1 + recommendation 1 (SECURITY-MATRIX wired to
nothing) and the audit-03 verdict (`notes/audit-03-agents.md`, section e, D1–D5),
approved by the user. NOT born from pilot friction — this is the **second conscious
exception** to the friction-only rule (the first was v4/Step 1); provenance entry
added to `friction.md` (YOURS) in this proposal's commit, mirroring the v4 pattern.

Scope: **D1–D4** — matrix gains a Fix direction per row; tier triage + row
assignment at planning; execution by kind at verify time with a read-only reviewer
subagent; builder-fixes / fresh-reviewer-re-judges loop — plus mirrors and one new
plugin agent. Explicitly **OUT of scope**:

- **D5**, the PreToolUse commit-gate hook (audit-01 rec 2). It is what makes D3/D4
  unskippable; without it this wiring is L3 prose + L4 evidence. Separate proposal,
  separate approval — bundling it here would hide its cost.
- **WORKFLOW-TARGET.md**: no amendment needed. Step 12 of the contract already
  requires "the security checks the task's risk surfaces require per
  playbook/SECURITY-MATRIX.md" — this proposal implements that step as written; it
  does not change the contract.

---

## Design decisions made in this proposal

Each can be vetoed independently; the reason is stated so the veto is informed.

1. **Triage moment: method STEP 4 (planning), after the SPEC is approved** — not
   "after Step 1" as audit-01 rec 1 sketched. Reason: the T3 axis (file uploads)
   and the surface toggles ("stores anything?", "calls an external API?") are only
   fully visible in the approved SPEC's feature list; Step 1's critical block gives
   the T0–T2 axes but not all of T3. Triage still happens before any card is
   written, so rows flow into cards at birth.
2. **Every new project receives its own copy of the matrix** (`SECURITY-MATRIX.md`
   in the project root, written by `start-project` Step 0). Reason: the Boundaries
   rule forbids a project session from reading this repo's copy, and the drift
   rule needs the FULL matrix available in-project (a surface turned on mid-project
   must have its rows pullable there). Cost, stated plainly: `start-project.md`
   gains a third embedded copy (method text + matrix text + templates) — the
   duplication trap friction.md documents grows; the friction entry is updated.
3. **Fix direction is a fifth column** on every matrix table (D1). One line per
   row. It serves the fix loop (D4): the builder fixes toward a named direction
   instead of improvising, and the reviewer cites it in findings.
4. **The reviewer receives the diff in its prompt** (plus the card's REVIEW rows
   and the touched-file list) and has tools `Read, Grep, Glob` only — same
   read-only allowlist as the official code-reviewer example (audit-03 (d) claim
   3). No Bash: it cannot run commands, so AUTOMATED rows stay the main session's
   job by construction, and "read-only" is structural, not prose.
5. **AUTOMATED security rows join the regression set** (cheap commands, re-run
   every later task). **REVIEW stays diff-scoped per task** — the matrix defines
   REVIEW as a read of the diff; re-reviewing unchanged code every task would pay
   a reviewer invocation for nothing.
6. **HUMAN DECISION rows split by moment:** a row that shapes how the task is
   built (3.2 auth library, 5.3 hosted checkout, 6.3 storage location, 10.3 new
   dependency) is asked at task start — `next-task` (b) already has the
   one-interruption slot. The rest (state-of-the-world checks: 1.4, 1.5, 2.3, 8.3)
   are asked at verify time (d). Never answered on the user's behalf, either way.
7. **One reviewer invocation per verify round, batching all applicable REVIEW
   rows** — never one agent per row. A fix round triggers a NEW invocation on the
   updated diff. Rounds with no REVIEW row pay zero delegation.
8. **method.md carries one top nota only** (pt-BR, provenance + list of changed
   steps). Three steps change in v5; three per-step notas would bloat a file meant
   to stay lean. The v4 Step-1 nota stays where it is, untouched.

---

## Changes, file by file — exact text

### 1. `playbook/SECURITY-MATRIX.md`

**1a.** New section, inserted between "HONESTY" and "PROPORTIONALITY":

```markdown
## WHERE THIS FILE LIVES

The canonical copy is `playbook/SECURITY-MATRIX.md` in the my-method
repo. `start-project` writes a byte-identical copy into every new
project's root as `SECURITY-MATRIX.md` — a project session never
reads the repo's copy (Boundaries rule). The project copy is the one
Step 4 triages from, cards cite, and Step 5c re-opens when a new
surface turns on mid-project.
```

**1b.** In "HOW TO READ EACH ROW", append one paragraph directly after the
three-kind list:

```markdown
REVIEW rows are executed by the plugin's `security-reviewer` agent,
defined with a read-only tool allowlist (`Read, Grep, Glob`): it can
read code and return findings; it cannot edit files or run commands.
It never fixes. Fixing is the building session's job, and a fixed
diff is re-judged by a NEW reviewer invocation — never by the session
that fixed it, and never by the reviewer invocation that found it.
```

**1c.** Every table gains a fifth column, **`Fix direction`**, header row
`| # | Required check | How it is performed | Pass criterion | Fix direction |`.
Per-row texts (the applier adds them mechanically):

| Row | Fix direction |
|---|---|
| 1.1 | Replace string concatenation with parameterized queries / ORM binding. |
| 1.2 | Scope the query to the logged-in user's ID in the WHERE/filter, server-side. |
| 1.3 | Hash with Argon2id/bcrypt via the auth library; migrate stored values; never store raw. |
| 1.4 | Create a scoped DB role with only the needed privileges; point the app's connection at it. |
| 1.5 | Turn on the provider's automatic backups. |
| 2.1 | Move the key to an environment variable AND rotate it at the provider — it is burned. |
| 2.2 | Add a timeout and an error branch that fails gracefully without leaking internals. |
| 2.3 | Generate a scoped key at the provider; replace and revoke the broad one. |
| 3.1 | Switch to Argon2id/bcrypt via the auth library; force resets if plaintext was ever stored. |
| 3.2 | Adopt a maintained auth library; do not patch the hand-rolled code. |
| 3.3 | Return one identical generic status + message for both failure cases. |
| 3.4 | Set expiry at issuance; revoke server-side on logout. |
| 4.1 | Add an ownership check (resource owner == logged-in user) before the read/write. |
| 4.2 | Fix the ownership check in the failing handler; re-run the user-A/user-B test. |
| 4.3 | Re-check the role server-side inside the privileged handler itself. |
| 5.1 | Remove all raw-card handling from this codebase; use the provider's hosted checkout/element. |
| 5.2 | Verify the provider's webhook signature before any state change. |
| 5.3 | Switch to hosted checkout; if refused, stop — that is specialist territory per the row. |
| 6.1 | Replace the blocklist with an allowlist of only the types the feature needs. |
| 6.2 | Enforce the size limit server-side, before reading the whole body. |
| 6.3 | Move uploads to object storage or outside the web root; serve with a download-forcing content type. |
| 7.1 | Use the framework's escaping/parameterization instead of concatenation. |
| 7.2 | Add server-side validation for the field, independent of any client check. |
| 7.3 | Escape at render time (framework auto-escaping); never inject raw HTML. |
| 8.1 | Rotate the credential NOW (history rewrite alone is not enough), move it to an env var, then scrub history. |
| 8.2 | Add the pattern to `.gitignore` and untrack the file (`git rm --cached`). |
| 8.3 | Issue separate production secrets; a dev key never touches prod. |
| 9.1 | Enable HTTPS-only / HTTP→HTTPS redirect at the host. |
| 9.2 | Turn the debug flag off in the production environment. |
| 9.3 | Add the missing headers via host or framework config. |
| 10.1 | Upgrade to the fixed version; if none exists, replace the dependency or escalate to the user. |
| 10.2 | Commit the lockfile. |
| 10.3 | n/a — the explain-before-install rule is already in force. |

### 2. `method.md` — v5

**2a.** Header: `# METHOD — v4 (post-audit-02)` → `# METHOD — v5 (post-audit-03)`.

**2b.** Top nota replaced by:

```markdown
*Nota (pt-BR): quinta versão. Regra de origem: mudar só com friction
concreta; a v4 (Step 1, comparação com "grilling") foi a primeira
exceção consciente e a v5 é a segunda — o wiring de segurança nasce da
lacuna registrada na auditoria 01 (matriz ligada a nada) e do desenho
aprovado na auditoria 03 (2026-08-10), por decisão explícita do
usuário, com proveniência em friction.md. Mudanças da v5: STEP 0
(cópia da matriz no projeto), STEP 4 (triagem de tier + linhas nas
fichas), STEP 5c (checagens por tipo, revisor só-leitura, laço de
correção). Nenhum outro passo mudou.*
```

**2c.** STEP 0 gains item 4:

```markdown
4. Save the security matrix's own text as `SECURITY-MATRIX.md` in the
   project root, next to `method.md`. Step 4 triages from it, cards
   cite its rows, and Step 5c re-opens it when the work turns on a
   risk surface the plan did not declare.
```

**2d.** STEP 4 — insert between the card-fields bullet list and "Then ask exactly
one question…":

```markdown
Security rows — before showing the plan: triage the project's
security tier (T0–T3) per `SECURITY-MATRIX.md`, from the Step 1
answers and the approved SPEC. Tell the user the tier and its reason
in one line, in Portuguese. Copy every in-scope row (ID + required
check) into "How we will check it" of each card whose work touches
that surface — every in-scope row lands on at least one card; a row
with no natural home (e.g. deployment) goes on the card where it
first becomes checkable. A card touching no surface states
"Security: none applicable". Record the tier and its reason in
`STATE.md`'s settled decisions. This adds no sixth field and no
second question — Gate 2 stays exactly one question.
```

**2e.** STEP 5c — the existing paragraph stays byte-identical, and this block is
appended to it:

```markdown
   The card's security rows run inside this step, by kind:
   - Drift first: if the diff turned on a risk surface the card does
     not declare (new endpoint, new dependency, upload path, stored
     secret…), pull that surface's rows from `SECURITY-MATRIX.md`
     into the card now and say so — the matrix's own re-triage rule.
   - AUTOMATED rows are commands, run here, raw output on screen;
     they join the regression set and are re-run by every later task.
   - REVIEW rows go, all together, to ONE fresh invocation of the
     read-only `security-reviewer` subagent, with the diff; findings
     (severity + `file:line`) are shown raw and recorded on the card
     BEFORE anything is fixed. The reviewer cannot edit; it reports.
   - HUMAN DECISION rows are asked to the user verbatim, in
     Portuguese, never answered on their behalf. A row that shapes
     how the task is built is asked before building starts, not here.
   - Fix loop: failures are fixed in this session, within the card's
     file scope, only after findings are shown and recorded; then the
     AUTOMATED rows re-run and the updated diff goes to a NEW
     reviewer invocation. This session never declares a REVIEW row
     passed — only a fresh reviewer's "no open HIGH or CRITICAL
     finding" does. Two failed rounds of the same row → Step 6.
```

### 3. `kit/my-method/commands/start-project.md`

**3a.** Step 0 gains item 4 (operational): write `SECURITY-MATRIX.md` in the
project root with EXACTLY the revised matrix text, embedded byte for byte in the
command file (same mechanism as the method.md block; Boundaries forbids reading
the kit at runtime — this becomes the file's third embedded copy).

**3b.** The embedded `method.md` block is replaced by the full v5 text (2a–2e
applied). Both copies — the embedded method text AND the operational steps below
it — must say the same thing; friction.md's duplication-trap entry is the standing
warning.

**3c.** Step 4 (PLAN — GATE 2) gains, before the card-writing instructions, the
operational mirror of 2d:

```markdown
Before writing the cards: triage the project's security tier (T0–T3)
per the `SECURITY-MATRIX.md` written in Step 0, using the Step 1
critical answers and the approved SPEC. Tell the user, in Portuguese,
in one line, the tier and why. Then, as each card is written, copy
every in-scope row (ID + required check) into its "How we will check
it" when the card's work touches that surface. Coverage rule: every
in-scope row must land on at least one card; a row with no natural
home (e.g. `deployment`) goes on the card where it first becomes
checkable. A card touching no surface states "Security: none
applicable". Do not add a sixth field; do not add a second Gate-2
question.
```

**3d.** Step 5.1, CLAUDE.md template, directory layout: add after the
`method.md` line:

```
SECURITY-MATRIX.md  security checks for this project's tier (do not edit)
```

**3e.** Step 5.2, STATE.md template, "## Settled decisions" placeholder becomes:

```markdown
<Key answers from Step 1, the SPEC/stack decisions from Steps 2-3, and the security tier — "Security tier: TX — <reason>" — from Step 4's triage.>
```

**3f.** Step 5.5 staging list gains `SECURITY-MATRIX.md`.

### 4. `kit/my-method/commands/next-task.md`

**4a.** Section (b), appended after the existing question paragraph:

```markdown
If the card carries a HUMAN DECISION security row that shapes how the
task is built (e.g. 3.2 auth library, 5.3 hosted checkout, 6.3 upload
storage, 10.3 new dependency), ask it here, as part of this same
single interruption — the row's question verbatim, in Portuguese.
```

**4b.** Section (d), appended after the existing bullets:

```markdown
Security rows on the card run inside this step, by kind:

1. Drift check first: compare the diff against the card's declared
   surfaces. If the work turned on a surface the card does not
   declare (new endpoint, new dependency, upload path, stored
   secret…), open the project's `SECURITY-MATRIX.md` — only in this
   case; minimum reading holds otherwise — pull that surface's rows
   into the card, and say so in Portuguese.
2. AUTOMATED rows: run the commands here, raw output on screen. They
   join the regression set re-run by every later task.
3. REVIEW rows: send ALL of them in ONE invocation of the
   `security-reviewer` subagent (read-only; it cannot edit or run
   anything), passing three things: the rows verbatim, the list of
   files the task touched, and the raw diff. Show its findings raw
   and record any open finding on the card BEFORE fixing anything.
4. HUMAN DECISION rows not already asked at (b): ask the row's
   question verbatim, in Portuguese. Never answer it on the user's
   behalf; never mark it resolved without their explicit answer.
5. Fix loop: fix failures in this session, within the card's file
   scope, only after findings are displayed and recorded. Then re-run
   the AUTOMATED rows and send the updated diff to a NEW
   `security-reviewer` invocation. You never declare a REVIEW row
   passed — only a fresh reviewer's "no open HIGH or CRITICAL
   finding" verdict does. Second failed round of the same row → (f).
```

### 5. NEW — `kit/my-method/agents/security-reviewer.md`

```markdown
---
description: Read-only security reviewer for my-method tasks — judges a diff against the REVIEW rows of a task card and reports findings with severity and file:line; never edits, never fixes, never runs commands.
tools: Read, Grep, Glob
---

You are the security reviewer for a my-method project. You are
invoked at verification time with three inputs in your prompt: the
REVIEW rows that apply to the task (verbatim from the card), the list
of files the task touched, and the raw diff.

You are read-only BY DESIGN. You cannot edit files or run commands,
and you do not propose to do either. You report; the building session
fixes; a fresh invocation of you re-judges the fixed diff. If a
previous fix attempt or its reasoning appears in your prompt, ignore
its conclusions and judge only the code in front of you.

Legitimacy boundary (from SECURITY-MATRIX.md): every check targets
this project's own code and the owner's own infrastructure. Never
evaluate, suggest, or reason about probing systems this project does
not own.

Procedure:
1. Read the diff first; then open touched files with Read/Grep/Glob
   for surrounding context (call sites, schema, config) as needed.
2. For each REVIEW row given, hunt for violations of that row's
   required property in the diff and its blast radius. Adversarial
   stance: the property is absent until the code shows it holds.
3. Report findings, one per violation, exactly in this format:
   `file:line` — severity (CRITICAL/HIGH/MEDIUM/LOW) — row ID — what
   is wrong, one sentence — concrete attack or failure scenario, one
   sentence — fix direction (the matrix row's, adapted to this code).
4. If a row's property cannot be established either way (code not in
   the diff, runtime-only behaviour, unreadable file), list it under
   `NOT ESTABLISHED` with the reason. Silence is not a pass —
   research/13-testing-strategy.md documents what a reading review
   cannot see.
5. End with exactly one verdict line:
   `PASS — no open HIGH or CRITICAL finding`
   or
   `FAIL — <N> open HIGH/CRITICAL finding(s)`.
   Severity honesty: never inflate a MEDIUM to force attention, never
   deflate a HIGH to be agreeable. The pass criterion is the
   matrix's, not yours to move.

Language: findings are written in English (they are recorded on an
English card). You do not address the user directly; the building
session relays and translates.
```

### 6. `kit/my-method/templates/TASK-XXX.md` — comment only

"How we will check it" comment becomes:

```markdown
<!-- Something the user can see, or a command that can prove it.
     Include the applicable SECURITY-MATRIX.md rows for this
     project's tier (row ID + required check), or state
     "Security: none applicable". -->
```

### 7. `kit/my-method/templates/STATE.md` and `templates/CLAUDE.md` — one line each

- `STATE.md` "Settled decisions" comment becomes:
  `<!-- Decisions not to reopen without new information. Always includes: Security tier: TX — reason (from Step 4 triage). -->`
- `CLAUDE.md` directory layout gains, after the `method.md` line:
  `SECURITY-MATRIX.md  security checks for this project's tier (do not edit)`

### 8. `friction.md` — provenance entry (added in THIS proposal's commit)

New YOURS entry recording: origin (audit-01 gap + audit-03 approved design, second
conscious exception, D5 out of scope), and the duplication-trap growth (three
embedded copies in `start-project.md`). Text is in the commit alongside this file.

---

## Application order (after the user approves this text)

1. `playbook/SECURITY-MATRIX.md` (1a–1c) — the canonical text everything else
   copies.
2. `method.md` → v5 (2a–2e).
3. `kit/my-method/commands/start-project.md` (3a–3f) — BOTH the operational steps
   and the two embedded copies (method v5 + revised matrix). Check friction.md's
   duplication entry first, per its own warning.
4. `kit/my-method/commands/next-task.md` (4a–4b).
5. NEW `kit/my-method/agents/security-reviewer.md` (5).
6. Templates (6, 7).
7. `CHANGELOG.md` entry at apply time (what changed, what was NOT tested yet).
8. Verify-at-apply, before trusting the agent: invoke `security-reviewer` once in
   a throwaway context and confirm the harness refuses it an Edit/Write/Bash call
   (the allowlist is the load-bearing guarantee — test it, do not assume it).
9. Existing pilot projects keep their frozen `method.md` copies — v5 applies to
   projects created after the mirror, not retroactively (v4 precedent).

One commit for 1–7 (mirror of the v4 apply commit), with the verify-at-apply
result (8) reported in the commit's CHANGELOG entry.

## NOT VERIFIED / open risks

- Whether a **plugin** agent's `tools:` frontmatter allowlist is enforced by the
  harness identically to the Agent SDK's `tools` field (the read-only example in
  audit-03 (d) claim 3 is SDK documentation). Step 8 above exists precisely to
  test this before trusting it. If enforcement turns out to be absent, the
  read-only rule degrades to L3 prose and this proposal must say so in CHANGELOG.
- Token cost of one reviewer invocation on a real card — unmeasured; the official
  general figure is 3–10x single-agent for multi-agent work (audit-03 (d) claim
  5). Mitigations already in the design: rows batched in one invocation,
  diff-scoped review, zero invocations when no REVIEW row applies.
- Without D5 (commit-gate hook), nothing deterministic blocks a commit that skips
  this entire procedure — the wiring raises step 12 from "absent" to L3+L4, not to
  L1. That is the same honest ceiling audit-01 measured; D5 remains the next
  structural investment.
- `start-project.md` grows by roughly the matrix's full length (~200 lines). The
  duplication trap now covers three embedded texts; any future matrix revision
  must touch the playbook copy AND the embedded copy in the same commit.
