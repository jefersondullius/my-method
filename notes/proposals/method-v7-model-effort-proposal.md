# PROPOSAL — method.md v7, model/effort recommendation at task start (audit-01 rec 3 / target step 10)

Status: **proposed, awaiting the user's approval of this text. Nothing applied.**
Requested by the user on 2026-08-11 ("Quero desenvolver a rec 3 … escreva uma
proposta, sem aplicar").

Provenance: WORKFLOW-TARGET step 10 ("At the START of the task, you recommend
the model and effort level … One interruption, at the beginning, never
mid-task") is the ONLY step of the 14 still ABSENT (audit-01 verdict table).
This revision comes from audit-01 rec 3, requested explicitly by the user —
**the third conscious exception** to the change-only-on-pilot-friction rule
(after v4/grilling and v5/security). Kept honest: audit-01 itself recorded a
live occurrence of the failure this closes ("This audit session itself started
on leftover settings until the user changed them by hand"), but no friction.md
pilot entry exists for it. Provenance entry ships in friction.md with this
proposal's commit, per the series pattern.

## Verified mechanism (live research, one subagent, 2026-08-11)

Subagent's five-line summary:

> Model switching remains user-only via /model; no API or tool lets the agent
> switch models. The `model` setting reads once at session start; `effortLevel`
> is written by /effort (or per-session CLI flag/env var). Skill frontmatter
> `model:`/`effort:` are turn-scoped ("applies for the rest of the current
> turn… the session model resumes on your next prompt"). No changes to any of
> this in the changelog since 2026-08-10 (latest entry v2.1.227, Aug 10).
> `${CLAUDE_EFFORT}` is exposed as a documented substitution in skill content;
> `${CLAUDE_MODEL}` is not listed — model-identity exposure NOT VERIFIED.

Claims this proposal builds on (all accessed 2026-08-11):

1. "/model can only be invoked by the user, not by the model itself" —
   https://code.claude.com/docs/en/commands.md
2. `model` setting: "Read once at session start… To switch models mid-session,
   use the /model command instead" — https://code.claude.com/docs/en/settings.md
3. `effortLevel`: written by /effort; per-session override via `--effort` CLI
   flag or `CLAUDE_CODE_EFFORT_LEVEL` env var —
   https://code.claude.com/docs/en/settings.md
4. Skill frontmatter `model:`/`effort:` are turn-scoped (exact wording
   confirmed at skills.md line 265) — https://code.claude.com/docs/en/skills.md
5. `${CLAUDE_EFFORT}` substitution: "The current effort level: low, medium,
   high, xhigh, or max… Use this to adapt skill instructions" (line 327) —
   https://code.claude.com/docs/en/skills.md. `${CLAUDE_MODEL}` does not exist
   in the substitutions table → current-model exposure: NOT VERIFIED (docs
   silent; this harness shows the model its own identity in the system prompt,
   but that is local observation, not documentation).
6. No relevant changes since 2026-08-10 — changelog ends at v2.1.227
   (Aug 10, 2026) — https://code.claude.com/docs/en/changelog.md

**Conclusion (constraint 1):** audit-01's feasibility finding stands unchanged
— recommend-and-ask is not a workaround, it is the only mechanism. One new
capability improves the design: the command text can know the CURRENT effort
via `${CLAUDE_EFFORT}` and skip a pointless ask (decision D5).

---

## Design decisions made in this proposal

Each can be vetoed independently.

- **D1 — The decision is born at PLANNING, checked at task start.** Same
  criteria that placed security triage at planning (audit-03 c): the planner
  has the most context exactly when the card is written (checks, dependencies,
  novelty); the card line is a durable, visible record (L4); runtime
  re-derivation would repeat judgment every task with less context (next-task
  reads only STATE + PLAN + one card) and no memory. Runtime keeps two valves:
  next-task (b) may ADJUST a visibly wrong recommendation with one stated line
  of reasoning (never silently), and the stuck protocol's option 2 (escalate
  and retry once) stays unchanged as the mid-task escape.
- **D2 — No sixth field.** The line lives INSIDE "Does it fit in one
  session?", whose answer already characterizes the task's weight — the same
  move v5 used to wire security into "How we will check it". The five-field
  rule ("each extra field is something to fill in every task, forever")
  stands untouched.
- **D3 — Silence is the default.** The line is written ONLY when a trigger
  applies; a card with no line means "the user's current settings serve", by
  definition. This deliberately diverges from the security convention (which
  writes "Security: none applicable" explicitly): security is a safety
  checklist where silence would be ambiguous; model choice is advice, where a
  line every task becomes noise the user stops reading — the user's own
  original rule. Triggers, applicable by the model alone:
  - UP (stronger model and/or higher effort), any one suffices: the card
    carries REVIEW security rows on `authentication`, `authorization` or
    `payments`; OR two or more other tasks depend on this one in `PLAN.md`;
    OR the task spends its "1 new concept/library" sizing proxy on genuinely
    novel logic (algorithm, concurrency, cryptography); OR `STATE.md` "Things
    that broke once" records a failure in this task's area.
  - DOWN (cheaper model): purely mechanical work — renames, copy changes,
    configuration, scaffolding — with no new logic and no new checks beyond
    re-runs.
  The thresholds are judgment defaults; pilots calibrate them.
- **D4 — One interruption, merged.** The recommendation enters next-task
  (b)'s existing single-question slot: ONE message carries the 6-line intro,
  the model/effort ask (exact `/model` and `/effort` values + the card's
  one-line reason), and any build-shaping HUMAN DECISION security question —
  then ONE wait. Never mid-task. If the user declines or simply does not
  switch, the task builds on current settings and the subject is not raised
  again.
- **D5 — Effort self-check, model always asked.** The (b) text embeds
  `${CLAUDE_EFFORT}` (claim 5): when the card's ONLY recommendation is an
  effort level that already matches the session, the ask is skipped entirely.
  A recommendation naming a MODEL is always asked (current model exposure is
  NOT VERIFIED in docs). Fallback stated in the command: if the placeholder
  renders literally (the `${CLAUDE_PLUGIN_ROOT}`-in-commands bug is precedent
  for substitution failures in command bodies — friction.md 2026-08-10),
  treat current effort as unknown and ask. An apply-time probe settles which
  behavior is real.
- **D6 — method.md v7, lean.** The method carries the principle (silence rule
  at STEP 4; the one-interruption ask at STEP 5a); the operational trigger
  list lives only in `start-project.md`. Third conscious exception, recorded
  in the top nota and friction.md.
- **D7 — Advisory by design, and honestly so.** No enforcement is possible:
  /model is user-only (claim 1) and built-ins are not tool calls, so not even
  a hook can see or force the switch — the ceiling is L3 (instruction) + L4
  (the card line as durable record of what was advised). Ignoring the
  recommendation blocks nothing.

---

## Changes, file by file — exact text

### 1. `method.md` — v7

**1a.** Header: `# METHOD — v6 (post-audit-03, D5)` → `# METHOD — v7 (post-audit-01 rec 3)`.

**1b.** Top nota replaced by:

```markdown
*Nota (pt-BR): sétima versão. Origem: rec 3 da auditoria 01 — o passo
10 do fluxo-alvo (recomendação de modelo e esforço no início da
tarefa), o único ainda ABSENT — a pedido explícito do usuário em
2026-08-11. Terceira exceção consciente à regra de mudar só com
friction de piloto; ocorrência registrada pela própria auditoria: a
sessão da auditoria 01 começou em configurações herdadas até o
usuário trocar à mão. Mudanças da v7: STEP 4 ganha a regra do
silêncio (linha `Model/effort:` na ficha só quando a tarefa
genuinamente precisa de algo diferente do padrão); STEP 5a ganha a
única interrupção de início de tarefa para o usuário apertar os
botões — o modelo não consegue trocar modelo/esforço sozinho
(verificado ao vivo em 2026-08-11). Nenhum outro passo mudou.*
```

**1c.** STEP 4 — inserted after the "Security rows" paragraph, before "Then
ask exactly one question…":

```markdown
Model and effort — silence is the default: only when a task genuinely
needs something different from the user's current settings, write one
line inside its "Does it fit in one session?" field —
`Model/effort: <model> + <effort> — <one-line reason>` — naming
values the user can type with `/model` and `/effort`. A card with no
such line means the current settings serve; never write a line to say
the default is fine.
```

**1d.** STEP 5a becomes:

```markdown
a) Tell the user in at most 6 lines which task this is and what will
   exist when it ends. If the card carries a `Model/effort:` line,
   state it in this same message — the exact values to type — and ask
   the user to set them before building starts: one interruption, at
   the start, never mid-task. Only the user can switch model or
   effort; if they decline or do not switch, build on the current
   settings and do not raise it again.
```

### 2. `kit/my-method/commands/start-project.md`

**2a.** Embedded method copy → v7 (1a–1d applied inside the block, +3
spaces). Of the four embedded texts, only the method one changes; matrix,
templates and verify skeleton stay byte-identical.

**2b.** Operational Step 4 — appended after the sizing-proxies paragraph:

```markdown
Model and effort — silence is the default. Write the line
`Model/effort: <model> + <effort> — <one-line reason>` inside "Does
it fit in one session?" ONLY when one of these triggers applies;
otherwise write nothing about model or effort:

- UP (stronger model and/or higher effort): the card carries REVIEW
  security rows on `authentication`, `authorization` or `payments`;
  OR two or more other tasks depend on this one in `PLAN.md`; OR the
  task spends its "1 new concept/library" proxy on genuinely novel
  logic (algorithm, concurrency, cryptography); OR `STATE.md` "Things
  that broke once" already records a failure in this task's area.
- DOWN (cheaper model): purely mechanical work — renames, copy
  changes, configuration, scaffolding — with no new logic and no new
  checks beyond re-runs.

Name values the user can actually type with `/model` and `/effort`.
```

### 3. `kit/my-method/commands/next-task.md`

Section (b) — appended after the HUMAN DECISION paragraph:

```markdown
If the card carries a `Model/effort:` line, include it in this same
single interruption: state the exact `/model` and `/effort` values to
type and the card's one-line reason, and ask the user to set them
now, before (c). The current effort level is `${CLAUDE_EFFORT}` — if
the card's only recommendation is an effort level and it already
matches, skip the ask entirely (if that placeholder shows literally
instead of a level, treat the current effort as unknown and ask). One
message carries the 6-line intro, this ask, and any build-shaping
HUMAN DECISION question; then WAIT once. You cannot switch model or
effort yourself; if the user declines or does not switch, build on
the current settings and do not raise it again. If the card's
recommendation is visibly wrong for what the card actually asks,
adjust it here with one stated line of reasoning — never silently.
```

### 4. `kit/my-method/templates/TASK-XXX.md`

The "Does it fit in one session?" comment becomes:

```markdown
<!-- If not, split now. Proxies: one feature/slice; ~5 files max;
     at most 2 new entrypoint checks + 1 human check; at most 1 new
     concept/library. Missing two or more = split.
     Optional, only when a start-project Step 4 trigger applies:
     Model/effort: <model> + <effort> — <one-line reason>.
     No line = the user's current settings serve. -->
```

### 5. `friction.md` — provenance entry (in THIS proposal's commit)

New YOURS entry: rec 3 proposed; third conscious exception; audit-01's live
occurrence noted; mechanism re-verified 2026-08-11.

---

## Application order (after the user approves this text)

1. `method.md` → v7 (1a–1d).
2. `start-project.md` (2a–2b) — operational text AND the embedded method
   copy; re-run the mechanical byte-comparison of all embedded texts before
   committing (series practice).
3. `next-task.md` (3).
4. `templates/TASK-XXX.md` (4).
5. CHANGELOG entry.
6. **Probe P1 (runtime half + substitution check), one turn:** hand-build a
   throwaway project (STATE.md, PLAN.md with one pending task, a card whose
   fit field carries `Model/effort: opus + high — novel algorithm`), run
   `/my-method:next-task` headless in a fresh session, abort after turn 1.
   Expected: ONE message with the 6-line intro AND the `/model`/`/effort`
   ask, before any build; the message reveals whether `${CLAUDE_EFFORT}`
   substituted (a real level) or rendered literally (fallback path).
7. **Planning half (silence rule + triggers): declared validation debt** to
   the pending T2 pilot — same pattern as rec 4 items 2–4 — because it only
   shows in a full planning run, and the T2 pilot exercises the UP trigger
   naturally (auth REVIEW rows).
8. One commit for 1–5 with P1's result in the CHANGELOG entry.

## Cost per task, forever (constraint 7)

- **Default task (no trigger):** 0 extra lines on the card, 0 extra lines in
  (b), 0 buttons. Nothing changes at all.
- **Non-default task:** 1 line on the card + 2–3 lines inside (b)'s existing
  single message; at most 2 typed commands (`/model X`, `/effort Y`), once,
  at the start.
- **If the user ignores the recommendation:** nothing blocks — the task runs
  on current settings; the failure this feature mitigates (silent waste on
  trivial tasks, silent quality loss on hard ones — audit-01 step 10) simply
  returns for that task; the card line remains as the L4 record that the
  advice existed.

## What this does NOT guarantee (kept honest)

- It cannot switch anything: /model and /effort stay user-only (claim 1) —
  and built-ins are not tool calls, so no hook can force or even observe the
  switch. L3 + L4 is the structural ceiling for step 10.
- It cannot verify compliance for MODEL: whether the user actually switched
  is unknowable from inside (model-identity exposure NOT VERIFIED); effort is
  verifiable only if `${CLAUDE_EFFORT}` substitutes in command bodies (probe
  P1 decides).
- No record of what the task actually RAN on — the card records the advice,
  not the outcome.
- The trigger list is heuristic judgment, not measurement; pilots calibrate.

## NOT VERIFIED

- `${CLAUDE_EFFORT}` substitution specifically inside plugin COMMAND bodies —
  documented for skill content (claim 5), but `${CLAUDE_PLUGIN_ROOT}` has a
  known expansion bug in `commands/*.md` (friction.md, 2026-08-10); probe P1
  settles it, and the command text carries the fallback either way.
- Current MODEL exposure to the session (docs silent; local observation
  only).
- Whether `/fast` interacts with any of this — not investigated; out of
  scope.
