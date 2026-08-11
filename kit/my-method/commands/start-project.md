---
description: Start a brand-new project from an empty folder — questions, spec, stack, plan, and the first commit, all in one session. The entry point that runs before the first line of code.
disable-model-invocation: true
---

You are executing Step 0 through Step 4 of `method.md` for a NEW
project in the current working directory. This command DRIVES the
entire pre-code phase in one session — questions, spec, stack, plan,
and the first commit. Follow the sequence below in order. Do not skip
a step, do not reorder it, do not add steps this command does not
have.

All prose you write to the user is Portuguese (pt-BR). All file
content you write (file names, code, comments, commit messages) is
English, except user-facing strings inside those files, which are
Portuguese.

## Safety check — before anything

If `method.md`, `SPEC.md`, `PLAN.md`, or `STATE.md` already exists in
the current directory, STOP. Tell the user, in Portuguese, that this
folder already looks like a project this method was run on, and that
`/start-project` is only for a folder that has not been through this
yet. Suggest `/where-am-i` or `/next-task` instead. Do not overwrite
anything.

## Step 0 — before anything (method.md Step 0)

1. Write the file `method.md` in the project root with EXACTLY the
   content in the block below — this is the method's own text, byte
   for byte, so every project carries the same copy:

   ```markdown
   # METHOD — v4 (post-audit-02)

   *Nota (pt-BR): quarta versão. As três primeiras só mudaram o que uma
   entrada de friction concreta justificou; a v4 abre uma exceção
   consciente: o Step 1 foi revisado a partir de uma comparação deliberada
   com a skill "grilling" (auditoria 02, 2026-08-10), por decisão do
   usuário, com a proveniência registrada em friction.md. Nenhum outro
   passo mudou.*

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
   ```

2. Write `friction.md` in the project root with exactly:

   ```markdown
   # FRICTION

   ## YOURS

   ## MINE
   ```

3. The `/friction` command does not need to be created — it ships with
   this plugin and is already available as `/my-method:friction` in
   every project. Do not create a duplicate file for it.

Do not commit yet. Git is initialized once, together with the first
commit, in Step 5 below — there is nothing meaningful to version until
the spec and plan exist.

## Step 1 — QUESTIONS (method.md Step 1)

Interview the user about the project in Portuguese. Every question
carries your own recommendation, so the user can just agree if they
have no opinion — phrase it like "Pergunta: ... Minha recomendação: ...
(pode só confirmar se topar)."

Open with the CRITICAL BLOCK — one question at a time, one message
each, wait for the answer before the next:
1. Se precisa funcionar online/hospedado, ou se rodar só na máquina
   do usuário já resolve.
2. Se precisa de login/conta de usuário.
3. Se envolve pagamento — cobrar, receber ou repassar qualquer
   dinheiro de quem usa.
4. Se o projeto guarda dado pessoal de terceiros (nome, e-mail, foto,
   localização, o que for) — e de quem.

Any question in these classes — money, other people's data,
access/login, hosting, legal exposure — is ALWAYS asked alone, in its
own message, whenever it comes up, even late in the interview.

After the critical block is settled, related questions MAY be grouped
in one message — small groups, each question numbered and carrying its
own recommendation, so the user can answer item by item. Cover, at
minimum:
5. Quem usa isto (só você? outras pessoas? quantas, mais ou menos?).
6. Em que língua as pessoas que usam o produto vão ler a tela.
7. O que significa "pronto" para este projeto especificamente — o que
   precisa existir para você considerar a primeira versão utilizável.

Three rules for the whole interview:
- Dependency order: never ask a question whose answer depends on an
  answer not yet given.
- Facts vs decisions: anything researchable, research yourself; only
  genuine decisions reach the user as questions.
- Silent assumptions: before closing, list in Portuguese anything you
  assumed without asking, one line each, for the user to confirm or
  correct.

If an answer opens a new decision not on this list, ask about it too —
alone if it touches a critical class, grouped otherwise. Stop asking
once no decision is open — do not pad the list with questions that
have an obvious answer given what was already said.

## Step 2 — SPEC (method.md Step 2) — GATE 1

Write `SPEC.md` in the project root, in English, describing BEHAVIOUR
only — what the thing does from the point of view of whoever uses it,
never the technology it runs on. Structure it around the answers from
Step 1:

```markdown
# <Project Name>

<One sentence: what this is, for whom.>

## Who uses this

## What it does

<The concrete flows/features, from the user's point of view.>

## Data

<Personal data handled, if any — whose, and what fields. "None" if
Step 1's answer was none.>

## Access

<Login required or not.>

## Availability

<Must be online, or works offline.>

## Language

<Language end users read on screen.>

## Definition of done

<What "finished" means for this project — from Step 1's answer.>
```

Then summarize `SPEC.md` back to the user in Portuguese, in plain
language, and WAIT. This is a real gate: do not proceed to Step 3
until the user explicitly confirms the spec is right. If they ask for
changes, edit `SPEC.md` and summarize again — repeat until confirmed.

## Step 3 — STACK (method.md Step 3)

Decide the stack yourself — do not ask the user to choose between
options they have no basis to evaluate. Base the decision on what
`SPEC.md` actually requires (data storage needs, login, online
requirement, expected scale). Present it in Portuguese, already
decided:

- The technology chosen, in plain language (define any term the user
  has not seen yet, per the global language policy).
- Why it fits what `SPEC.md` asks for.
- What the runner-up option would have cost — in effort, money, or
  fragility — so the user understands the decision without needing to
  evaluate the alternatives themselves.

