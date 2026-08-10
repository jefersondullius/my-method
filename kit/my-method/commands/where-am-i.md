---
description: Summarize where the project stands right now — project, current task, settled decisions, next step. Read-only, changes nothing.
disable-model-invocation: true
---

You are answering "onde eu parei?" for the project in the current
working directory. This command is READ-ONLY: it executes nothing and
changes no file. Do not write, edit, or create any file. Do not run
any command that changes state (no git, no build, no test run).

## a) Read — minimum needed

1. Read `STATE.md` in full.
2. Read `PLAN.md` in full (index only).
3. Determine the current task:
   - If `STATE.md`'s "CURRENT TASK" section names a task ID, that is
     the current task.
   - If it says "none"/is empty, find the first task in `PLAN.md`
     marked `pending` whose `depends-on` tasks are all `done` — that
     is the next task, not yet started.
   - If every task in `PLAN.md` is `done` and "CURRENT TASK" is empty,
     there is no current or next task.
4. If a task was identified, open ONLY that task's card,
   `plan/TASK-XXX.md`. Do not open any other card.

## b) Summarize — in Portuguese, at most 8 lines

Say, in this order:

1. **Projeto**: one sentence, from STATE.md's "Project and goal".
2. **Tarefa atual**: the task ID + name; whether it is in progress or
   not yet started; and, from the card's "What concretely exists when
   this is done", what will exist once it finishes. If there is no
   current/next task, say so plainly.
3. **Decisões já fechadas**: the settled decisions from STATE.md that
   are relevant to the current task — not the whole list if it is
   long.
4. **Próximo passo concreto**: one concrete, actionable sentence —
   what to literally do next.

Do not add anything else: no recommendations beyond the next step, no
offer to start work, no questions. This command only orients — it
does not act.
