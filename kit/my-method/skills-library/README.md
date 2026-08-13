# skills-library

Pre-vetted, ready-to-deploy skill copies, held OUTSIDE the plugin's own
skill surface on purpose — this folder is not named `skills/`, so
Claude Code does not scan it and nothing here is installed or active.
Confirmed dormant by `claude plugin details my-method` showing an
unchanged inventory (6 skills, same always-on token cost) after this
folder was added.

Each subfolder is a skill researched live and approved for storage in
`notes/research-skills/<name>.md`, copied verbatim from its upstream
source except for one added frontmatter line,
`disable-model-invocation: true` — so that if it were ever installed
as-is, it would only load on manual invocation, never on Claude's own
description-based trigger. The original license file travels with it.

**Purpose:** a future `method.md` STEP 3b run (search for a skill for
the decided stack) can copy a matching folder from here straight into
a project's `.claude/skills/<name>/` instead of re-fetching from the
internet — same vetted content, same license, already reviewed once.
`method.md` itself does not reference this folder yet; using it is an
implementation-time optimization, not a documented method step. If
this pattern proves useful across real projects, wiring STEP 3b to
check here first would need its own proposal and approval, like any
other method.md change.

## Contents

- `frontend-design/` — Anthropic, Apache 2.0. Zero external
  dependencies (no scripts/agents/hooks). Verified live 2026-08-10 and
  2026-08-13, see `notes/research-skills/frontend-design.md`.
  **Invocation rule (user directive, 2026-08-13, not friction-backed —
  a conscious exception, see `friction.md`'s own precedent for that
  class): in any project where this skill is deployed, any layout
  change, however small, must call it explicitly — do not rely on
  Claude's own description-based auto-trigger to notice.** Concretely:
  keep `disable-model-invocation: true` on the deployed copy too (not
  just this dormant one), and have the project's `CLAUDE.md` and any
  task card that touches layout instruct an explicit `/frontend-design`
  invocation before or during that work. This is the direct, structural
  answer to the same fragility named in `friction.md`, MINE,
  2026-08-13 ("em vez de confiar só no disparo automático por
  descrição, que é mecanismo frágil") — applied here immediately for
  this one skill, by explicit user instruction, rather than left on the
  watchlist like the general case (see Axis F in
  `notes/maintenance/WATCHLIST.md`).
