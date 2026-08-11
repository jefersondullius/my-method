---
description: Full maintenance pass of the method and its plugin — re-verifies Anthropic practices, vulnerability sources, installed skills and agents, models and effort levels, and runs one open sweep for what exists today that would make part of the method obsolete. Researches and PROPOSES; changes nothing without explicit approval.
argument-hint: [apply]
disable-model-invocation: true
---

You are running the maintenance pass for the my-method kit itself.
Two modes, selected by the argument:

- **no argument** — RESEARCH AND PROPOSE. Ends with a written proposal
  and a `/clear` instruction. Changes no method, command, template,
  matrix or manifest file.
- **`apply`** — apply a proposal the user has already approved.

## Safety check — before anything, in both modes

If `method.md`, `kit/my-method/.claude-plugin/plugin.json` and
`.claude-plugin/marketplace.json` are not ALL present in the current
directory, STOP. Say, in Portuguese, that this command only runs
inside the my-method repository, because it edits the kit's own files
and must never reach outside the current folder. Point at
`/my-method:health-check`, which runs anywhere.

---

# MODE 1 — research and propose (no argument)

## Step 1 — read what is already known

Read in full: `notes/maintenance/WATCHLIST.md` (what gets checked, and
the canonical URL and re-check recipe of each source) and
`notes/maintenance/LAST-CHECK.md` (per-axis last-check dates and the
previous run's NOT VERIFIED list). Read `method.md` and the most
recent `CHANGELOG.md` entry. Do not read the audits or the applied
proposals — the watchlist carries forward whatever still matters from
them.

Note each axis's last-check date. That date is the lower bound of every
"since when" question below. An axis with no date recorded uses the
repository's first commit date.

## Step 2 — delegate the five axes, in parallel

Launch FIVE subagents in a single batch. Give every one of them these
standing rules verbatim:

> Research only — install nothing, change no setting, and modify no
> file except the one output file named in your prompt. Every claim
> needs a URL and "accessed <today's date>". Anything you cannot
> confirm from a live source goes under NOT VERIFIED with the reason.
> Your own prior knowledge is NEVER a source, and "probably" is not an
> answer. An HTTP 200 is not evidence a source is alive — pages in
> this watchlist are known to return 200 for redirect shells,
> meta-refresh stubs and empty JavaScript pages; read the CONTENT.
> For every source you check, record the re-check recipe you used:
> the exact thing to read, in the exact place, for next time. Write
> your findings to the file named below, then reply with EXACTLY five
> lines summarizing what is decisive. No more.

Each writes to `notes/research-maintenance/<YYYY-MM-DD>-<axis>.md`.

**Axis A — Anthropic practices.** What changed in the official Claude
Code documentation since axis A's last-check date. Cover at minimum
the docs pages listed under A in the watchlist, plus the docs
changelog. For each change, say whether it touches this method or this
plugin, and name the file and step it touches. Changes touching
neither get one line each and are dropped.

**Axis B — Vulnerabilities.** Is the OWASP Top 10 edition named in
`research/13-testing-strategy.md` still current; has a revision or a
new category appeared. For each of `semgrep`, `gitleaks`, `npm audit`
and `pip-audit`: still maintained (latest release + date), still the
same command-line invocation the matrix's rows type, still free and
installable, or deprecated/renamed/abandoned. A tool that changed how
it is invoked is a defect in the matrix, not a note.

**Axis C — Skills and agents.** For everything installed
(`claude plugin list --json`): current version, renamed, deprecated or
abandoned. Then re-read each DEFERRED-with-trigger item in the
watchlist against its recorded trigger and report, per item, whether
the trigger is MET, NOT MET, or UNKNOWABLE-FROM-HERE. A trigger that
depends on the user's other projects cannot be observed from this
repository — say so, and the main session will ask the user.

**Axis D — Models and mechanisms.** Which Claude models and effort
levels exist today in Claude Code, and which the docs list as
deprecated or retired. Then: is `/model` still user-only, is `/effort`
still user-only, is `${CLAUDE_EFFORT}` still a documented
substitution. Any model named anywhere in this repository that no
longer exists is a defect — method v7 lets a task card name a model,
and a card naming a dead model sends the user to type a command that
fails.

**Axis E — The open sweep.** Answer exactly one question:

> What exists today that did not exist when this method was written,
> and that would make some part of it obsolete or unnecessary?

Read the Claude Code changelog entries since axis E's last-check date,
Anthropic's official news and blog posts in that same window, and the
docs pages the watchlist names. Two hard rules: (1) every candidate
must name the specific step, row, command, template or file of this
repository it would make obsolete or unnecessary — a candidate with no
named target is noise, discard it; (2) "nothing found" is a valid and
expected answer — if that is the answer, say it plainly and state the
window covered. Do not pad the list to look productive.

## Step 3 — read the five summaries, then write the proposal

Read only the five five-line summaries. Open a research file only to
quote a specific claim you are putting in the proposal.

Sort every finding into exactly one of three buckets:

- **DEFECT** — something the method or kit depends on changed or
  broke: a cited tool gone or renamed, a documented mechanism changed,
  a named model retired, a dead URL. Proposed as a fix.
- **CANDIDATE** — something new exists that could improve or replace
  part of the method. Proposed with its cost, and **the default answer
  is no**. A candidate is adopted only if it removes something the
  method currently does, or closes a gap an audit already named.
- **NOT VERIFIED** — could not be confirmed live. Never becomes a
  proposed change. Goes to the ledger so the next run starts from it.

Write `notes/proposals/maintenance-<YYYY-MM-DD>.md` in this
repository's existing proposal format: provenance; verified mechanism
with one URL and date per claim; decisions the user can veto one by
one; exact text per file; application order; test plan; what it does
NOT guarantee; NOT VERIFIED.

If every axis came back clean, write the proposal anyway saying so — a
run that found nothing is a result worth dating, and it is what
updates the ledger.

## Step 4 — present, in Portuguese, and STOP

At most 40 lines. Per axis: one line for what was checked and the
window; then the DEFECTS, each with its consequence in plain language;
then the CANDIDATES, each with its cost and your recommendation, which
is "no" unless it removes something; then the NOT VERIFIED count.

If axis C reported any UNKNOWABLE-FROM-HERE trigger, ask about those
here as ONE grouped question — these are not critical-class questions,
so grouping is allowed and the answers stay separable one by one.

Then end the turn with exactly this text and nothing else:

> Proposta escrita em `notes/proposals/maintenance-<data>.md`. Rode
> `/clear` e depois `/my-method:update-method apply` para aplicar
> depois de ler.

Do not apply anything in this session. Do not offer to.

---

# MODE 2 — apply (`apply`)

## Step 1 — load and re-confirm

Read the most recent `notes/proposals/maintenance-*.md`. Summarize in
Portuguese, in at most 10 lines, exactly what will change, file by
file. Ask for explicit confirmation and WAIT. If the user vetoes an
item, drop it and restate what remains before proceeding.

## Step 2 — apply, in this order

1. `method.md` — only if a DEFECT requires it. If its text changes,
   bump the version in the header, add the origin nota, and record the
   provenance in `friction.md`'s YOURS section: maintenance findings
   are the **external-change** class, distinct from pilot friction and
   from the recorded conscious exceptions.
2. `playbook/SECURITY-MATRIX.md` — tool, row or source changes.
3. `research/13-testing-strategy.md` — OWASP edition or reasoning.
4. The kit's commands, agents and templates.
5. **The embedded copies inside `kit/my-method/commands/start-project.md`.**
   That file embeds four texts: the method, the matrix, the templates
   and the `verify.ps1` skeleton. Any change to a canonical file above
   touches its embedded copy in the SAME commit.
6. **`kit/my-method/.claude-plugin/plugin.json` — bump `version`.**
   Version is the cache key the harness uses to decide whether an
   update is available; a change applied without a bump relies on
   undocumented behaviour to reach the installed copy.
7. `notes/maintenance/WATCHLIST.md` — add a line for every new URL the
   changes introduce; remove lines for sources that died.
8. `notes/maintenance/LAST-CHECK.md` — append this run's entry: date,
   axes covered with their windows, what was applied, what was
   rejected and why, and the full NOT VERIFIED list.
9. `kit/my-method/commands/health-check.md` — rewrite the two literal
   lines `Last full maintenance run:` and `Kit inventory at that run:`
   to today's date and the new counts. This is what the health check
   reports in every project folder; skip this and it lies from now on.
10. `CHANGELOG.md` — one entry, in Portuguese, in the existing style,
    naming the new plugin version.

## Step 3 — the mechanical checks, before committing

Both must pass; either failing blocks the commit:

1. Compare, byte for byte, each canonical file against its embedded
   copy in `start-project.md` (method, matrix, templates, verify
   skeleton). Report line counts and the number of divergences. This
   repository has recorded that duplication trap in `friction.md`
   since 2026-08-10 and has checked it mechanically on every method
   revision since v5.
2. Run `claude plugin validate ./kit/my-method` and show the raw
   output. It checks `plugin.json`, every command's and agent's
   frontmatter, and `hooks/hooks.json` for schema errors.

## Step 4 — commit, verify the harness picked it up, close

One commit, in English. Then show `git show --stat` raw.

Then run `claude plugin details my-method` and show the raw output.
If its component inventory does not match what was just applied, say
so plainly and tell the user to run
`/plugin update my-method@jeferson-tools` and then `/reload-plugins` —
applied on disk and loaded by the harness are two different things,
and only this output tells them apart.

End with exactly:

> Manutenção aplicada e commitada. Rode `/clear` antes de continuar.
