# Audit 04 — cost guidance (session 3 of the cost audit)

Builds on [[my-method-audit-series-rules]] / `notes/audit-04-cost-measurements.md` (session 1)
and `notes/audit-04-cost-waste.md` (session 2), both 2026-08-12. This session researches what
official Anthropic/Claude Code documentation recommends TODAY about context/cost efficiency,
via seven live-research subagents (one per topic/target, each fetching code.claude.com/docs
and, where named, Anthropic's own engineering blog), then compares every recommendation found
against this kit's actual practice. Nothing was built, changed, or installed. Every claim below
carries its own URL and access date (all 2026-08-12); anything not confirmable live is marked
NOT VERIFIED and excluded from recommendations.

---

## a) CLAUDE.md size and content

**Docs:** https://code.claude.com/docs/en/memory.md, https://code.claude.com/docs/en/best-practices.md,
https://code.claude.com/docs/en/context-window.md — all accessed 2026-08-12. Explicit,
repeated guidance: **"target under 200 lines per CLAUDE.md file. Longer files consume more
context and reduce adherence."** No token-count limit is stated, line count only. A table of
what belongs (build commands, code-style deltas, testing instructions, repo etiquette,
architectural decisions, env quirks, gotchas) versus what doesn't (anything Claude can read
itself, standard conventions, API docs — link instead, frequently-changing info, tutorials,
file-by-file descriptions) is given in best-practices.md.

**Kit:** `kit/my-method/templates/CLAUDE.md` is 69 lines — well under the 200-line target.
`method.md`'s own narration rules and the "what belongs" table are directionally consistent
with the doc's include/exclude split (project conventions and gotchas, not API docs or
tutorials).

**Divergence: none.** The kit already complies; this is a clean pass, not a finding.

---

## b) Skills/commands size, and description-vs-body cost

**Docs:** https://code.claude.com/docs/en/skills.md, https://code.claude.com/docs/en/context-window.md
— accessed 2026-08-12. "Keep SKILL.md under 500 lines. Move detailed reference material to
separate files." The `description` (+ `when_to_use`) field is truncated at 1,536 characters
combined, specifically "to reduce context usage." Body content is deferred: "a skill's body
loads only when it's used, so long reference material costs almost nothing until you need it."

