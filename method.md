# METHOD — v6 (post-audit-03, D5)

*Nota (pt-BR): sexta versão. Esta mudança é lastreada em friction
observada — as notas 5c/5d registram verificação pulada/rotulada
"humana" sem tentativa e arquivos de status dessincronizados nos
pilotos — com desenho vindo da auditoria 01 (rec 2) e da auditoria 03
(D5), aprovado pelo usuário em 2026-08-11. Mudanças da v6: 5c ganha o
ponto de entrada de verificação (`scripts/verify.ps1`) que grava
evidência de máquina (`.claude/last-verify.json`); 5d passa a ser
travado por hook — commit sem evidência fresca de PASS, ou commit de
tarefa sem os três arquivos de status + evidência juntos, é NEGADO
deterministicamente. A v5 (wiring de segurança) permanece intacta.
Nenhum outro passo mudou.*

## STEP 0 — BEFORE ANYTHING

1. Save this method's own text as a file in the project root (e.g.
   `method.md`) and commit it. Do this once per project, first thing.
2. Create `friction.md` in the project root, with two sections, `YOURS`
   and `MINE`, kept separate.
3. Create the `/friction` command if it does not already exist: it
   appends verbatim to the `MINE` section — the user's text, which
   task/step was in progress, what was just done immediately before —
   with no paraphrasing and no evaluation of the complaint.
4. Save the security matrix's own text as `SECURITY-MATRIX.md` in the
   project root, next to `method.md`. Step 4 triages from it, cards
   cite its rows, and Step 5c re-opens it when the work turns on a
   risk surface the plan did not declare.

*Nota (pt-BR): no piloto, o texto do método em si nunca foi salvo em
disco — existiu só dentro de conversas que depois levaram `/clear`.
Isso quebrava a própria regra de durabilidade que o método impõe ao
STATE.md, e só foi descoberto na retrospectiva, quando foi preciso
pedir o texto de volta ao usuário. Passo 0.1 fecha essa lacuna.*

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

## STEP 2 — SPEC

Write what you understood to `SPEC.md`, in English, describing
BEHAVIOUR, not technology: what the thing does, from the point of view
of whoever uses it. Summarize it back in Portuguese and wait. This is
a real gate — the user can evaluate behaviour, not technology.

## STEP 3 — STACK

Decide the stack yourself. Present the decision already made, in
Portuguese, with plain-language reasoning and what the runner-up would
have cost. Do not ask the user to choose between things they cannot
evaluate. Write it into `STATE.md` with the reason, not just the name.

## STEP 4 — PLAN

Break the work into tasks. Write:
- `PLAN.md` — an index only: one line per task (ID, name, status,
  depends-on).
- `plan/TASK-XXX.md` — one card per task, five fields only: what
  concretely exists when done; how it will be checked, in a way the
  user can see or a command can prove; which files it touches; does
  it fit in one session (if not, split now); status.

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

Then ask exactly one question in Portuguese: "você reconhece o seu
produto nesta lista?" — confirming the product being built, not the
technical sequencing. **After this question is answered, end the turn
with the `/clear` instruction (see 5d's exact wording) before Step 5
of the first task begins.**

*Nota (pt-BR): no piloto calculo-investimento, perguntas (Passo 1),
SPEC, stack, plano e a execução da TASK-001 rodaram numa sessão só de
45 minutos — os commits provam que nenhum `/clear` real aconteceu no
projeto inteiro. O Passo 4 já termina numa pergunta ao usuário; era o
ponto de corte natural e não existia. Este passo fecha essa lacuna.*

## STEP 5 — ONE TASK PER SESSION

For each task:

a) Tell the user in at most 6 lines which task this is and what will
   exist when it ends.
b) Build it, narrating intent and consequence, never mechanics.
c) VERIFY — not negotiable: **attempt automated verification first**;
   only say "verificação humana necessária" after a real attempt fails
   (not before being asked to try), and say exactly what failed. Show
   the RAW OUTPUT of whatever proves it; re-run everything that
   already existed, not only the new check; give the user something to
   confirm with their own eyes wherever possible.
   Automated verification runs through the project's verify entrypoint
   (`scripts/verify.ps1`): it re-runs every accumulated check, prints
   the raw output, and records machine evidence at
   `.claude/last-verify.json` — the commit gate reads that file. A task
   that adds an automated check (including the card's AUTOMATED
   security rows) adds it to the entrypoint as part of the task; that
   is how a check joins the regression set.
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
d) Sync EVERY status-bearing file in one commit — `STATE.md`, `PLAN.md`
   row, and the task's own card (`plan/TASK-XXX.md`) — not just
   `STATE.md`. Commit in English.
   The staged set must include `.claude/last-verify.json` together
   with the three status files — the commit gate denies a task commit
   missing any of them, and denies any commit without fresh PASS
   evidence.
   **Then end the turn with exactly
   this text and nothing else:**
   > Tarefa concluída e commitada. Rode `/clear` antes de continuar.
   Do not offer to continue to the next task, do not ask if the user
   wants to keep going. If a next task exists, its 6-line intro (5a)
   is for the *next* session.

*Nota (pt-BR): 5c — no piloto, a checagem visual foi rotulada "humana"
sem tentar automatizar, e só foi tentada depois que o usuário pediu a
saída bruta. 5d — duas falhas distintas no mesmo piloto: (1) `PLAN.md`
ficou "pending" com `STATE.md` já "done" porque o passo só mandava
sincronizar `STATE.md`; (2) mesmo com 5d já marcado "não negociável" na
v2, a instrução de fim de turno não foi emitida — prosa enfática já
falhou uma vez em garantir execução, por isso 5d agora dá um texto
literal a copiar em vez de uma regra a interpretar.*

## STEP 6 — STUCK PROTOCOL

After TWO failed attempts at the same check, STOP. Do not try a third
variation of the same idea. Write to `STATE.md` what was tried, what
failed, and the suspected cause. Give three options in Portuguese with
a recommendation: split the task smaller, escalate model/effort and
retry once, or answer a specific question that unblocks the work.

## FILES THAT CARRY STATE

`STATE.md`, max 80 lines, updated at the end of every task. Sections:
project and goal in one sentence; stack and why; tasks completed (ID +
date, one line each); CURRENT TASK and the concrete next action;
settled decisions not to reopen; open questions waiting on the user;
things that broke once.

Rule at the top of `STATE.md`: if information exists only in this
conversation, it does not exist. Before any `/clear` it must be here.

## START

Begin at Step 0, then Step 1. Do not skip ahead. Do not add steps this
method does not have — if the urge shows up, that is friction: log it
and continue without it.
