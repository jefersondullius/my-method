# LAST CHECK — maintenance ledger

Append-only. One entry per run of `/my-method:update-method`. The
per-axis dates here are the lower bound of the next run's "since when"
questions.

| Axis | Last checked | Run |
|---|---|---|
| A — Anthropic practices | 2026-08-11 | 2 (first full sweep) |
| B — Vulnerabilities | 2026-08-11 | 2 |
| C — Skills and agents | 2026-08-11 | 2 |
| D — Models and mechanisms | 2026-08-11 | 2 |
| E — Open sweep | 2026-08-11 | 2 (one-day window) |

The dates above are the RESEARCH date (2026-08-11), not the apply date
(2026-08-12). The next run's "since when" is what was actually read,
not when it was written down.

---

## 2026-08-11 — run 1 (partial, pre-command)

This entry records the research done **while the maintenance commands
were being proposed**, not a run of the command itself. It is written
here so the first real run has a lower bound to start from instead of
the repository's first commit.

**Axes covered, with windows:**

- **A — partial.** The CLI and plugin mechanics the health check
  depends on were verified live and twice
  (`notes/research-maintenance/cli-mechanics.md`). The docs changelog
  was read only far enough to establish the current version (2.1.227,
  2026-08-10). A full axis-A sweep of every page in the watchlist has
  NOT been done — the next run should treat A as covering only the
  pages named in that research file.
- **B — full.** All five sources verified live
  (`notes/research-maintenance/sources-baseline.md`).
- **C — not run.** Carried over from `notes/audit-02-skills.md`
  (2026-08-10); no trigger was re-checked since.
- **D — full.** Model aliases, provider resolution, effort levels and
  persistence rules verified live (same file).