**Kit:** of the six command files, five are well inside the 500-line guidance (friction 59,
where-am-i 43, health-check 133, next-task 145, update-method 242 lines — session 1's counts).
**`start-project.md` is 897 lines — roughly 1.8x the documented ceiling.** No entry in
`method.md`'s version notes or this repo's prior audits records a deliberate decision to exceed
it. Description fields are all well under the 1,536-char cap (largest, update-method, is ~110
tokens ≈ well under 400 chars).

**Divergence: `start-project.md`'s size — likely accidental, not deliberate.** No recorded
provenance for "this file may exceed the 500-line guidance." Session 1 already identified *why*
it's this large (four inline embeds, ~72% of its lines) and flagged that the embedding itself is
currently forced by a platform gap (§b of session 1) — but the *size guidance being exceeded* is
a separate, newly-confirmed fact this session adds: even setting aside whether the embeds could
be avoided, this file is now measurably outside official guidance, and nothing in the repo says
the kit chose that knowingly.

---

## c) When subagent delegation pays for itself

**Docs (official, code.claude.com):** https://code.claude.com/docs/en/sub-agents.md, accessed
2026-08-12: "Explore and Plan skip your CLAUDE.md files and the parent session's git status to
keep research fast and inexpensive. Every other built-in and custom subagent loads both." No
numeric task-size or token threshold for when delegation "breaks even" is stated anywhere on
this page.

**Docs (official, Anthropic engineering blog, not code.claude.com but Anthropic-authored):**
https://www.anthropic.com/engineering/multi-agent-research-system, accessed 2026-08-12: "Agents
typically use about 4× more tokens than chat interactions, and multi-agent systems use about
15× more tokens as chats." "Multi-agent systems require tasks where the value of the task is
high enough to pay for the increased performance" — qualitative, not a number.

Two third-party (non-Anthropic) sources were also consulted by the subagent and are recorded
here only to be explicitly excluded from anything citable: hatchworks.com and cloudzero.com blog
posts claiming similar multipliers. **Not Anthropic-authored — not used as a basis for any
finding below.**

**Kit:** `security-reviewer` is invoked once per task carrying REVIEW rows, ~1,200–2,400
tok/invocation (session 1, ESTIMATIVA) — order-of-magnitude consistent with the confirmed ~4x
single-subagent multiplier over a plain turn. Session 2 already found its three inputs
(REVIEW rows, file list, raw diff) load-bearing with nothing to cut.

**Divergence: none identified.** No numeric official threshold exists to diverge from — the
only guidance is qualitative ("value high enough"), and the kit's one-reviewer-per-task-with-
REVIEW-rows design already satisfies that qualitative bar per session 2's own check.

---

## d) Context window management: /clear, /compact, degradation signals

**Docs:** https://code.claude.com/docs/en/commands, https://code.claude.com/docs/en/best-practices.md,
https://code.claude.com/docs/en/prompt-caching.md, https://code.claude.com/docs/en/costs —
all accessed 2026-08-12.

- `/clear`: "Start a fresh conversation with an empty context window while preserving project
  memory... Use this when starting a genuinely new task or you want a clean slate."
- `/compact`: "Summarize the conversation to free up context space while continuing the same
  conversation... Use this when the conversation gets long but you want to maintain
  continuity."
- Degradation signal, explicit: "If you've corrected Claude more than twice on the same issue in
  one session, the context is cluttered with failed approaches."
- Subagents are separately recommended for context isolation during investigation, so verbose
  exploration doesn't pollute the main conversation.

**Kit:** `method.md` STEP 5d makes `/clear` mandatory after every single task, with a literal
end-of-turn instruction (added specifically because prose alone failed once in the pilot — see
method.md's own v2/v3 notes). This audit series itself reuses the same mechanism between its
four sessions (per [[my-method-audit-series-rules]]). `/compact` is never mentioned anywhere in
the kit.

**Divergence: `/compact` is unused — assessed as a consequence of a deliberate choice, not an
independent gap.** The doc's own framing is that `/compact` exists for sessions that get long
but need continuity; the kit's one-task-per-session + mandatory-`/clear` design is a stronger,
already-recorded mitigation that sidesteps the long-session-degradation problem `/compact`
would otherwise be needed for. This matches the doc's own `/clear` use case ("starting a
genuinely new task") more closely than it needs `/compact`'s use case. **Deliberate, with
recorded provenance** (method.md STEP 5d note).

---

## e) Model and effort level choice

**Primary target — the blog post:** https://claude.com/blog/claude-model-and-effort-level-in-claude-code,
published 2026-07-07, accessed 2026-08-12 (this repo's own maintenance audit had flagged it as
never opened — now read). Core recommendations: bigger models (Fable 5 / Opus 5) for subtle
bugs, unfamiliar domains, and architecture decisions requiring deep reasoning, or when a
smaller model is "confidently wrong" with full context; smaller models (Sonnet 5 / Haiku) for
routine, well-specified, mechanical work. Signal to raise effort: Claude skips files, avoids
running tests, or abandons work partway — "insufficient work depth rather than knowledge gaps,"
not a reason to switch model. Explicit principle: "no reason to pay for capability the task
doesn't need."

**Secondary — model-config docs:** https://code.claude.com/docs/en/model-config, accessed
2026-08-12. Effort levels low/medium/high/xhigh/max (max set varies slightly by exact model);
default is HIGH on every model except Opus 4.7 (XHIGH default). `low` reserved for short,
non-intelligence-sensitive tasks; `max` flagged as prone to overthinking, "test before adopting
broadly."

**Gap found:** no official task-type × model/effort matrix exists (no "for planning tasks use
X" table) — only the qualitative signals above.

**Kit:** `method.md` STEP 4's rule — "silence is the default: only when a task genuinely needs
something different from the user's current settings, write a `Model/effort:` line" — is
**already the same principle the blog post states explicitly** ("no reason to pay for
capability the task doesn't need"), and the kit's rule predates this session's reading of the
post (method.md v7, dated 2026-08-11, one day before the post was checked here). The `UP`
trigger firing on security REVIEW rows (per `notes/maintenance/WATCHLIST.md` axis D) also lines
up with the blog's "ambiguous/subtle-bug domains → bigger model" signal.

**Divergence: none.** Alignment is real and appears independently arrived at, not copied from
the post (the method.md rule predates this session's reading of it) — worth recording as a
confirmed-independently-correct design choice, not just a coincidence.

---

## f) Sweep for other documented efficiency mechanisms not used by this kit

**Docs swept:** code.claude.com/docs — skills, large-codebases, mcp, costs, best-practices,
model-config, prompt-caching — accessed 2026-08-12. 15 distinct mechanisms found beyond a–e:
prompt-cache invalidation rules, skills lazy loading (already covered under b), per-directory
CLAUDE.md on-demand loading, `claudeMdExcludes`, `Read` deny rules for vendored/generated code,
LSP-backed code-intelligence plugins, deferred MCP tool search, `alwaysLoad` MCP exemption,
threshold-based MCP loading, PreToolUse hook output-preprocessing, subagent delegation for
verbose operations (already covered under c), extended-thinking budget reduction
(`MAX_THINKING_TOKENS`), path-scoped rules (`.claude/rules/`), the auto-compact window
threshold env var, and `additionalDirectories` without CLAUDE.md loading.

**Applicability check against this kit, one by one:**
- Per-directory CLAUDE.md, `claudeMdExcludes`, Read-deny rules, code-intelligence plugins,
  deferred/`alwaysLoad`/threshold MCP loading, `additionalDirectories` — **not applicable at
  this kit's current scale.** These target large codebases, deep directory trees, or multiple
  MCP servers; my-method projects have one project-root CLAUDE.md (69 lines) and zero MCP
  servers (confirmed, session 1's `claude plugin details my-method` output: "MCP servers (0)").
  Correctly unused, not a gap.
- PreToolUse output-preprocessing (grep-before-context pattern) — **not applicable to this
  kit's own hook**, because session 1 already confirmed `verify-gate.ps1`'s allow path already
  emits empty stdout / zero tokens; there is no verbose output for this pattern to trim.
- Extended-thinking budget (`MAX_THINKING_TOKENS`) — **a lower-level lever than the kit needs.**
  The kit's own model/effort "silence by default" rule (topic e) already covers the same
  cost-avoidance goal at the effort-level granularity the user actually interacts with; adding a
  second, env-var-level control would duplicate a decision method.md already makes deliberately.
- Path-scoped rules (`.claude/rules/`) — **not currently needed**, since the kit's CLAUDE.md is
  69 of a possible 200 lines; worth remembering if a future project's CLAUDE.md approaches the
  limit, but not a present gap.

**Conclusion: the sweep found nothing that resolves an existing waste item beyond what a–e and
targets 1–2 already cover.** Every mechanism found is either already accounted for elsewhere in
this document or genuinely not applicable to a kit this size — this is a clean sweep, not an
overlooked opportunity.

---

## Target 1 — the hooks `if` field: CONFIRMED, exact syntax

Source: https://code.claude.com/docs/en/hooks (and the hooks-guide worked example), accessed
2026-08-12.

Exact confirmed syntax: **`"if": "Bash(git *)"`** — a permission-rule-syntax string, sibling
field to `type`/`command`/`args` inside a hook handler object, one level below `matcher`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "if": "Bash(git *)", "command": "..." }
        ]
      }
    ]
  }
}
```

Restrictions: only evaluated on tool-related events (`PreToolUse`, `PostToolUse`,
`PostToolUseFailure`, `PermissionRequest`, `PermissionDenied`); accepts exactly one permission
rule, no boolean composition.

**Sibling mechanisms in the same category, also confirmed live:** `timeout` (per-hook seconds
limit — the kit already sets this, 30s, in `hooks.json`), `async`/`asyncRewake` (background
execution without blocking), `disableAllHooks` (global off-switch), `once` (skill/agent
frontmatter only — runs once per session then is removed; does not apply to plain
`hooks.json` entries). Explicitly checked and confirmed absent: no debounce/rate-limit
mechanism, no per-hook individual disable, no event-type condition inside `if` itself.

**Kit:** `kit/my-method/hooks/hooks.json` (read this session) uses `"matcher": "Bash|PowerShell"`
only — no `if` field. Confirms session 2's finding exactly: the fix is documented, shipped, and
unused. **Divergence: accidental, not deliberate** — nothing in this repo's notes records a
reason to keep spawning `powershell.exe` for every non-`git commit` Bash/PowerShell call.
Adding `"if": "Bash(git commit*)"` (or similar, scoped to the gate's actual concern) would
remove the ~296ms spawn (session 1, measured) from the ~99% of calls that never needed the gate
open in the first place — session 2 already found no detectable loss from doing this.

---

## Target 2 — is the ~457-token always-on cost a mandatory platform mechanism?

**This is the load-bearing finding of this session — an open contradiction, not a closed
answer.**

Two facts, both confirmed live and independently checked this session:

1. **Docs:** https://code.claude.com/docs/en/skills.md (frontmatter reference table) and
   https://code.claude.com/docs/en/context-window.md (interactive walkthrough), both accessed
   2026-08-12. A skill/command with `disable-model-invocation: true` has its description
   **excluded from the startup "Skill descriptions" context block entirely** — "Description not
   in context, full skill loads when you invoke it." The walkthrough states explicitly: "Its
   description was not in the skill index at startup, so it cost zero context until this
   moment."
2. **Kit:** confirmed live this session (`grep -n "disable-model-invocation" kit/my-method/commands/*.md`)
   — **all six of this kit's commands already carry `disable-model-invocation: true`.**

**If (1) applies identically to plugin-sourced commands** (not just project-root skills — the
docs page's examples are not explicitly plugin-scoped), then the ~457-token "Always-on" figure
`claude plugin details my-method` reports (session 1, section a) is **not** the real per-session
context cost of this plugin. The real cost, for a session that invokes none of the six commands,
would be ~0 tokens — directly contradicting session 1's framing ("added to every session") and
session 2's ranking of this item as the **#2 highest-cost waste** in the whole audit ("~89% of
the always-on budget describes commands that session will not run").

**This session could not settle which reading is correct**, for two reasons this document is
recording rather than resolving:
- The docs' worked examples describe project-level skills; whether a *plugin's* commands are
  routed/loaded identically was never tested, only assumed to be the same mechanism.
- `claude plugin details`'s "Projected token cost: Always-on" output was never confirmed
  (neither in session 1 nor here) to already discount for `disable-model-invocation: true` — it
  may be a static per-component estimate that doesn't know about the flag at all, in which case
  it would over-report the true cost for exactly this kit's shape (all six commands using the
  flag).

**One concrete, cheap, unresolved next step (recording, not doing):** run `/context` inside a
real session with the my-method plugin enabled — before invoking any of its six commands — and
check whether the six command descriptions actually appear in the startup "Skill descriptions"
token count or not. This is the same kind of single empirical test as the 2026-08-11 T4 test
already used elsewhere in this repo to settle a different documented-but-contested question, and
it would convert this section from "contradiction, unresolved" to a measured fact.

**Consequence for session 4:** if the test comes back showing 0 cost, the #2-ranked item in
session 2's waste ranking should be removed or radically downgraded — it may not be a real cost
at all, only an artifact of how `claude plugin details` reports numbers. If it comes back
showing the ~457 tokens still load, the item stands as ranked and the platform-mechanism
question session 2 left as "NOT independently re-verified" becomes confirmed as a genuine fixed
cost with no escape hatch — the exact opposite conclusion, from the same test.

---

## Cross-reference against session 2's waste ranking

1. **`PLAN.md`/`STATE.md` growth (item f, no ceiling)** — no official guidance found addresses
   this; it's a kit-internal design question about what to track over a project's life, outside
   the scope of this session's documentation sweep.
2. **Always-on component menu, ~457 tok/session** — see Target 2 above: **possibly not a real
   waste item at all**, pending the one unresolved live test. The single biggest reframe this
   session produced.
3. **`start-project.md`'s full-tier matrix embed** — topic (b) adds a new, independent fact:
   the file also exceeds the documented 500-line skill-size guidance by ~1.8x, on top of
   session 1's finding about the embed itself being currently forced by a platform gap. Two
   separate problems compounding in the same file.
4. **Hook process-spawn, ~296ms per call** — Target 1: confirmed fix exists, exact syntax now
   known, unused. The most directly actionable item in the whole audit.
5. **`update-method` MODE 2 / `health-check` Probe 5** — no official guidance touches either;
   both remain kit-internal, small-impact findings from session 2.
6. **Triplicated narration rule** — no official guidance found on CLAUDE.md content duplication
   across command files specifically; remains an internal-consistency finding, not a documented
   anti-pattern.
7. **`security-reviewer` inputs** — topic (c) confirms: no official numeric threshold exists to
   check the inputs against, consistent with session 2's own finding that they're already
   near-minimal.

---

## Divergences found — deliberate vs. accidental, summarized

| Divergence | Deliberate or accidental | Basis |
|---|---|---|
| `start-project.md` at 897 lines vs. 500-line skill guidance | **Accidental** | No recorded decision anywhere in `method.md` or prior audits to exceed it |
| `hooks.json` missing the `if` field | **Accidental** | Session 2 already called this "an oversight rather than a deliberate tradeoff"; nothing here changes that read |
| Model/effort "silence by default" rule (STEP 4) | **Deliberate, and independently correct** | Matches the blog post's own stated principle; predates this session's reading of the post (method.md v7, 2026-08-11 vs. post accessed 2026-08-12) |
| One task per session + mandatory `/clear`, no `/compact` use | **Deliberate** | Recorded provenance in method.md STEP 5d's own version note (pilot bug fix); sidesteps the long-session problem `/compact` exists to manage |
| CLAUDE.md at 69/200 lines | **N/A — already compliant**, not a divergence | — |
| 15 other mechanisms (per-directory CLAUDE.md, MCP deferral, etc.) unused | **N/A — not applicable at this kit's scale** | Zero MCP servers, single-file 69-line CLAUDE.md, small codebase |

---

## Proposed WATCHLIST additions (compiled from all seven research files — proposal only, not applied)

| Source | URL | Why it matters | Re-check recipe |
|---|---|---|---|
| Claude Code Memory guide | https://code.claude.com/docs/en/memory.md | Sole documented size/content guidance for CLAUDE.md (200-line target), which every my-method project writes and auto-loads every session | Grep for "target under 200 lines", "Write effective instructions", "reduce adherence" |
| Skills reference — frontmatter table | https://code.claude.com/docs/en/skills.md | `disable-model-invocation: true` claimed to remove description from startup context entirely — directly decides Target 2 above if confirmed for plugin commands; also the 500-line/1,536-char size caps | Grep for "disable-model-invocation", "Description not in context", "1,536 characters", "under 500 lines" |
| Context window simulation | https://code.claude.com/docs/en/context-window.md | Interactive walkthrough claiming a `disable-model-invocation: true` skill "cost zero context until invoked" | Grep for "Skill descriptions", "tokens: 450", "cost zero context" |
| Subagents reference | https://code.claude.com/docs/en/sub-agents.md | Documents the Explore/Plan exception (skip CLAUDE.md + git status) as the only stated cost-saving lever for subagent startup cost | Grep for "Explore and Plan skip" |
| Anthropic engineering blog — multi-agent research system | https://www.anthropic.com/engineering/multi-agent-research-system | Only Anthropic-sourced token-multiplier figure (4×/15×) found for subagent cost | Re-fetch, grep for "4×" and "15×" |
| Commands reference | https://code.claude.com/docs/en/commands | Definitive source for `/clear`, `/compact`, `/autocompact` syntax | Confirm `/autocompact`'s version gate (currently v2.1.221+) |
| Costs guide | https://code.claude.com/docs/en/costs | "Why usage climbs in a long session"; PreToolUse output-preprocessing pattern; extended-thinking budget reduction | Re-read "Reduce token usage" and "Why usage climbs" sections |
| Best practices | https://code.claude.com/docs/en/best-practices.md | Degradation signal ("corrected twice"); subagent-for-context-isolation guidance | Re-check the "corrected Claude more than twice" quote |
| Prompt caching | https://code.claude.com/docs/en/prompt-caching.md | Cache-invalidator list (model/effort switches, MCP toggles cost more mid-session); file edits do NOT invalidate cache | Re-check the cache-invalidators list for additions/removals |
| Blog: Choosing a Claude model and effort level in Claude Code | https://claude.com/blog/claude-model-and-effort-level-in-claude-code | Canonical source for cost-optimization/model-selection reasoning; this repo's own maintenance audit had flagged it as never opened | Re-fetch, confirm publish date unchanged (2026-07-07), re-check "cost" and "routine" sections |
| Docs: Model configuration | https://code.claude.com/docs/en/model-config | Effort-level availability matrix and per-model defaults — v8 STEP 4/5a card lines name these values | Diff the effort-level table against what's recorded |
| Claude Code hooks reference — `if` field + siblings | https://code.claude.com/docs/en/hooks | `if` filters hooks by tool+args, avoiding a process spawn for non-matching calls — directly applicable to this kit's `hooks.json` `git commit` gate, currently unused | Grep for "if", "timeout", "async", "disableAllHooks", "once" |
| Large codebases guide | https://code.claude.com/docs/en/large-codebases.md | Per-directory CLAUDE.md lazy loading, `claudeMdExcludes`, Read deny rules, path-scoped rules, `additionalDirectories` — not applicable today, but relevant if project scale grows | Grep for "claudeMdExcludes", "on demand when it reads files there", "Read deny", "additionalDirectories" |
| MCP reference — tool search | https://code.claude.com/docs/en/mcp.md | Deferred-by-default MCP tool loading, `alwaysLoad` exemption, threshold config — not applicable today (0 MCP servers), relevant if that changes | Grep for "ENABLE_TOOL_SEARCH", "alwaysLoad" |

Not applied to `notes/maintenance/WATCHLIST.md` this session — proposal only, per this session's
own rules.
