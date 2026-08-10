---
description: Log a friction complaint verbatim to friction.md's MINE section — no paraphrasing, no evaluation, no defense.
disable-model-invocation: true
argument-hint: <texto da reclamação>
---

Everything typed after `/friction` is the verbatim complaint text —
call it TEXT. Do not paraphrase it, shorten it, correct its grammar,
translate it, or interpret it. Do not respond defensively, do not
explain or justify what happened, do not argue the point.

If TEXT is empty, ask in Portuguese, in one line, for the text to log
after `/friction`, then stop — do not guess at content.

## a) Gather the two context fields — from this session, not by asking

1. **Tarefa/etapa em andamento**: the task ID (and name) actually
   being worked on in this session right now. `STATE.md`'s "CURRENT
   TASK" is a hint if the project has one, but prefer what is actually
   happening in this conversation if it is more specific. If nothing
   task-shaped is in progress, write "sem tarefa corrente".
2. **Feito imediatamente antes**: one factual sentence describing the
   concrete action taken in this session right before this command was
   typed. Describe only what happened — no judgment of whether it was
   right or wrong.

## b) Append — verbatim, no evaluation

1. If `friction.md` does not exist in the project root, create it
   first with:
   ```
   # FRICTION

   ## YOURS

   ## MINE
   ```
2. Append to the end of the `## MINE` section (create that heading if
   the file exists but lacks it) a new entry in exactly this shape,
   using today's date:

   ```
   ### {YYYY-MM-DD} — {task ID or "sem tarefa corrente"}

   Feito imediatamente antes: {the one sentence from step a.2}

   Palavras do usuário (verbatim):

   > {TEXT, character for character, unmodified}
   ```
3. Save the file. Do not touch the `## YOURS` section. Do not commit.

## c) Confirm and continue

Reply with exactly one line, in Portuguese, confirming the entry was
logged (e.g. "Friction registrada em `friction.md`."). Then resume
whatever was in progress before this command was typed, exactly where
it left off. Do not ask if the user wants to continue. Do not
summarize the complaint back to them. Do not defend the prior action.
