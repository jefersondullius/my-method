# METHOD — v3 (post-retrospective)

*Nota (pt-BR): terceira versão, revisada depois de dois pilotos reais
(meu-organizador, depois calculo-investimento). Só mudou o que uma
entrada de friction concreta justificou — ver `friction.md` de cada
piloto. O resto do texto é idêntico às versões anteriores.*

## STEP 0 — BEFORE ANYTHING

1. Save this method's own text as a file in the project root (e.g.
   `method.md`) and commit it. Do this once per project, first thing.
2. Create `friction.md` in the project root, with two sections, `YOURS`
   and `MINE`, kept separate.
3. Create the `/friction` command if it does not already exist: it
   appends verbatim to the `MINE` section — the user's text, which
   task/step was in progress, what was just done immediately before —
   with no paraphrasing and no evaluation of the complaint.

*Nota (pt-BR): no piloto, o texto do método em si nunca foi salvo em
disco — existiu só dentro de conversas que depois levaram `/clear`.
Isso quebrava a própria regra de durabilidade que o método impõe ao
STATE.md, e só foi descoberto na retrospectiva, quando foi preciso
pedir o texto de volta ao usuário. Passo 0.1 fecha essa lacuna.*

## STEP 1 — QUESTIONS

Ask about the project one question at a time, in Portuguese, each with
your own recommendation embedded so the user can just agree when they
have no opinion. Continue until no decision is open. Cover at least:
who uses it, whether it stores anyone's personal data, whether it
needs login, whether it needs to be online, what language its end
users read, and what "finished" means for this project.

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
d) Sync EVERY status-bearing file in one commit — `STATE.md`, `PLAN.md`
   row, and the task's own card (`plan/TASK-XXX.md`) — not just
   `STATE.md`. Commit in English. **Then end the turn with exactly
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
