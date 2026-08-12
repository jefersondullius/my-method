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

If the card carries a HUMAN DECISION security row that shapes how the
task is built (e.g. 3.2 auth library, 5.3 hosted checkout, 6.3 upload
storage, 10.3 new dependency), ask it here, as part of this same
single interruption — the row's question verbatim, in Portuguese.

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

## c) Build

Build exactly what the card describes under "What concretely exists
when this is done" — nothing more, nothing the card did not ask for.
Narrate intent and consequence as you go ("isto existe para que X
funcione").

## d) Verify — non-negotiable

Follow the card's "How we will check it".

- Attempt automated verification first, by running the verify
  entrypoint: `powershell -NoProfile -ExecutionPolicy Bypass -File
  scripts/verify.ps1`. If this task's card added automated checks
  (including AUTOMATED security rows), add them to `$checks` in
  `scripts/verify.ps1` as part of the task, BEFORE running it. Only
  say "verificação humana necessária" after a real attempt has
  failed, and say exactly what failed — never before even trying.
- Show the RAW OUTPUT of the verifying command on screen — the actual
  result, not a sentence describing it.
- Re-run every check that already existed for earlier `done` tasks in
  this project, not only the new one, so a regression is caught.
- Wherever possible, give the user something they can confirm with
  their own eyes, and state exactly what they should see.
- If any check fails: the task is NOT complete. Stop here. Do not
  update status files. Do not commit. Go to the Stuck Protocol below
  if this is the second consecutive failure of the same check.

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

## e) Close the task

Only after every check in (d) passes:

1. Update, in the same pass: the task's own card status to `done`,
   its row in `PLAN.md`, and `STATE.md` ("Tasks completed", "CURRENT
   TASK", and any new settled decision or thing that broke).
2. Commit all changed files together, in English — including
   `.claude/last-verify.json`: the commit gate requires it staged with
   the three status files, and denies the commit otherwise.
3. Run `git show --stat` on the task commit and show its RAW output
   on screen — the user sees directly that the card, `PLAN.md`,
   `STATE.md` and the verify evidence are all in the commit.
4. End the turn with exactly this text and nothing else:

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