This is not a gate — do not wait for approval, just inform. Hold onto
the decision and its reasoning; it gets written into `STATE.md` in
Step 5, not before (there is no `STATE.md` yet).

## Step 4 — PLAN (method.md Step 4) — GATE 2

Break the work into tasks and write:

- `PLAN.md` — index only, one line per task:
  ```markdown
  # PLAN

  <!-- TASK-001 — name — pending — depends-on: none -->
  ```
- `plan/TASK-XXX.md` — one card per task, exactly these five fields,
  nothing else:
  ```markdown
  # TASK-XXX — <name>

  ## What concretely exists when this is done

  ## How we will check it

  ## Files it touches

  ## Does it fit in one session?

  ## Status

  pending
  ```

If any task would not fit in a single session, split it into more
tasks now, at planning time — do not defer the split to when
`/next-task` reaches it.

Then ask exactly this one question, in Portuguese, and nothing else:

> Você reconhece o seu produto nesta lista?

This confirms the *product* being built, not the technical sequencing
of tasks — the user has no basis to approve or reject task order. If
they say no or ask for changes, revise `PLAN.md` and the cards and ask
again. WAIT for a yes before Step 5.

## Step 5 — finalize project files, git, first commit

Only after Gate 2 is confirmed:

1. Write `CLAUDE.md` in the project root:
   ````markdown
   # <Project Name>

   <One sentence: what this project does, from the user's point of view — same as SPEC.md's opening line.>

   ## Stack

   <Technology chosen in Step 3 — reason it was chosen.>

   Build: `<command, or "n/a" if none>`
   Run: `<command>`
   Test: `<command, or "n/a" if none yet>`

   ## Directory layout

   ```
   method.md        the method this project follows (do not edit)
   friction.md       YOURS / MINE — friction log, appended verbatim
   SPEC.md           behaviour spec, agreed with the user
   STATE.md          project memory — read this first, every session
   PLAN.md           task index only — one line per task
   plan/TASK-XXX.md  one card per task
   .claude/skills/   procedures (see "What does NOT go here" below)
   ```

   ## LANGUAGE POLICY

   - ENGLISH: all file names, folder names, code, comments, git messages,
     config files.
   - PORTUGUESE (pt-BR): every message, question, summary, and narration
     written to the user.
   - User-facing strings inside English files are Portuguese, marked
     `# user-facing (pt-BR)`.
   - Never translate a technical identifier into Portuguese.

   ## Narration rule

   - Before a block of work: one plain sentence on what is about to
     happen and why.
   - When a file is created or changed: one line on what it is for.
   - When done: what changed in practice for whoever will use the
     product.
   - Never narrate mechanics ("now I will open the file"). That is
     noise.

   ## Security — non-negotiable

   - No key, password, or token ever goes into a versioned file.
   - Never ask the user to paste a credential into the chat — teach them
     to use an environment variable instead.
   - Before installing any third-party package, say what it is and why
     it is needed; if a credential is already found in a file, stop and
     alert the user before continuing.

   ## Where things live

   State is in `STATE.md`. Task index is in `PLAN.md`. Task cards are in
   `plan/`. Start a session with `/next-task`.

   ## What does NOT go in this file

   - Procedures — those are skills, not text here.
   - Anything that must happen reliably every time — that is a hook, not
     a rule someone has to remember to follow.
   - Anything that changes as work progresses — that belongs in
     `STATE.md`, not here. This file describes what stays true for the
     life of the project; `STATE.md` describes what is true right now.
   ````
   (Fill the two `<...>` lines and the three commands; keep everything
   else verbatim — this section text is shared across every project
   this method runs on.)

2. Write `STATE.md` in the project root:
   ```markdown
   # STATE

   > Rule: if information exists only in the conversation, it does not
   > exist. Before any `/clear` it must be here.

   ## Project and goal

   <One sentence — same as CLAUDE.md's opening line.>

   ## Stack and why

   <Technology — reason, from Step 3's decision. One line each if more than one technology.>

   ## Tasks completed

   <Empty — nothing is done yet.>

   ## CURRENT TASK

   TASK-001 — <name>. Next action: run `/next-task`.

   ## Settled decisions

   <Key answers from Step 1 and the SPEC/stack decisions from Steps 2-3 that should not be reopened without new information.>

   ## Open questions

   <Empty, unless something genuinely remains unresolved.>

   ## Things that broke once

   <Empty.>
   ```

3. Run `git init` if the directory is not already a git repository.

4. Only if the stack chosen in Step 3 produces files that must never be
   versioned (dependency folders, build output, local files holding
   secrets), write a minimal `.gitignore` listing exactly those — no
   generic boilerplate beyond what this stack actually produces.

5. Stage `method.md`, `friction.md`, `SPEC.md`, `STATE.md`, `CLAUDE.md`,
   `PLAN.md`, `plan/*.md`, and `.gitignore` if created, and make ONE
   commit, in English, e.g.:
   ```
   Initialize project: spec, stack, plan
   ```

## Step 6 — close

Tell the user, in Portuguese, in a few lines: the project was
initialized, how many tasks are in the plan, and what TASK-001 is.
Then say, and mean literally:

> Rode `/clear` agora. Na próxima sessão, digite `/next-task` para
> começar a primeira tarefa.

Do not start Step 5 of `method.md` (building TASK-001) in this
session — that belongs to `/next-task`, in a fresh session.
