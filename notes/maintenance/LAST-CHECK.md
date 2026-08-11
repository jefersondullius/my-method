# LAST CHECK — maintenance ledger

Append-only. One entry per run of `/my-method:update-method`. The
per-axis dates here are the lower bound of the next run's "since when"
questions.

| Axis | Last checked | Run |
|---|---|---|
| A — Anthropic practices | 2026-08-11 | 1 (partial) |
| B — Vulnerabilities | 2026-08-11 | 1 |
| C — Skills and agents | 2026-08-10 | audit-02 (pre-ledger) |
| D — Models and mechanisms | 2026-08-11 | 1 |
| E — Open sweep | — | never run |

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
