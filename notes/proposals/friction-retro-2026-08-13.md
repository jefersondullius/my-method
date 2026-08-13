# PROPOSAL — retrospective on the two friction entries v4–v9 left unprocessed

Status: **Recommendation 1 applied 2026-08-13. Recommendation 2 NOT
applied, by explicit user instruction — skipped entirely, not even as
a watchlist row.** A third item, outside this proposal's original two
recommendations, was applied the same turn on direct user instruction:
a mandatory-invocation rule for `frontend-design` on any layout
change, however small — see "Applied beyond this proposal" at the end
of this file. Written 2026-08-13, reading
`friction.md` (this repo's own) and `friction-logtech.md` (a real
project's friction log, copied into this repo 2026-08-13) end to end,
cross-checked against every prior proposal (v4 through v9, plus the
maintenance rounds) to confirm these two entries are genuinely
unprocessed, not just unmentioned.

Nothing below has been applied.

---

## Before PARTE 1 — why item 2 is not in v9

**Evaluated and excluded, not overlooked.** `notes/proposals/logtech-friction-proposal-2026-08-13.md` (v9's proposal, same day it read `friction-logtech.md`) addresses this entry twice:

1. PARTE 1, root cause **D** ("Functional-first, visual-later task separation"): quotes the entry and states *"Reported here for visibility; **not turned into a recommendation**, per the user's own stated preference to wait for more signal."*
2. The closing **"Not proposed"** section repeats it by name with the same reason.

Both times, the stated reason is the entry's own last sentence: *"Ainda não sei se isso deveria ser regra fixa ou só uma prática recomendada — quero ver como o restante do logtech se comporta antes de propor a mudança no method.md."* v9 respected that instruction literally — it did not propose a rule the entry's own author asked to defer. So: **avaliado e descartado**, with the author's own deferral as the reason, recorded in writing at the time. This retrospective is not catching a miss; it is reopening a question its own author asked to leave open, now that the condition attached to reopening it (more signal from logtech) has changed — the project will not continue.

---

## PARTE 1 — Análise

### Item 1 — `friction.md`, `MINE`, 2026-08-13: cite the applicable skill on the task card

Verbatim: *"quando uma skill relevante para uma tarefa está disponível (instalada ou guardada (exemplo: frontend-design)), a ficha da tarefa deveria citar explicitamente que ela deve ser usada — em vez de confiar só no disparo automático por descrição, que é mecanismo frágil (imposição instrucional, não estrutural, como o próprio kit já reconhece para next-task/start-project). Sem isso, corro o risco de instalar/guardar uma skill e 'esquecer' que ela existe na hora de construir."*

**Ainda é cedo.** The entry's own last line settles this: *"Ainda não aconteceu de fato — é hipótese antecipada, não atrito observado."* Zero occurrences — weaker evidentiary footing than item 2, which at least has one. The analogy to STEP 5d's "prosa enfática já falhou uma vez" (the precedent that justified giving STEP 5d a literal end-of-turn string instead of a rule to interpret) is reasoning by comparison, not a report of this specific failure happening. The risk described is also generic to any Claude Code project with an installed skill, not evidence specific to how this method's task cards are built.

There is a real cost to waiting, though, worth naming honestly: this session's own STEP 3b work (`kit/my-method/skills-library/frontend-design/`) is the first concrete case where this risk could bite — a vetted skill sitting unused because nothing on a future task card points at it. That does not turn hypothesis into friction, but it does make the risk worth tracking somewhere cheaper than a method.md rule: PARTE 2 proposes a watchlist trigger, not a text change.

Worth flagging for the eventual real design, if the trigger ever fires: STEP 4's task card is deliberately kept to five fields, and the security-tier integration already set the precedent of folding new information into an *existing* field ("How we will check it") rather than adding a sixth — *"This adds no sixth field and no second question."* A skill-citation fix, when it has real evidence behind it, should probably follow that same discipline rather than default to a new field.

### Item 2 — `friction-logtech.md`, `MINE`, 2026-08-12: separate functional tasks from visual-polish tasks

Verbatim: *"o method.md deveria deixar explícito que tarefas de funcionalidade e tarefas de acabamento visual são sempre separadas — construir funcional primeiro, capricho visual depois, em tarefa própria. Isso evitaria o que aconteceu aqui: telas funcionais mas feias, sem aviso de que o visual ficaria para depois. Ainda não sei se isso deveria ser regra fixa ou só uma prática recomendada — quero ver como o restante do logtech se comporta antes de propor a mudança no method.md."*

**Still one occurrence — still too early for a method.md rule**, and the fact that logtech will not continue does not change that math. One data point asking to become a rule because the source that might have supplied a second one dried up is exactly the over-fit this method's "change only with pilot friction" discipline exists to prevent — the bar is real evidence, not "we can't check anymore, so let's decide now."

What logtech ending *does* change is the entry's own stated condition for revisiting it: "o restante do logtech" as an observation window no longer exists. The honest fix is not to promote the item, and not to drop it either — it is to keep the same question (does this pattern recur?) but stop tying its trigger to a project that cannot answer it. PARTE 2 proposes reframing the trigger as project-agnostic: the next occurrence in *any* project this method runs, not specifically logtech.

---

## PARTE 2 — Recomendações

Both items land as **watchlist triggers, not method.md text changes** — neither has enough evidence for a rule yet, and inventing one now would repeat exactly the mistake `friction-logtech.md`'s own commit-gate entry warned about elsewhere in this repo's history: writing a rule the evidence does not yet support. `notes/maintenance/WATCHLIST.md` Axis F already exists for precisely this shape — *"design questions a past audit found real but decided not to fix without more evidence... has the trigger condition been met."*

### Recommendation 1 — Axis F row: skill citation on task cards

**Traces to:** `friction.md`, `MINE`, 2026-08-13 (quoted above in full in PARTE 1).

**File:** `notes/maintenance/WATCHLIST.md`, appended to the existing Axis F table.

**Proposed row:**
```markdown
| Task cards don't name which installed/stored skill applies to them — STEP 5b's build step relies only on Claude's own description-based auto-trigger to notice a relevant skill exists | `friction.md`, MINE, 2026-08-13 | A real occurrence: a task's build step skips a skill that STEP 3b installed or `kit/my-method/skills-library/` already vetted as relevant to that exact task, and the gap is only caught after the fact | **Partly** — would surface as a future `/friction` entry in some project's `friction.md`; not independently observable from this repo alone, since no project has yet run STEP 3b with a skill a later task should have used |
```

**Saves:** the concern stays on record and gets re-asked the next time anyone reads the watchlist, instead of depending on someone remembering a `/clear`-separated conversation.

**Costs to implement:** one table row.

**What is lost:** nothing — no behavior changes; this only makes sure the question is asked again later, with real evidence, instead of forgotten.

**Rollback:** delete the row.

### Recommendation 2 — Axis F row: functional/visual task separation, trigger reframed project-agnostic

**Traces to:** `friction-logtech.md`, `MINE`, 2026-08-12 (quoted above in full in PARTE 1); already evaluated once in `notes/proposals/logtech-friction-proposal-2026-08-13.md` (see "Before PARTE 1", above).

**File:** `notes/maintenance/WATCHLIST.md`, appended to the existing Axis F table.

**Proposed row:**
```markdown
| Task cards don't distinguish "functional" from "visual polish" work — a task can ship functionally correct but visually unstyled, with no flag that polish is a separate later task | `friction-logtech.md`, MINE, 2026-08-12 (one occurrence, TASK-004); original trigger ("o restante do logtech") is now unreachable — logtech will not continue, reframed here project-agnostic | A second, independent occurrence of the same pattern in **any** project this method runs — not specifically logtech | **Partly** — would surface as a future `/friction` entry in that project's `friction.md`; ask the user when noticed |
```

**Saves:** the question the entry's own author asked to keep open ("regra fixa ou prática recomendada?") stays open and answerable, instead of being silently closed just because logtech ended.

**Costs to implement:** one table row.

**What is lost:** nothing — no behavior changes.

**Rollback:** delete the row.

---

## Approval

Both recommendations are independent and separately vetoable; neither depends on the other. On approval, apply in the order listed (Recommendation 1, then 2) — both are additions to the same Axis F table, order only affects row position. No version bump: `WATCHLIST.md` is not one of the embedded copies (`start-project.md` carries method.md, the security matrix, the templates, and the verify skeleton — not the watchlist), so this is untouched by the byte-for-byte mechanical check that method.md changes require.

---

## Outcome (2026-08-13)

User's decision, verbatim: *"aplique a citação das skills e não aplique a parte de separar as tarefas. aplique também que, em todos os casos em que haja mudança de layout, por menor que seja, a skill frontend-design deve ser chamada."*

- **Recommendation 1 — applied.** The exact row proposed above was added to `notes/maintenance/WATCHLIST.md` Axis F.
- **Recommendation 2 — not applied, fully skipped.** No row added, no method.md change. `friction-logtech.md`'s task-separation entry stays exactly as processed by v9: evaluated, its own deferral honored, nothing further.

## Applied beyond this proposal — mandatory `frontend-design` invocation on layout changes

Not one of this proposal's two recommendations — a fresh, direct instruction given in the same turn as the decision above, applied immediately rather than going through its own proposal cycle, since it does not touch `method.md`'s canonical text or its embedded copies (no version bump needed).

**Provenance:** user directive, 2026-08-13, verbatim above. **Not friction-backed** — friction.md's 2026-08-13 entry named the general fragility ("confiar só no disparo automático por descrição") but stopped at "hipótese antecipada, não atrito observado," which is why PARTE 1 above only recommended a watchlist row for the general case. This specific, concrete rule for `frontend-design` is the user directly closing that gap for one skill, by explicit choice — a **conscious exception**, the same provenance class this repo has used before (v4/grilling, v7/model-effort): not derived from observed friction, its provenance recorded honestly rather than dressed up as one.

**What changed:** `kit/my-method/skills-library/frontend-design/SKILL.md` (provenance comment) and `kit/my-method/skills-library/README.md` (Contents entry) both now carry the same invocation rule: wherever this skill is deployed into a real project, any layout change, however small, must call it explicitly — keep `disable-model-invocation: true` on the deployed copy too, and have the project's `CLAUDE.md` plus any layout-touching task card instruct an explicit `/frontend-design` call. Nothing in `method.md` itself changed; the rule travels with the asset, not with the method's canonical text. Confirmed the plugin's own inventory is still untouched by this (`claude plugin details my-method`: 6 skills, unchanged) — the asset remains dormant.

**Open question, not resolved here:** this rule only takes effect once a real project's STEP 3b actually deploys this asset — `method.md` does not yet reference `kit/my-method/skills-library/` at all (noted already in the folder's own README). If this pattern (pre-vetted assets with attached deployment rules) proves useful, wiring STEP 3b to read from it — and to carry rules like this one into the deployed copy automatically — would need its own proposal, like any other `method.md` change.
