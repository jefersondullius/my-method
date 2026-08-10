# Audit 01 — Gap analysis: my-method plugin vs WORKFLOW-TARGET.md

Session 1 of 4 · 2026-08-10 · Analysis only — nothing was built or installed.

Evaluated: the plugin as committed at `9a4f46c` (plus `WORKFLOW-TARGET.md` at `5667b0a`), against the 14 steps in `WORKFLOW-TARGET.md`. Files read in full: `method.md`, `kit/my-method/**` (manifest, 4 commands, 4 templates), `playbook/SECURITY-MATRIX.md`, `research/13-testing-strategy.md`, `CHANGELOG.md`, `friction.md`, `README.md`, `.claude-plugin/marketplace.json`.

Claude Code facts are cited from official docs, all accessed 2026-08-10:

- [S1] https://code.claude.com/docs/en/hooks — hook events; blocking semantics; output visibility; Windows execution; plugin `hooks/hooks.json`; skill-frontmatter hooks.
- [S2] https://code.claude.com/docs/en/slash-commands — served as the skills page ("Custom commands have been merged into skills"); frontmatter reference (`disable-model-invocation`, `model`, `effort`, `argument-hint`, `allowed-tools`, `hooks`); plugin command naming (`/my-plugin:command`).
- [S3] https://code.claude.com/docs/en/settings — permissions allow/ask/deny at user/project/local scope; `model` setting "read once at session start… To switch mid-session, use the /model command"; `effortLevel` written by `/effort`; hooks configurable in settings.
- [S4] https://code.claude.com/docs/en/commands — `/clear` ("Start a new conversation with empty context"), `/model`, `/effort` (`low`…`xhigh`, `max`/`ultracode` session-only) are built-in commands, "recognized at the start of your message" (i.e., typed by the user).
- [S5] https://code.claude.com/docs/en/plugins-reference — plugin components (skills/commands, agents, hooks, MCP, monitors); `${CLAUDE_PLUGIN_ROOT}`/`${CLAUDE_PLUGIN_DATA}`/`${CLAUDE_PROJECT_DIR}` substitutions for hooks/MCP/monitors.
- [L1] Local observation, this session, 2026-08-10: the harness's skill-invocation tool contract states built-in CLI commands (`/help`, `/clear`, …) are not invocable by the model; `/model` and `/effort` were run by the user as CLI commands.

Repo evidence is cited as: method.md notas (pilot post-mortems), CHANGELOG.md (test caveats), friction.md (research findings).

---

## Verdict table

| Step | Verdict | Mechanism / what is missing |
|---|---|---|
| 1 | GUARANTEED | User's own action; `start-project` safety check refuses an already-processed folder |
| 2 | GUARANTEED | Structural: command registered by plugin; `disable-model-invocation: true` |
| 3 | PARTIAL | No explicit idea-capture step or `argument-hint`; interrogation starts blind |
| 4 | PARTIAL | Fully specified in command body; zero enforcement (inherent) |
| 5 | PARTIAL | Gate specified with WAIT; no enforcement of the wait, no durable approval record |
| 6 | PARTIAL | Specified + STATE template slot "Stack and why"; nothing checks a reason was given |
| 7 | PARTIAL | Card field "Does it fit in one session?" exists; no sizing heuristic, no enforcement |
| 8 | PARTIAL | Fully specified incl. literal `/clear` text; no machine self-check of the artifacts |
| 9 | GUARANTEED | Structural: `next-task` exists with deterministic task-location procedure |
| 10 | ABSENT | No model/effort recommendation anywhere at task start (only in stuck protocol) |
| 11 | PARTIAL | Specified in command + both CLAUDE.md layers; style is un-hookable (inherent) |
| 12 | PARTIAL | Verify prose is strong; SECURITY-MATRIX wired to nothing; commit-on-red not blocked |
| 13 | PARTIAL | Same-pass sync + literal end text specified; the pilot already proved prose fails here |
| 14 | PARTIAL | `/clear` is user-typed by design; plugin contributes only the literal end texts |

---

## Step-by-step analysis

Format per step: verdict → enforcement level today → level it should sit at → cost → what breaks one level lower.

### Step 1 — empty folder, open Claude Code

**GUARANTEED** — it is the user's own action, outside any plugin's reach. The plugin's only exposure is being run in the *wrong* folder, and `start-project` opens with a safety check: if `method.md`, `SPEC.md`, `PLAN.md`, or `STATE.md` exists, stop and refuse to overwrite (instructional).

