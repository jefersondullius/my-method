# PROPOSAL — audit-01 rec 4: four small L3/L4 patches (commands and templates only)

Status: **approved and applied, 2026-08-11** ("aprovado"). Kept as the record
of what was proposed. Item-1 live probes both PASSED (no-idea run asked for
the idea first, with a minor Step-0 sequencing observation; with-idea run
restated and opened critical question 1) — details in CHANGELOG. Items 2–4
are declared validation debt until the next full pilot (T2). Originally
requested by the user on 2026-08-11 ("Escreva a proposta da rec 4 antes de
aplicar").

Provenance, item by item — this bundle is audit-01's recommendation 4 verbatim
("idea-capture + argument-hint (step 3); approval marker in SPEC.md at Gate 1
(step 5); close start-project and next-task with raw git show --stat (steps
8/13); sizing proxies in the card template comment (step 7)"):

- **Item 1 (idea capture) is friction-backed**: the 2026-08-11 pilot showed the
  interview starting blind and inferring the idea from the FOLDER NAME —
  recorded in `friction.md` the same day. This is observed pilot friction, the
  method's own strongest trigger.
- **Items 2–4** carry audit-01's step analyses (steps 5, 8, 13, 7) as
  provenance, approved into work by this request. **`method.md` is NOT touched
  by any item** — everything here is command/template mechanics, so the
  method's "change only with friction" rule for method revisions is not in
  play. No version bump. The embedded copies inside `start-project.md`
  (method, matrix, verify skeleton) are also untouched — only operational text
  changes.

Explicitly OUT of scope, named so approval stays informed:

- The optional **L1 extension** audit-01 sketched under step 5 (deny writes to
  `PLAN.md`/`plan/**` while `SPEC.md` lacks the approval marker). It became
  cheap now that `verify-gate.ps1` exists to share infrastructure, but it is a
  behavior change to the hook with its own failure modes — separate proposal
  if wanted.
- **Audit-01 rec 3** (step 10, model/effort recommendation at task start) —
  still ABSENT, bigger, separate proposal.

---

## Design decisions made in this proposal

1. **The idea is asked BEFORE the critical block, and never inferred.** The
   pilot's failure was literal inference from the folder name; the instruction
   forbids exactly that. If the idea came typed after the command, it is
   restated in one line instead of re-asked. No reliance on any argument
   substitution mechanism — the instruction reads the invocation text itself
   (`argument-hint` is UI affordance only, documented in the skills frontmatter
   reference [audit-01 S2, code.claude.com/docs/en/slash-commands, accessed
   2026-08-10]).
2. **Approval marker is append-only.** `Approved: <YYYY-MM-DD>` is appended to
   the end of `SPEC.md` at the moment of confirmation; a later re-approval
   appends a new line, never edits old ones — the file carries its own audit
   trail. The date also lands in STATE.md's settled decisions.
3. **The raw `git show --stat` comes BEFORE the sacred end text.** Method 5d's
   "end the turn with exactly this text and nothing else" stays intact: the
   stat display happens first, the literal text still closes the turn with
   nothing after it.
4. **Sizing proxies are four, with a two-missed rule**: (a) one feature or one
   slice of a feature; (b) touches at most ~5 files; (c) verification adds at
   most 2 new entrypoint checks plus at most 1 human check; (d) introduces at
   most 1 new concept or library. Missing two or more = split now. The numbers
   are judgment defaults — veto or adjust freely. They live in
   `start-project`'s operational Step 4 prose (where the planner actually
   reads at runtime) AND in the kit template comment (documentation); the
   bare card template embedded in the command stays bare, since comments would
   be dropped when cards are filled.

---

## Changes, file by file — exact text

### 1. `kit/my-method/commands/start-project.md`

**1a.** Frontmatter gains one line (after `description:`):

```yaml
argument-hint: <ideia em 1-2 frases>
```

**1b.** Step 1, inserted directly after the opening paragraph ("Interview the
user … 'pode só confirmar se topar.'") and before "Open with the CRITICAL
BLOCK":

```markdown
Before any question: if the user typed the idea together with the
command, restate it in one line and go straight to the critical
block. If not, ask for it first — one line, in Portuguese ("Qual é a
ideia? Uma ou duas frases bastam.") — and WAIT for the answer. Never
infer the idea from the folder name or any other context: ask.
```

**1c.** Step 2 (GATE 1), appended after "…repeat until confirmed.":

```markdown
On the confirmation, append one line to the end of `SPEC.md`:
`Approved: <YYYY-MM-DD>` (today's date). If the spec is ever revised
and re-approved, append a new `Approved:` line — never edit or remove
an earlier one.
```

**1d.** Step 4, appended to the paragraph "If any task would not fit in a
single session, split it into more tasks now, at planning time — do not defer
the split to when `/next-task` reaches it.":

```markdown
Sizing proxies for "Does it fit in one session?": (a) one feature or
one slice of a feature; (b) touches at most ~5 files; (c) verification
adds at most 2 new checks to the entrypoint plus at most 1 human
check; (d) introduces at most 1 new concept or library. A task that
misses two or more proxies is split now.
```

**1e.** Step 5.2, the STATE.md template's settled-decisions placeholder
becomes:

```markdown
<Key answers from Step 1, the SPEC approval — "SPEC approved: <YYYY-MM-DD>" — the stack decision from Step 3, and the security tier — "Security tier: TX — <reason>" — from Step 4's triage.>
```

**1f.** Step 6 (close), inserted before "Then say, and mean literally:":

```markdown
Run `git show --stat` on the initial commit and show its RAW output
on screen — the user sees the commit and its file list directly, not
a sentence about them.
```

### 2. `kit/my-method/commands/next-task.md`

Section (e): insert a new item 3 between the commit item and the end-text
item, renumbering the end-text item to 4:

```markdown
3. Run `git show --stat` on the task commit and show its RAW output
   on screen — the user sees directly that the card, `PLAN.md`,
   `STATE.md` and the verify evidence are all in the commit.
```

### 3. `kit/my-method/templates/TASK-XXX.md`

The "Does it fit in one session?" comment becomes:

```markdown
<!-- If not, split now. Proxies: one feature/slice; ~5 files max;
     at most 2 new entrypoint checks + 1 human check; at most 1 new
     concept/library. Missing two or more = split. -->
```

### 4. `kit/my-method/templates/STATE.md`

The settled-decisions comment becomes:

```markdown
<!-- Decisions not to reopen without new information. Always includes: SPEC approved: YYYY-MM-DD; Security tier: TX — reason (from Step 4 triage). -->
```

### 5. `friction.md` — provenance entry (in THIS proposal's commit)

New YOURS entry: rec 4 proposed; item 1 friction-backed (pilot entry of
2026-08-11), items 2–4 audit-01-backed; method.md and the embedded copies
untouched.

---

## Application order (after the user approves this text)

1. `start-project.md` (1a–1f).
2. `next-task.md` (2).
3. Templates (3, 4).
4. CHANGELOG entry.
5. **Targeted live test of item 1** (the friction-backed one), two one-turn
   headless probes in fresh throwaway folders:
   a. `/my-method:start-project` with NO idea typed → the first message must
      ASK for the idea (not start the critical block, not guess);
   b. `/my-method:start-project uma lista de compras local` → the first
      message must restate the idea in one line and open critical question 1.
   Abort both after turn 1 (no resume); throwaways discarded.
6. Items 2–4 are gate/close/planning behaviors observable only in a full run:
   recorded in CHANGELOG as validation debt, to be observed in the next real
   pilot (the pending T2 pilot exercises all of them plus the REVIEW path).
7. One commit for 1–4 with the probe results (5) in the CHANGELOG entry.

## NOT VERIFIED / risks

- `argument-hint` rendering for plugin commands in the current CLI version —
  cited from audit-01 [S2] (accessed 2026-08-10), not re-verified today; the
  ask-first instruction works with or without it, so the risk is cosmetic.
- The two-missed-proxies rule and the specific numbers are defaults from
  judgment, not measured; the next pilots calibrate them.
- Items 2–4 land untested-in-flow until the T2 pilot (application order 6) —
  same validation-debt pattern the kit has used since `/next-task`.