- **E — never run.** The open sweep has no prior date. The first real
  run uses 2026-08-10 (this repository's first commit) as its lower
  bound.

**Applied:** the two maintenance commands themselves
(`health-check`, `update-method`), the watchlist, this ledger, plugin
version 0.1.0 → 0.2.0. See `CHANGELOG.md` for the entry and
`notes/proposals/maintenance-command-proposal.md` for the approved
text.

**Found but NOT applied** — these are findings, not changes; each
needs its own approval and belongs to the first real run's proposal:

1. **gitleaks is feature-frozen.** Maintainer's README, verbatim:
   "Gitleaks is feature complete… Future releases will be security
   patches only. I'm shifting my focus to Betterleaks." Latest
   v8.30.1 (2026-03-21), MIT, not archived. `SECURITY-MATRIX.md` rows
   2.1 and 8.1 depend on it. CANDIDATE, not a defect — nothing is
   broken today.
2. **OWASP 2025 has two categories this repo covers nowhere:** A03
   Software Supply Chain Failures (much broader than the "vulnerable
   and outdated components" that row 10.1 checks) and A10 Mishandling
   of Exceptional Conditions (new in 2025). `research/13` already
   cites 2025 codes, so the edition is not stale — the coverage is.
3. **Fable 5 auto-falls-back on cybersecurity-flagged prompts.**
   Method v7's UP trigger recommends a stronger model exactly when a
   card carries REVIEW security rows, which is the one class of task
   where that model may not be the one that answers.
4. **The npm audit docs canonical URL moved** to the `/cli/v12/`
   shelf; `/cli/v11/` is labelled "Legacy". The unversioned
   `/cli/audit` alias still resolves via meta-refresh, so the matrix's
   footnote is not broken — but it now depends on that alias tracking
   the newest major, which npm does not promise anywhere.

**SETTLED by test T4, 2026-08-11** — moved here out of NOT VERIFIED:

A seventh command file was added to `kit/my-method/commands/` with NO
version bump and NO `/plugin update`, and a fresh session was asked
for the inventory. It reported **Skills (7)**, including the new file.

Conclusion: for this local-marketplace install at user scope, **the
harness reads the kit source live** — the frozen-cache behaviour the
docs describe does not govern component discovery here. Consequences,
recorded so nobody re-derives them:

- A version bump is **not** what delivers a change to a session.
  D-VER's bump is kept as an honest record of which kit a session ran,
  and as the fallback if the live-read behaviour ever changes to match
  the documentation. `update-method`'s step 6 was corrected on
  2026-08-11 to say this plainly, because its original wording claimed
  the opposite.
- The install record stays pinned: `claude plugin list --json` keeps
  reporting `version: 0.1.0` and the `...\0.1.0` cache path, while
  `claude plugin details` reports `0.2.0` and the current components.
  **A difference between those two numbers is expected, not a
  failure**, and the health check's probe 1 deliberately compares
  component inventory rather than version strings.
- Still undocumented, and therefore still not something to rely on:
  no Anthropic page describes this live-read behaviour, so it can
  change without notice. That is precisely what probe 1 watches for.

**NOT VERIFIED, carried to the next run:**
- Whether `claude plugin list --json`'s extra fields (`scope`,
  `installPath`, `installedAt`, `lastUpdated`, `errors`) are stable —
  observed live, not documented.
- Whether `${CLAUDE_PLUGIN_ROOT}` expands inside command markdown —
  docs say yes, issue #9354 (open since 2025-10-11) says no. The kit
  depends on it in `hooks/hooks.json` only, where it is confirmed
  working (CHANGELOG 2026-08-11).
- Whether the Semgrep `owasp-top-ten` ruleset is keyed to the 2021 or
  the 2025 OWASP edition. Strong suspicion: 2021.
- The Betterleaks project — existence, maturity, license, suitability
  as a migration target. Never fetched.
- Which models this account can actually select. Account tier and
  organization policy can restrict the documented set; a research
  subagent in this very session terminated with "Fable 5 requires
  usage credits", which is a live instance of that class.
- OWASP Top 10:2025's publication date and any next-revision plan —
  not stated on any canonical OWASP page.
- The remaining 13 NOT VERIFIED entries in
  `notes/research-maintenance/sources-baseline.md` and 9 in
  `cli-mechanics.md`, which stay in those files rather than being
  copied here.

---

## 2026-08-12 — run 2 (first real run of the command)

Research ran 2026-08-11 (five subagents, five files,
`notes/research-maintenance/2026-08-11-axis-{A..E}.md`); the proposal
`notes/proposals/maintenance-2026-08-11.md` was written 2026-08-12 and
applied the same day. The session that delegated the research died
before writing the proposal, so the five-line summaries were lost and
the axis files were read in full — the friction that produced C-8.

**Axes covered, with windows:**

- **A — full, first time.** Lower bound 2026-08-10. 12 watchlist rows
  re-checked. One additive change; two recipe defects.
- **B — full.** Lower bound 2026-08-11. One real breakage (D-1), one
  false claim retired, two carried-forward items closed.
- **C — full.** Lower bound 2026-08-10 (audit-02). Nothing to install;
  six triggers re-read; no renames in the official catalog.
- **D — full.** Lower bound 2026-08-11. Zero dead models; one citation
  defect (D-2).
- **E — full but nearly worthless.** Lower bound 2026-08-10, this
  repository's first commit — a one-day window. **Zero candidates.**
  The axis's own words: *"A negative result over one day is worth
  almost nothing as evidence that the method is current; it is worth
  something only as a lower bound the next run can start from."* Its
  real value is giving run 3 a lower bound of 2026-08-11.

**Applied** (plugin 0.2.0 → 0.3.0, method v7 → **v8**):

- **D-1** — `gitleaks git -s .` → `gitleaks git .` in
  `playbook/SECURITY-MATRIX.md` row 8.1 and its embedded copy in
  `start-project.md`. `-s`/`--source` exists only on the deprecated
  `detect`/`protect` subcommands; `git` takes the path positionally.
  The row was wrong from the day it was written, and it is the row
  that enforces "no credential in a versioned file".
- **D-2** — the fabricated `/model` quotation removed from
  `CHANGELOG.md` and `notes/proposals/method-v7-model-effort-proposal.md`,
  replaced by the structural evidence that does exist.
- **D-3** — two watchlist recipes and the `update-method` axis-D
  delegation stopped hunting for that non-existent sentence.
- **D-4** — the changelog recipes (axes A and E) now cross-check
  GitHub Releases and tolerate either markup.
- **D-5** — the headless recipe now reads the `<Note>` announcing that
  `--bare` will become the default for `-p`.
- **D-6** — `method.md` STEP 5a: "the user can switch **the session's**
  model or effort". Triggered the v8 bump and the `friction.md`
  provenance entry.
- **C-2** — the Semgrep coverage boundary recorded in
  `research/13-testing-strategy.md` (new section) and in the matrix's
  HONESTY list, with a new `[^semgrep2025]` source.
- **C-3** — the watchlist's third preamble rule: check the
  *invocation*, not just the project.
- **C-4** — `start-project.md`'s planning half now says to prefer
  `opus` over `fable` on security-triggered cards.
- **C-7** — `claude-security` added to the axis-C DEFERRED table.
- **C-8** — `update-method` Step 3 now says to fall back to the five
  research files when the summaries did not survive the session.

**Rejected, with the reason:**

- **C-1 Betterleaks** — verified real, MIT, v1.7.4, same maintainers,
  same CLI shape, low migration cost. **No anyway:** gitleaks v8.30.1
  works and is not abandoned (frozen ≠ dead), Betterleaks is six
  months old, and **detection parity was never measured** — that needs
  both binaries and a corpus. Fix the string first; switch tools as a
  separate, deliberate decision.
- **C-5 `claude doctor` in health-check probe 1** — shipped 2026-07-08,
  before this repo existed, so it fails axis E's "did not exist" test.
  Makes about half of one probe out of five redundant. Default rule
  applies: no.
- **C-6 `STATE.md` vs auto memory** — auto memory does not obsolete
  `STATE.md` (machine-local and not in git; Claude-curated; only the
  first 200 lines of `MEMORY.md` load). The real observation is
  narrower: the method never says which store owns a fact. Recorded,
  not applied.
- **D1-a `notes/audit-03-agents.md:36`** — left unedited. It quotes the
  bad gitleaks string as a dated record of a past evaluation, nobody
  executes an audit file, and this repo amends by recorded amendment
  rather than rewrite.
- **Probe 1 comparing version strings** (axis A's proposal) — refused.
  Axis C was right and this ledger already says why: the install record
  stays pinned while `plugin details` reads the source live, so a
  version comparison would produce a permanent false alarm.

**The user's answers to axis C's UNKNOWABLE-FROM-HERE triggers**
(2026-08-12), which are the only way those triggers can be resolved:

1. `frontend-design` — **NOT MET.** No user-facing-screens task on any
   project since 2026-08-10.
2. `webapp-testing` — **NOT MET.** No web-UI task reached verification,
   and no `friction.md` anywhere records difficulty authoring Playwright
   specs. Both halves fail.
3. `playwright` MCP — **not applicable**, gated behind 2.
4. `security-guidance` — **the tier half is now MET.** The user is
   starting a project with login and other people's personal data
   (T2). **Nothing was installed**: the recorded order says try
   Semgrep-in-verify + the built-in `/security-review` first, and that
   is the user's decision, not this run's. **Blocking fact for that
   project: `semgrep` is not installed on this machine**, so the
   AUTOMATED rows a T2 tier pulls in cannot run today. That is a
   before-the-project fact, not a during-verification surprise.
5. TDD staged stage — **NOT MET.** User agrees with the strict reading:
   the 2026-08-11 pilot's simulated-persona "human" check is a
   limitation of the test rig, not an observed wrong behaviour.

`skill-creator` — **NOT MET**, answerable from here: no scheduled task,
no eval mechanism anywhere in the repo.

**SETTLED this run, moved out of NOT VERIFIED:**

- Semgrep `owasp-top-ten` edition keying → **2025-keyed** (517 of 559
  rules). The prior entry's "strong suspicion: 2021" was **wrong** and
  is retired. The semantic gap it feared does not exist; a different
  and real gap does (A03/A10 → 0 rules), now recorded in `research/13`.
- Betterleaks → **verified real.** Created 2026-02-03, v1.7.4
  (2026-08-10), 17 releases in ~6 months, MIT, not archived, 1,647
  stars, maintained by the original gitleaks author, ships
  sigstore-signed checksums. Migration shape confirmed compatible.
- `claude plugin list --json`'s extra fields → **confirmed present**
  (`scope`, `installPath`, `installedAt`, `lastUpdated`, `errors`).
- Whether a plugin that failed to load is listed → **yes**, with an
  `errors` array; the `my-method@skills-dir` entry is the proof.
- **`${CLAUDE_EFFORT}` substitution inside a plugin `commands/*.md`
  body → observed a second time**, in this apply session: the
  `update-method.md` text arrived with `${CLAUDE_EFFORT}` already
  expanded to the session's effort level. Two independent observations
  now (probe P1 and this one). Still **not** contractually documented
  for plugin `commands/`, so item 7 below stays open and the fallback
  clause in `next-task.md:49-51` remains load-bearing.

**CONFIRMED UNCHANGED** (recorded so run 3 does not re-derive it, all
accessed 2026-08-11): every mechanism the commit gate depends on
(`PreToolUse` "Can block it", `permissionDecision: "deny"`, plugin
`hooks/hooks.json`, `disableAllHooks`); `disable-model-invocation` and
`argument-hint`; `${CLAUDE_EFFORT}` in the substitutions table and
`${CLAUDE_MODEL}` still absent; frontmatter `model:`/`effort:` still
turn-scoped ("the session model resumes on your next prompt") — which
is exactly why v7 refused them; `tools:` still an allowlist honoured
for plugin agents, so `security-reviewer`'s read-only guarantee is
still structural; local-path marketplaces still first-class; **zero
dead models** — and the structural reason worth keeping is that this
repo names only aliases, never a dated model ID, while
`claude-opus-4-1-20250805` retired 2026-08-05; OWASP Top 10:2025 still
current with all six cited cheat sheets resolving; npm's docs shelf
still `/cli/v12/`; nothing to install (all six DEFERRED triggers
re-read, none MET at research time); no renames affecting the five
watched plugins (catalog 287, up from 285).

Two method notes needing no action: **`max` effort is session-only**
and v7's loop ends every task with `/clear`, so a card recommending
`/effort max` does not survive to the next card, by design. And **the
official marketplace catalog must be parsed, never summarized** — a
summarizing fetch returned 221 plugins and three false "does not
exist" verdicts against the same file the same day the raw parse
returned 287. That is the most dangerous methodology trap found this
run.

**Where the subagents disagreed** — recorded rather than silently
resolved: (1) whether probe 1 should compare version strings — axis C
right, axis A wrong, resolved above; (2) what markup the docs changelog
uses — axis A saw `##` headings, axis E saw `<Update label=…>` blocks,
same URL, same day. Unresolved; the replacement recipe is written to
work under either.

**FOUND WHILE APPLYING, not by the research — open defect for run 3:**

The apply-time mechanical check compares four canonical files against
their embedded copies in `start-project.md`. Method (236/236) and
matrix (213/213) came back at **0 divergences**. The two templates did
not:

- `kit/my-method/templates/CLAUDE.md` — 69/69 lines, **10 divergences**
- `kit/my-method/templates/STATE.md` — 32/32 lines, **14 divergences**

Both counts are **identical at `HEAD`**, so this run neither caused nor
touched them. The drift is systematic rather than accidental: the files
under `templates/` use HTML-comment placeholders
(`<!-- One sentence: … -->`) while the copies `start-project` actually
writes use angle-bracket placeholders (`<One sentence — …>`), and the
angle-bracket versions carry cross-references the template files lack
("same as SPEC.md's opening line").

The open question, which needs a decision and not a patch: **no command
in the kit reads `templates/` at all** — `grep -n "templates/"` over
`kit/my-method/commands/*.md` returns nothing. `start-project` writes
its embedded copies. So either the `templates/` directory is dead
weight that `plugin details` counts and nothing uses, or it is the
intended canonical source and `start-project` should read from it. Until
that is decided, "canonical vs embedded" is not even well-defined for
these two files, which is why this was NOT force-fixed here. It was out
of the approved proposal's scope.

**NOT VERIFIED, carried to run 3:**

1. ~~The exact error `gitleaks git -s .` produces.~~ **SETTLED
   2026-08-12** — see the entry below; gitleaks v8.30.1 was installed
   and test T1 run.
2. Betterleaks' detection parity with gitleaks — never measured.
3. The docs changelog's markup, and how far it lags Releases. One day
   is not a pattern.
4. Whether the four additions in the plugins-reference caching section
   are new since 2026-08-10 or merely unquoted before. Recorded as
   "present today", not "added".
5. The date the `--bare`-will-become-default `<Note>` appeared. No
   changelog entry mentions `--bare` at any version.
6. Whether 2.1.228 contains anything relevant — no changelog entry
   existed for it on 2026-08-11 though the binary shipped.
7. Whether `${CLAUDE_EFFORT}` substitution is *contractually*
   guaranteed inside plugin `commands/*.md` bodies. Now observed
   twice; still never stated for plugin `commands/` by name.
8. Whether Haiku 4.5 and Sonnet 4.5 support effort at all. Implied by
   omission, never stated positively. A card naming an effort level
   alongside `haiku` could be silently ineffective.
9. Whether the `/model` "user-only" sentence ever existed. This run
   proves only its absence today across three surfaces; Anthropic
   publishes no docs-page history.
10. Whether the 287 vs 285 marketplace delta is genuinely +2 net.
11. The date `anthropics/claude-plugins-public` became `-official`. The
    301 is live; its date is not exposed. Two catalog entries still
    carry the old name in `homepage`.
12. Whether auto memory is enabled for this repository.
    `autoMemoryEnabled` was not read — that would mean reading outside
    the project folder.
13. Whether this account can run `claude-security` at all (needs
    dynamic workflows; on Pro, enabled in `/config`). Not tested; the
    standing rule forbids changing settings.
14. Whether the installed 0.1.0 cache copy differs in content from the
    kit. Axis C ran `diff -rq` and reports it does (1 command, 4
    templates, no agent, no hook) — **the diff result is recorded as
    fact, and the boundary question is flagged**: axis C read a
    directory under the user's home to get it.
15. OWASP Top 10:2025's publication date. Four surfaces exhausted;
    recorded so run 3 does not repeat them.
16. OWASP's next-revision plan. The ~4-year cadence pointing at ~2029
    is an inference, not a published plan.
17. Whether the stale "2025 Data Analysis Plan" text is current or
    leftover.
18. Whether Semgrep's OSS CLI has feature gaps versus Pro. No
    capability matrix is published.
19. Human-visible content of `semgrep.dev/p/owasp-top-ten` — still an
    empty JS shell to a fetcher.
20. Whether `docs.npmjs.com/cli/audit` is contractually pinned to the
    current major. Two consistent observations, no contract.
21. Whether `/hooks`, `/plugin`, `/skills` or `/context` produce output
    in `-p` mode.
22. The `${CLAUDE_PLUGIN_ROOT}`-in-command-markdown dispute (issue
    #9354, open since 2025-10-11). The kit depends on it in
    `hooks/hooks.json` only, where it is confirmed working.
23. Which models this account can actually select. Documentation cannot
    answer it; the `/model` picker can, interactively.
24. **The blog post "Choosing a Claude model and effort level in Claude
    Code"** (claude.com/blog/claude-model-and-effort-level-in-claude-code),
    cited by `model-config.md` as the official guidance and directly
    relevant to v7's triggers — **never opened.** Axis D calls it the
    highest-value open item on that axis. Run 3 should start here.
25. Whether a "Week 33" what's-new digest will cover Aug 10–14. Week 31
    is missing from the index entirely, so the weekly series has a
    known gap and is not complete coverage.
26. Where `.claude/skills/my-method` lives — established as a *symlink*
    into `kit/my-method`, so it cannot drift. The error is a name
    collision, not a stale duplicate. Removing it is a user decision.

---

## 2026-08-12 — T1 executed (ad-hoc, outside a maintenance run)

Not a run of `/my-method:update-method`; the user installed the three
tools the matrix assumes exist (semgrep, gitleaks, pip-audit) and asked
for proposal test T1 to be run once gitleaks was in place. Recorded
here because it settles NOT VERIFIED item 1 above.

**Installed:** semgrep 1.172.0 (via pipx, official quickstart at
`docs.semgrep.dev/getting-started/quickstart`), gitleaks 8.30.1
(official Windows release binary from
`github.com/gitleaks/gitleaks/releases`, no winget/scoop path is
documented by the project itself), pip-audit (via pip, official
`pypa/pip-audit` README) — all installed 2026-08-12, this machine only.

**T1 result — D-1 moves from documented to observed:**

```
$ gitleaks git .
...
1:01AM INF 33 commits scanned.
1:01AM INF scanned ~846844 bytes (846.84 KB) in 407ms
1:01AM INF no leaks found
exit code: 0

$ gitleaks git -s .
Error: unknown shorthand flag: 's' in -s
Usage:
  gitleaks git [flags] [repo]
...
exit code: 1
```

Both halves confirmed exactly as predicted: `gitleaks git .` (the
corrected row 8.1 string) runs clean, `gitleaks git -s .` (the old,
wrong string) fails with an unknown-flag error. `SECURITY-MATRIX.md`
row 8.1 is now AUTOMATED and runnable on this machine, not just
theoretically correct.

---

## 2026-08-12 — T2 executed (ad-hoc, outside a maintenance run)

Not a run of `/my-method:update-method`; settles session 3 of the cost
audit's Target 2 (`notes/audit-04-cost-guidance.md` lines 237–284) —
whether the ~457-token "Always-on" figure `claude plugin details
my-method` reports (session 1, section a) is the real per-session
context cost of the six my-method commands, or an overestimate that
does not account for `disable-model-invocation: true`, which all six
already carry.

**Method:** `claude -p "/context" --output-format text`, a fresh
non-interactive session, before invoking any of the plugin's six
commands. Raw output:

```
## Context Usage

**Model:** claude-sonnet-5
**Tokens:** 28.2k / 967k (3%)

### Estimated usage by category

| Category | Tokens | Percentage |
|----------|--------|------------|
| System prompt | 9.2k | 0.9% |
| System tools | 16.5k | 1.7% |
| System tools (deferred) | 16.2k | 1.7% |
| Custom agents | 79 | 0.0% |
| Memory files | 537 | 0.1% |
| Skills | 1.9k | 0.2% |
| Messages | 8 | 0.0% |
| Free space | 905.8k | 93.7% |
| Autocompact buffer | 33k | 3.4% |

### Custom Agents

| Agent Type | Source | Tokens |
|------------|--------|--------|
| my-method:security-reviewer | Plugin | 79 |

### Skills

| Skill | Source | Tokens |
|-------|--------|--------|
| dataviz | Built-in | ~380 |
| update-config | Built-in | ~240 |
| keybindings-help | Built-in | ~80 |
| code-review | Built-in | ~270 |
| simplify | Built-in | ~60 |
| fewer-permission-prompts | Built-in | ~60 |
| loop | Built-in | ~120 |
| schedule | Built-in | ~130 |
| claude-api | Built-in | ~360 |
| run | Built-in | ~120 |
| init | Built-in | ~20 |
| security-review | Built-in | ~30 |
```

(Memory Files table omitted above — unrelated to this test.)

**Result — SETTLED:** none of the six my-method skills (`friction`,
`health-check`, `next-task`, `start-project`, `update-method`,
`where-am-i`) appear anywhere in the "Skills" table. Every row listed
there is **Built-in** (Claude Code's own), none **Plugin**-sourced.
The only my-method component present anywhere in the breakdown is the
plugin's one **agent**, `my-method:security-reviewer`, at 79 tokens
(Custom Agents table) — consistent with session 1's own separate ~70-
token estimate for that one component, which was never in dispute.

**Conclusion:** `disable-model-invocation: true` excludes a command's
description from a session's startup context entirely for
plugin-sourced commands, exactly as `code.claude.com/docs/en/context-
window.md` (accessed 2026-08-12, cited in session 3) documents for
project-root skills. The ~457-token "Always-on" figure `claude plugin
details my-method` reports is a **static per-component estimate that
does not account for the flag** — it overstates the real per-session
cost of the six commands by their full amount (~387 of the ~457
tokens; only the agent's ~70–79 tokens was ever real, and it was
already counted as such).

**`notes/audit-04-cost-waste.md` item 2 — ranked #2 in that session's
waste ranking ("~457 tok/session, ~89% unused in a typical single-
command session") — is retired.** It is not a real cost. The real,
confirmed always-on cost of the my-method plugin is the
security-reviewer agent's ~79 tokens, not ~457. `notes/audit-04-cost-
plan.md` item 1 (FAZER AGORA) is closed by this result, not superseded
by it — running the test was the whole action.

**NOT itself re-verified by this test:** whether `claude plugin
details`'s "Always-on" number is wrong for flagged components in
general, or specific to this kit's shape — one plugin was checked, not
the mechanism in the abstract. A future plugin with components that do
NOT carry `disable-model-invocation: true` should not assume the same
discount applies.

---

## 2026-08-12 — `notes/proposals/audit-04-cost-fixes-2026-08-12.md` applied

Plugin 0.3.0 → 0.3.1. All three items approved and applied as written,
no changes from the proposed text:

- `kit/my-method/hooks/hooks.json` — added `"if": "Bash(git commit*)"`
  to the `PreToolUse` handler. The proposal's own open caveat stands
  uncorrected because nothing in this kit's command bodies needs it
  today: `grep -rn "git commit" kit/my-method/commands/*.md` shows every
  commit instruction is bare `git commit`, never `-C`-prefixed. If a
  future task ever commits through a wrapper or a different working
  directory, this scope should be re-checked before trusting the gate
  fires.
- `kit/my-method/commands/next-task.md` — removed the clause `, never
  mechanics ("agora vou abrir o arquivo")` from section (c); the
  narrate-intent-and-consequence instruction stays.
- `notes/maintenance/WATCHLIST.md` — added Axis F, one row: revisit
  `PLAN.md`'s uncapped growth when a real project reaches 30 completed
  tasks.

CHANGELOG entry: same date, "auditoria de custo (sessão 4/4) aplicada:
plugin 0.3.1".
