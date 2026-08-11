# External sources baseline — liveness and current state

Purpose: a dated snapshot of every external source a future maintenance command will
re-check. Each claim carries the URL it came from and the date it was accessed.
All checks in this file were performed live on the web on **2026-08-11**.

Method: `WebFetch` (page rendered to markdown) plus, where a page is
JavaScript-rendered or WebFetch returned an empty body, a direct HTTP request
(`curl -sSL -o /dev/null -w "%{http_code} %{url_effective}"`) and/or the public
GitHub REST API (`api.github.com`). Anything that could not be confirmed by one of
those is listed in the final **NOT VERIFIED** section instead of being guessed.

Legend for the status line of each item:

- **LIVE** — HTTP 200 reached and content read.
- **LIVE (JS-rendered)** — HTTP 200 reached, but the readable content had to come
  from a companion machine-readable endpoint.

---

## 1. Claude Code docs changelog

- Canonical URL: <https://code.claude.com/docs/en/changelog.md>
- Status: **LIVE** — accessed 2026-08-11.
- Page title: "Claude Code changelog". Source: <https://code.claude.com/docs/en/changelog.md>, accessed 2026-08-11.
- Latest version: **2.1.227**, dated **August 10, 2026**. Source: <https://code.claude.com/docs/en/changelog.md>, accessed 2026-08-11.
- Two preceding entries, for shape of the release cadence:
  - 2.1.226 — August 8, 2026 ("Bug fixes and reliability improvements").
  - 2.1.225 — August 8, 2026 (gateway spend-limit support in usage warnings; workspace
    trust prompt for `claude agents`; OAuth token fixes).
  - Source: <https://code.claude.com/docs/en/changelog.md>, accessed 2026-08-11.
- Cadence observation: three releases dated within a 3-day window (Aug 8–10, 2026),
  so a maintenance command should expect this page to move within days, not months.
  Source: <https://code.claude.com/docs/en/changelog.md>, accessed 2026-08-11.

### Re-check recipe

Fetch the URL and read the first `##` heading — it is the latest version and its date.

---

## 2. github.com/anthropics/claude-code

