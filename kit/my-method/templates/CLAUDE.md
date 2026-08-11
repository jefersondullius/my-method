# <PROJECT NAME>

<!-- One sentence: what this project does, from the user's point of view. -->

## Stack

<!-- Technology — reason it was chosen (from STATE.md Step 3). -->

Build: `<command>`
Run: `<command>`
Test: `<command>`

## Directory layout

```
method.md        the method this project follows (do not edit)
SECURITY-MATRIX.md  security checks for this project's tier (do not edit)
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
