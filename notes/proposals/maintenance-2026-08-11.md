# PROPOSAL — maintenance run 1 (first real run of `/my-method:update-method`)

Status: **proposed, nothing applied.** Research ran 2026-08-11; this proposal was
written 2026-08-12 from the five axis files, which are the only surviving record —
the subagents' five-line summaries died with that session.

Research files this proposal reads from, all in `notes/research-maintenance/`:
`2026-08-11-axis-A.md`, `-B.md`, `-C.md`, `-D.md`, `-E.md`.

## Provenance

`notes/maintenance/LAST-CHECK.md`'s run-1 entry (2026-08-11) was written *while the
maintenance commands were being proposed*, not by a run of the command. This is the
first execution of `/my-method:update-method` MODE 1 proper: five axes delegated in
parallel, each writing its own file, then sorted here into DEFECT / CANDIDATE /
NOT VERIFIED per the command's Step 3.

One deviation from the command text, stated plainly: Step 3 says *"Read only the five
five-line summaries. Open a research file only to quote a specific claim."* The
summaries did not survive the session boundary, so all five files were read in full.
The rule assumes the proposal is written in the same session as the delegation. It is
worth amending the command to say what to do when it is not — see C-8.

## Window covered, per axis

| Axis | Lower bound | Source of the bound | Result |
|---|---|---|---|
| A — Anthropic practices | 2026-08-10 (partial prior run) | `LAST-CHECK.md:9` | 12 rows re-checked; 1 changed (additive), 2 recipe defects |
| B — Vulnerabilities | 2026-08-11 | `LAST-CHECK.md:10` | 1 real breakage, 1 false claim retired, 2 open items closed |
| C — Skills and agents | 2026-08-10 (audit-02, pre-ledger) | `LAST-CHECK.md:11` | Nothing to install; 6 triggers re-read; no renames |
| D — Models and mechanisms | 2026-08-11 | `LAST-CHECK.md:12` | Zero dead models; 1 citation defect |
| E — Open sweep | 2026-08-10 (first commit) | `LAST-CHECK.md:13` | **Zero candidates** — one-day window |

Axis E's honest self-assessment, quoted because it governs how much the clean result
is worth: *"a one-day window is too short to expect a finding. A negative result over
one day is worth almost nothing as evidence that the method is current; it is worth
something only as a lower bound the next run can start from."*
(`2026-08-11-axis-E.md`)

---

# DEFECTS

Six. One is a live breakage; the rest are claims and recipes that do not survive
re-verification.

## D-1 — `gitleaks git -s .` is not a valid gitleaks invocation

**This is the only live breakage found this run, and it is in the check that enforces
the "no credential in a versioned file" rule.**

`-s` / `--source` is registered **only** on gitleaks' deprecated `detect` and `protect`
subcommands. The `git` subcommand takes the path as a **positional argument**
(`Use: "git [flags] [repo]"`, `Args: cobra.MaximumNArgs(1)`), and no `-s` shorthand
exists among the global persistent flags. Verified against three independent reads —
the README's own verbatim `--help` dump, `cmd/root.go`'s flag registrations, and
`cmd/git.go` in both `master` and the `v8.30.1` tag.

Sources, all accessed 2026-08-11:
<https://raw.githubusercontent.com/gitleaks/gitleaks/v8.30.1/cmd/git.go>,
<https://raw.githubusercontent.com/gitleaks/gitleaks/master/cmd/root.go>,
<https://raw.githubusercontent.com/gitleaks/gitleaks/master/cmd/detect.go>,
<https://raw.githubusercontent.com/gitleaks/gitleaks/master/README.md>.

**Consequence in plain language.** Any project that follows row 8.1 literally types a
command that exits with an unknown-shorthand error and scans nothing. The row looks
wired up and is not. Row 8.1 is what enforces the global rule "no key, password, or
token ever goes into a versioned file", so a failure here is expensive.

**Not a regression in this window.** The `detect`→`git` change landed in gitleaks
v8.19.0, which predates this repo's first citation of the tool (2026-08-10). The string
was wrong when it was written. The baseline pass never caught it because every Axis B
recipe probed *liveness and version*, never *the command line* — which is exactly what
C-3 fixes.

**The fix:** `gitleaks git .` — positional, still full history. The README, accessed
2026-08-11: *"Under the hood, gitleaks uses the `git log -p` command to scan patches."*
Bare `gitleaks git` also works (*"If there is no target specified as a positional
argument, then gitleaks will attempt to scan the current working directory as a git
repo"*), but the explicit `.` is closer to the current text and states the intent.

**Scope correction to the axis-B report.** Only **row 8.1** types the invocation.
Row 2.1 (`playbook/SECURITY-MATRIX.md:104`) says only *"run `gitleaks` (or equivalent
secret scanner)"* — no flags — so row 2.1 is **not** defective. Verified in this repo.

**Every place the bad string lives** (verified by grep, 2026-08-12):

| # | File:line | What it is | Proposed action |
|---|---|---|---|
| 1 | `playbook/SECURITY-MATRIX.md:165` | Row 8.1, the canonical matrix | **Fix** |
| 2 | `kit/my-method/commands/start-project.md:443` | Row 8.1 in the embedded copy written into *every new project* — the blast radius | **Fix, same commit** |
| 3 | `notes/maintenance/WATCHLIST.md:42` | Axis B row propagates the error | **Fix** |
| 4 | `notes/audit-03-agents.md:36` | Cites it as evidence the matrix names "exact test designs" | **Leave — see D1-a** |

### Exact text — `playbook/SECURITY-MATRIX.md:165` and `kit/my-method/commands/start-project.md:443`

Both lines are byte-identical today. In both, replace:

> **AUTOMATED** — `gitleaks git -s .` (scans full git history, not just the working tree)[^gitleaks], run before the first push and before every subsequent push.

with:

> **AUTOMATED** — `gitleaks git .` (scans full git history, not just the working tree)[^gitleaks], run before the first push and before every subsequent push.

### Exact text — `notes/maintenance/WATCHLIST.md:42`

Replace the row's "Rows that depend on it" and "Re-check recipe" cells:

