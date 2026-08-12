# 13 — Testing strategy

*Scope note: this pass covers the SECURITY half only — the reasoning
behind `playbook/SECURITY-MATRIX.md`. Non-security testing strategy
(unit/integration/performance test approach) is not covered here and
is a separate piece of future work, not an oversight.*

## Legitimacy boundary

Every check discussed below applies only to systems the project owner
already owns or controls: this project's own code, and infrastructure
under his own accounts. "Testing an integration with a third-party
API" means testing how *this project's code* calls that API and
handles its responses — never probing, scanning, or load-testing the
third party's service itself. That line does not move regardless of
how easy a given tool makes it to point somewhere else.

## Vulnerability classes a small web app with login and personal data faces

For each class: what it is in plain terms, what kind of task tends to
introduce it, how it is checked, and whether that check can be
automated.

### 1. Injection (SQL, command, and similar)

**What it is.** User-typed text gets pasted directly into a command
the server runs (a SQL query, a shell command) instead of being kept
separate as data. If the text contains query/command syntax, the
server ends up running part of what the attacker typed.

**Introduced by.** Any task that builds a database query or a shell
command by concatenating strings that include user input, instead of
using parameterized queries / an ORM / a library's escaping function.

**How it is checked.** A static scanner (Semgrep with the OWASP
Top 10 ruleset) flags string-built queries; a human/LLM reviewer
double-checks any flagged spot and any query the scanner's pattern set
doesn't recognize.

**Automatable?** Yes, largely. Parameterized-query use is a
pattern-matchable code shape.