- Today: n/a (user action) + L3 safety check. Should: same. Cost: paid.
- One level lower: a re-run over an existing project could overwrite the spec/state — the safety check is the only thing standing there, and it is prose.

### Step 2 — type `/my-method:start-project`

**GUARANTEED** — structural. The command file exists (`kit/my-method/commands/start-project.md`), is registered via the local marketplace at user scope (README/CHANGELOG record), and is namespaced `/my-method:start-project` [S2]. `disable-model-invocation: true` means only the user's typing can trigger it — this restriction is enforced by the harness, not by model judgment [S2].

- Today: **L2** (correct). Should: L2. Cost: paid.
- One level lower (L3, no command): the entry point disappears; the user would paste method text into chat each session — section C of the target ("I only ever type two commands") collapses.

### Step 3 — describe the initial idea

**PARTIAL** — the command jumps from Step 0 (write files) to Step 1 (interrogation) and never instructs capturing the user's initial idea; there is no `argument-hint` to pass it with the command. In practice the model will ask — but the one step the whole interrogation anchors on is the only one not written down.

- Today: L3-implicit. Should: **L3** — one added instruction ("if the idea was not given with the command, ask for it in one line first") plus `argument-hint: <ideia em 1-2 frases>`. Cost: two lines in one file.
- One level lower (nothing): the first question ("quem usa isto?") refers to an "isto" nobody has named.

### Step 4 — relentless interrogation, one question at a time

