# PROPOSAL — method.md v4, STEP 1 revision (NOT applied)

Status: **proposal only. method.md is untouched.** The user approves this text before any
mirroring happens.
Approval: pending.

Provenance: derived from a deliberate technique comparison with the `grilling` skill
(Matt Pocock), audit session 2, 2026-08-10 — NOT from observed pilot friction. Decision
trail: `notes/audit-02-skills.md` (addendum), evidence `notes/research-skills/grilling.md`,
risk assessment done in-session before acceptance (bundled-question skips, blanket
agreement, answer misattribution; mitigations: critical block one-at-a-time, out-of-group
safeguard for critical classes, silent-assumptions list, Gate 1's written SPEC).
Provenance entry recorded in `friction.md` (YOURS, 2026-08-10) at the user's request.
The cadence change was chosen by the user with the "safeguard" option: critical classes
are never grouped, at any point of the interview.

---

## Diff summary

1. Header: `# METHOD — v3 (post-retrospective)` → `# METHOD — v4 (post-audit-02)`.
2. Top nota: records that v1–v3 changed only on concrete friction and that v4 makes the
   first deliberate exception, with provenance in friction.md. No other step changes.
3. STEP 1 — QUESTIONS: replaced in full (below). Everything else in method.md: unchanged,
   byte for byte.

## STEP 1 — current text (v3, REMOVED)

```markdown
## STEP 1 — QUESTIONS

Ask about the project one question at a time, in Portuguese, each with
your own recommendation embedded so the user can just agree when they
have no opinion. Continue until no decision is open. Cover at least:
who uses it, whether it stores anyone's personal data, whether it
needs login, whether it needs to be online, what language its end
users read, and what "finished" means for this project.
```

## STEP 1 — proposed text (v4, ADDED)

```markdown
## STEP 1 — QUESTIONS

Interview the user about the project in Portuguese, every question
carrying your own recommendation embedded so the user can just agree
when they have no opinion.

Open with the critical block, ONE question at a time, one message
each: does it run offline/local or online/hosted; does it need login;
does it involve payment; does it store other people's personal data.
Any question in these classes — money, other people's data,
access/login, hosting, legal exposure — is always asked alone,
whenever it comes up, even late in the interview.

After the critical block is settled, related questions MAY be grouped
in one message — small groups, answers separable one by one. Still
cover at least: who uses it, what language its end users read, and
what "finished" means for this project.

Three rules for the whole interview:
- Dependency order: never ask a question whose answer depends on an
  answer not yet given.
- Facts vs decisions: anything researchable, research yourself; only
  genuine decisions reach the user as questions.
- Silent assumptions: before closing, list anything you assumed
  without asking, for the user to confirm or correct.

Continue until no decision is open.

*Nota (pt-BR): revisão v4 — única mudança desta versão. Origem:
comparação deliberada com a skill "grilling" (Matt Pocock), auditoria
02 (2026-08-10), por decisão explícita do usuário — NÃO nasceu de
atrito observado em piloto; proveniência registrada em friction.md.
Aditivos: ordem por dependência, fato≠decisão, suposições silenciosas.
Cadência: bloco crítico um-por-vez ("pagamento" entra na lista mínima
nesta versão), depois agrupamento autorizado, com a salvaguarda de que
classes críticas nunca entram em grupo. O modelo de "rodadas" do
grilling não foi adotado; o Gate 1 (SPEC escrito) segue sendo a
confirmação final.*
```

## Top nota — proposed replacement (v4)

```markdown
*Nota (pt-BR): quarta versão. As três primeiras só mudaram o que uma
entrada de friction concreta justificou; a v4 abre uma exceção
consciente: o Step 1 foi revisado a partir de uma comparação deliberada
com a skill "grilling" (auditoria 02, 2026-08-10), por decisão do
usuário, com a proveniência registrada em friction.md. Nenhum outro
passo mudou.*
```

## Deliberately NOT adopted from grilling

- Frontier/rounds batching as the default cadence — replaced by: critical block strictly
  one-at-a-time + safeguard; grouping only after, and only for non-critical questions.
- A second end-of-interview "shared understanding" gate — Gate 1 (written SPEC approval)
  is already the stronger version of it.
- Its ❓/➡️ question format — the existing "Pergunta / Minha recomendação" phrasing avoids
  a format bug grilling's own docs admit.

## Mirror scope — after approval, in this order

1. `method.md` (repo root): apply exactly the blocks above.
2. `kit/my-method/commands/start-project.md`: BOTH copies — its operational "Step 1 —
   QUESTIONS" section AND the embedded method.md text (friction.md's 2026-08-10 entry
   names this duplication trap explicitly: check this file first on any v4).
3. `WORKFLOW-TARGET.md`: its verbatim sections must not be edited (its own rule); append a
   dated amendment note recording that the owner revised step 4's cadence on 2026-08-10,
   so audit sessions 3–4 measure against the real contract. Wording shown to the user at
   mirror time.
4. Existing pilot projects keep the v3 `method.md` frozen inside them — v4 applies to
   projects created after the mirror, not retroactively.