*Source: [OWASP Cheat Sheet Series — SQL Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html), accessed 2026-08-10 — "parameterized queries... enforce code-data separation," recommended as the primary defense. Also ranked A05:2025 in the current [OWASP Top 10:2025](https://owasp.org/Top10/2025/0x00_2025-Introduction/), accessed 2026-08-10.*

### 2. Broken authentication

**What it is.** Weaknesses in how the app proves "you are who you say
you are": weak password storage, no rate limit on login attempts,
login responses that reveal whether an e-mail is registered, sessions
that never expire.

**Introduced by.** Writing login/signup/password-reset logic from
scratch instead of using a maintained auth library; storing passwords
with a fast hash (or none); skipping session expiry.

**How it is checked.** Review of the password-storage code path for a
slow salted hash (Argon2id or bcrypt); a written test that a login
endpoint gives identical responses for "wrong password" and "unknown
e-mail."

**Automatable?** Partially. The "identical response" behavior is a
test that runs and passes/fails on its own. Whether the *library
choice itself* was sound is closer to a judgment call, though a
reviewer can flag a hand-rolled hash function with high confidence.

*Source: [OWASP Cheat Sheet Series — Password Storage](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html), accessed 2026-08-10 — recommends Argon2id or bcrypt with a unique salt per password, explicitly against fast general-purpose hashes. Named "Authentication Failures" at A07:2025 in the current OWASP Top 10.*

### 3. Broken authorization

**What it is.** The app correctly identifies *who* is logged in, but
does not check whether that person is *allowed* to touch the specific
piece of data being requested — the classic case is an Insecure Direct
Object Reference (IDOR): changing an ID in a URL exposes someone
else's record.

**Introduced by.** Any endpoint that takes an ID from the request
(user ID, order ID, document ID) and reads/writes the matching row
without also checking that the row belongs to the logged-in user.

**How it is checked.** Adversarial review of every handler that takes
an ID from the request; a written test that logs in as user A and
tries to read/modify a resource that belongs to user B, expecting a
403/404.

**Automatable?** The test itself, yes, once someone (human or LLM)
identifies which endpoints touch per-user resources. Finding *all* of
those endpoints in a large codebase is closer to REVIEW than AUTOMATED
— nothing scans for "a check that's missing" as reliably as it scans
for a pattern that's present.

*Source: [OWASP Cheat Sheet Series — Insecure Direct Object Reference Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Insecure_Direct_Object_Reference_Prevention_Cheat_Sheet.html), accessed 2026-08-10. Broken Access Control is A01:2025, currently ranked #1 in the OWASP Top 10 2025 — "on average, 3.73% of applications tested had one or more of the 40 CWEs in this category" per [Qualys' 2025 breakdown](https://blog.qualys.com/qualys-insights/2026/06/15/what-changed-in-owasp-top-10-2025-and-recommendations-for-each-category), accessed 2026-08-10 — NOT VERIFIED against the primary OWASP data report directly.*

### 4. Sensitive data exposure

**What it is.** Personal data (passwords, e-mails, documents, payment
details) is stored, logged, or transmitted in a way that exposes it if
something else goes wrong — plaintext passwords, secrets printed to
logs, personal data sent over plain HTTP.

**Introduced by.** Logging a whole request/response object without
redaction; storing a field "temporarily" in plaintext; skipping HTTPS
on a form that submits personal data.

**How it is checked.** Review of write paths to sensitive-looking
columns/fields for hashing/encryption; an automated check that the
deployed site refuses plain HTTP.

**Automatable?** The HTTPS check, yes — it is a network request with a
pass/fail answer. Whether a specific field "counts" as sensitive
enough to need hashing is a judgment call for review.

*Source: folded into "Cryptographic Failures," A04:2025 in the current OWASP Top 10 2025 (renamed from "Sensitive Data Exposure" in the 2017 list — the newer name describes the cause, the older name describes the symptom).*

### 5. Insecure/outdated dependencies

**What it is.** A third-party library the project depends on has a
publicly known vulnerability, and the project is using the vulnerable
version.

**Introduced by.** Adding any new dependency; letting existing
dependencies sit unpatched over time.

**How it is checked.** The ecosystem's own vulnerability scanner run
against the lockfile.

**Automatable?** Yes, fully — this is the cleanest AUTOMATED check in
the whole matrix. The tool either finds a matching CVE or it doesn't.

*Sources: [npm Docs — `npm audit`](https://docs.npmjs.com/cli/audit/), accessed 2026-08-10 — "scans your project's dependencies for known security vulnerabilities... categorizing vulnerabilities with low, moderate, high, or critical severity levels." [pypa/pip-audit](https://github.com/pypa/pip-audit), accessed 2026-08-10 — scans Python environments against the PyPI/OSV advisory databases.*

### 6. Security misconfiguration

**What it is.** The application or its hosting is set up in a way
that leaves an unnecessary door open: debug mode left on in
production, default credentials never changed, verbose error pages
that leak stack traces, missing security headers.

**Introduced by.** Copying a framework's default/dev configuration
straight into production without reviewing it.

**How it is checked.** A script that requests the deployed URL and
checks response headers and error-page behavior; review of the
production config/environment variables for debug flags.

**Automatable?** The header/error-page checks, yes. Whether the whole
configuration is *appropriate* for the project needs a reviewer to
read it, not just probe it externally.

*Source: "Security Misconfiguration" is A02:2025 in the current OWASP Top 10 2025, up from #5 in the 2021 list — per the [Qualys 2025 breakdown](https://blog.qualys.com/qualys-insights/2026/06/15/what-changed-in-owasp-top-10-2025-and-recommendations-for-each-category), accessed 2026-08-10.*

### 7. Secrets in source

**What it is.** A key, password, or token ends up committed to the
git repository — even if later deleted, it remains in git history
unless the history itself is rewritten.

**Introduced by.** Pasting a real API key into a config file during
testing and committing before moving it to an environment variable;
not gitignoring the `.env` file before creating it.

**How it is checked.** A secret scanner run over the working tree
*and* full git history before every push.

**Automatable?** Yes, fully.

*Source: [gitleaks/gitleaks](https://github.com/gitleaks/gitleaks), accessed 2026-08-10 — "scan your whole repository's history with all commits up to the initial one." Also [OWASP Cheat Sheet Series — Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html), accessed 2026-08-10 — secrets "should never be hardcoded," should come from environment/orchestrator injection instead.*

### 8. Unsafe file upload

**What it is.** A feature that accepts files from users can be abused
to upload something other than what was intended — a script disguised
as an image, an oversized file, a file that gets executed once stored.

**Introduced by.** Any "upload a file/photo/document" feature that
checks file type by a denylist (or not at all) instead of an
allowlist, or that stores uploads somewhere the server would execute
them.

**How it is checked.** Review of the upload handler's validation
logic against an allowlist of extensions/MIME types; a written test
for the size-limit rejection; a human decision about *where* uploaded
files are stored and served from.

**Automatable?** Partially — size-limit rejection is a clean pass/fail
test. Type-allowlisting logic and storage location are better suited
to review and a human decision, respectively, because "is this
storage location safe" depends on the hosting setup, not just the
code.

*Source: [OWASP Cheat Sheet Series — File Upload](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html), accessed 2026-08-10 — recommends an allowlist of extensions over a denylist, and warns that an allowlist itself needs review (e.g. `.shtml` enabling server-side include attacks).*

### 9. Missing rate limiting

**What it is.** Nothing stops an attacker (or a bug) from calling a
sensitive endpoint — login, password reset, an expensive search — as
many times as they want, enabling brute-force guessing or resource
exhaustion.

**Introduced by.** Any authentication or resource-intensive endpoint
shipped without a request-rate limit.

**How it is checked.** For a small project, this is closer to a
configuration decision (does the hosting platform or framework offer
built-in rate limiting? is it turned on for the login/reset routes?)
than something to hand-write. Review confirms it is enabled where it
matters; a human decision covers whether the chosen host/framework
even provides it out of the box.

**Automatable?** Weakly. A test *can* hammer an endpoint N times and
assert a 429 eventually appears, but that only proves the limit
exists, not that it is set to a sensible threshold — the threshold
itself is closer to a human/business call.

*Source: [OWASP Cheat Sheet Series — Denial of Service](https://cheatsheetseries.owasp.org/cheatsheets/Denial_of_Service_Cheat_Sheet.html), accessed 2026-08-10 — describes rate limiting by IP/geolocation/load as a defense, and states explicitly that "anti-DoS methods cannot be one-step solutions."*

## What an LLM-driven review can and cannot establish

An LLM subagent reading a diff can reliably: recognize known-bad
patterns (string-concatenated queries, missing ownership checks,
plaintext-looking password fields, hardcoded-looking secrets), and
explain *why* a pattern is risky with a concrete `file:line` and a
plausible attack scenario.

It cannot reliably: verify runtime behavior it never executes (whether
a "fixed" race condition actually stopped racing, whether a header is
actually sent by the deployed server rather than just present in
config), reason confidently across many files and indirect call
chains, or replace the AUTOMATED tests in this matrix that exist
specifically because they run code instead of reading it.

*Source: [ProjectDiscovery — "AI code review has come a long way, but it can't catch everything"](https://projectdiscovery.io/blog/ai-code-review-vs-neo), accessed 2026-08-10 — "code-only review misses issues that only become visible when you exercise an end-to-end flow." Specific numeric claims about LLM recall/precision on security review (e.g. exact false-negative rates) vary by study and model version — treated as NOT VERIFIED here rather than quoted as a fixed number.*

## What the Semgrep OWASP ruleset does and does not cover

The `p/owasp-top-ten` ruleset that rows 1.1 and 7.1 name **is** keyed
to the 2025 edition, not the 2021 one: of its 559 rules, 517 (92.5%)
carry a 2025 code. That closes an open question this repository had
recorded the other way around.

What it does not close is coverage. Two of the 2025 edition's
categories appear in **zero** of those 559 rules: `A10:2025`
Mishandling of Exceptional Conditions, and `A03:2025` Software Supply
Chain Failures (no rule mentions the phrase at all). That is not an
oversight in the ruleset — it is the shape of the tool. Both
categories are about what a system does at runtime and about where its
dependencies came from, and neither is visible in the source patterns
a static scanner matches.

The practical consequence for this matrix: a clean
`semgrep --config p/owasp-top-ten` run is evidence about the eight
categories the ruleset encodes, and says nothing about the other two.
Row 10.1 (`npm audit` / `pip-audit`) covers part of A03's ground —
known-vulnerable dependency versions — but not the rest of what the
2025 edition folded into supply chain (build and distribution
integrity, compromised maintainers). A10 is covered nowhere in this
matrix, and is left to the general "what an LLM-driven review can and
cannot establish" limits above.

*Source: [Semgrep — `p/owasp-top-ten` config endpoint](https://semgrep.dev/c/p/owasp-top-ten), accessed 2026-08-11. The `/c/p/` endpoint returns the ruleset itself (1,448,110 bytes); the counts above come from parsing it. The human-facing page `semgrep.dev/p/owasp-top-ten` is an empty JavaScript shell to a fetcher and cannot be read this way — NOT VERIFIED whether a browser-rendered banner on that page says anything the config endpoint does not.*

## Self-review weakness

The same model that wrote a piece of code, asked to review that code
immediately after in the same context, tends to re-apply the same
assumptions that produced the bug in the first place — it is checking
its own reasoning against itself, not against an adversarial
perspective. This is *why* `playbook/SECURITY-MATRIX.md` specifies
REVIEW checks as "a subagent with fresh context," not a self-check by
the same conversation that wrote the diff: fresh context means the
reviewer did not decide the original approach and has no stake in it
being right.

*NOT VERIFIED: no single authoritative study is cited here for the
magnitude of this effect specifically for security review; the
practice of using an independent reviewer (human or model) instead of
self-review is long-standing software engineering practice
independent of LLMs, and the reasoning is applied here by extension,
not by a directly cited security-specific study.*

## Payments: the design decision that matters most for a beginner

The single biggest risk-reducer available to a small project handling
payments is architectural, not a code check: **never let this
project's own code receive, store, log, or transmit a raw card number
or CVV.** Route card entry through the payment provider's own hosted
checkout page or embedded element (e.g. Stripe Checkout or Stripe
Elements), so the card number never passes through servers this
project controls.

This matters concretely for PCI-DSS scope. A merchant that fully
outsources card data handling to a compliant provider — nothing
stored, processed, or transmitted on the merchant's own systems, and
the payment page itself served by the provider — can qualify for
**SAQ A**, the shortest and least burdensome PCI self-assessment
questionnaire. The moment a project's own page collects or even
touches the card number directly, it moves into a much larger
compliance scope that a small project has no realistic way to satisfy
alone.

*Sources: [PCI Security Standards Council — SAQ A, PCI DSS v4.0](https://listings.pcisecuritystandards.org/documents/PCI-DSS-v4-0-SAQ-A.pdf), accessed 2026-08-10 — SAQ A is for card-not-present merchants that have "fully outsourced all cardholder data functions" with no cardholder data stored, processed, or transmitted on their own systems. [PCI SSC FAQ #1443](https://www.pcisecuritystandards.org/faqs/1443/), accessed 2026-08-10, dated 2016-11 on the source page — confirms outsourced transmission to a processor does not by itself break this eligibility; NOT VERIFIED for the exact redirect/iframe edge case (FAQ #1604), which the page referenced but did not display content for.*
