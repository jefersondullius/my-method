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