> | gitleaks | https://github.com/gitleaks/gitleaks | Rows 2.1, 8.1 (`gitleaks git -s .`) | `GET .../releases/latest`, then re-read the top of the README: as of 2026-08-11 it declares feature-freeze, security patches only, successor **Betterleaks** |

with:

> | gitleaks | https://github.com/gitleaks/gitleaks | Row 8.1 (`gitleaks git .`); row 2.1 names the tool with no flags | `GET .../releases/latest`; re-read the top of the README for the feature-freeze statement (security patches only, successor **Betterleaks**); and **diff the `func init()` block of `cmd/git.go` against the flags row 8.1 types** — that block is the authoritative list of what `gitleaks git` accepts |

### D1-a — the audit note is history, not a live instruction (decide this one)

`notes/audit-03-agents.md:36` quotes the bad string as an example. The audits are dated
records of past evaluations, and this repo's convention is to amend by recorded
amendment rather than rewrite (`WORKFLOW-TARGET.md`'s own rule). **Recommendation:
leave the line unedited** and let the ledger carry the correction — nobody executes an
audit file. If you would rather it not propagate, the alternative is a bracketed
inline marker, e.g. `gitleaks git -s .` → `` `gitleaks git -s .` [corrigido em
2026-08-12 para `gitleaks git .` — ver notes/proposals/maintenance-2026-08-11.md] ``.
Your call; the default is leave it.

### D1-b — footnote date

`playbook/SECURITY-MATRIX.md:194` (`[^gitleaks]`) says "accessed 2026-08-10". The
source was re-read 2026-08-11. Bump to 2026-08-11 in the same edit, in both the matrix
and its embedded copy.

---

## D-2 — a quotation attributed to the docs that appears nowhere in them

`CHANGELOG.md:129-132` and `notes/proposals/method-v7-model-effort-proposal.md:40-41`
both present this as a live-verified quotation from `code.claude.com/docs/en/commands.md`:

> `/model` "can only be invoked by the user, not by the model itself"

**That string does not exist.** Searches on 2026-08-11 across three surfaces:

| Needle | `commands.md` (153,878 B) | `commands` HTML (447,111 B) | `llms-full.txt` (7,115,382 B — the entire docs corpus) |
|---|---|---|---|
| `not by the model itself` | 0 | 0 | **0** |
| `only be invoked by the user` | 0 | 0 | **0** |
| `user-only` (case-insensitive) | 0 | 0 | 4 — **all four about custom skills**, none about `/model` |

Source: <https://code.claude.com/docs/en/commands.md>,
<https://code.claude.com/docs/llms-full.txt>, both accessed 2026-08-11.

**The substance is not in doubt — only the citation.** What *is* documented, verbatim
and verified 2026-08-11:

1. *"A command is only recognized at the start of your message."* (`commands.md:13`)
2. The all-commands table marks with `[Skill]` exactly the entries Claude can invoke on
   its own, and describes them as *"a prompt handed to Claude, which Claude can also
   invoke automatically when relevant"*, versus built-ins *"whose behavior is coded into
   the CLI"*. **Neither the `/model` row nor the `/effort` row carries a `[Skill]` or
   `[Workflow]` marker.**
3. The `model` setting is *"read once at session start"*, with `/model` named as the
   mid-session switch (`settings.md`, accessed 2026-08-11).
4. No assistant-callable tool sets model or effort — a corpus search for `setModel`
   returns only the Agent SDK method, which the host application calls.

That structural evidence is **stronger** than the sentence the repo invented, because
it is a property of the table's own legend rather than a single line of prose.

**Contrast already in the repo:** `notes/audit-01-gaps.md:12` quotes the real sentence
and explicitly marks the rest as its own inference — `(i.e., typed by the user)`. That
line is correct and re-verifiable today. The CHANGELOG and the v7 proposal hardened
that inference into a quotation.

**Method v7's design needs no change.** Only the citation does.

### Exact text — `CHANGELOG.md:129-132`

Replace:

> sai de ABSENT para L3 + L4. Esse é o teto estrutural: `/model` "can
> only be invoked by the user, not by the model itself"
> (code.claude.com/docs/en/commands.md, verificado ao vivo em
> 2026-08-11); nem hook enxerga comandos embutidos.

with:

> sai de ABSENT para L3 + L4. Esse é o teto estrutural: `/model` é um
> built-in, e "a command is only recognized at the start of your
> message"; a tabela de comandos marca com `[Skill]` exatamente as
> entradas que o Claude pode invocar sozinho, e nem `/model` nem
> `/effort` carregam essa marca (code.claude.com/docs/en/commands.md,
> reverificado em 2026-08-11); nem hook enxerga comandos embutidos.
> *(Correção de 2026-08-12: a redação anterior citava como aspas literais
> uma frase — "can only be invoked by the user, not by the model itself" —
> que não existe em página nenhuma da documentação; 0 ocorrências no corpo
> inteiro `llms-full.txt`. A conclusão continua válida, agora apoiada na
> evidência que existe de fato. Ver `notes/proposals/maintenance-2026-08-11.md`
> D-2.)*

### Exact text — `notes/proposals/method-v7-model-effort-proposal.md:40-41`

Replace claim 1:

> 1. "/model can only be invoked by the user, not by the model itself" —
>    https://code.claude.com/docs/en/commands.md

with:

> 1. `/model` is a built-in command, not a skill: "A command is only recognized at
>    the start of your message", and the all-commands table marks `[Skill]` entries —
>    the ones "Claude can also invoke automatically" — while the `/model` and
>    `/effort` rows carry no such marker —
>    https://code.claude.com/docs/en/commands.md
>    *(Corrigido em 2026-08-12: a redação original citava uma frase inexistente na
>    documentação. A conclusão não muda. Ver `maintenance-2026-08-11.md` D-2.)*

---

## D-3 — two watchlist recipes hunt for wording that does not exist

Direct consequence of D-2: the recipes tell a future run to confirm a sentence that is
not there. A run following them literally will either report a false regression or
invent a confirmation. Both were written from the same bad citation.

### Exact text — `notes/maintenance/WATCHLIST.md:26` (Axis A, Built-in commands)

Replace the recipe cell:

> Confirm `/model` is still described as user-only

with:

> Confirm the `/model` row still carries **no** `[Skill]`/`[Workflow]` marker, and that
> the legend above the table still says built-ins are "coded into the CLI" while
> `[Skill]` entries are "a prompt handed to Claude, which Claude can also invoke
> automatically when relevant"

### Exact text — `notes/maintenance/WATCHLIST.md:66` (Axis D, row 1)

Replace the recipe cell:

> Confirm the user-only wording still stands

with:

> Two checks. Presence: `grep -n "only recognized at the start of your message"` in
> `commands.md` → that sentence, and only that sentence, is the citable basis.
> Absence: `grep -c "not by the model itself"` over `llms-full.txt` → **expect 0**.
> Do not re-cite the string the CHANGELOG once carried; it is not in the docs

### Exact text — `kit/my-method/commands/update-method.md:87-88`

Replace, inside the Axis D delegation paragraph:

> Then: is `/model` still user-only, is `/effort`
> still user-only, is `${CLAUDE_EFFORT}` still a documented
> substitution.

with:

> Then: does the all-commands table still leave the `/model` and
> `/effort` rows unmarked by `[Skill]`/`[Workflow]` (the structural
> form of "the model cannot switch itself" — do NOT go looking for a
> "user-only" sentence, there is none), is `${CLAUDE_EFFORT}` still a
> documented substitution.

---

## D-4 — the changelog recipe reads the wrong thing, twice over

`WATCHLIST.md:22` (Axis A row 1) and `WATCHLIST.md:82` (Axis E row 1) both say to read
`##` headings on `changelog.md`. Two independent problems:

1. **The docs changelog lags the shipped binary.** On 2026-08-11 the page topped out at
   **2.1.227 (August 10, 2026)** while `releases/latest` already reported **v2.1.228**,
   `published_at` 2026-08-11T19:50:59Z — and the installed CLI was 2.1.228. Any recipe
   that reads the changelog's top entry as "the current CLI version" is reading the
   latest *documented* version, which is a different number.
   Sources: <https://code.claude.com/docs/en/changelog.md> and
   <https://api.github.com/repos/anthropics/claude-code/releases/latest>, both accessed
   2026-08-11.
2. **The heading form is unreliable.** Axis A reports that the literal first `##` on
   the `.md` variant is `## Documentation Index` (a fetch preamble, not content), with
   the first *version* heading below it. Axis E reports the page uses
   `<Update label="…" description="…">` blocks and that *"a recipe that greps for `##`
   finds nothing"*. **The two reports disagree about the page's markup** — see the
   Disagreements section. The fix below is deliberately written to work either way.

### Exact text — `notes/maintenance/WATCHLIST.md:22`

Replace the recipe cell:

> Read the first `##` heading: it is the latest version and its date

with:

> Read the first **version** entry — skip any `Documentation Index` preamble, and note
> the page may render entries as `<Update label="…" description="…">` rather than `##`.
> Then **always cross-check** `GET https://api.github.com/repos/anthropics/claude-code/releases/latest`
> → `tag_name`, `published_at`. The docs page lags: on 2026-08-11 it topped out at
> 2.1.227 while Releases reported 2.1.228. Releases is the version signal; the changelog
> is the prose

### Exact text — `notes/maintenance/WATCHLIST.md:82`

Replace the recipe cell:

> Read every `##` entry newer than that date

with:

> Read every version entry newer than that date (see Axis A row 1 on the heading form),
> and cross-check GitHub Releases for anything the docs page has not documented yet

---

## D-5 — a watchlist recipe cannot catch the change it exists to catch

`WATCHLIST.md:30` (Axis A row 9, headless) says: *"Confirm `-p` still loads plugins by
default (only `--bare` skips them)."* That is true today — and the page carries a
`<Note>` announcing it will stop being true:

> `--bare` is the recommended mode for scripted and SDK calls, and will become the
> default for `-p` in a future release.

Source: <https://code.claude.com/docs/en/headless>, accessed 2026-08-11.

**Why this matters here.** If that lands, `claude -p` stops loading plugins by default,
and **every probe in this repo that relies on the kit being loaded in a `-p` run
silently stops testing the kit**. Named targets:

- `kit/my-method/commands/health-check.md`, **Probe 1 step 1** — "This command executing
  at all proves the plugin loaded in this session." Under a default `--bare`, the
  command would not execute at all, so the probe cannot report FAILED; it never runs.
- `kit/my-method/commands/health-check.md`, **Probe 3** (commit gate) — bare mode skips
  hook auto-discovery, so the gate would not fire and the probe would read "gate did not
  fire" as a pass condition it was never testing.

**No version is named, so nothing is actionable yet.** What is actionable is the recipe:
as written it confirms the current state and never looks at the sentence where the
reversal will be announced.

### Exact text — `notes/maintenance/WATCHLIST.md:30`

Replace the recipe cell:

> Confirm `-p` still loads plugins by default (only `--bare` skips them)

with:

> Confirm `-p` still loads plugins by default (only `--bare` skips them) — **and read
> the `<Note>` under "Start faster with bare mode"**, which as of 2026-08-11 says
> `--bare` "will become the default for `-p` in a future release". That Note is where
> the reversal gets announced, and it would break health-check probes 1 and 3 silently

---

## D-6 — `method.md` STEP 5a claims more than the docs support

`method.md:140-141`, and its embedded copy at
`kit/my-method/commands/start-project.md:174-175`:

> Only the user can switch model or effort; if they decline or do not switch, build on
> the current settings and do not raise it again.

True of the `/model` and `/effort` **commands**. Not true in general:
<https://code.claude.com/docs/en/model-config> (accessed 2026-08-11) lists six ways to
set effort, and the sixth is *"**Skill and subagent frontmatter**: set `effort` in a
skill or subagent markdown file to override the effort level when that skill or subagent
runs"*.

**No behaviour changes.** Method v7 deliberately rejected the frontmatter path because
it is turn-scoped — a decision this run re-verified as still correct (see "Confirmed
unchanged" below). The sentence is simply broader than the evidence, and a future reader
will find the docs contradicting the method.

**Note `next-task.md:54-55` already says it correctly** — *"You cannot switch model or
effort yourself"* — which is accurate and needs no edit. The axis-A report claimed
`next-task.md` carried the same defect; it does not. Verified 2026-08-12.

### Exact text — `method.md:140-141` and `kit/my-method/commands/start-project.md:174-175`

Replace, in both:

> Only the user can switch model or
> effort; if they decline or do not switch, build on the current
> settings and do not raise it again.

with:

> Only the user can switch the session's model or
> effort; if they decline or do not switch, build on the current
> settings and do not raise it again.

**Cost you should weigh before approving this one.** It is a one-word fix, but
`method.md` changing text triggers the apply procedure's step 1: bump the version
(v7 → **v8**), add the origin nota, and record provenance in `friction.md`'s YOURS
section as the **external-change** class. That is a version bump for a word. The
alternative is to hold D-6 until the next change that touches `method.md` anyway and
batch them. **Recommendation: apply it — an imprecise load-bearing sentence in the
canonical method is worth more than a tidy version number, and the provenance entry is
exactly what the external-change class was created for.** Veto it and nothing else in
this proposal is affected.

---

# CANDIDATES

Default answer is no. A candidate is adopted only if it removes something the method
currently does, or closes a gap an audit already named.

## C-1 — Betterleaks as gitleaks' successor · **Recommendation: NO, not yet**

gitleaks' own README, verbatim and unchanged since the baseline:

> Gitleaks is feature complete. I'm not merging new features into Gitleaks. Future
> releases will be security patches only. I'm shifting my focus to
> [Betterleaks](https://github.com/betterleaks/betterleaks)

Betterleaks was **never fetched before this run** — it was a NOT VERIFIED item on the
ledger. It is now verified real:
`created_at` 2026-02-03, latest release **v1.7.4** (2026-08-10, *one day before the
sweep*), **17 releases in ~6 months**, MIT, `archived: false`, 1,647 stars, maintained
*"by the folks who made Gitleaks, including the original author"*, and it ships
**sigstore-signed** checksums, which gitleaks does not.
Source: <https://api.github.com/repos/betterleaks/betterleaks>,
<https://raw.githubusercontent.com/betterleaks/betterleaks/main/README.md>, accessed
2026-08-11.

**Migration cost is genuinely low:** `cmd/git.go` is structurally the same file —
`Use: "git [flags] [repo]"`, same positional default, same flag shorthands, and it
reads `.gitleaksignore` for compatibility. Row 8.1's command maps to `betterleaks git .`
with the same meaning. This repo ships no gitleaks config, so the one genuinely breaking
change (CEL → Expr config language) costs nothing here.

**Why still no.** gitleaks v8.30.1 works, is MIT, and is not abandoned — frozen ≠ dead.
Betterleaks is 6 months old and moved 7 minor versions in that time. And **detection
parity was not measured** — that needs both binaries and a test corpus, i.e. an install
(NOT VERIFIED 9 below). Fix D-1 first so row 8.1 types a command that runs at all; treat
the switch as a separate, deliberate decision later. Both changes touch the same lines,
so doing D-1 first costs nothing.

## C-2 — record the Semgrep-vs-2025 coverage boundary · **Recommendation: YES**

Qualifies under the adoption rule: it closes a gap the **previous run already named**
(`LAST-CHECK.md:58-62`, finding 2 — "OWASP 2025 has two categories this repo covers
nowhere: A03 Software Supply Chain Failures and A10 Mishandling of Exceptional
Conditions").

This run measured it precisely. The `p/owasp-top-ten` ruleset was downloaded whole
(1,448,110 bytes) and parsed: **559 rules**, of which **517 (92.5%) carry a 2025 code**.
But:

- **`A10:2025` appears in 0 of 559 rules.**
- **"Software Supply Chain Failures" (A03:2025) appears in 0 of 559 rules.**

Source: <https://semgrep.dev/c/p/owasp-top-ten> (the `/c/p/` config endpoint), accessed
2026-08-11.

**The point:** now that the ruleset *is* 2025-keyed, it becomes tempting to read a clean
`semgrep --config p/owasp-top-ten` run as covering the 2025 Top 10. It does not — the
two categories the 2025 edition added or broadened are exactly the two a code-pattern
scanner cannot see. Row 10.1 (`npm audit` / `pip-audit`) already covers part of A03's
ground, which is worth stating rather than leaving implied.

**Cost: one paragraph of prose** in `research/13-testing-strategy.md`, near the
"what an LLM-driven review can and cannot establish" material, and/or the matrix's
HONESTY section (`playbook/SECURITY-MATRIX.md:16-32`). No tool change, no dependency.
Exact wording to be drafted at apply time against the current text of those sections.

## C-3 — "check the invocation, not just the project" · **Recommendation: YES**

Qualifies: it closes the gap that let D-1 — this run's only real breakage — survive a
full baseline pass undetected. Every Axis B recipe probed *liveness and version*
(`releases/latest` → `tag_name`); none probed *the command line*. A tool can be alive,
unarchived, freshly released, correctly licensed — and still reject the exact string the
matrix types.

**Cost: one sentence in the preamble, plus one clause per Axis B recipe.** The concrete
probes are already written by this run and cost nothing to adopt: for a Go/cobra tool,
read the `func init()` block of the subcommand's file; for npm, grep `<main>` not the
whole HTML (34 `deprecat*` hits in the full page are all left-nav noise); for Semgrep,
grep the CLI reference for the literal `--config p/` example.

### Exact text — `notes/maintenance/WATCHLIST.md`, after line 12

Append a third rule to the preamble:

> Third rule, learned from the 2026-08-11 run: a recipe must check the **invocation**,
> not just the project. `gitleaks git -s .` sat in row 8.1 through a full baseline pass
> because every recipe asked "is the tool alive and current" and none asked "does it
> still accept the exact string we type". For a Go/cobra tool, read the `func init()`
> block of the subcommand's own file; for a docs page, grep `<main>`, not the whole
> HTML; for a registry config, grep the CLI reference for the literal flag example.

## C-4 — method v7's UP trigger should prefer `opus` over `fable` on security cards · **Recommendation: YES**

Qualifies: closes a gap the previous run already named (`LAST-CHECK.md:64-67`,
finding 3 — "Fable 5 auto-falls-back on cybersecurity-flagged prompts… which is the one
class of task where that model may not be the one that answers").

This run made it actionable. Verbatim from
<https://code.claude.com/docs/en/model-config> (accessed 2026-08-11):

> * **Fable 5**: biology-flagged requests re-run on Opus 5, and cybersecurity-flagged
>   requests re-run on Opus 4.8.
> * **Opus 5**: cybersecurity-flagged requests re-run on Opus 4.8. Biology-flagged
>   requests end with a refusal instead.

Independently confirmed on a second page — <https://code.claude.com/docs/en/claude-security>
(accessed 2026-08-11): *"Due to Fable 5's cybersecurity safety classifiers, certain model
activities will be blocked and automatically downgraded to Opus."*

**The consequence, stated concretely.** The UP trigger fires when a card carries REVIEW
security rows on `authentication`, `authorization` or `payments`
(`kit/my-method/commands/start-project.md:663-668`). On exactly those cards,
**recommending `fable` lands the user on Opus 4.8 — weaker than the Opus 5 that `opus`
resolves to on the Anthropic API.** Recommending the strongest-sounding model produces
the weaker result. `opus` degrades one step instead of two and never refuses outright on
this category.

Also worth knowing, same source: *"Fallback can trigger on the first request of a
session… because the first request carries workspace context such as your CLAUDE.md
content and git status. A repository that contains security or biology material can trip
the classifier on that context alone."* Nothing in the kit detects this.

**Cost: two lines** in the embedded planning half. Note the kit currently names **no**
model anywhere — the UP trigger is written in the abstract ("stronger model and/or
higher effort"), so this adds a caution, it does not remove a recommendation.

### Exact text — `kit/my-method/commands/start-project.md`, after line 673

Replace:

> Name values the user can actually type with `/model` and `/effort`.

with:

> Name values the user can actually type with `/model` and `/effort`.
> On a card whose UP trigger is the security one, prefer `opus` over
> `fable`: cybersecurity-flagged requests re-run on Opus 4.8, so `fable`
> lands *below* what `opus` resolves to, and the classifier can fire on
> repository context alone before the card is even read
> (code.claude.com/docs/en/model-config, 2026-08-11).

## C-5 — point health-check probe 1 at `claude doctor` first · **Recommendation: NO**

`/doctor` (alias `/checkup`) became "a full setup checkup that can diagnose and fix
issues" in v2.1.205, 2026-07-08 — a month *before* this repo's first commit, so it fails
axis E's "did not exist when this method was written" test. It covers install health,
duplicate/leftover installs, PATH, unparseable settings, unused-plugin context cost,
slow hooks, and whether a newer version exists.
Source: <https://code.claude.com/docs/en/commands>, accessed 2026-08-11.

It makes **roughly half of one probe out of five** redundant. It does not touch probe
1's second half (comparing `plugin details` inventory against the kit on disk — it has
no notion of "the kit that was last applied"), probe 2, probe 3 (nothing built-in tests
that a *specific* hook fires), probe 4, or probe 5. Cost is one line; value is one line.
**No, by the default rule.** Cheap to add if you want it.

## C-6 — declare which store owns a fact: `STATE.md` vs auto memory · **Recommendation: NO, but record it**

Auto memory shipped v2.1.59, **2026-02-26** — five months before this repo's first
commit, so not an axis-E candidate. It writes Claude-curated notes to
`~/.claude/projects/<project>/memory/`, with `MEMORY.md` loaded into every conversation.
Source: <https://code.claude.com/docs/en/memory>, accessed 2026-08-11.

It does **not** make `STATE.md` obsolete, for three sourced reasons: auto memory is
machine-local and not in git, while STATE.md is committed and is one of the three status
files `verify-gate.ps1` denies a commit for missing; auto memory is Claude-curated,
while STATE.md has seven named sections that `where-am-i.md` and `next-task.md` read by
name; and only the first 200 lines / 25 KB of `MEMORY.md` load.

**The real observation is narrower and worth recording:** the method never mentions auto
memory at all, so nothing says which store owns a fact when both exist. That is a
documentation gap, not an obsolescence. It is also live for this user — this repository
has an auto-memory directory today. **No change proposed; carried to the ledger** so the
next run can weigh it against a real T2 project.

## C-7 — `claude-security` plugin · **Recommendation: NO — add to the DEFERRED list**

The one security tool this repo's audits never evaluated. Announced Week 30
(July 20–24, 2026), ~3 weeks *before* this repo's first commit, so not an axis-E
candidate. Multi-agent: maps architecture, builds a threat model, hunts vulnerabilities,
and independently verifies every finding.
Source: <https://code.claude.com/docs/en/claude-security>, accessed 2026-08-11.

**Why it does not replace `security-reviewer`**, per its own docs: it is unkeyed to
matrix row IDs; its unit of output is a report directory rather than a per-card finding;
**"Scans are nondeterministic: two scans of the same code can surface different
findings"** — while STEP 5c's fix loop requires a fresh reviewer to clear *the same
row*; and its patch flow contradicts the reviewer's structural read-only guarantee
(`tools: Read, Grep, Glob`). Costs: v2.1.154+, a **paid plan** (on Pro, dynamic
workflows must be enabled in `/config`), `python3` ≥ 3.9.6, significant tokens, counts
against usage limits.

**Proposed action: add one row to `WATCHLIST.md` Axis C**, on the same DEFERRED footing
as `security-guidance`, with trigger "a real T2/T3 project reaches STEP 5c and the
matrix's REVIEW rows prove too many to review one at a time", and "Observable from this
repo? **No** — ask the user".

## C-8 — teach `update-method` what to do when the session dies mid-run · **Recommendation: YES**

This run hit it: Step 3 says to read only the five-line summaries, but those live in the
delegating session's context and do not survive `/clear` or a crashed session. The five
research files do survive — they are the durable artifact — but the command never says
to fall back to them.

**Cost: two sentences** in `kit/my-method/commands/update-method.md` Step 3.

### Exact text — `kit/my-method/commands/update-method.md`, Step 3, after line 110

Append:

> If the five summaries are not in this session's context — because the run was
> interrupted, cleared, or resumed later — read the five research files in full
> instead. They are the durable record; the summaries are not. Say in the proposal
> that this is what happened, and check the axis files' own dates against the ledger
> before trusting them as current.

---

# WHERE THE SUBAGENTS DISAGREED

Recorded rather than silently resolved, because both are load-bearing.

## 1. Should health-check probe 1 compare version strings?

- **Axis A** says yes: the install is pinned at 0.1.0 while the kit is 0.2.0, the
  component inventory matches, so the probe passes and *"a stale install with an
  unchanged component count is invisible to the current check."*
- **Axis C** says no: *"Probe 1 of `/health-check` comparing component inventory rather
  than version strings is the correct design and needs no change."*

**Resolution: axis C is right, and axis A's cure is the thing the ledger already warns
against.** `LAST-CHECK.md:92-95` records, from test T4, that the install record stays
pinned while `plugin details` reads the source live, and that **"A difference between
those two numbers is expected, not a failure."** Comparing them would produce a
permanent false alarm. Axis A's underlying concern is real but has no cheap fix, and the
condition it fears — a stale *loaded* kit — is precisely what the inventory comparison
already detects. **No change proposed to probe 1.**

Axis C also added physical corroboration that was not in the record: `diff -rq` against
the pinned cache directory shows it holds **1 command, 4 templates, no agent, no hook**,
while `plugin details` reports 6 skills / 1 agent / 1 hook. So the commit gate and the
`security-reviewer` are loaded **only** because the harness reads the kit source live.
That is T4's conclusion confirmed by a second, independent method — and it remains
**undocumented behaviour**, so probe 1 watching for it is still the right design.

## 2. What markup does the docs changelog use?

- **Axis A**: the `.md` variant's first literal `##` is `## Documentation Index`, and
  version headings are `## 2.1.227 (August 10, 2026)`.
- **Axis E**: the page uses `<Update label="…" description="…">` blocks, and *"a recipe
  that greps for `##` finds nothing."*

Both read the same URL on the same day and describe its markup differently — plausibly
because they fetched through different paths (raw `curl` vs a fetch tool that
post-processes). **Not resolved here**, and it goes to NOT VERIFIED. D-4's replacement
recipe is deliberately written to work under either markup, and anchors the version
signal on GitHub Releases, which is unambiguous JSON.

---

# CONFIRMED UNCHANGED — the good news, sourced

Recorded so the next run does not re-derive it. All accessed 2026-08-11.

- **Every mechanism the commit gate depends on is intact.** `PreToolUse` still "Can
  block it"; `permissionDecision: "deny"` still documented; plugin `hooks/hooks.json`
  still a supported location; `disableAllHooks` still exists with its managed-settings
  caveat. (`hooks.md`)
- **`disable-model-invocation` and `argument-hint` are character-for-character
  identical** to the prior record — all six kit commands remain valid. (`skills.md`)
- **`${CLAUDE_EFFORT}` is still in the substitutions table**, and `${CLAUDE_MODEL}` is
  still absent — so `next-task`'s effort self-check works and its model asymmetry is
  still correct by design. (`skills.md`)
- **Frontmatter `model:`/`effort:` are still turn-scoped**, verbatim: *"the session
  model resumes on your next prompt"* — v7's reason for not using them holds word for
  word. (`skills.md`)
- **`tools:` is still an allowlist and still honoured for plugin agents** — the
  exclusion list for plugin subagents is `hooks`, `mcpServers`, `permissionMode`, and
  `tools` is not in it. `security-reviewer`'s read-only guarantee is still structural.
  (`sub-agents.md`)
- **Local-path marketplaces are still first-class.** This repo remains a supported
  shape. (`plugin-marketplaces.md`)
- **Zero dead models.** Every model and effort value named anywhere in the 42 tracked
  files exists today. The structural reason, worth preserving: **the repo names only
  aliases, never a dated full model ID** — and `claude-opus-4-1-20250805` retired on
  2026-08-05, six days before the sweep. (`model-config.md`,
  `platform.claude.com/.../model-deprecations.md`)
- **The Semgrep ruleset is NOT 2021-keyed** — 517 of 559 rules carry a 2025 code. The
  prior run's "strong suspicion: 2021" (`LAST-CHECK.md:108-109`) is **wrong and is
  retired**. The semantic gap it flagged does not exist.
- **`semgrep --config p/owasp-top-ten`, `npm audit`, `pip-audit`, and `gitleaks version`
  all still accept exactly what the repo types.** Checked against each tool's own
  current documented CLI, not its existence.
- **OWASP Top 10:2025 is still the current edition**, final, no RC regression, no new
  category — so `research/13`'s citations are correct. **All six** cited cheat sheets
  resolve with matching titles and real content (63–178 KB each).
- **npm's docs shelf is still `/cli/v12/`** — the meta-refresh target is unchanged, so
  the matrix's footnote alias still resolves.
- **Nothing to install, still.** All six DEFERRED items re-read against their triggers:
  none MET. `audit-02`'s "Minimum set to install now: NOTHING" survives unchanged.
- **No renames** affecting any of the five watched plugins — the official marketplace's
  `renames` map (9 entries) contains none of them, in either direction. Catalog is 287
  plugins, up from 285 on 2026-08-10.
- **Axis E: zero candidates.** Nothing released in the window makes any part of this
  repo obsolete. Both releases in range are fixes; the one blog post is an enterprise
  compliance-API expansion.

Two method notes from the same sweep, neither requiring action:

- **`max` is session-only, and v7's loop ends every task with `/clear`.** A card
  recommending `/effort max` does not survive to the next card, by design. Worth knowing
  before anyone writes one.
- **The official marketplace catalog must be parsed, never summarized.** A summarizing
  fetch of `marketplace.json` returned **221 plugins** and three false "does not exist"
  verdicts against the same file the same day; the raw parse returned 287. Axis C's
  recipe table already records this; it is the single most dangerous methodology trap
  found this run.

---

# QUESTIONS ONLY YOU CAN ANSWER

Axis C returned four UNKNOWABLE-FROM-HERE triggers plus one judgement call. They are not
critical-class questions, so they are grouped — answers stay separable one by one. These
are asked in the Portuguese summary; recorded here so they are not lost.

1. **`frontend-design`** — since 2026-08-10, did any project of yours (outside this repo)
   get a *user-facing screens* task on its `PLAN.md`?
2. **`webapp-testing`** — did a *web UI* task reach verification in any project, and did
   you record in that project's `friction.md` that authoring the committed Playwright
   specs was hard? (Both halves required; the second needs a friction entry, not an
   impression.)
3. **`playwright` MCP** — only if 2 is yes: did you need *interactive browser debugging*,
   or did written-and-committed specs suffice?
4. **`security-guidance`** — have you started, or are you about to start, a project that
   requires login or stores other people's personal data (tier T2)? If yes, the recorded
   order says try Semgrep-in-verify + the built-in `/security-review` first. Warning:
   `semgrep` is not installed on this machine.
5. **TDD stage (judgement call)** — in the 2026-08-11 pilot, the "human" check was
   passed by a simulated persona with nobody opening the GUI
   (`CHANGELOG.md:265-267`). Does that count as "an unfalsifiable check in a pilot",
   which would trigger the prose-only TDD stage? **Strict reading: no** — no wrong
   behaviour was ever observed, the two automated checks really ran, and the pilot itself
   declares this a limitation of the test rig.

`skill-creator` needs no question: NOT MET, answerable from here — no scheduled task, no
eval mechanism anywhere in the repo.

---

# APPLICATION ORDER

Follows `update-method.md` MODE 2 Step 2. Items map to that numbering.

1. **`method.md`** — D-6 only. Triggers v7 → **v8**, an origin nota, and a `friction.md`
   YOURS provenance entry in the **external-change** class. Skip if D-6 is vetoed.
2. **`playbook/SECURITY-MATRIX.md`** — D-1 (row 8.1), D1-b (footnote date), C-2 (HONESTY
   paragraph, if approved).
3. **`research/13-testing-strategy.md`** — C-2 only.
4. **Kit commands** — D-3 (`update-method.md` Axis D wording), C-8 (`update-method.md`
   Step 3 fallback).
5. **The embedded copies inside `start-project.md`** — D-1 (row 8.1 at :443), D-6
   (:174-175), D1-b (footnote), C-4 (UP-trigger caution after :673), plus the embedded
   matrix/method copies of anything changed in 1–3. **Same commit, always.**
6. **`kit/my-method/.claude-plugin/plugin.json`** — bump `version` 0.2.0 → 0.3.0. Per
   T4, this is *not* the delivery mechanism (the harness reads the kit source live); it
   is the honest record of which kit a session ran, and the documented fallback.
7. **`notes/maintenance/WATCHLIST.md`** — D-1 (:42), D-3 (:26, :66), D-4 (:22, :82),
   D-5 (:30), C-3 (new preamble rule), C-7 (new Axis C row).
8. **`notes/maintenance/LAST-CHECK.md`** — append run 2's entry: the five windows above,
   what was applied, what was rejected and why, the SETTLED items (Semgrep 2025 keying;
   Betterleaks verified; `plugin list --json` fields confirmed), and the full NOT
   VERIFIED list below.
9. **`kit/my-method/commands/health-check.md`** — rewrite the two literal lines
   `Last full maintenance run:` and `Kit inventory at that run:` to the apply date and
   the new counts. Skip this and the health check lies in every project folder from now
   on.
10. **`CHANGELOG.md`** — D-2's correction (:129-132) plus one new entry in Portuguese,
    in the existing style, naming plugin version 0.3.0.

Then the two mechanical checks, both blocking: byte-for-byte comparison of each
canonical file against its embedded copy in `start-project.md` (report line counts and
divergence count), and `claude plugin validate ./kit/my-method` with raw output shown.

---

# TEST PLAN

Nothing here is provable by re-reading the diff. Each item names what would actually
demonstrate it.

| # | What to test | How | Passes if |
|---|---|---|---|
| T1 | The gitleaks fix is real, not just different | Install gitleaks, run `gitleaks git .` in this repo, then `gitleaks git -s .` | The first runs and reports; the second errors on the unknown shorthand. **This is the only test that converts D-1 from documented to observed** (see NOT VERIFIED 4) |
| T2 | Embedded copy stays in sync | Byte-compare matrix ↔ its copy in `start-project.md` after the edit | 0 divergences, line counts reported |
| T3 | The kit still loads | `claude plugin validate ./kit/my-method`; then `claude plugin details my-method` | `✔ Validation passed`; inventory still 6 skills / 1 agent / 1 hook |
| T4 | Health-check's mirrored dates are honest | Run `/my-method:health-check` in a *different* folder | It reports the new date and the new counts, not the old ones |
| T5 | The `/model` recipe is runnable | Follow D-3's replacement recipe literally | Presence grep returns the sentence; absence grep returns 0 |
| T6 | C-4 changes a real card | Plan a task with a REVIEW row on `authentication` in a scratch project | The card's `Model/effort:` line names `opus`, not `fable` |

T1 requires installing a third-party binary and is the one item that needs your approval
before it can run at all.

---

# WHAT THIS DOES NOT GUARANTEE

- **It does not prove `gitleaks git .` finds anything.** It proves the string is accepted
  and that the old one is not. Detection quality was never in scope.
- **It does not make the matrix's AUTOMATED rows runnable on this machine.** `semgrep`,
  `gitleaks` and `pip-audit` are still not installed (`friction.md:227-228`, re-confirmed
  by health-check T1). Fixing the string does not fix the absence of the tool.
- **Axis E's clean result is nearly worthless as evidence.** One-day window. Its only
  real value is giving the next run a lower bound of 2026-08-11.
- **Axis C's verdicts about your other projects are not verdicts.** Four of six triggers
  are unobservable from here by construction.
- **Nothing here was tested by running it.** This is a research pass; the axis files were
  produced by subagents that installed nothing and changed nothing.
- **The five axis files are one day old at the time of writing.** Nothing in them was
  re-verified on 2026-08-12. Two Claude Code releases in a day is the observed cadence,
  so treat anything version-sensitive as one day stale.

---

# NOT VERIFIED — carried to the ledger

Never becomes a proposed change. Consolidated from all five axis files; each states why.

**New this run:**

1. **The exact error `gitleaks git -s .` produces.** gitleaks is not installed here and
   installing it was out of scope. What *is* verified is the load-bearing fact: no
   `-s`/`--source` on the `git` subcommand or among persistent flags, in both `master`
   and the `v8.30.1` tag. The precise cobra message is inferred, not observed.
2. **Betterleaks' detection parity with gitleaks.** Rule set, false-positive rate, and
   whether it finds what gitleaks finds were **not measured** — needs both binaries and a
   corpus. C-1's "low cost" covers invocation and licensing only.
3. **The docs changelog's markup**, and how far behind GitHub Releases it runs. Axis A
   and axis E describe the same page differently (see Disagreements); and one day's lag
   is not a pattern.
4. **Whether the four additions in the plugins-reference caching section are new since
   2026-08-10** or merely unquoted by the prior run. The prior run quoted selectively; no
   changelog entry names the section. Recorded as "present today", not "added".
5. **The date the `--bare`-will-become-default `<Note>` appeared.** The entire changelog
   contains no entry mentioning `--bare` or "bare mode" at any version. Live on the page
   2026-08-11; age unknown.
6. **Whether 2.1.228 contains anything relevant.** No 2.1.228 entry existed on the
   changelog page on 2026-08-11, though the binary was installed and Releases had
   published it.
7. **Whether `${CLAUDE_EFFORT}` substitution is contractually guaranteed inside plugin
   `commands/*.md` bodies.** The docs promise substitution "in the skill content" and say
   commands and skills "work the same way", but never enumerate plugin `commands/` by
   name. Probe P1 observed it working. **The fallback clause in `next-task.md:49-51`
   remains load-bearing and must not be removed.**
8. **Whether Haiku 4.5 and Sonnet 4.5 support effort at all.** Implied by omission
   ("Models not listed here do not support effort") but never stated positively. A card
   recommending an effort level alongside `haiku` would be silently ineffective.
9. **Whether the `/model` "user-only" sentence ever existed.** This run proves only its
   absence today across three surfaces. Anthropic publishes no docs-page history. Note
   the docs anchor is identical (2.1.227, Aug 10) in both readings, so no release
   intervened between the CHANGELOG's claimed check and this one.
10. **Whether the 287 vs 285 marketplace delta is genuinely +2 net.** Audit-02's 285 came
    from a different phrasing and may have counted a different field.
11. **The date `anthropics/claude-plugins-public` was renamed to `-official`.** The
    redirect is live (HTTP 301); its date is not exposed. Two catalog entries
    (`frontend-design`, `playwright`) still carry the old name in `homepage`. Breaks
    nothing; a future recipe hard-coding the old name would be building on a redirect.
12. **Whether auto memory is enabled for this repository.** A memory directory appears in
    session context, consistent with it being on, but `autoMemoryEnabled` was not read —
    that would mean reading outside the project folder.
13. **Whether this account can run `claude-security` at all.** Requires dynamic
    workflows, which on Pro must be enabled in `/config`. Not tested; the standing rule
    forbids changing settings.
14. **Whether the installed 0.1.0 cache copy differs in content from the kit** — axis C
    ran `diff -rq` and reports it does (1 command, 4 templates, no agent, no hook), which
    contradicts axis A recording this as unverifiable under the boundary rule. **The diff
    result is recorded as fact; the boundary question is flagged** — axis C read a
    directory under the user's home to get it.

**Carried forward, still open:**

15. **OWASP Top 10:2025's publication date.** Four surfaces exhausted this run — the
    project hub, `/Top10/2025/`, the introduction page, and the GitHub repo (which
    publishes **zero** releases and only three `2017-RC2*` tags). Recorded so the next
    run does not repeat them.
16. **OWASP's next-revision plan.** No forward-looking statement on any canonical page.
    The ~4-year cadence pointing at ~2029 is an inference, not a published plan.
17. **Whether the stale "2025 Data Analysis Plan" text is current or leftover.** Future
    tense on a page that simultaneously announces 2025 as released.
18. **Whether Semgrep's OSS CLI has feature gaps versus Pro.** No OSS-vs-paid capability
    matrix is published. Only the LGPL-2.1 license and the free registry `p/` path were
    confirmed.
19. **Human-visible content of `semgrep.dev/p/owasp-top-ten`.** Still an empty JS shell
    to a fetcher; a browser-rendered deprecation banner would be missed.
20. **Whether `docs.npmjs.com/cli/audit` is contractually pinned to the current major.**
    Two consistent observations (`/cli/v12/`), no documented contract.
21. **Whether `/hooks`, `/plugin`, `/skills` or `/context` produce output in `-p` mode.**
    Still not stated; the `-p` degradation list names only `/model`, `/effort`, `/fast`,
    `/color`, `/rename`, `/mcp`, `/config`.
22. **The `${CLAUDE_PLUGIN_ROOT}`-in-command-markdown dispute.** Docs say yes, issue
    \#9354 (open since 2025-10-11) says no. The kit depends on it in `hooks/hooks.json`
    only, where it is confirmed working. Out of scope for these axes.
23. **Which models this account can actually select.** Documentation cannot answer it;
    the `/model` picker can, interactively. The observed "Fable 5 requires usage credits"
    subagent termination is consistent with the documented billing note but does not
    settle the account's state.
24. **The blog post "Choosing a Claude model and effort level in Claude Code"**
    (<https://claude.com/blog/claude-model-and-effort-level-in-claude-code>), cited by
    `model-config.md` as the official guidance for model/effort selection — directly
    relevant to v7's triggers, **never opened**. Axis D calls it the highest-value open
    item on this axis.
25. **Whether a "Week 33" what's-new digest will cover Aug 10–14.** Week 32 is the
    newest; Week 31 is missing from the index entirely, so the weekly series has a known
    gap and is not complete coverage.
26. **Where `.claude/skills/my-method` lives** — axis C established it is a *symlink*
    into `kit/my-method`, so it cannot drift; the error is a name collision, not a stale
    duplicate. Removing it is a user decision, not a maintenance defect.

**Settled this run, moved out of NOT VERIFIED:**

- Semgrep `owasp-top-ten` edition keying → **2025-keyed** (517/559). Prior suspicion of
  2021 was wrong.
- Betterleaks existence, maturity, license, migration suitability → **verified real**,
  MIT, v1.7.4, 17 releases, same CLI shape, same maintainers.
- `claude plugin list --json`'s extra fields → **confirmed present** (`scope`,
  `installPath`, `installedAt`, `lastUpdated`, `errors`), still more than the docs
  describe.
- Whether a plugin that failed to load is listed → **yes, with an `errors` array**; the
  `my-method@skills-dir` entry is the proof.
