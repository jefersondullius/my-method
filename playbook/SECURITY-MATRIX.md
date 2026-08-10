# SECURITY MATRIX

## LEGITIMACY — read this before running anything in this file

Every check in this matrix targets systems the project owner (Jeferson)
actually owns: the codebase in this repository, and infrastructure
under his own accounts (his own database, his own hosting, his own API
keys). Every "external-api" or "third-party-dependency" check tests
*this project's own integration* with a third-party service — how this
codebase calls the service, what it does with the response, what it
exposes — never the third party's service itself. Do not port a check
from this file to point at a domain, API, or account this project does
not own. Do not scan, fuzz, or load-test a third party's endpoint even
"just to see" — that is out of scope, full stop.

## HONESTY — what this matrix does not give you

- This is not a penetration test. Nobody with adversarial training is
  trying to break the running system end to end.
- This is not a compliance audit. Passing every check here does not
  imply PCI-DSS, LGPD, or any other certification.
- This is not a guarantee. A clean run reduces the odds of the
  *common, well-known* mistakes listed below. It says nothing about
  novel attack paths, logic bugs specific to this product, or anything
  outside the ten risk surfaces this matrix covers.
- REVIEW checks are performed by an LLM subagent reading a diff. LLM
  review has real, documented blind spots — see
  `research/13-testing-strategy.md` ("what an LLM-driven review can
  and cannot establish") before trusting a clean REVIEW result more
  than it deserves.
- The goal is narrower and more honest than "secure": catch the
  mistakes that are common, cheap to check, and expensive to ship.

## PROPORTIONALITY — not every project needs every row

Applying all ten risk surfaces to a project with no login and no
stored data would be checking things that cannot fail because the
feature does not exist. Triage the project first, using the answers
already collected in Step 1 of `method.md`, then only run the rows
that apply.

| Tier | Project shape | Risk surfaces IN SCOPE |
|---|---|---|
| **T0 — Local/static** | No server reachable over the network; nothing persisted beyond the browser or the local machine. | `user-input` (only if it renders untrusted text), `secrets-and-config` (only if any key/token exists at all), `third-party-dependency` |
| **T1 — Online, anonymous** | Deployed and reachable, no accounts, no personal data stored. May call external APIs, may store anonymous/non-personal data. | everything in T0, plus `data-store` (if it stores anything), `external-api` (if it calls one), `deployment` |
| **T2 — Online, accounts + personal data** | Requires login; stores data tied to a specific person. **This is the shape of the next project.** | everything in T1, plus `authentication`, `authorization` |
| **T3 — Payments and/or uploads** | Charges money, and/or accepts files from users. | everything in T2, plus `payments` (only if it charges money), `file-upload` (only if it accepts files) |

A row for a surface that is out of scope for the current tier is
skipped, not failed. Re-triage whenever a feature is added that turns
a surface on (e.g., adding "upload your avatar" pulls in `file-upload`
even for an otherwise T2 project).

## HOW TO READ EACH ROW

Every check is classified into exactly one kind:

- **AUTOMATED** — a command, scanner, or test that runs and returns
  pass or fail on its own. No judgment call involved.
- **REVIEW** — an adversarial read of the diff by a subagent with
  fresh context (no memory of writing the code), returning findings
  with a severity and a `file:line` for each. Pass criterion is always
  the same: **no open HIGH or CRITICAL finding.**
- **HUMAN DECISION** — something only Jeferson can decide, because it
  is a tradeoff, a business call, or depends on information outside
  the code. Stated as a yes/no question in Portuguese.

---

## 1. data-store

*In scope from Tier T1 up, whenever the project persists anything.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 1.1 | No SQL/query built by string concatenation of user input | **AUTOMATED** — run a static scanner with an injection ruleset (e.g. `semgrep --config p/owasp-top-ten` — Semgrep's OWASP Top 10 ruleset maps rules directly to injection and access-control categories[^semgrep]) over the diff. | Scanner reports zero findings of ERROR/HIGH severity in the injection rule family. |
| 1.2 | Every query that touches "another user's row" is scoped to the logged-in user, not to an ID taken raw from the request | **REVIEW** — subagent reads the diff for every query/ORM call touching this data store and checks the `WHERE`/filter clause against the authenticated user. | No open HIGH/CRITICAL finding. |
| 1.3 | Passwords and other secrets-shaped fields (tokens, card data) are never stored as plain text or reversibly encrypted | **REVIEW** — subagent inspects the schema and every write path to a "password"/"token"/"secret" column for hashing (Argon2id/bcrypt) instead of storage-as-is[^password]. | No open HIGH/CRITICAL finding. |
| 1.4 | The database user/role this project's code connects as has only the privileges the app needs (not the provider's admin/root account) | **HUMAN DECISION** — "O usuário de banco de dados que a aplicação usa para se conectar tem só as permissões que ela realmente precisa (não é a conta admin/root do provedor)?" | Jeferson answers yes, or creates a scoped-down user before shipping. |
| 1.5 | Backups exist for any data that would hurt to lose | **HUMAN DECISION** — "O provedor de banco de dados escolhido faz backup automático, e você confirmou que ele está ligado?" | Jeferson answers yes, or accepts the risk explicitly. |

## 2. external-api

*In scope from Tier T1 up, whenever the project calls a third-party service.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 2.1 | No API key/secret hardcoded in a request to the external service | **AUTOMATED** — run `gitleaks` (or equivalent secret scanner) against the diff and the full history before first push[^gitleaks]. | Zero findings. |
| 2.2 | Calls to the external service have a timeout and handle a failure/error response without crashing or leaking internals | **REVIEW** — subagent checks every call site for a timeout and an error branch. | No open HIGH/CRITICAL finding. |
| 2.3 | The API key generated for this project is scoped to only what this project needs, not a full-account/admin key | **HUMAN DECISION** — "A chave de API que você gerou para este projeto tem permissão só para o que ele precisa, e não é uma chave de administrador da sua conta inteira no provedor?" | Jeferson answers yes, or generates a scoped key before shipping. |

## 3. authentication

*In scope from Tier T2 up.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 3.1 | Passwords are hashed with a slow, salted algorithm (Argon2id or bcrypt), never a fast general-purpose hash (MD5/SHA-family alone) | **REVIEW** — subagent inspects the password-write and password-check code paths[^password]. | No open HIGH/CRITICAL finding. |
| 3.2 | Login/authentication logic uses a maintained library (framework-provided auth, Passport, NextAuth, Supabase/Auth0, Django auth — not code written from scratch for hashing or session tokens) | **HUMAN DECISION** — "Você concorda em usar uma biblioteca de autenticação pronta e testada, em vez de escrevermos a lógica de login/senha do zero?" | Jeferson answers yes; if no, the REVIEW bar for 3.1 and 3.3 tightens (custom crypto gets adversarial review, not a pass by default). |
| 3.3 | The login endpoint rejects a wrong password without revealing whether the *username/e-mail* itself exists | **AUTOMATED** — a written test hits the login endpoint with (a) a real e-mail + wrong password and (b) a fake e-mail + any password, and asserts both responses are identical (same status code, same message, no timing tell built into the test). | Test passes: both attempts return the same generic failure. |
| 3.4 | Sessions/tokens expire and can be invalidated (logout actually ends the session) | **REVIEW** — subagent checks session/token issuance for an expiry and checks that logout revokes it server-side (not just clears the client cookie). | No open HIGH/CRITICAL finding. |

## 4. authorization

*In scope from Tier T2 up.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 4.1 | Every endpoint/action that reads or writes a specific user's data checks that the logged-in user owns that data (no Insecure Direct Object Reference)[^idor] | **REVIEW** — subagent walks every route/handler that takes an ID (user ID, order ID, document ID, etc.) from the request and verifies an ownership check exists before the read/write. | No open HIGH/CRITICAL finding. |
| 4.2 | Changing an ID in the request (e.g. `/orders/123` → `/orders/124`) while logged in as a different user does not return or modify that other user's data | **AUTOMATED** — a written test: log in as user A, request/modify a resource ID known to belong to user B, assert a 403/404, not the data. | Test passes for every resource type that belongs to a specific user. |
| 4.3 | Admin-only or privileged actions check the role/permission server-side, not just hide the button in the UI | **REVIEW** — subagent checks that every privileged action re-checks the role on the server, independent of what the client sends or shows. | No open HIGH/CRITICAL finding. |

## 5. payments

*In scope from Tier T3, only if the project charges money.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 5.1 | This project's own code never receives, stores, logs, or transmits a raw card number/CVV — card entry happens on the payment provider's own hosted page/element (Stripe Checkout/Elements or equivalent) | **REVIEW** — subagent scans the diff for any field or variable that looks like a raw card number/CVV/expiry being read or stored by this project's code. This is also the single biggest scope-reducer for a small project: see `research/13-testing-strategy.md` for why. | No open HIGH/CRITICAL finding: zero raw-card-data handling found in this project's code. |
| 5.2 | Payment provider webhooks verify the provider's signature before trusting the payload | **REVIEW** — subagent checks the webhook handler for signature verification before any state change. | No open HIGH/CRITICAL finding. |
| 5.3 | Using a hosted checkout/elements flow (never collecting the card number on this project's own page) is a deliberate choice, confirmed | **HUMAN DECISION** — "Você concorda em usar o checkout hospedado do provedor de pagamento (ex.: Stripe Checkout), em vez de coletarmos o número do cartão na nossa própria página?" | Jeferson answers yes. A "no" here reopens PCI-DSS scope well beyond what this matrix covers, and needs a specialist, not this checklist. |

## 6. file-upload

*In scope from Tier T3, only if the project accepts files from users.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 6.1 | Accepted file types are checked against an allowlist (only the extensions/MIME types the feature needs), not a blocklist[^fileupload] | **REVIEW** — subagent checks the upload handler's validation logic. | No open HIGH/CRITICAL finding. |
| 6.2 | Oversized uploads are rejected | **AUTOMATED** — a written test uploads a file above the configured limit and asserts rejection. | Test passes. |
| 6.3 | Uploaded files are stored/served in a way that cannot be executed as code by the server (outside the web root, or served with a content-type that forces download, or via object storage) | **HUMAN DECISION** — "Os arquivos enviados pelos usuários vão ficar guardados num lugar de onde o servidor não pode executá-los como código (ex.: um bucket de armazenamento, não a mesma pasta que serve o site)?" | Jeferson answers yes, or the hosting choice is adjusted before shipping. |

## 7. user-input

*In scope from Tier T0 up, whenever the project renders or stores anything a user typed.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 7.1 | User-typed text is never inserted into HTML/SQL/shell commands by raw string concatenation | **AUTOMATED** — `semgrep --config p/owasp-top-ten` (or the framework's built-in escaping check) over the diff[^semgrep]. | Zero ERROR/HIGH findings. |
| 7.2 | Every field with a size/format expectation (e-mail, amount, date, ID) is validated server-side, not only in the browser | **REVIEW** — subagent checks that server-side handlers validate input independent of any client-side check. | No open HIGH/CRITICAL finding. |
| 7.3 | Submitting a `<script>` tag or similar payload in a text field does not execute when the field is later displayed | **AUTOMATED** — a written test submits a script-tag string through the field and asserts the rendered output is escaped, not executed. | Test passes. |

## 8. secrets-and-config

*In scope from Tier T0 up, whenever any key/token/password exists in the project at all.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 8.1 | No key, password, or token appears in a file tracked by git | **AUTOMATED** — `gitleaks git -s .` (scans full git history, not just the working tree)[^gitleaks], run before the first push and before every subsequent push. | Zero findings. |
| 8.2 | `.env` (or equivalent secret file) is listed in `.gitignore` before it is ever created | **AUTOMATED** — a command checks `.gitignore` contains the env-file pattern; fails if the file is tracked. | Check passes. |
| 8.3 | Development and production use different secrets (a leaked dev key cannot touch production data) | **HUMAN DECISION** — "As chaves/segredos do ambiente de desenvolvimento são diferentes das chaves de produção?" | Jeferson answers yes, or separates them before shipping. |

## 9. deployment

*In scope from Tier T1 up, whenever the project is reachable over the network.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 9.1 | The deployed site is only reachable over HTTPS (HTTP redirects or is refused) | **AUTOMATED** — a script requests the deployed URL over plain HTTP and asserts a redirect to HTTPS, or connection refusal. | Check passes. |
| 9.2 | Debug/verbose mode is off in production (stack traces and internal errors are not shown to the end user) | **REVIEW** — subagent checks the production config/environment for debug flags. | No open HIGH/CRITICAL finding. |
| 9.3 | Basic security response headers are present (at minimum: no `X-Powered-By` leak, `Strict-Transport-Security`, sane `Content-Security-Policy` if the framework supports it easily) | **AUTOMATED** — a script requests the deployed URL and checks response headers against the minimum list. | Check passes. |

## 10. third-party-dependency

*In scope from Tier T0 up, whenever the project uses any external library/package.*

| # | Required check | How it is performed | Pass criterion |
|---|---|---|---|
| 10.1 | No dependency has a known HIGH/CRITICAL vulnerability | **AUTOMATED** — the ecosystem's own scanner: `npm audit` for Node[^npmaudit], `pip-audit` for Python[^pipaudit], or equivalent, run before every commit that touches dependencies. | Zero HIGH/CRITICAL vulnerabilities reported (moderate/low are logged, not blocking). |
| 10.2 | The lockfile (`package-lock.json`, `poetry.lock`, etc.) is committed, so installs are reproducible | **AUTOMATED** — a check that the lockfile exists and is tracked by git. | Check passes. |
| 10.3 | A new dependency was actually necessary for this task, not a convenience pull for something a few lines of code would do | **HUMAN DECISION**, triggered whenever a new dependency is added — stated per `method.md`'s existing rule to explain any new package before installing it, not a new gate here. | Explained to Jeferson before install, per the global CLAUDE.md rule already in force. |

---

## Sources

[^semgrep]: [Semgrep — `p/owasp-top-ten` ruleset](https://semgrep.dev/p/owasp-top-ten), accessed 2026-08-10.
[^gitleaks]: [gitleaks/gitleaks — README](https://github.com/gitleaks/gitleaks), accessed 2026-08-10.
[^password]: [OWASP Cheat Sheet Series — Password Storage](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html), accessed 2026-08-10.
[^idor]: [OWASP Cheat Sheet Series — Insecure Direct Object Reference Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Insecure_Direct_Object_Reference_Prevention_Cheat_Sheet.html), accessed 2026-08-10.
[^fileupload]: [OWASP Cheat Sheet Series — File Upload](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html), accessed 2026-08-10.
[^npmaudit]: [npm Docs — `npm audit`](https://docs.npmjs.com/cli/audit/), accessed 2026-08-10.
[^pipaudit]: [pypa/pip-audit — GitHub](https://github.com/pypa/pip-audit), accessed 2026-08-10.

See `research/13-testing-strategy.md` for the reasoning behind this
matrix's design choices (why each vulnerability class matters, what
automated checks can and cannot catch, and why payments checks center
on never touching raw card data).
