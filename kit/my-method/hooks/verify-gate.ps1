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
