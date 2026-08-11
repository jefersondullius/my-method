# PROPOSAL — method.md v6, verify-evidence commit gate (D5 / audit-01 rec 2)

Status: **proposed, awaiting the user's approval of this text. Nothing applied.**
Requested by the user on 2026-08-11 ("Escreva a proposta do D5 antes de aplicar").

Provenance — this change is **friction-backed, not an exception**: the pilots
recorded exactly the failure class it closes (method.md notas 5c/5d — visual
check labeled "humana" without attempting automation; PLAN.md left `pending`
with STATE.md `done`; the end-of-turn text not emitted despite emphatic prose).
Design lineage: audit-01 step-12/13 findings + recommendation 2 (the one L1
investment), audit-03 verdict D5 (deliberately left out of the v5 proposal so
its cost would be approved separately). Hook mechanics below were re-verified
LIVE against official docs by a subagent on 2026-08-11 (section "Verified
contract"); the friction.md provenance entry ships in this proposal's commit.

What D5 buys, in one sentence: today, "do not commit on red" and "sync the
three status files" are prose (L3) plus after-the-fact evidence (L4); this
proposal makes them **deterministic** (L1) — a hook denies the commit itself.

---

## The two pieces

- **L4 — evidence convention.** Every project gets a single verify entrypoint,
  `scripts/verify.ps1`, scaffolded at project creation. It runs EVERY
  accumulated automated check (tests, AUTOMATED security rows), prints raw
  output, and writes machine evidence to `.claude/last-verify.json`
  (timestamp, current HEAD, pass/fail, per-check exit codes). Checks
  accumulate: a task that adds a check adds a line to the entrypoint as part
  of the task — this is what makes "re-run everything that already existed"
  structural instead of remembered.
- **L1 — the gate.** The plugin ships a PreToolUse hook on `Bash|PowerShell`
  that intercepts `git commit` and DENIES it in a my-method project unless
  the evidence file exists, parses, says `pass: true`, was recorded on the
  current HEAD, and is at most 60 minutes old; task commits must additionally
  stage `STATE.md`, `PLAN.md`, a `plan/TASK-*.md`, and the evidence file
  together (audit-01's step-13 add-on). Everything else — non-commit
  commands, non-my-method folders, a repo with zero commits (the
  `start-project` first commit) — passes untouched.

## Verified contract (live research, one subagent, 2026-08-11)

Subagent's five-line summary:

> PreToolUse stdin carries `tool_name` ("Bash" or "PowerShell"),
> `tool_input.command`, and `cwd`. Blocking: exit code 2 (stderr → Claude) or
> JSON stdout `hookSpecificOutput.permissionDecision` "deny"/"allow"/"ask"/
> "defer" + `permissionDecisionReason`. Plugin hooks live in `hooks/hooks.json`
> at plugin root; matcher is a regex over tool names; `${CLAUDE_PLUGIN_ROOT}`
> expands in hook commands. Windows runs hooks via Git Bash (PowerShell
> fallback), with per-hook `"shell"` override and `"timeout"` (seconds,
> default 600). `disableAllHooks` disables all hooks; PowerShell is a distinct
> tool, so matchers need `"Bash|PowerShell"`.

Claims this proposal builds on (all accessed 2026-08-11):

1. Stdin fields `tool_name`, `tool_input.command`, `cwd` —
   https://code.claude.com/docs/en/hooks.md
2. Deny via JSON stdout `hookSpecificOutput.{hookEventName,
   permissionDecision: "deny", permissionDecisionReason}`; reason is shown to
   Claude — https://code.claude.com/docs/en/hooks.md
3. Plugin hook file `hooks/hooks.json` at plugin root; structure
   `{"hooks": {"EventName": [{"matcher", "hooks": [...]}]}}`; matcher is
   regex; `${CLAUDE_PLUGIN_ROOT}` expands in hook commands —
   https://code.claude.com/docs/en/plugins.md,
   https://code.claude.com/docs/en/hooks-guide.md
4. Windows: hooks run via Git Bash, PowerShell fallback if absent
   (https://code.claude.com/docs/en/tools-reference.md); per-hook `"shell"`
   field and `"timeout"` in seconds, default 600
   (https://code.claude.com/docs/en/hooks.md)
5. `disableAllHooks` accepted at user/project/local/managed scope —
   https://code.claude.com/docs/en/settings.md
6. PowerShell is a distinct tool on Windows; PreToolUse matchers need
   `"Bash|PowerShell"` — https://code.claude.com/docs/en/tools-reference.md
7. Recent change that strengthens this gate: PreToolUse now fires **before
   all permission-mode checks, even `bypassPermissions`** —
   https://code.claude.com/docs/en/whats-new. (The new `if` field for
   filtering tool calls exists there too; its syntax was not verified and is
   NOT adopted in this proposal.)

---

## Design decisions made in this proposal

Each can be vetoed independently.

1. **Evidence file:** `.claude/last-verify.json`, written ONLY by the verify
   entrypoint, **committed with the task** (auditable L4 trail; the gate
   requires it staged in task commits). `start-project`'s `.gitignore` step
   gains a rule: never ignore this file (if a stack ignores `.claude/`, add
   the exception `!.claude/last-verify.json`).
2. **Freshness = same HEAD + ≤ 60 minutes.** HEAD binding stops cross-task
   staleness (HEAD changes at every task commit); the 60-minute window covers
   the verify → status-file-update → commit gap of one session. Honest hole,
   kept from audit-01's framing: code edited AFTER a pass, same HEAD, within
   the window, commits without re-verify — the hook narrows the lying window,
   it does not close it.
3. **Hook script in PowerShell 5.1** (`powershell.exe`, present on every
   Windows 10/11), invoked explicitly as
   `powershell -NoProfile -ExecutionPolicy Bypass -File ...` so it behaves
   identically whether the harness shell is Git Bash or the PowerShell
   fallback (claim 4). Native JSON parsing, zero dependencies. Portability to
   a future non-Windows machine is future work, stated in CHANGELOG at apply
   time.
4. **Matcher `"Bash|PowerShell"`** — PowerShell is a separate tool on Windows
   (claim 6); gating only Bash would leave a trivial hole.
5. **Asymmetric failure.** Anything that is not "a `git commit` in a
   my-method project with ≥1 commit" allows (exit 0) — including any
   unexpected error during detection, so a script bug can never block normal
   work. Once a gated commit IS identified, every failure path DENIES
   (fail-closed), including unexpected gate errors. Deny uses the JSON
   `permissionDecision` form (claim 2) with a reason that states the correct
   next action.
6. **No model-reachable bypass.** No env var, no flag, no magic commit
   message. The only escapes are user-typed: fix the verify, or
   `disableAllHooks` in settings (claim 5). An env-var escape would collapse
   the guarantee — the model could set it inline in the same command.
7. **Initial-commit exemption** by `git rev-parse HEAD` failing (zero
   commits) — `start-project`'s Step 5 first commit passes with no evidence,
   by design.
8. **Strictness: every post-initial commit needs fresh pass evidence.** The
   completeness check (four files staged together) applies only when the
   staged set touches any status file (`STATE.md`, `PLAN.md`,
   `plan/TASK-*.md`) — the deterministic proxy for "this is a task commit".
   Consequence, accepted: an ad-hoc non-task commit (e.g. a friction.md
   append) also needs a fresh `VERIFY: PASS` first — cheap, and the method's
   own doctrine is one commit per task anyway.
9. **Project guard = `method.md` AND `PLAN.md` AND `STATE.md` present in
   cwd.** This repo itself has no root `PLAN.md`/`STATE.md` → never gated.
   The existing pilots DO match the guard and lack `scripts/verify.ps1`, so
   their next commit will be denied until the entrypoint is bootstrapped
   there (the deny reason says exactly that). Alternative (vetoable): also
   require `scripts/verify.ps1` to exist in the guard — old pilots would
   no-op, but then a new project where scaffolding silently failed would be
   ungated; protection was chosen over convenience.
10. **The gate does not re-run checks.** It trusts the entrypoint-written
    evidence. Re-running at commit time would double cost and duplicate the
    runner of record; the L3 residue (are the checks the RIGHT checks; is the
    evidence honest) is stated in "What this does NOT guarantee".

---

## Changes, file by file — exact text

### 1. NEW — `kit/my-method/hooks/hooks.json`

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

### 2. NEW — `kit/my-method/hooks/verify-gate.ps1`

```powershell
# PreToolUse gate for my-method projects (method.md v6, D5).
# Denies `git commit` unless fresh pass evidence exists and, for task
# commits, the staged set is complete. Allows everything else: other
# commands, non-my-method folders, repos with zero commits (the
# start-project first commit), and any error while still detecting.
# Once a gated commit is identified, failures DENY. User-only escape:
# "disableAllHooks" in settings.

$ErrorActionPreference = 'Stop'

function Allow { exit 0 }
function Deny([string]$reason) {
    @{
        hookSpecificOutput = @{
            hookEventName            = 'PreToolUse'
            permissionDecision       = 'deny'
            permissionDecisionReason = $reason
        }
    } | ConvertTo-Json -Depth 3 -Compress | Write-Output
    exit 0
}

# ---- detection: any failure here allows (fail-open) ----
$headProbe = $null
try {
    $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
    if ($payload.tool_name -ne 'Bash' -and $payload.tool_name -ne 'PowerShell') { Allow }
    $cmd = [string]$payload.tool_input.command
    if (-not $cmd) { Allow }
    if ($cmd -notmatch '(?i)\bgit\b[^\r\n;|&]{0,200}?\bcommit\b') { Allow }
    if ($payload.cwd) { Set-Location -LiteralPath $payload.cwd }
    if (-not ((Test-Path 'method.md') -and (Test-Path 'PLAN.md') -and (Test-Path 'STATE.md'))) { Allow }
    $headProbe = cmd /c "git rev-parse HEAD 2>nul"
    if ($LASTEXITCODE -ne 0) { Allow }   # zero commits: the first commit is exempt
} catch { Allow }

# ---- gate: from here on, failures deny (fail-closed) ----
try {
    $evPath = '.claude/last-verify.json'
    if (-not (Test-Path -LiteralPath $evPath)) {
        Deny ('my-method commit gate: no verify evidence at {0}. Run the verify entrypoint (scripts/verify.ps1) and commit only after it prints VERIFY: PASS. If this project predates method v6, create scripts/verify.ps1 per the method first.' -f $evPath)
    }
    try { $ev = Get-Content -Raw -LiteralPath $evPath | ConvertFrom-Json }
    catch { Deny 'my-method commit gate: verify evidence is unreadable JSON. Re-run scripts/verify.ps1.' }
    if ($ev.pass -ne $true) {
        Deny 'my-method commit gate: the last verify run FAILED. Fix the failure, re-run scripts/verify.ps1, and commit only on VERIFY: PASS. Do not commit on red.'
    }
    $head = ([string]$headProbe).Trim()
    if ([string]$ev.head -ne $head) {
        Deny 'my-method commit gate: verify evidence was recorded on a different HEAD (stale). Re-run scripts/verify.ps1 on the current state.'
    }
    try { $age = (Get-Date) - [DateTimeOffset]::Parse([string]$ev.verified_at).LocalDateTime }
    catch { Deny 'my-method commit gate: verify evidence has an unreadable timestamp. Re-run scripts/verify.ps1.' }
    if ($age.TotalMinutes -gt 60) {
        Deny 'my-method commit gate: verify evidence is older than 60 minutes. Re-run scripts/verify.ps1.'
    }
    $staged = @(cmd /c "git diff --cached --name-only 2>nul")
    $cardStaged = @($staged | Where-Object { $_ -like 'plan/TASK-*.md' }).Count -gt 0
    $touchesStatus = ($staged -contains 'STATE.md') -or ($staged -contains 'PLAN.md') -or $cardStaged
    if ($touchesStatus) {
        $missing = @()
        if ($staged -notcontains 'STATE.md') { $missing += 'STATE.md' }
        if ($staged -notcontains 'PLAN.md')  { $missing += 'PLAN.md' }
        if (-not $cardStaged)                { $missing += 'plan/TASK-*.md' }
        if ($staged -notcontains '.claude/last-verify.json') { $missing += '.claude/last-verify.json' }
        if ($missing.Count -gt 0) {
            Deny ('my-method commit gate: a task commit must stage STATE.md, PLAN.md, the task card and the verify evidence together (method 5d). Missing from the staged set: {0}.' -f ($missing -join ', '))
        }
    }
    Allow
} catch {
    Deny 'my-method commit gate: internal gate error while a commit was being checked. Re-run scripts/verify.ps1; if this repeats, the user (only) can set disableAllHooks in settings while the hook is fixed.'
}
```

### 3. Verify entrypoint skeleton — scaffolded by `start-project` (exact template)

Written to each new project as `scripts/verify.ps1`; at scaffold time,
`start-project` seeds `$checks` with the stack's own test command if one
exists (the same command recorded as `Test:` in CLAUDE.md).

```powershell
# Verify entrypoint - the runner of record for this project.
# Runs EVERY accumulated automated check, prints raw output on screen,
# and records machine evidence at .claude/last-verify.json (read by the
# my-method commit gate). Each task that adds an automated check ADDS a
# line to $checks as part of that task; a line is removed only if the
# feature it checks is removed.

$checks = @(
    # @{ name = 'tests'; command = 'npm test' }
)

$results = @()
$allPass = $true
foreach ($c in $checks) {
    Write-Output ('=== {0}: {1}' -f $c.name, $c.command)
    cmd /c $c.command
    $code = $LASTEXITCODE
    Write-Output ('=== exit {0}' -f $code)
    if ($code -ne 0) { $allPass = $false }
    $results += @{ name = $c.name; command = $c.command; exit = $code }
}
$headProbe = cmd /c "git rev-parse HEAD 2>nul"
$head = if ($LASTEXITCODE -eq 0) { ([string]$headProbe).Trim() } else { 'NO-COMMITS' }
if (-not (Test-Path '.claude')) { New-Item -ItemType Directory '.claude' | Out-Null }
@{
    verified_at = (Get-Date).ToString('o')
    head        = $head
    pass        = $allPass
    checks      = $results
} | ConvertTo-Json -Depth 4 | Out-File -Encoding utf8 '.claude/last-verify.json'
if ($allPass) { Write-Output 'VERIFY: PASS'; exit 0 } else { Write-Output 'VERIFY: FAIL'; exit 1 }
```

Note, stated honestly: an empty `$checks` yields `VERIFY: PASS` with
`"checks": []` — correct at project birth, and visible in the committed
evidence if a task ever closes without adding its check (L4 makes the L3
failure inspectable).

### 4. `method.md` — v6

**4a.** Header: `# METHOD — v5 (post-audit-03)` → `# METHOD — v6 (post-audit-03, D5)`.

**4b.** Top nota replaced by:

```markdown
*Nota (pt-BR): sexta versão. Esta mudança é lastreada em friction
observada — as notas 5c/5d registram verificação pulada/rotulada
"humana" sem tentativa e arquivos de status dessincronizados nos
pilotos — com desenho vindo da auditoria 01 (rec 2) e da auditoria 03
(D5), aprovado pelo usuário em 2026-08-11. Mudanças da v6: 5c ganha o
ponto de entrada de verificação (`scripts/verify.ps1`) que grava
evidência de máquina (`.claude/last-verify.json`); 5d passa a ser
travado por hook — commit sem evidência fresca de PASS, ou commit de
tarefa sem os três arquivos de status + evidência juntos, é NEGADO
deterministicamente. A v5 (wiring de segurança) permanece intacta.
Nenhum outro passo mudou.*
```

**4c.** STEP 5c — insert directly after "...confirm with their own eyes
wherever possible." and before the v5 security block:

```markdown
   Automated verification runs through the project's verify entrypoint
   (`scripts/verify.ps1`): it re-runs every accumulated check, prints
   the raw output, and records machine evidence at
   `.claude/last-verify.json` — the commit gate reads that file. A task
   that adds an automated check (including the card's AUTOMATED
   security rows) adds it to the entrypoint as part of the task; that
   is how a check joins the regression set.
```

**4d.** STEP 5d — after "Commit in English." insert:

```markdown
   The staged set must include `.claude/last-verify.json` together
   with the three status files — the commit gate denies a task commit
   missing any of them, and denies any commit without fresh PASS
   evidence.
```

### 5. `kit/my-method/commands/start-project.md`

**5a.** Embedded method copy → v6 (4a–4d applied inside the block, +3 spaces).

**5b.** Step 5 gains a new item (after the STATE.md item, before `git init`):
write `scripts/verify.ps1` with EXACTLY the section-3 skeleton (embedded in
the command file, indented, same mechanism as the other embedded texts), then
seed `$checks` with the stack's test command from Step 3's decision, if one
exists.

**5c.** Step 5.1 CLAUDE.md template — under the Stack commands add:

```
Verify: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verify.ps1`
```

and in the directory layout, after the `plan/TASK-XXX.md` line:

```
scripts/verify.ps1  verify entrypoint — runs every accumulated check, writes the evidence the commit gate reads
```

**5d.** Step 5.4 (`.gitignore`) gains: never ignore `.claude/last-verify.json`;
if the stack's ignore rules cover `.claude/`, add the exception line
`!.claude/last-verify.json`.

**5e.** Step 5.5 staging list gains `scripts/verify.ps1`.

### 6. `kit/my-method/commands/next-task.md`

**6a.** Section (d), first bullet becomes:

```markdown
- Attempt automated verification first, by running the verify
  entrypoint: `powershell -NoProfile -ExecutionPolicy Bypass -File
  scripts/verify.ps1`. If this task's card added automated checks
  (including AUTOMATED security rows), add them to `$checks` in
  `scripts/verify.ps1` as part of the task, BEFORE running it. Only
  say "verificação humana necessária" after a real attempt has
  failed, and say exactly what failed — never before even trying.
```

**6b.** Section (e), item 2 becomes:

```markdown
2. Commit all changed files together, in English — including
   `.claude/last-verify.json`: the commit gate requires it staged with
   the three status files, and denies the commit otherwise.
```

### 7. `kit/my-method/templates/CLAUDE.md`

Same two additions as 5c (Verify line under Stack; layout line).

### 8. `friction.md` — provenance entry (in THIS proposal's commit)

New YOURS entry: origin (pilot notas 5c/5d = observed friction; audit-01 rec
2; audit-03 D5; user request 2026-08-11), scope, and the standing warning
that `start-project.md` now embeds FOUR texts (method, matrix, templates,
verify skeleton).

---

## Application order (after the user approves this text)

1. `kit/my-method/hooks/hooks.json` + `kit/my-method/hooks/verify-gate.ps1`.
2. `method.md` → v6 (4a–4d).
3. `start-project.md` (5a–5e) — operational steps AND the embedded copies.
4. `next-task.md` (6a–6b).
5. `templates/CLAUDE.md` (7).
6. CHANGELOG entry (what changed + test results + caveats).
7. **Test protocol, in a fresh session** (hooks, like agents, load at session
   start — observed 2026-08-11), against a throwaway project:
   a. initial commit with zero evidence → ALLOWED (decision 7);
   b. task commit with no evidence file → DENIED with the bootstrap reason;
   c. evidence with `pass: false` → DENIED;
   d. evidence pass on a different HEAD → DENIED;
   e. evidence older than 60 min (timestamp edited for the test) → DENIED;
   f. fresh PASS evidence, full staged set → ALLOWED;
   g. fresh PASS evidence, card missing from staged set → DENIED naming it;
   h. same commit via the PowerShell tool instead of Bash → same behavior;
   i. non-commit commands and a non-my-method folder → unaffected;
   j. `git commit` typed by the user at a terminal OUTSIDE Claude Code →
      NOT gated (hooks only see tool calls) — recorded as expected behavior,
      not a bug.
8. Results of (7) recorded in the CHANGELOG entry before trust; any failing
   case blocks the rollout and reverts the hook files.

One commit for 1–6 (message: `Apply method v6 verify-evidence commit gate`),
test results appended to CHANGELOG in the same or a follow-up docs commit.

## What this does NOT guarantee (kept honest)

- **Right checks:** the gate proves the entrypoint ran and passed recently;
  whether `$checks` contains the RIGHT checks stays L3 judgment (audit-01's
  residual, unchanged).
- **Honest evidence:** a model that explicitly writes a fake evidence file
  can pass the gate — but that is a visible, committed lie (L4), a different
  failure class from forgetting.
- **Unusual paths:** `git -C other-repo commit` evaluated against the wrong
  cwd; commits from scripts/processes the harness does not see; the user's
  own terminal (7j). The gate targets the normal path, not an adversary.
- **Coverage window:** decision 2's post-verify-edit hole.
- **Latency:** the hook spawns `powershell.exe` on every Bash/PowerShell call
  in every project (user-scope plugin), ~100–300 ms each. If this hurts, the
  verified-but-unadopted `if` field (claim 7) is the future optimization.

## NOT VERIFIED

- The `if` field's filter syntax (claim 7) — not adopted.
- Exact stdin behavior when the harness PowerShell-fallback (no Git Bash)
  runs the hook command — the explicit `powershell -File` invocation is
  shell-agnostic by construction, but this specific fallback path is untested
  until step 7 of the application order.
- Whether `${CLAUDE_PLUGIN_ROOT}` expansion inside `hooks.json` command
  strings behaves identically for user-scope marketplace installs — friction.md
  records it as reliable for hooks (2026-08-10 research); re-confirmed in
  docs (claim 3); live-confirmed only by test 7b.
- Hook latency figures — estimate, not measured; measured at apply time.
