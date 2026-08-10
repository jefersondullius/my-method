---
description: Execute the next pending task of the project in the current directory — the only command typed to resume work on a project already underway.
disable-model-invocation: true
---

You are executing Step 5 (and, if needed, Step 6) of `method.md` for
the project in the current working directory. This command EXECUTES
the next task — it does not just report status. Follow the sequence
below in order. Do not skip a step, do not reorder them, do not add
steps.

## a) Locate the task — minimum reading

1. Read `STATE.md` in full.
2. Read `PLAN.md` in full — it is an index only, one line per task.
3. From `PLAN.md`, find the first task marked `pending` whose
   `depends-on` tasks are all `done`. If a `pending` task's
   dependencies are not all done, skip it and continue to the next.
4. If no such task exists:
   - If every task is `done`, tell the user in Portuguese that there
     is nothing pending and stop. Do not invent a task.
   - If pending tasks exist but all are blocked by unfinished
     dependencies, tell the user in Portuguese which task is next and
     what it is waiting on, and stop.
5. Open ONLY that one task's card, `plan/TASK-XXX.md`. Do not open any
   other card. Do not re-read `PLAN.md` line content the card already
   repeats.

## b) Tell the user, then gate

In at most 6 lines, in Portuguese, say: what is already done (from
`STATE.md`'s "Tasks completed"), which task comes now (ID + name),
and what will concretely exist when it finishes (from the card's
"What concretely exists when this is done").

If the card's content raises any question only the user can answer,
ask it now, before writing or changing anything — one interruption,
at the very beginning. Wait for the answer before proceeding to (c).
Do not raise questions mid-task once (c) has started.

## c) Build

Build exactly what the card describes under "What concretely exists
when this is done" — nothing more, nothing the card did not ask for.
Narrate intent and consequence as you go ("isto existe para que X
funcione"), never mechanics ("agora vou abrir o arquivo").

## d) Verify — non-negotiable

Follow the card's "How we will check it".

- Attempt automated verification first. Only say "verificação humana
  necessária" after a real attempt has failed, and say exactly what
  failed — never before even trying.
- Show the RAW OUTPUT of the verifying command on screen — the actual
  result, not a sentence describing it.
- Re-run every check that already existed for earlier `done` tasks in
  this project, not only the new one, so a regression is caught.
- Wherever possible, give the user something they can confirm with
  their own eyes, and state exactly what they should see.
- If any check fails: the task is NOT complete. Stop here. Do not
  update status files. Do not commit. Go to the Stuck Protocol below
  if this is the second consecutive failure of the same check.

## e) Close the task

Only after every check in (d) passes:

1. Update, in the same pass: the task's own card status to `done`,
   its row in `PLAN.md`, and `STATE.md` ("Tasks completed", "CURRENT
   TASK", and any new settled decision or thing that broke).
2. Commit all changed files together, in English.
3. End the turn with exactly this text and nothing else:

   > Tarefa concluída e commitada. Rode `/clear` antes de continuar.

   Do not offer to continue to the next task. Do not ask if the user
   wants to keep going. If another pending task exists, its 6-line
   introduction happens the next time `/next-task` is typed, in a new
   session.

## f) Stuck protocol

After TWO failed attempts at the same check, stop. Do not try a third
variation of the same idea. Write to `STATE.md`, under "Things that
broke once": what was tried, what failed, and the suspected cause. Do
not commit a partial task. Then give the user, in Portuguese, three
options with a recommendation:

1. Dividir a tarefa em partes menores.
2. Trocar de modelo ou aumentar o esforço e tentar mais uma vez.
3. Responder a uma pergunta específica que destrava o trabalho.
