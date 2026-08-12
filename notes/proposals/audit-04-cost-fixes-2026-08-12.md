# PROPOSAL — audit-04 FAZER AGORA items 2 and 3, plus a WATCHLIST trigger

Status: **proposed, nothing applied.** Written 2026-08-12, same day as
`notes/audit-04-cost-plan.md` (session 4 of the cost audit) and
`notes/maintenance/LAST-CHECK.md`'s T2 entry, which already settled and
closed item 1 of the same FAZER AGORA list directly (a measurement, not
a kit change — no proposal needed for that one). This proposal covers
the two items from that list that **do** change files inside
`kit/my-method/`, plus one addition the user asked for separately: a
WATCHLIST trigger so `PLAN.md`'s unbounded growth (audit-04-cost-plan.md
item 4, "FAZER SE O CUSTO INCOMODAR") is not forgotten.

Nothing below has been applied. Each item states the exact change, what
it costs to make, what is lost if applied, and how to undo it if it
turns out wrong.

---

## Item 2 — `hooks.json`: add the `if` field, scoped to `git commit`

**Traces to:** `notes/audit-04-cost-plan.md` item 2; confirmed syntax
from `notes/audit-04-cost-guidance.md` Target 1
(`code.claude.com/docs/en/hooks`, accessed 2026-08-12).

**File:** `kit/my-method/hooks/hooks.json`

**Current:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash|PowerShell",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"${CLAUDE_PLUGIN_ROOT}/hooks/verify-gate.ps1\"",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**Proposed:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash|PowerShell",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(git commit*)",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"${CLAUDE_PLUGIN_ROOT}/hooks/verify-gate.ps1\"",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

One field added, nothing removed.

**Saves:** ~296ms wall-clock (measured, `notes/audit-04-cost-measurements.md`
section e) per Bash/PowerShell call, on the ~99% of calls that are not
`git commit` and today still spawn `powershell.exe` just to be told
"allow" with empty stdout. This is latency, not token/Pro-plan budget —
it makes the terminal feel faster, it does not raise the number of
tasks a day the plan allows.

**Costs to implement:** one line, already verified against the
documented worked example.

**What is lost:** nothing detected by session 2's check — the gate's own
logic (`verify-gate.ps1`) already allows every non-`git commit` call
immediately; a call that never reaches the gate today does not change
outcome by not spawning the process. **The one thing worth double-
checking before approval:** the `if` pattern must match every shape the
gate needs to see, including `git commit` invoked through a wrapper or
with a working-directory flag (e.g. `git -C some/path commit`). As
written, `"Bash(git commit*)"` matches a command line that starts with
`git commit`, but **would not** match `git -C x commit` if that shape is
ever used in this workflow. Grep of this repo's own command bodies
(`kit/my-method/commands/*.md`) shows every commit instruction is a
bare `git commit`, never `-C`-prefixed, so the pattern is believed
sufficient for this kit's own usage — but this is the one place a wrong
scope would silently create a gap in the "no credential in a versioned
file" enforcement, so it is called out rather than assumed correct.

**Rollback:** delete the `"if"` line. Single-field change, trivially
reversible, no data or history affected.

---

## Item 3 — `next-task.md`: delete the third copy of the narration rule

**Traces to:** `notes/audit-04-cost-plan.md` item 3;
`notes/audit-04-cost-waste.md` item 5 (`next-task.md` lines 64–65,
"redundância paga três vezes").

**File:** `kit/my-method/commands/next-task.md`, section `## c) Build`

**Current (lines 62–65):**
```
Build exactly what the card describes under "What concretely exists
when this is done" — nothing more, nothing the card did not ask for.
Narrate intent and consequence as you go ("isto existe para que X
funcione"), never mechanics ("agora vou abrir o arquivo").
```

**Proposed:**
```
Build exactly what the card describes under "What concretely exists
when this is done" — nothing more, nothing the card did not ask for.
Narrate intent and consequence as you go ("isto existe para que X
funcione").
```

Only the clause `, never mechanics ("agora vou abrir o arquivo")` is
removed — the instruction to narrate intent/consequence stays, since
that half is not duplicated anywhere else in this file.

**Saves:** tens of tokens per `/next-task` invocation, every session,
for the life of every project — small per instance, recurring forever
at zero ongoing cost to have removed.

**Costs to implement:** trivial, a partial-line edit.