**PARTIAL** — the behaviour is fully specified in `start-project` Step 1: one at a time, wait for each answer, recommendation embedded with suggested phrasing, the six minimum topics (exactly the target's list), follow-up rule for new decisions, stop rule. What is missing is enforcement — and none is possible: conversational cadence cannot be hooked or made structural.

- Today: **L3**. Should: **L3 — this is the ceiling.** Cost: paid. Mitigating factor: this always runs in a fresh session (project start), where instruction-following is at its strongest.
- One level lower (nothing): questions get bundled or topics silently skipped. Bundling is visible to the user; a *missing* topic is not — that residual risk is permanent and should be acknowledged, not engineered away.

### Step 5 — SPEC gate: stop and wait

**PARTIAL** — Gate 1 is specified: write `SPEC.md` (behaviour only, fixed structure), summarize in Portuguese, WAIT, iterate until explicit confirmation. Missing: (a) any enforcement of the wait; (b) any durable record that approval happened — nothing writes "approved" anywhere, so a later session cannot tell an approved spec from a draft.

- Today: **L3**. Should: **L3 + L4** — on confirmation, append an approval line to `SPEC.md` (e.g., `Approved: 2026-08-10`) and list it under STATE.md settled decisions. Cost: two lines in one command file.
- Optional L1: a PreToolUse hook denying writes to `PLAN.md`/`plan/**` while `SPEC.md` lacks the approval marker [S1]. Cost: hook script + project guard. Residual honesty: the hook enforces *ordering*, not truth — the marker itself is model-written. Not recommended until the Step-12 hook exists to share infrastructure.
- One level lower (L3 alone): CHANGELOG records that the "user asks for changes" path of both gates has never been tested, and method.md's own nota records the calculo-investimento pilot running questions→spec→stack→plan→first task in one 45-minute session. Gates pass at conversational speed and leave no trace.

### Step 6 — stack decided by Claude, reason recorded

**PARTIAL** — specified exactly as the target wants: decide alone, present in Portuguese with plain-language reasoning and the runner-up's cost, no gate; the reason lands in STATE.md via the mandatory "Stack and why" template slot (template comment: "reason it was chosen, not just the name"). Missing: nothing checks the slot received a reason rather than a name.

- Today: **L3**. Should: **L3 + L4** — the template slot *is* the evidence; an empty or name-only slot is visible to `/where-am-i` and to the next session. Cost: paid (slot exists).
- One level lower: name-only recording; three sessions later the decision gets reopened because nobody remembers why it was made — the exact failure the slot was designed against.

### Step 7 — plan of session-sized tasks; one question only

**PARTIAL** — `PLAN.md` index + per-task cards with five fields including "Does it fit in one session? If not, split now", and the verbatim single question "Você reconhece o seu produto nesta lista?" — all specified. Missing: (a) enforcement; (b) any operational definition of "fits" — the card asks the question but gives the model no proxy (scope, file count, verification rounds) to answer it against; (c) nothing prevents asking extra questions.

- Today: **L3**. Should: **L3 + L4** — the card field forces a written yes per task, so an oversized task is at least visibly declared, and the split obligation is anchored at planning time exactly as the target demands. Recommended cheap addition (method-consistent, since method.md Step 4 already mandates the field): sharpen the template comment with sizing proxies. Cost: one template comment.
- One level lower: an oversized task slips through → context fills mid-task → silent quality degradation — the one failure mode the user has stated they cannot detect. Deterministic enforcement is impossible here (future context use cannot be measured at plan time); the honest defense is aggressive splitting at L3 plus the stuck protocol at execution time.

### Step 8 — STATE.md, CLAUDE.md, git init, first commit, tell /clear

**PARTIAL** — fully specified: both files' full content is embedded in the command, `git init`, conditional `.gitignore`, ONE commit with an explicit staged-file list, then Step 6's literal text ("Rode `/clear` agora…"). Missing: a machine self-check that everything actually landed.

- Today: **L3**. Should: **L3 + L4** — end the command by displaying `git show --stat` raw output, so the user sees the commit and its file list with their own eyes (same visibility doctrine the method already applies to task verification). Cost: one line in one command file.
- One level lower: a missing STATE.md is discovered only in the *next* session, when `/next-task` has nothing to orient from — and the session that knew the answers is gone.

### Step 9 — fresh session, type `/my-method:next-task`

**GUARANTEED** — structural. The command exists, is user-only (`disable-model-invocation: true` [S2]), and section (a) gives a deterministic task-location procedure (first `pending` whose `depends-on` are all `done`; explicit behaviour for "all done" and "all blocked"; read only STATE.md, PLAN.md, and the one card). Honest caveat from CHANGELOG: a true fresh-session invocation through the real command parser has never been tested ("teste de sessão fresca pendente") — the structure is in place; its fresh-context behaviour is validation debt.

- Today: **L2** (correct). Should: L2. Cost: paid, minus the pending test.
- One level lower: the user must re-describe what to do from memory every session; the loop collapses.

### Step 10 — model/effort recommendation at task start

**ABSENT** — neither `next-task` nor the card template mentions model or effort at task start. The only mention in the whole plugin is the stuck protocol's option 2 (escalate *after* two failures). The target requires a recommendation at the START of every task, one interruption, user sets it.

Feasibility (this shapes the design):
- The agent cannot switch the session's model or effort. `/model` and `/effort` are built-in commands typed by the user [S4]; the `model` setting is "read once at session start… To switch mid-session, use the /model command" [S3]; built-ins are not model-invocable [L1]. **The target's design — recommend, then ask the user to press the button — is not a workaround; it is the only mechanism that exists.**
- Skill frontmatter `model:` and `effort:` exist [S2] but are turn-scoped: "applies for the rest of the current turn… the session model resumes on your next prompt" [S2]. `next-task` step (b) may ask a gate question, which ends the turn — the override would lapse exactly when building starts. Also static per command file, so it cannot vary per task. Not fit for this purpose.

- Today: **ABSENT**. Should: **L3 + L4** — add a sixth card field (recommended model + effort, decided at planning time by `start-project`, adjustable by `next-task` with one line of reasoning), and one added step in `next-task` (b): state the recommendation, ask the user to run `/model X` and `/effort Y`, wait. One button, at the start, never mid-task — exactly the target. Cost: one template field + ~10 lines across two command files + a method.md v4 line (see Recommendations — method.md does not currently contain this step either).
- One level lower (today's reality): every task runs on whatever was last set. This audit session itself started on leftover settings until the user changed them by hand. On a trivial task that is silent waste; on a hard task with a cheap model it is silent quality loss — invisible in both directions.

### Step 11 — narrate intent and consequence, in Portuguese

**PARTIAL** — specified three times over: `next-task` (c), the generated project CLAUDE.md's narration rules, and the user's global CLAUDE.md. Style cannot be hooked; L3 is the ceiling.

- Today: **L3**. Should: L3. Cost: paid.
- One level lower: mechanics noise — the lowest-risk gap on this list, because the failure is fully visible to the user and `/friction` exists precisely to log it.

### Step 12 — verification before done: functional, regression, security

**PARTIAL** — the general-verification prose in `next-task` (d) is the strongest instruction in the plugin: automated-first, raw output on screen, re-run every pre-existing check, any failure → task NOT complete, no status updates, no commit, stuck protocol. Two real gaps:

1. **SECURITY-MATRIX.md is wired to nothing.** `start-project` never triages the project's tier (the matrix's own precondition: "Triage the project first, using the answers already collected in Step 1"), cards never receive the applicable matrix rows in "How we will check it", and `next-task` never mentions the matrix. The target's step 12 explicitly requires "the security checks the task's risk surfaces require per playbook/SECURITY-MATRIX.md" — today, zero of that happens by any mechanism. Note: `method.md` itself does not reference the matrix either, so wiring it into the commands without touching `method.md` would violate the method's own rule ("do not add steps this method does not have"). The fix must start as a method.md v4 revision — flagged as a recommendation, not silently added.
2. **Nothing blocks a commit on red.** The no-commit-on-failure rule is prose. The v2/v3 pilots already demonstrated end-of-task instruction slippage under exactly this pressure (method.md nota 5c: the visual check was labeled "humana" without attempting automation until the user pushed).

- Today: **L3**. Should: **L1 + L4** — the one place in the whole workflow where a hook clearly pays:
  - **L4**: the verify run writes a machine-generated evidence file (e.g., `.claude/last-verify.json`: timestamp, commands run, pass/fail), committed with the task.
  - **L1**: a PreToolUse hook on Bash `git commit` — deny unless fresh pass evidence exists [S1: exit 2 or `permissionDecision: "deny"`]. Shipped in the plugin as `hooks/hooks.json` [S1], which runs wherever the plugin is enabled — since the install is user-scoped, the script must self-guard (no-op unless the cwd looks like a my-method project: `PLAN.md` + `STATE.md` present). Windows execution is documented: shell form runs via Git Bash (or PowerShell if absent), or explicit `"shell": "powershell"` [S1].
  - Cost: the largest of any recommendation — a verify-entrypoint convention that `start-project` must scaffold per project, one hook script (~100 lines, portable), guard logic, and a real test in a throwaway project. Escape hatch exists (`disableAllHooks` in settings [S3]), so a false block can never brick the user.
  - Residual honesty: the hook proves checks *ran and passed recently*; whether the checks are the *right* checks remains L3 judgment. Determinism narrows the lying window; it does not close it.
- One level lower (L3, today): "done" can be claimed without the regression re-run or with checks skipped — precisely the failure class the user cannot detect, and the one their own pilot history documents.
- NOT VERIFIED: how much raw tool output the interactive CLI shows the user before truncation — the evidential file plus `git show --stat` compensate regardless.

### Step 13 — update STATE.md + PLAN.md + card together, commit, tell /clear

**PARTIAL** — `next-task` (e) specifies the same-pass update of all three status files, one commit, and the literal end text. This step carries the method's own strongest admission: v2's emphatic prose already failed here twice in one pilot (PLAN.md left `pending` with STATE.md `done`; end text not emitted — method.md nota 5d). v3's answer was *more literal prose*. That is the correct cheap next move, but it is the same enforcement level that already failed.

- Today: **L3**. Should: **L4 now, cheap L1 later** — L4: one commit per task makes drift visible after the fact (`git show --stat` on the task commit shows whether all three files are in it; recommend displaying it as part of closing). L1 (only as a marginal add-on to the Step-12 hook): the same PreToolUse check verifies the staged set includes `STATE.md`, `PLAN.md`, and a `plan/TASK-*.md` when committing a task in a my-method project. Cost: ~15 extra lines in a script that already exists at that point.
- One level lower: state drift compounds across `/clear` boundaries — the next session trusts STATE.md as ground truth *because* it cannot see this conversation. A stale STATE.md is not a small bug in this method; it is corruption of the only memory the system has.

### Step 14 — user runs /clear; loop repeats

**PARTIAL** — `/clear` is a built-in the user types ("Start a new conversation with empty context" [S4]); the agent cannot run it [L1]. The plugin's entire contribution is prompting at the right moment: the two literal end texts (steps 8 and 13) and the structural re-entry via `/next-task`. That is the maximum available; no mechanism can force the user's `/clear`.

- Today: **L3** (the literal texts). Should: L3 — ceiling. Cost: paid.
- One level lower (no literal texts): the calculo-investimento pilot is the case study — commits prove zero `/clear` happened in the entire project (method.md Step 4 nota); context accumulated silently. The literal texts exist because of that failure. Residual: the pilot also showed the text can fail to be emitted (CHANGELOG caveat 2, with extenuating circumstances); a Stop-hook enforcement is technically conceivable [S1] but would require transcript inspection — disproportionate cost and fragility for what it buys. Not recommended.

---

## The honest two-column answer

**Deterministic or structural today (does not depend on in-session judgment):**

1. The four commands exist, and typing them injects their exact text (plugin install at user scope; harness behaviour).
2. Only the user can trigger them — `disable-model-invocation: true` is enforced by the harness [S2].
3. Only the user can run `/clear`, `/model`, `/effort` — built-ins are not model-invocable [S4][L1]. (A constraint more than a feature, but it does make section C's "I only type two commands" structurally clean.)
4. Git history: every commit that *did* happen is immutable evidence after the fact.

**Depends on Claude choosing to follow an instruction (everything else):**

The safety-check refusal; asking for the idea; one-question-at-a-time with embedded recommendations; actually WAITING at both gates; stack reasoning with runner-up cost; recording reasons, not names; task sizing and splitting; asking only the one plan question; the minimum-reading discipline ("open ONLY that card"); building only what the card says; running verification at all; automated-first; regression re-runs; showing raw output; **not committing on red**; the stuck-protocol stop after two failures; same-pass sync of the three status files; one commit per task; emitting the literal end texts; Portuguese; narration style; friction logged verbatim; `where-am-i` staying read-only.

**Bottom line:** the plugin currently has **zero Level-1 mechanisms** — no hooks, no permission rules (`kit/my-method/` contains no `hooks/` directory and no settings). Its hard guarantees are exactly two: commands fire only when typed, and git records what happened. Everything between the typing and the commit is the model choosing to obey — which the pilots show it *mostly*, not always, does. The method's own template CLAUDE.md already states the principle ("Anything that must happen reliably every time — that is a hook, not a rule someone has to remember to follow") without yet practicing it anywhere.

---

## Recommendations (ranked; nothing built — user approval required first)

1. **Wire SECURITY-MATRIX into the flow — method.md first.** Revise method.md (v4): Step 4 cards gain the applicable matrix rows per the project's tier; Step 5c includes them in verification. Then mirror in `start-project` (triage tier after Step 1, record it in STATE.md settled decisions, copy applicable rows into each card's "How we will check it") and `next-task` (d). Also update the method copy embedded verbatim inside `start-project.md` — the duplication trap friction.md already documents.
2. **One PreToolUse hook gating `git commit`** in my-method projects on fresh machine-written verify evidence + staged-set completeness (covers steps 12 and 13 at L1). Ship in plugin `hooks/hooks.json` with a project guard; scaffold the verify entrypoint from `start-project`. This is the single highest-value deterministic investment; everything else stays prose.
3. **Fill step 10 (ABSENT):** sixth card field with recommended model + effort; `next-task` (b) surfaces it and asks for the one button before building. Requires a method.md v4 line as well.
4. **Small L3/L4 patches:** idea-capture + `argument-hint` (step 3); approval marker in SPEC.md at Gate 1 (step 5); close `start-project` and `next-task` with raw `git show --stat` (steps 8/13); sizing proxies in the card template comment (step 7).
5. **Pay the validation debt:** run the pending fresh-session, real-parser test of `/next-task` (CHANGELOG caveat 1) before trusting step 9 beyond its structure.

## NOT VERIFIED (kept honest)

- `${CLAUDE_PLUGIN_ROOT}` failing to expand inside `commands/*.md` bodies — friction.md's 2026-08-10 research finding; documented contexts today are hooks/MCP/monitors [S5]; not re-verified against the current version in this session.
- Exact truncation behaviour of raw tool output shown to the user in the interactive CLI transcript.
- Whether skill-frontmatter hooks persist across the multiple user turns of one multi-turn command execution ("scoped to the component's lifetime" [S1] is ambiguous for this case) — relevant only if the cheap-variant hook placement is ever preferred over plugin `hooks/hooks.json`.
- Whether editing a settings file mid-session can change the active model — [S3] states the `model` key is read once at session start, implying no; not tested.