- Canonical URL: <https://github.com/anthropics/claude-code>
- Status: **LIVE** — HTTP 200, no redirect. Source: direct HTTP request to <https://github.com/anthropics/claude-code>, accessed 2026-08-11.
- Repository metadata (from <https://api.github.com/repos/anthropics/claude-code>, accessed 2026-08-11):
  - `full_name`: `anthropics/claude-code`
  - `archived`: **false**
  - `stargazers_count`: **141,056**
  - `open_issues_count`: **15,738**
  - `pushed_at`: **2026-08-10**
  - `license`: **none declared in the API metadata** (a `LICENSE.md` file exists at the
    repo root, but the API reports no SPDX license object)
- **Does it have a `CHANGELOG.md`?** **Yes.** The repository root listing includes
  `CHANGELOG.md`, alongside `.claude-plugin/`, `.claude/`, `.devcontainer/`, `.github/`,
  `LICENSE.md`, `README.md`, `SECURITY.md`, `examples/`, `plugins/`, `scripts/`,
  `Script/`, `demo.gif`, and `feed.xml`.
  Source: <https://api.github.com/repos/anthropics/claude-code/contents/>, accessed 2026-08-11.
- Raw changelog is fetchable at
  <https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md>
  (496,199 bytes on 2026-08-11); its first entry is `## 2.1.227`, matching the docs site.
  Accessed 2026-08-11.
- **Does it have GitHub Releases?** **Yes.** Latest release: tag **`v2.1.227`**,
  name `v2.1.227`, `published_at` **2026-08-10T22:56:53Z**.
  Source: <https://api.github.com/repos/anthropics/claude-code/releases/latest>, accessed 2026-08-11.
- Consistency note: the docs changelog, the repo `CHANGELOG.md`, and the GitHub Release
  all agreed on 2.1.227 on 2026-08-11. Any one of the three is a valid version probe;
  the GitHub Releases API is the cheapest for a script because it returns a single
  JSON object with `tag_name` and `published_at`.
- `feed.xml` at the repo root suggests an RSS-style feed also exists; its content was
  not fetched (see NOT VERIFIED).

### Re-check recipe

`GET https://api.github.com/repos/anthropics/claude-code/releases/latest` → read
`tag_name` and `published_at`.

---

## 3. Anthropic official news

- Canonical URL: <https://www.anthropic.com/news>
- Status: **LIVE** — HTTP 200, no redirect (`num_redirects=0`). Source: direct HTTP request to <https://www.anthropic.com/news>, accessed 2026-08-11.
- Most recent post visible: **"Improving Fable 5's biology safeguards"**, dated
  **August 7, 2026**, filed under the *Product* category.
  Source: <https://www.anthropic.com/news>, accessed 2026-08-11.
- Next two posts:
  - **August 4, 2026** — "Mariano-Florentino (Tino) Cuéllar to join Anthropic as Chief
    Global Affairs Officer" (*Announcements*).
  - **July 30, 2026** — "Investigating three real-world incidents in our cybersecurity
    evaluations".
  - Source: <https://www.anthropic.com/news>, accessed 2026-08-11.

### Re-check recipe

Fetch the URL and read the first post card's title and date.

---

## 4. Claude blog

- Canonical URL: <https://claude.com/blog>
- Status: **LIVE** — HTTP 200, **no redirect** (`num_redirects=0`, final URL identical
  to the requested URL). Source: direct HTTP request to <https://claude.com/blog>, accessed 2026-08-11.
- **It has NOT merged with anthropic.com/news.** On 2026-08-11 the two surfaces were
  live simultaneously and showed *different* most-recent posts, so they are separate
  publication streams and a maintenance command must check both.
  Sources: <https://claude.com/blog> and <https://www.anthropic.com/news>, both accessed 2026-08-11.
- Most recent post: **"Compliance API coverage extends to Claude Cowork and Claude Code"**,
  dated **August 11, 2026** (i.e. same day as this check).
  Source: <https://claude.com/blog>, accessed 2026-08-11.
- Next two posts:
  - **August 7, 2026** — "How Anthropic's business development team uses Claude to run
    inbound and outbound at scale".
  - **August 7, 2026** — "Auto mode is now the default in Claude Code for Pro, Max, and
    Team plans".
  - Source: <https://claude.com/blog>, accessed 2026-08-11.
- Cross-link worth knowing: the Claude Code model-config doc points at a blog post,
  "Choosing a Claude model and effort level in Claude Code", at
  <https://claude.com/blog/claude-model-and-effort-level-in-claude-code>. That is the
  official guidance page for model/effort selection and is a natural companion source
  for any method that recommends models. Its existence is cited by
  <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11; the post itself
  was not opened (see NOT VERIFIED).
- Editorial split observed on 2026-08-11: `claude.com/blog` skews product/customer/how-to,
  `anthropic.com/news` skews company announcements, policy, and safety research.

### Re-check recipe

Fetch the URL and read the first post's title and date. Do the same for
`anthropic.com/news`; do not treat either as a mirror of the other.

---

## 5. OWASP Top 10

- Canonical URL (content): **<https://owasp.org/Top10/>** — HTTP 200, `num_redirects=0`.
  The 200 response is a **client-side redirect shell**: the body carries a
  "Redirecting to OWASP Top 10:2025" instruction pointing at `/Top10/2025/`, so a
  `curl` status check alone will not reveal the edition.
  Sources: direct HTTP request to <https://owasp.org/Top10/> and WebFetch of the same URL, both accessed 2026-08-11.
- Canonical URL (project hub): **<https://owasp.org/www-project-top-ten/>** — HTTP 200,
  `num_redirects=0`, live. It states that "The most current released version is the
  **OWASP Top Ten 2025**", linking to <https://owasp.org/Top10/2025/>.
  Source: <https://owasp.org/www-project-top-ten/>, accessed 2026-08-11.
- **Current edition today: OWASP Top 10:2025 — not 2021.** This is the answer to the
  2021-vs-2025 question. The 2025 edition is the **8th installment** of the Top Ten.
  Sources: <https://owasp.org/www-project-top-ten/> and
  <https://owasp.org/Top10/2025/0x00_2025-Introduction/>, both accessed 2026-08-11.
- **Final, not a release candidate.** The rendered page at <https://owasp.org/Top10/2025/>
  has `<title>OWASP Top 10:2025</title>` and the raw HTML contains **zero** occurrences of
  "release candidate", "RC1", "RC2", or any `rc<digit>` token. Note that a web search
  still surfaces a stale result titled "OWASP Top 10:2025 RC1" for `owasp.org/Top10/` —
  that title is cached from the release-candidate phase and does **not** match the page
  served today. Source: raw HTML of <https://owasp.org/Top10/2025/>, accessed 2026-08-11.
- The ten categories, exactly as published for 2025
  (source: raw HTML of <https://owasp.org/Top10/2025/>, accessed 2026-08-11):

  | Code | Category |
  | :--- | :--- |
  | A01:2025 | Broken Access Control |
  | A02:2025 | Security Misconfiguration |
  | A03:2025 | Software Supply Chain Failures |
  | A04:2025 | Cryptographic Failures |
  | A05:2025 | Injection |
  | A06:2025 | Insecure Design |
  | A07:2025 | Authentication Failures |
  | A08:2025 | Software or Data Integrity Failures |
  | A09:2025 | Security Logging and Alerting Failures |
  | A10:2025 | Mishandling of Exceptional Conditions |

- Changes worth flagging for anything in this repo that still references the 2021 list:
  - **A03 "Software Supply Chain Failures"** is an expansion of the former
    *A06:2021 Vulnerable and Outdated Components*, widened to cover compromises across
    the whole ecosystem.
  - **A02 "Security Misconfiguration"** rose from #5 (2021) to #2 (2025).
  - **A10 "Mishandling of Exceptional Conditions"** is new in 2025.
  - *Broken Access Control* holds #1 in both editions.
  - Source: OWASP pages surfaced via search on owasp.org, accessed 2026-08-11.
  - The precise 2021→2025 mapping for every slot was not enumerated (see NOT VERIFIED).
- Next-revision plan: **no forward-looking statement found** on either canonical page
  (see NOT VERIFIED). The only cadence evidence is historical — editions in 2010, 2013,
  2017, 2021, 2025 — implying a roughly 4-year cycle, which points to ~2029, but that is
  an inference, not a published plan.
  Source: <https://owasp.org/www-project-top-ten/>, accessed 2026-08-11.

### Re-check recipe

Fetch <https://owasp.org/www-project-top-ten/> and read the "most current released
version" sentence. Do not rely on `curl` against `/Top10/` — it returns 200 for a
redirect shell regardless of edition.

---

## 6. Semgrep

### 6a. OWASP Top Ten ruleset page

- Canonical URL: <https://semgrep.dev/p/owasp-top-ten>
- Status: **LIVE (JS-rendered)** — HTTP 200, `num_redirects=0`. WebFetch extracted only
  the single word "Semgrep" from it, so the page is a client-rendered application and
  cannot be read by a markdown-converting fetcher.
  Source: direct HTTP request to <https://semgrep.dev/p/owasp-top-ten>, accessed 2026-08-11.
- The ruleset itself **is** live and machine-readable at the companion config endpoint
  **<https://semgrep.dev/c/p/owasp-top-ten>** — HTTP 200, `content-type: text/yaml`,
  **1,448,110 bytes**. Accessed 2026-08-11.
- The ruleset contains **559 rules** (counted as top-level `- id:` entries in the YAML).
  Source: <https://semgrep.dev/c/p/owasp-top-ten>, accessed 2026-08-11.
- Languages/ecosystems covered by rule-ID prefix (20 distinct): `bash`, `clojure`,
  `csharp`, `dockerfile`, `generic`, `go`, `html`, `java`, `javascript`, `json`,
  `kotlin`, `php`, `python`, `ruby`, `scala`, `solidity`, `swift`, `terraform`,
  `typescript`, `yaml`. Source: <https://semgrep.dev/c/p/owasp-top-ten>, accessed 2026-08-11.
- Rule metadata reports `origin: community` and the rules are covered by the
  **Semgrep Rules License v1.0** (<https://semgrep.dev/legal/rules-license>), which is a
  separate license from the Semgrep CLI's own. Source: rule metadata inside
  <https://semgrep.dev/c/p/owasp-top-ten>, accessed 2026-08-11.
- **No deprecation notice was found** in the served YAML. However, the human-facing page
  could not be read, so a banner rendered only in the browser would have been missed
  (see NOT VERIFIED).
- Practical consequence for a maintenance command: probe
  `https://semgrep.dev/c/p/owasp-top-ten` (yields real content and a countable rule set),
  not `https://semgrep.dev/p/owasp-top-ten` (yields an empty shell).
- Caveat to carry forward: this ruleset is still named and packaged as `owasp-top-ten`,
  and its rule metadata predates the 2025 edition, so it should be assumed to be aligned
  with the **2021** category list until proven otherwise. That alignment was not
  verified (see NOT VERIFIED).

### 6b. Semgrep repository

- Canonical URL: <https://github.com/semgrep/semgrep>
- Status: **LIVE and actively maintained.** Metadata from
  <https://api.github.com/repos/semgrep/semgrep>, accessed 2026-08-11:
  - `full_name`: `semgrep/semgrep`
  - `description`: "Lightweight static analysis for many languages. Find bug variants
    with patterns that look like source code."
  - `archived`: **false**
  - `license`: **LGPL-2.1** (GNU Lesser General Public License v2.1) — so the CLI
    **is still open source**
  - `stargazers_count`: **16,184**
  - `open_issues_count`: **896**
  - `pushed_at`: **2026-08-11** (same day as this check — active development)
- Latest release: tag **`v1.172.0`**, name "Release v1.172.0",
  `published_at` **2026-07-28T22:40:28Z**, `prerelease`: **false**.
  Source: <https://api.github.com/repos/semgrep/semgrep/releases/latest>, accessed 2026-08-11.
- Health read: pushed the same day, released ~2 weeks prior, not archived, OSI license
  intact. Nothing suggests the OSS CLI is going away.

### Re-check recipe

`GET https://api.github.com/repos/semgrep/semgrep/releases/latest` for the version;
`GET https://semgrep.dev/c/p/owasp-top-ten` and count `^- id:` lines for the ruleset.

---

## 7. gitleaks

- Canonical URL: <https://github.com/gitleaks/gitleaks>
- Status: **LIVE, but explicitly in maintenance-only mode.** This is the most important
  finding in this file for anything in the repo that depends on gitleaks.
- Repository metadata (from <https://api.github.com/repos/gitleaks/gitleaks>, accessed 2026-08-11):
  - `full_name`: `gitleaks/gitleaks`
  - `description`: "Find secrets with Gitleaks 🔑"
  - `archived`: **false**
  - `license`: **MIT**
  - `stargazers_count`: **28,600**
  - `open_issues_count`: **460**
  - `pushed_at`: **2026-07-29**
- Latest release: tag **`v8.30.1`**, name `v8.30.1`,
  `published_at` **2026-03-21T02:17:58Z**, `prerelease`: **false**.
  Source: <https://api.github.com/repos/gitleaks/gitleaks/releases/latest>, accessed 2026-08-11.
- **Maintainer's own statement, quoted verbatim from line 12 of the README**
  (source: <https://raw.githubusercontent.com/gitleaks/gitleaks/master/README.md>, accessed 2026-08-11):

  > Gitleaks is feature complete. I'm not merging new features into Gitleaks. Future
  > releases will be security patches only. I'm shifting my focus to
  > [Betterleaks](https://github.com/betterleaks/betterleaks)

- Reading of that statement: gitleaks is **not abandoned** (not archived; repo pushed
  2026-07-29) but it is **frozen** — security patches only, no new features. The named
  successor is **Betterleaks** at <https://github.com/betterleaks/betterleaks>.
- Gap signal for a maintenance command: ~5 months between the latest tagged release
  (2026-03-21) and today (2026-08-11), which is consistent with the frozen posture and
  should **not** by itself be read as abandonment.
- The Betterleaks repository was **not** independently inspected (see NOT VERIFIED). If
  this repo's method recommends gitleaks, a future maintenance pass should evaluate
  Betterleaks as the migration target before recommending a switch.
- Version drift note: the gitleaks README's own pre-commit example still pins
  `v8.24.2`, older than the current `v8.30.1`. Do not read a version out of the README
  example; read it from the releases API.
  Source: <https://github.com/gitleaks/gitleaks>, accessed 2026-08-11.

### Re-check recipe

`GET https://api.github.com/repos/gitleaks/gitleaks/releases/latest` for the version,
and re-read the top of the README for any change to the feature-freeze statement.

---

## 8. npm audit

- URL given for checking: <https://docs.npmjs.com/cli/audit>
- Status: **LIVE, but it is a redirect chain — the canonical URL has moved.**
  Chain observed on 2026-08-11:
  1. `https://docs.npmjs.com/cli/audit` → HTTP 301 → `https://docs.npmjs.com/cli/audit/`
  2. `https://docs.npmjs.com/cli/audit/` returns HTTP 200 with a **77-byte body**
     containing only a meta-refresh:
     `<meta http-equiv="refresh" content="0; URL='/cli/v12/commands/npm-audit/'" />`
  - Source: direct HTTP requests to <https://docs.npmjs.com/cli/audit>, accessed 2026-08-11.
- **Canonical URL today: <https://docs.npmjs.com/cli/v12/commands/npm-audit>**
  (HTTP 200, final URL `https://docs.npmjs.com/cli/v12/commands/npm-audit/`).
  Accessed 2026-08-11.
- The canonical page documents **npm CLI v12.0.2**, labelled **"(Latest)"**.
  Source: <https://docs.npmjs.com/cli/v12/commands/npm-audit>, accessed 2026-08-11.
- **Deprecation / interface change: none.** The v12 page carries **no** deprecation
  notice, **no** "Legacy" label, and **no** breaking-change warning. A raw grep of the
  redirect stub and a read of the v12 page found zero occurrences of "deprecat*".
  Source: <https://docs.npmjs.com/cli/v12/commands/npm-audit>, accessed 2026-08-11.
- Version-shelf caveat worth recording: the **v11** page
  (<https://docs.npmjs.com/cli/v11/commands/npm-audit>) is still live but is labelled
  **npm CLI v11.19.0 "(Legacy)"**. The "(Legacy)" tag marks the *docs version shelf*,
  not the `npm audit` command. Pinning a method to `/cli/v11/...` will silently go stale
  as npm ships new majors; the unversioned `/cli/audit` alias follows the current major
  automatically. Source: <https://docs.npmjs.com/cli/v11/commands/npm-audit>, accessed 2026-08-11.
- Interface as documented for v12 (source: <https://docs.npmjs.com/cli/v12/commands/npm-audit>, accessed 2026-08-11):
  - Subcommands: `npm audit` (scan, no changes), `npm audit fix` (install compatible
    updates), `npm audit signatures` (verify registry signatures and provenance
    attestations).
  - `--audit-level` accepts: `null` (default), `info`, `low`, `moderate`, `high`,
    `critical`, `none` — the minimum severity that makes `npm audit` exit non-zero.
  - Other documented flags: `--json`, `--dry-run`, `--force`, `--package-lock-only`,
    `--no-package-lock`, `--only=prod`.
  - Both the v11 and v12 pages show "Last edited by mitchdenny on March 18, 2026".

### Re-check recipe

Request <https://docs.npmjs.com/cli/audit> and **follow the meta-refresh in the body**,
not just HTTP redirects — the major-version number in the resulting path is the signal
that npm has shipped a new major.

---

## 9. pip-audit

- Canonical URL: <https://github.com/pypa/pip-audit>
- Status: **LIVE and actively maintained.** Metadata from
  <https://api.github.com/repos/pypa/pip-audit>, accessed 2026-08-11:
  - `full_name`: `pypa/pip-audit`
  - `description`: "Audits Python environments, requirements files and dependency trees
    for known security vulnerabilities, and can automatically fix them"
  - `archived`: **false**
  - `license`: **Apache-2.0**
  - `stargazers_count`: **1,345**
  - `open_issues_count`: **71**
  - `pushed_at`: **2026-08-11T16:04:25Z** (same day as this check — active)
- Latest release: tag **`v2.10.1`**, name `v2.10.1`,
  `published_at` **2026-06-10T22:16:05Z**, `prerelease`: **false**.
  That release fixed a crash "when an OSV vulnerability record contains an `affected`
  entry that omits the optional `ranges` field."
  Source: <https://api.github.com/repos/pypa/pip-audit/releases/latest>, accessed 2026-08-11.
- Health read: under the **PyPA** organisation (the official Python Packaging Authority),
  pushed today, permissive license, no freeze or successor notice. Contrast with gitleaks
  (item 7), which is frozen.

### Re-check recipe

`GET https://api.github.com/repos/pypa/pip-audit/releases/latest` → `tag_name`, `published_at`.

---

## 10. Claude model lineup and effort levels in Claude Code

### 10a. Model aliases

- Canonical URL: <https://code.claude.com/docs/en/model-config>
- Status: **LIVE** — HTTP 200, `num_redirects=0`. Page title "Model configuration".
  Source: direct HTTP request to and WebFetch of <https://code.claude.com/docs/en/model-config>, both accessed 2026-08-11.
- The `model` setting accepts either a **model alias** or a **model name** (full
  Anthropic API model name, a Bedrock inference profile ARN, a Microsoft Foundry
  deployment name, or a Google Cloud Agent Platform version name).
  Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
- Aliases documented today, exactly as named
  (source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11):

  | Alias | Behavior as documented |
  | :--- | :--- |
  | `default` | Clears any model override and reverts to the recommended model for your account type, or to the organization default model when an admin has set one. **Explicitly "Not itself a model alias".** |
  | `best` | Uses Fable 5 where your organization has access to it, otherwise the latest Opus model |
  | `fable` | Uses Claude Fable 5 for your hardest and longest-running tasks |
  | `sonnet` | Uses the latest Sonnet model for daily coding tasks |
  | `opus` | Uses the latest Opus model for complex reasoning tasks |
  | `haiku` | Uses the fast and efficient Haiku model for simple tasks |
  | `sonnet[1m]` | Sonnet with a 1M-token context window. No effect when `sonnet` already resolves to Sonnet 5 with its native 1M window; behind an LLM gateway, selects the 1M window for Sonnet 5 |
  | `opus[1m]` | Opus with a 1M-token context window |
  | `opusplan` | Uses `opus` during plan mode, then switches to `sonnet` for execution |

- **Alias resolution depends on the provider** — the same alias is not the same model
  everywhere (source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11):

  | Provider | `opus` resolves to | `sonnet` resolves to |
  | :--- | :--- | :--- |
  | Anthropic API | Opus 5 | Sonnet 5 |
  | Claude Platform on AWS | Opus 5 | Sonnet 4.6 |
  | Amazon Bedrock, Google Cloud's Agent Platform | Opus 5 | Sonnet 4.5 |
  | Microsoft Foundry | Opus 4.6 | Sonnet 4.5 |

- Concrete model IDs named on the page: `claude-opus-5`, `claude-sonnet-5`,
  `claude-haiku-4-5`, `claude-sonnet-4-5`, `claude-sonnet-4-5-20250929`,
  `claude-opus-4-6`, `claude-fable-5`. Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
- Minimum Claude Code versions for the newest models: **Opus 5 requires v2.1.219+**,
  **Sonnet 5 requires v2.1.197+**, **Opus 4.8 requires v2.1.154+**. Since the current
  release is 2.1.227 (item 1), all are available on an up-to-date install.
  Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
- **Fable 5 is never the default** on any account type; it is used only after explicit
  selection via `/model fable`, a `model` setting, or the `best` alias where available.
  Requests its safety classifiers flag — most often in **cybersecurity and biology**
  domains — trigger automatic model fallback; the docs call this "expected routing for
  these domains, not an account flag".
  Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
  This matters directly for any security-scanning step in this repo's method: a
  security-flavoured prompt run on Fable 5 may silently fall back to another model.
- Alias overrides available as environment variables: `ANTHROPIC_DEFAULT_OPUS_MODEL`,
  `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL`,
  `ANTHROPIC_DEFAULT_FABLE_MODEL`; plus `ANTHROPIC_MODEL` to set the session model.
  Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
- Stability warning from the docs themselves: "Aliases point to the recommended version
  for your provider and update over time." A method that says "use `opus`" is
  self-updating; a method that says "use `claude-opus-5`" is pinned and will need
  manual maintenance. Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.

### 10b. Effort levels

- Canonical URLs: <https://code.claude.com/docs/en/settings.md> (the `effortLevel`
  setting) and <https://code.claude.com/docs/en/model-config> (the per-model table,
  section "Adjust effort level"). Both **LIVE**, accessed 2026-08-11.
- **`/effort` values, exactly as documented:** `low`, `medium`, `high`, `xhigh`, and
  `max`, plus the special menu entry `ultracode` and the reset value `auto`.
  Sources: <https://code.claude.com/docs/en/settings.md> and
  <https://code.claude.com/docs/en/model-config>, both accessed 2026-08-11.
- **Which levels each model supports** (models not listed do not support effort at all)
  (source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11):

  | Model | Levels |
  | :--- | :--- |
  | Fable 5 | `low`, `medium`, `high`, `xhigh`, `max` |
  | Opus 5, Sonnet 5, Opus 4.8, Opus 4.7 | `low`, `medium`, `high`, `xhigh`, `max` |
  | Opus 4.6 and Sonnet 4.6 | `low`, `medium`, `high`, `max` |

- Fallback rule: setting a level the active model does not support falls back to the
  highest supported level at or below it — e.g. `xhigh` runs as `high` on Opus 4.6.
  Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
- **Default effort is `high`** on every model that supports effort, **except Opus 4.7,
  which defaults to `xhigh`**. Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
- Persistence rules that a method must respect
  (source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11):
  - `low`, `medium`, `high`, `xhigh` **persist across sessions** when set interactively.
  - **`max` is session-only**, except when set via `CLAUDE_CODE_EFFORT_LEVEL`.
  - **`ultracode` is session-only** and is *not* a model effort level — it is a Claude
    Code setting that sends `xhigh` to the model *and* has Claude orchestrate dynamic
    workflows. Requires v2.1.203+ for `--effort ultracode`.
  - The persisted `effortLevel` setting and `CLAUDE_CODE_EFFORT_LEVEL` **do not accept**
    `ultracode`.
  - A level set with `/effort` in non-interactive/`-p` mode applies to that session only
    and is not saved.
  - First run of Fable 5, Opus 4.8, or Opus 4.7 applies that model's default effort and
    **holds it across sessions** until an explicit choice is made. **Opus 5 has no such
    hold** — a previously set level carries over.
- Settings-file form (source: <https://code.claude.com/docs/en/settings.md>, accessed 2026-08-11):

  ```json
  { "effortLevel": "xhigh" }
  ```

  Accepts `low` | `medium` | `high` | `xhigh` only. Overridable per session with the
  `--effort` CLI flag or the `CLAUDE_CODE_EFFORT_LEVEL` environment variable.
- Ways to set effort: `/effort` (no args opens a slider; `auto` resets to the model
  default), the effort slider inside `/model` (left/right arrows), the `--effort` launch
  flag, `CLAUDE_CODE_EFFORT_LEVEL`, or the `effortLevel` setting.
  Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
- Prompt-level nuance worth recording: the keyword **`ultrathink`** anywhere in a prompt
  requests deeper reasoning for that turn via an in-context instruction — **the effort
  level sent to the API is unchanged**. Phrases like "think", "think hard", and
  "think more" are **passed through as ordinary text and are not recognized as keywords**.
  Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
- Calibration warning: "The effort scale is calibrated per model, so the same level name
  does not represent the same underlying value across models." A method that hardcodes
  an effort name across models is not specifying a constant amount of reasoning.
  Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.
- Enterprise constraints that can silently alter a method's model/effort choice:
  `availableModels` and `enforceAvailableModels` in managed/policy settings restrict
  selectable models; **organization effort limits** cap the maximum level per model per
  role (v2.1.195+); an **organization default model** can override the Default option
  (v2.1.196+). Under `json`/`stream-json` output or in background agents, an effort clamp
  **applies silently** with no warning.
  Source: <https://code.claude.com/docs/en/model-config>, accessed 2026-08-11.

### Re-check recipe

Fetch <https://code.claude.com/docs/en/model-config> and diff the "Model aliases",
provider-resolution, and "Adjust effort level" tables against the tables above.

---

## 11. Official Anthropic plugin marketplace repo

- Canonical URL: <https://github.com/anthropics/claude-plugins-official>
- Status: **LIVE and still under this exact name** — HTTP 200, `num_redirects=0` (no
  rename redirect). Source: direct HTTP request to <https://github.com/anthropics/claude-plugins-official>, accessed 2026-08-11.
- Repository metadata (from <https://api.github.com/repos/anthropics/claude-plugins-official>, accessed 2026-08-11):
  - `full_name`: `anthropics/claude-plugins-official`
  - `description`: "Official, Anthropic-managed directory of high quality Claude Code Plugins."
  - `archived`: **false**
  - `stargazers_count`: **33,402**
  - `pushed_at`: **2026-08-11T13:25:25Z** (same day as this check — active)
- **Exact plugin count: 285.** Counted programmatically as the length of the `plugins`
  array in the marketplace manifest, not estimated.
  Source: <https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json>,
  168,408 bytes, accessed 2026-08-11.
- Manifest top-level keys: `$schema`, `name`, `description`, `owner`, `renames`,
  `plugins`. The `renames` key is notable — it maps old plugin names to new ones, so
  **plugin names in this marketplace are not permanently stable** and a method that
  references a plugin by name should consult `renames` when a lookup fails.
  Source: same manifest URL, accessed 2026-08-11.

### Re-check recipe

`GET https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json`
and read `len(plugins)`; check `renames` for any plugin this repo references by name.

---

## Summary table

| # | Source | Live 2026-08-11 | Latest version / entry | Date |
| :-- | :--- | :--- | :--- | :--- |
| 1 | code.claude.com/docs/en/changelog.md | Yes | 2.1.227 | 2026-08-10 |
| 2 | github.com/anthropics/claude-code | Yes (CHANGELOG.md **and** Releases) | v2.1.227 | 2026-08-10 |
| 3 | anthropic.com/news | Yes | "Improving Fable 5's biology safeguards" | 2026-08-07 |
| 4 | claude.com/blog | Yes (separate from /news) | "Compliance API coverage extends to Claude Cowork and Claude Code" | 2026-08-11 |
| 5 | owasp.org/Top10/ | Yes (meta-redirect shell) | **Top 10:2025**, final, 8th installment | n/a |
| 6a | semgrep.dev/p/owasp-top-ten | Yes (JS-rendered; use `/c/p/`) | 559 rules, 20 languages | n/a |
| 6b | github.com/semgrep/semgrep | Yes, active, LGPL-2.1 | v1.172.0 | 2026-07-28 |
| 7 | github.com/gitleaks/gitleaks | Yes, **frozen** (security patches only) | v8.30.1 | 2026-03-21 |
| 8 | docs.npmjs.com/cli/audit | Yes → **/cli/v12/commands/npm-audit** | npm CLI 12.0.2 (Latest) | doc edited 2026-03-18 |
| 9 | github.com/pypa/pip-audit | Yes, active | v2.10.1 | 2026-06-10 |
| 10 | code.claude.com/docs/en/model-config + settings.md | Yes | aliases + 5 effort levels + `ultracode` | n/a |
| 11 | github.com/anthropics/claude-plugins-official | Yes, same name | 285 plugins | pushed 2026-08-11 |

## Changes a maintenance command should act on

Ordered by how much they would change this repo's behaviour if left stale:

1. **OWASP Top 10 is now the 2025 edition, not 2021.** Ten renamed/reordered categories,
   including a new A10 and a broadened A03 supply-chain category. Any checklist keyed to
   `A0N:2021` codes is out of date.
2. **gitleaks is feature-frozen**, security patches only, with **Betterleaks** named by
   the maintainer as the successor. Still safe to use today; needs a migration decision.
3. **The npm audit docs URL moved to the `/cli/v12/` shelf**, and the `/cli/v11/` shelf is
   labelled "(Legacy)". Only the unversioned `/cli/audit` alias tracks the current major.
4. **The Semgrep `owasp-top-ten` ruleset is almost certainly still 2021-aligned** while
   OWASP has moved to 2025 — a real semantic gap between the standard and the scanner.
5. **`claude.com/blog` and `anthropic.com/news` are two distinct feeds**; checking only
   one misses roughly half the announcements.

## Probe-reliability notes

Three of these sources defeat a naive HTTP-status check, and a maintenance command
should be written with that in mind:

- `owasp.org/Top10/` returns **200 for a client-side redirect shell** — the status code
  is identical whether the current edition is 2021 or 2025. Read
  `owasp.org/www-project-top-ten/` instead.
- `docs.npmjs.com/cli/audit` returns **200 for a 77-byte meta-refresh stub** — the
  meaningful signal (the major-version path) is inside the body.
- `semgrep.dev/p/owasp-top-ten` returns **200 for an empty JS shell** — use the
  `semgrep.dev/c/p/...` config endpoint for content.

Conversely, the GitHub REST API (`/releases/latest`, `/contents/`, and the repo root
object) was reliable for every repository checked here and is the cheapest probe for
items 2, 6b, 7, 9, and 11.

---

## NOT VERIFIED

Everything below was **not** confirmed today. Each entry states the reason. None of it
should be treated as fact.

1. **OWASP Top 10:2025 exact release/publication date.** Neither
   <https://owasp.org/Top10/2025/>, <https://owasp.org/Top10/2025/0x00_2025-Introduction/>,
   nor <https://owasp.org/www-project-top-ten/> states a publication date (all accessed
   2026-08-11). The introduction confirms it is "the 8th installment" but gives no date.
   A raw-HTML grep for "released"/"release date"/"published" on
   <https://owasp.org/Top10/2025/> returned zero matches.

2. **OWASP next-revision plan.** No forward-looking statement was found on either
   canonical page (accessed 2026-08-11). The project page shows historical editions
   (2010, 2013, 2017, 2021, 2025) implying a ~4-year cadence, but the pages state no
   cadence and name no next edition. The ~2029 figure is an inference, not published.

3. **OWASP data-collection window relative to the 2025 release.**
   <https://owasp.org/www-project-top-ten/> (accessed 2026-08-11) carries the sentence
   "We plan to accept contributions to the new Top 10 until July 31, 2025, for data
   dating from 2021 to 2024." It is unclear whether that text is current or a leftover
   from the pre-release phase, so it is not used as evidence of anything above.

4. **Full 2021→2025 OWASP category mapping.** Only the highlighted changes (A03 supply
   chain, A02's rise from #5 to #2, the new A10, A01 unchanged at #1) were confirmed via
   search results on owasp.org, accessed 2026-08-11. The complete slot-by-slot mapping
   for all ten positions was not enumerated from a primary page.

5. **Whether the Semgrep `owasp-top-ten` ruleset is aligned to the 2021 or 2025 edition.**
   The served YAML at <https://semgrep.dev/c/p/owasp-top-ten> (accessed 2026-08-11)
   contains per-rule OWASP metadata, but the metadata fields were not parsed to determine
   which edition's category codes they carry. Treat "still 2021-aligned" as a strong
   suspicion, not a verified fact.

6. **Human-visible content of <https://semgrep.dev/p/owasp-top-ten>** — its displayed
   ruleset title, its own stated rule count, its description text, and any banner. The
   page is client-rendered and WebFetch extracted only the word "Semgrep" (accessed
   2026-08-11). **A deprecation banner rendered only in the browser would not have been
   seen.** The "no deprecation notice" claim in item 6a covers the YAML config endpoint
   only. Confirming this needs a real browser.

7. **Whether Semgrep's OSS CLI has feature gaps versus Semgrep Pro/AppSec Platform.**
   Only the repository license (LGPL-2.1) and activity were checked via
   <https://api.github.com/repos/semgrep/semgrep> (accessed 2026-08-11). No claim is made
   about which capabilities are paid-only.

8. **The Betterleaks project** at <https://github.com/betterleaks/betterleaks> — its
   existence, maturity, license, release history, and suitability as a gitleaks
   replacement. It is only cited here because the gitleaks README names it (accessed
   2026-08-11). The repository itself was not fetched.

9. **gitleaks last-commit date and the content of releases after v8.30.1.** The API
   reports `pushed_at` = 2026-07-29 (<https://api.github.com/repos/gitleaks/gitleaks>,
   accessed 2026-08-11), which indicates repository activity but is not the same as a
   commit to the default branch. Whether any pre-release or draft release exists after
   v8.30.1 was not checked — only the `/releases/latest` endpoint was queried, which
   excludes prereleases by design. The same prerelease caveat applies to items 2, 6b, and 9.

10. **Whether `docs.npmjs.com/cli/audit` will keep tracking the newest major.** It
    pointed at `/cli/v12/` on 2026-08-11, but no npm documentation states that the
    unversioned alias is contractually pinned to "latest". The inference is behavioural,
    from a single observation.

11. **npm CLI release date for v12.0.2.** The docs page shows a doc last-edited date of
    2026-03-18 (<https://docs.npmjs.com/cli/v12/commands/npm-audit>, accessed 2026-08-11);
    that is the documentation edit date, **not** the npm 12.0.2 release date. The npm CLI
    release history was not checked.

12. **Content of the Claude Code repo's `feed.xml`.** Its presence at the repo root was
    confirmed via <https://api.github.com/repos/anthropics/claude-code/contents/>
    (accessed 2026-08-11), but the file was not fetched, so whether it is a usable
    release feed is unknown.

13. **The blog post "Choosing a Claude model and effort level in Claude Code"** at
    <https://claude.com/blog/claude-model-and-effort-level-in-claude-code>. Its URL is
    cited by <https://code.claude.com/docs/en/model-config> (accessed 2026-08-11), but the
    post was not opened and its liveness and publication date are unconfirmed.

14. **Complete list of Claude model IDs available on the Anthropic API.**
    <https://code.claude.com/docs/en/model-config> (accessed 2026-08-11) documents aliases
    and names several concrete IDs, but the authoritative model list lives at
    <https://platform.claude.com/docs/en/about-claude/models/overview>, which was not
    fetched. Item 10a is therefore "what the Claude Code doc names today", not an
    exhaustive lineup.

15. **Which models this user's account can actually select.** All model/effort facts in
    item 10 come from public documentation. Account tier, organization `availableModels`
    policy, and organization effort caps can all restrict the real set, and none of that
    was inspected.

16. **Breakdown of the 285 marketplace plugins** — names, categories, and which are
    relevant to this repo's method. Only the array length was counted from
    <https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json>
    (accessed 2026-08-11). The `renames` map was likewise not enumerated.

17. **Stability of any star/issue count in this file.** All counts are point-in-time
    reads from api.github.com on 2026-08-11 and will drift; they are recorded as health
    signals, not as identifiers to match on.