**What is lost:** near-zero. The global `CLAUDE.md`
(`C:\Users\Jeferson\.claude\CLAUDE.md`) — *"Never narrate mechanics
('now I will open the file'). That is noise."* — and the project
`CLAUDE.md` every `/start-project` writes
(`kit/my-method/templates/CLAUDE.md`, "Narration rule" section,
near-identical wording) both auto-load at the start of the exact same
session in which `next-task.md`'s body would also load, with no
`/clear` between them. Session 2 already checked: there is no session
boundary here for a third copy to survive across, unlike the
model/effort or narration examples that do have one. If this
assumption turns out wrong in practice (a session where `next-task.md`
loads without either `CLAUDE.md` already in context), the rule would be
weaker there — worth watching for in `friction.md` entries, not
something this proposal can rule out with certainty from source
reading alone.

**Rollback:** re-add the deleted clause. Single-line change, trivially
reversible.

---

## WATCHLIST addition — a trigger to revisit `PLAN.md`'s uncapped growth

**Traces to:** `notes/audit-04-cost-plan.md` item 4 and
`notes/audit-04-cost-waste.md` item 1 — the one cost in the whole audit
with no ceiling, deliberately **not** proposed as a fix here (no design
for what replaces the full per-task read exists yet, and a wrong fix
risks the exact continuity `STATE.md`'s "if it's not in this file, it
doesn't exist" rule protects). This entry does not change behaviour —
it makes sure the question gets asked again at a concrete, observable
point, instead of the growth going unnoticed the way session 2 found it
had so far (no pilot project has ever reached a size where it would be
felt).

**File:** `notes/maintenance/WATCHLIST.md`

Every existing axis in that file (A–E) tracks an *external* URL/source
with a re-check recipe. This is not that — it is an internal, kit-only
design trigger, closer in shape to Axis C's DEFERRED-item table (an
Origin + Trigger + Observable-from-here row) than to a URL row. Proposed
as a new, small axis rather than forcing it into an existing one:

**Proposed addition, appended after Axis E:**

```markdown
## Axis F — Kit-internal cost items with a deferred revisit trigger

Not external sources; these rows are for design questions this audit
found real but decided not to fix without more evidence. Re-check means
"has the trigger condition been met — if so, this needs a real design
session," not "re-fetch a URL."

| Item | Origin | Trigger | Observable from this repo? |
|---|---|---|---|
| `PLAN.md` unconditional full-file read, no line cap (unlike `STATE.md`'s 80-line cap) | `notes/audit-04-cost-waste.md` item 1, `notes/audit-04-cost-plan.md` item 4 (2026-08-12) | Any real project's `PLAN.md` reaches **30 completed tasks** — chosen as a round number inside the linear-growth range session 1 already measured (ESTIMATIVA +700–900 tok by task 20; a 100-task project projected at ~5x that) | **Yes** — `PLAN.md`'s own line count / task-row count is readable directly from the project's repo, no other project's data needed |
```

**Saves:** nothing by itself — this is a tripwire, not a fix. Its value
is that the next maintenance run (`/my-method:update-method` axis E, or
any session that happens to read `WATCHLIST.md`) has a concrete,
checkable condition instead of having to remember an audit finding from
a `/clear`-separated session that no longer exists in context.

**Costs to implement:** trivial, one new table row in an existing file.

**What is lost:** nothing — this only adds a thing to check, it removes
no existing check and changes no command behaviour.

**Rollback:** delete the new axis section.

---

## What this proposal does NOT include

Item 1 of the FAZER AGORA list (`/context` empirical test) is not here
— it was run directly and its result recorded in
`notes/maintenance/LAST-CHECK.md`'s new T2 entry (2026-08-12), following
the same ad-hoc-test precedent as T1 and T4 in that same file. It needed
no proposal because it changed nothing in the kit; it only settled a
disputed number.

The FAZER SE O CUSTO INCOMODAR and NÃO FAZER items from
`notes/audit-04-cost-plan.md` are intentionally absent from this
proposal — the user asked specifically for the three FAZER AGORA items
plus the `PLAN.md` trigger, not the whole plan.

---

## Approval

On approval, apply in this order: item 2 (`hooks.json`), item 3
(`next-task.md`), the WATCHLIST addition — then record all three as
applied in `notes/maintenance/LAST-CHECK.md`'s next entry, and bump the
plugin's patch version per this repo's own convention for a kit-file
change (`kit/my-method/.claude-plugin/plugin.json`, `CHANGELOG.md`).
