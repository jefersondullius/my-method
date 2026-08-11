---
description: Start a brand-new project from an empty folder — questions, spec, stack, plan, and the first commit, all in one session. The entry point that runs before the first line of code.
argument-hint: <ideia em 1-2 frases>
disable-model-invocation: true
---

You are executing Step 0 through Step 4 of `method.md` for a NEW
project in the current working directory. This command DRIVES the
entire pre-code phase in one session — questions, spec, stack, plan,
and the first commit. Follow the sequence below in order. Do not skip
a step, do not reorder it, do not add steps this command does not
have.

All prose you write to the user is Portuguese (pt-BR). All file
content you write (file names, code, comments, commit messages) is
English, except user-facing strings inside those files, which are
Portuguese.

## Safety check — before anything

If `method.md`, `SPEC.md`, `PLAN.md`, or `STATE.md` already exists in
the current directory, STOP. Tell the user, in Portuguese, that this
folder already looks like a project this method was run on, and that
`/start-project` is only for a folder that has not been through this
yet. Suggest `/where-am-i` or `/next-task` instead. Do not overwrite
anything.

## Step 0 — before anything (method.md Step 0)

1. Write the file `method.md` in the project root with EXACTLY the
   content in the block below — this is the method's own text, byte
   for byte, so every project carries the same copy:

   ```markdown
   # METHOD — v6 (post-audit-03, D5)

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

   ## STEP 0 — BEFORE ANYTHING

   1. Save this method's own text as a file in the project root (e.g.
      `method.md`) and commit it. Do this once per project, first thing.
   2. Create `friction.md` in the project root, with two sections, `YOURS`
      and `MINE`, kept separate.
   3. Create the `/friction` command if it does not already exist: it
      appends verbatim to the `MINE` section — the user's text, which
      task/step was in progress, what was just done immediately before —
      with no paraphrasing and no evaluation of the complaint.
   4. Save the security matrix's own text as `SECURITY-MATRIX.md` in the
      project root, next to `method.md`. Step 4 triages from it, cards
      cite its rows, and Step 5c re-opens it when the work turns on a
      risk surface the plan did not declare.

   *Nota (pt-BR): no piloto, o texto do método em si nunca foi salvo em
   disco — existiu só dentro de conversas que depois levaram `/clear`.
   Isso quebrava a própria regra de durabilidade que o método impõe ao
   STATE.md, e só foi descoberto na retrospectiva, quando foi preciso
   pedir o texto de volta ao usuário. Passo 0.1 fecha essa lacuna.*

   ## STEP 1 — QUESTIONS

   Interview the user about the project in Portuguese, every question
   carrying your own recommendation embedded so the user can just agree
   when they have no opinion.

   Open with the critical block, ONE question at a time, one message
   each: does it run offline/local or online/hosted; does it need login;
   does it involve payment; does it store other people's personal data.
   Any question in these classes — money, other people's data,
   access/login, hosting, legal exposure — is always asked alone,
   whenever it comes up, even late in the interview.

   After the critical block is settled, related questions MAY be grouped
   in one message — small groups, answers separable one by one. Still
   cover at least: who uses it, what language its end users read, and
   what "finished" means for this project.

   Three rules for the whole interview:
   - Dependency order: never ask a question whose answer depends on an
     answer not yet given.
   - Facts vs decisions: anything researchable, research yourself; only
     genuine decisions reach the user as questions.
   - Silent assumptions: before closing, list anything you assumed
     without asking, for the user to confirm or correct.

   Continue until no decision is open.

   *Nota (pt-BR): revisão v4 — única mudança desta versão. Origem:
   comparação deliberada com a skill "grilling" (Matt Pocock), auditoria
   02 (2026-08-10), por decisão explícita do usuário — NÃO nasceu de
   atrito observado em piloto; proveniência registrada em friction.md.
   Aditivos: ordem por dependência, fato≠decisão, suposições silenciosas.
   Cadência: bloco crítico um-por-vez ("pagamento" entra na lista mínima
   nesta versão), depois agrupamento autorizado, com a salvaguarda de que
   classes críticas nunca entram em grupo. O modelo de "rodadas" do
   grilling não foi adotado; o Gate 1 (SPEC escrito) segue sendo a
   confirmação final.*

   ## STEP 2 — SPEC

   Write what you understood to `SPEC.md`, in English, describing
   BEHAVIOUR, not technology: what the thing does, from the point of view
   of whoever uses it. Summarize it back in Portuguese and wait. This is
   a real gate — the user can evaluate behaviour, not technology.

   ## STEP 3 — STACK

   Decide the stack yourself. Present the decision already made, in
   Portuguese, with plain-language reasoning and what the runner-up would
   have cost. Do not ask the user to choose between things they cannot
   evaluate. Write it into `STATE.md` with the reason, not just the name.

   ## STEP 4 — PLAN

   Break the work into tasks. Write:
   - `PLAN.md` — an index only: one line per task (ID, name, status,
     depends-on).
   - `plan/TASK-XXX.md` — one card per task, five fields only: what
     concretely exists when done; how it will be checked, in a way the
     user can see or a command can prove; which files it touches; does
     it fit in one session (if not, split now); status.

   Security rows — before showing the plan: triage the project's
   security tier (T0–T3) per `SECURITY-MATRIX.md`, from the Step 1
   answers and the approved SPEC. Tell the user the tier and its reason
   in one line, in Portuguese. Copy every in-scope row (ID + required
   check) into "How we will check it" of each card whose work touches
   that surface — every in-scope row lands on at least one card; a row
   with no natural home (e.g. deployment) goes on the card where it
   first becomes checkable. A card touching no surface states
   "Security: none applicable". Record the tier and its reason in
   `STATE.md`'s settled decisions. This adds no sixth field and no
   second question — Gate 2 stays exactly one question.

   Then ask exactly one question in Portuguese: "você reconhece o seu
   produto nesta lista?" — confirming the product being built, not the
   technical sequencing. **After this question is answered, end the turn
   with the `/clear` instruction (see 5d's exact wording) before Step 5
   of the first task begins.**

   *Nota (pt-BR): no piloto calculo-investimento, perguntas (Passo 1),
   SPEC, stack, plano e a execução da TASK-001 rodaram numa sessão só de
   45 minutos — os commits provam que nenhum `/clear` real aconteceu no
   projeto inteiro. O Passo 4 já termina numa pergunta ao usuário; era o
   ponto de corte natural e não existia. Este passo fecha essa lacuna.*

   ## STEP 5 — ONE TASK PER SESSION

   For each task:

   a) Tell the user in at most 6 lines which task this is and what will
      exist when it ends.
   b) Build it, narrating intent and consequence, never mechanics.
   c) VERIFY — not negotiable: **attempt automated verification first**;
      only say "verificação humana necessária" after a real attempt fails
      (not before being asked to try), and say exactly what failed. Show
      the RAW OUTPUT of whatever proves it; re-run everything that
      already existed, not only the new check; give the user something to
      confirm with their own eyes wherever possible.
      Automated verification runs through the project's verify entrypoint
      (`scripts/verify.ps1`): it re-runs every accumulated check, prints
      the raw output, and records machine evidence at
      `.claude/last-verify.json` — the commit gate reads that file. A task
      that adds an automated check (including the card's AUTOMATED
      security rows) adds it to the entrypoint as part of the task; that
      is how a check joins the regression set.
      The card's security rows run inside this step, by kind:
      - Drift first: if the diff turned on a risk surface the card does
        not declare (new endpoint, new dependency, upload path, stored
        secret…), pull that surface's rows from `SECURITY-MATRIX.md`
        into the card now and say so — the matrix's own re-triage rule.
      - AUTOMATED rows are commands, run here, raw output on screen;
        they join the regression set and are re-run by every later task.
      - REVIEW rows go, all together, to ONE fresh invocation of the
        read-only `security-reviewer` subagent, with the diff; findings
        (severity + `file:line`) are shown raw and recorded on the card
        BEFORE anything is fixed. The reviewer cannot edit; it reports.
      - HUMAN DECISION rows are asked to the user verbatim, in
        Portuguese, never answered on their behalf. A row that shapes
        how the task is built is asked before building starts, not here.
      - Fix loop: failures are fixed in this session, within the card's
        file scope, only after findings are shown and recorded; then the
        AUTOMATED rows re-run and the updated diff goes to a NEW
        reviewer invocation. This session never declares a REVIEW row
        passed — only a fresh reviewer's "no open HIGH or CRITICAL
        finding" does. Two failed rounds of the same row → Step 6.
   d) Sync EVERY status-bearing file in one commit — `STATE.md`, `PLAN.md`
      row, and the task's own card (`plan/TASK-XXX.md`) — not just
      `STATE.md`. Commit in English.
      The staged set must include `.claude/last-verify.json` together
      with the three status files — the commit gate denies a task commit
      missing any of them, and denies any commit without fresh PASS
      evidence.
      **Then end the turn with exactly
      this text and nothing else:**
      > Tarefa concluída e commitada. Rode `/clear` antes de continuar.
      Do not offer to continue to the next task, do not ask if the user
      wants to keep going. If a next task exists, its 6-line intro (5a)
      is for the *next* session.

   *Nota (pt-BR): 5c — no piloto, a checagem visual foi rotulada "humana"
   sem tentar automatizar, e só foi tentada depois que o usuário pediu a
   saída bruta. 5d — duas falhas distintas no mesmo piloto: (1) `PLAN.md`
   ficou "pending" com `STATE.md` já "done" porque o passo só mandava
   sincronizar `STATE.md`; (2) mesmo com 5d já marcado "não negociável" na
   v2, a instrução de fim de turno não foi emitida — prosa enfática já
   falhou uma vez em garantir execução, por isso 5d agora dá um texto
   literal a copiar em vez de uma regra a interpretar.*

   ## STEP 6 — STUCK PROTOCOL

   After TWO failed attempts at the same check, STOP. Do not try a third
   variation of the same idea. Write to `STATE.md` what was tried, what
   failed, and the suspected cause. Give three options in Portuguese with
   a recommendation: split the task smaller, escalate model/effort and
   retry once, or answer a specific question that unblocks the work.

   ## FILES THAT CARRY STATE

   `STATE.md`, max 80 lines, updated at the end of every task. Sections:
   project and goal in one sentence; stack and why; tasks completed (ID +
   date, one line each); CURRENT TASK and the concrete next action;
   settled decisions not to reopen; open questions waiting on the user;
   things that broke once.

   Rule at the top of `STATE.md`: if information exists only in this
   conversation, it does not exist. Before any `/clear` it must be here.

   ## START

   Begin at Step 0, then Step 1. Do not skip ahead. Do not add steps this
   method does not have — if the urge shows up, that is friction: log it
   and continue without it.
   ```

2. Write `friction.md` in the project root with exactly:

   ```markdown
   # FRICTION

   ## YOURS

   ## MINE
   ```

3. The `/friction` command does not need to be created — it ships with
   this plugin and is already available as `/my-method:friction` in
   every project. Do not create a duplicate file for it.

4. Write `SECURITY-MATRIX.md` in the project root with EXACTLY the
   content in the block below — the security matrix's own text, byte
   for byte, so every project carries the same copy:

   ```markdown
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

   ## WHERE THIS FILE LIVES

   The canonical copy is `playbook/SECURITY-MATRIX.md` in the my-method
   repo. `start-project` writes a byte-identical copy into every new
   project's root as `SECURITY-MATRIX.md` — a project session never
   reads the repo's copy (Boundaries rule). The project copy is the one
   Step 4 triages from, cards cite, and Step 5c re-opens when a new
   surface turns on mid-project.

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

   REVIEW rows are executed by the plugin's `security-reviewer` agent,
   defined with a read-only tool allowlist (`Read, Grep, Glob`): it can
   read code and return findings; it cannot edit files or run commands.
   It never fixes. Fixing is the building session's job, and a fixed
   diff is re-judged by a NEW reviewer invocation — never by the session
   that fixed it, and never by the reviewer invocation that found it.

   ---

   ## 1. data-store

   *In scope from Tier T1 up, whenever the project persists anything.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 1.1 | No SQL/query built by string concatenation of user input | **AUTOMATED** — run a static scanner with an injection ruleset (e.g. `semgrep --config p/owasp-top-ten` — Semgrep's OWASP Top 10 ruleset maps rules directly to injection and access-control categories[^semgrep]) over the diff. | Scanner reports zero findings of ERROR/HIGH severity in the injection rule family. | Replace string concatenation with parameterized queries / ORM binding. |
   | 1.2 | Every query that touches "another user's row" is scoped to the logged-in user, not to an ID taken raw from the request | **REVIEW** — subagent reads the diff for every query/ORM call touching this data store and checks the `WHERE`/filter clause against the authenticated user. | No open HIGH/CRITICAL finding. | Scope the query to the logged-in user's ID in the WHERE/filter, server-side. |
   | 1.3 | Passwords and other secrets-shaped fields (tokens, card data) are never stored as plain text or reversibly encrypted | **REVIEW** — subagent inspects the schema and every write path to a "password"/"token"/"secret" column for hashing (Argon2id/bcrypt) instead of storage-as-is[^password]. | No open HIGH/CRITICAL finding. | Hash with Argon2id/bcrypt via the auth library; migrate stored values; never store raw. |
   | 1.4 | The database user/role this project's code connects as has only the privileges the app needs (not the provider's admin/root account) | **HUMAN DECISION** — "O usuário de banco de dados que a aplicação usa para se conectar tem só as permissões que ela realmente precisa (não é a conta admin/root do provedor)?" | Jeferson answers yes, or creates a scoped-down user before shipping. | Create a scoped DB role with only the needed privileges; point the app's connection at it. |
   | 1.5 | Backups exist for any data that would hurt to lose | **HUMAN DECISION** — "O provedor de banco de dados escolhido faz backup automático, e você confirmou que ele está ligado?" | Jeferson answers yes, or accepts the risk explicitly. | Turn on the provider's automatic backups. |

   ## 2. external-api

   *In scope from Tier T1 up, whenever the project calls a third-party service.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 2.1 | No API key/secret hardcoded in a request to the external service | **AUTOMATED** — run `gitleaks` (or equivalent secret scanner) against the diff and the full history before first push[^gitleaks]. | Zero findings. | Move the key to an environment variable AND rotate it at the provider — it is burned. |
   | 2.2 | Calls to the external service have a timeout and handle a failure/error response without crashing or leaking internals | **REVIEW** — subagent checks every call site for a timeout and an error branch. | No open HIGH/CRITICAL finding. | Add a timeout and an error branch that fails gracefully without leaking internals. |
   | 2.3 | The API key generated for this project is scoped to only what this project needs, not a full-account/admin key | **HUMAN DECISION** — "A chave de API que você gerou para este projeto tem permissão só para o que ele precisa, e não é uma chave de administrador da sua conta inteira no provedor?" | Jeferson answers yes, or generates a scoped key before shipping. | Generate a scoped key at the provider; replace and revoke the broad one. |

   ## 3. authentication

   *In scope from Tier T2 up.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 3.1 | Passwords are hashed with a slow, salted algorithm (Argon2id or bcrypt), never a fast general-purpose hash (MD5/SHA-family alone) | **REVIEW** — subagent inspects the password-write and password-check code paths[^password]. | No open HIGH/CRITICAL finding. | Switch to Argon2id/bcrypt via the auth library; force resets if plaintext was ever stored. |
   | 3.2 | Login/authentication logic uses a maintained library (framework-provided auth, Passport, NextAuth, Supabase/Auth0, Django auth — not code written from scratch for hashing or session tokens) | **HUMAN DECISION** — "Você concorda em usar uma biblioteca de autenticação pronta e testada, em vez de escrevermos a lógica de login/senha do zero?" | Jeferson answers yes; if no, the REVIEW bar for 3.1 and 3.3 tightens (custom crypto gets adversarial review, not a pass by default). | Adopt a maintained auth library; do not patch the hand-rolled code. |
   | 3.3 | The login endpoint rejects a wrong password without revealing whether the *username/e-mail* itself exists | **AUTOMATED** — a written test hits the login endpoint with (a) a real e-mail + wrong password and (b) a fake e-mail + any password, and asserts both responses are identical (same status code, same message, no timing tell built into the test). | Test passes: both attempts return the same generic failure. | Return one identical generic status + message for both failure cases. |
   | 3.4 | Sessions/tokens expire and can be invalidated (logout actually ends the session) | **REVIEW** — subagent checks session/token issuance for an expiry and checks that logout revokes it server-side (not just clears the client cookie). | No open HIGH/CRITICAL finding. | Set expiry at issuance; revoke server-side on logout. |

   ## 4. authorization

   *In scope from Tier T2 up.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 4.1 | Every endpoint/action that reads or writes a specific user's data checks that the logged-in user owns that data (no Insecure Direct Object Reference)[^idor] | **REVIEW** — subagent walks every route/handler that takes an ID (user ID, order ID, document ID, etc.) from the request and verifies an ownership check exists before the read/write. | No open HIGH/CRITICAL finding. | Add an ownership check (resource owner == logged-in user) before the read/write. |
   | 4.2 | Changing an ID in the request (e.g. `/orders/123` → `/orders/124`) while logged in as a different user does not return or modify that other user's data | **AUTOMATED** — a written test: log in as user A, request/modify a resource ID known to belong to user B, assert a 403/404, not the data. | Test passes for every resource type that belongs to a specific user. | Fix the ownership check in the failing handler; re-run the user-A/user-B test. |
   | 4.3 | Admin-only or privileged actions check the role/permission server-side, not just hide the button in the UI | **REVIEW** — subagent checks that every privileged action re-checks the role on the server, independent of what the client sends or shows. | No open HIGH/CRITICAL finding. | Re-check the role server-side inside the privileged handler itself. |

   ## 5. payments

   *In scope from Tier T3, only if the project charges money.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 5.1 | This project's own code never receives, stores, logs, or transmits a raw card number/CVV — card entry happens on the payment provider's own hosted page/element (Stripe Checkout/Elements or equivalent) | **REVIEW** — subagent scans the diff for any field or variable that looks like a raw card number/CVV/expiry being read or stored by this project's code. This is also the single biggest scope-reducer for a small project: see `research/13-testing-strategy.md` for why. | No open HIGH/CRITICAL finding: zero raw-card-data handling found in this project's code. | Remove all raw-card handling from this codebase; use the provider's hosted checkout/element. |
   | 5.2 | Payment provider webhooks verify the provider's signature before trusting the payload | **REVIEW** — subagent checks the webhook handler for signature verification before any state change. | No open HIGH/CRITICAL finding. | Verify the provider's webhook signature before any state change. |
   | 5.3 | Using a hosted checkout/elements flow (never collecting the card number on this project's own page) is a deliberate choice, confirmed | **HUMAN DECISION** — "Você concorda em usar o checkout hospedado do provedor de pagamento (ex.: Stripe Checkout), em vez de coletarmos o número do cartão na nossa própria página?" | Jeferson answers yes. A "no" here reopens PCI-DSS scope well beyond what this matrix covers, and needs a specialist, not this checklist. | Switch to hosted checkout; if refused, stop — that is specialist territory per the row. |

   ## 6. file-upload

   *In scope from Tier T3, only if the project accepts files from users.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 6.1 | Accepted file types are checked against an allowlist (only the extensions/MIME types the feature needs), not a blocklist[^fileupload] | **REVIEW** — subagent checks the upload handler's validation logic. | No open HIGH/CRITICAL finding. | Replace the blocklist with an allowlist of only the types the feature needs. |
   | 6.2 | Oversized uploads are rejected | **AUTOMATED** — a written test uploads a file above the configured limit and asserts rejection. | Test passes. | Enforce the size limit server-side, before reading the whole body. |
   | 6.3 | Uploaded files are stored/served in a way that cannot be executed as code by the server (outside the web root, or served with a content-type that forces download, or via object storage) | **HUMAN DECISION** — "Os arquivos enviados pelos usuários vão ficar guardados num lugar de onde o servidor não pode executá-los como código (ex.: um bucket de armazenamento, não a mesma pasta que serve o site)?" | Jeferson answers yes, or the hosting choice is adjusted before shipping. | Move uploads to object storage or outside the web root; serve with a download-forcing content type. |

   ## 7. user-input

   *In scope from Tier T0 up, whenever the project renders or stores anything a user typed.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 7.1 | User-typed text is never inserted into HTML/SQL/shell commands by raw string concatenation | **AUTOMATED** — `semgrep --config p/owasp-top-ten` (or the framework's built-in escaping check) over the diff[^semgrep]. | Zero ERROR/HIGH findings. | Use the framework's escaping/parameterization instead of concatenation. |
   | 7.2 | Every field with a size/format expectation (e-mail, amount, date, ID) is validated server-side, not only in the browser | **REVIEW** — subagent checks that server-side handlers validate input independent of any client-side check. | No open HIGH/CRITICAL finding. | Add server-side validation for the field, independent of any client check. |
   | 7.3 | Submitting a `<script>` tag or similar payload in a text field does not execute when the field is later displayed | **AUTOMATED** — a written test submits a script-tag string through the field and asserts the rendered output is escaped, not executed. | Test passes. | Escape at render time (framework auto-escaping); never inject raw HTML. |

   ## 8. secrets-and-config

   *In scope from Tier T0 up, whenever any key/token/password exists in the project at all.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 8.1 | No key, password, or token appears in a file tracked by git | **AUTOMATED** — `gitleaks git -s .` (scans full git history, not just the working tree)[^gitleaks], run before the first push and before every subsequent push. | Zero findings. | Rotate the credential NOW (history rewrite alone is not enough), move it to an env var, then scrub history. |
   | 8.2 | `.env` (or equivalent secret file) is listed in `.gitignore` before it is ever created | **AUTOMATED** — a command checks `.gitignore` contains the env-file pattern; fails if the file is tracked. | Check passes. | Add the pattern to `.gitignore` and untrack the file (`git rm --cached`). |
   | 8.3 | Development and production use different secrets (a leaked dev key cannot touch production data) | **HUMAN DECISION** — "As chaves/segredos do ambiente de desenvolvimento são diferentes das chaves de produção?" | Jeferson answers yes, or separates them before shipping. | Issue separate production secrets; a dev key never touches prod. |

   ## 9. deployment

   *In scope from Tier T1 up, whenever the project is reachable over the network.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 9.1 | The deployed site is only reachable over HTTPS (HTTP redirects or is refused) | **AUTOMATED** — a script requests the deployed URL over plain HTTP and asserts a redirect to HTTPS, or connection refusal. | Check passes. | Enable HTTPS-only / HTTP→HTTPS redirect at the host. |
   | 9.2 | Debug/verbose mode is off in production (stack traces and internal errors are not shown to the end user) | **REVIEW** — subagent checks the production config/environment for debug flags. | No open HIGH/CRITICAL finding. | Turn the debug flag off in the production environment. |
   | 9.3 | Basic security response headers are present (at minimum: no `X-Powered-By` leak, `Strict-Transport-Security`, sane `Content-Security-Policy` if the framework supports it easily) | **AUTOMATED** — a script requests the deployed URL and checks response headers against the minimum list. | Check passes. | Add the missing headers via host or framework config. |

   ## 10. third-party-dependency

   *In scope from Tier T0 up, whenever the project uses any external library/package.*

   | # | Required check | How it is performed | Pass criterion | Fix direction |
   |---|---|---|---|---|
   | 10.1 | No dependency has a known HIGH/CRITICAL vulnerability | **AUTOMATED** — the ecosystem's own scanner: `npm audit` for Node[^npmaudit], `pip-audit` for Python[^pipaudit], or equivalent, run before every commit that touches dependencies. | Zero HIGH/CRITICAL vulnerabilities reported (moderate/low are logged, not blocking). | Upgrade to the fixed version; if none exists, replace the dependency or escalate to the user. |
   | 10.2 | The lockfile (`package-lock.json`, `poetry.lock`, etc.) is committed, so installs are reproducible | **AUTOMATED** — a check that the lockfile exists and is tracked by git. | Check passes. | Commit the lockfile. |
   | 10.3 | A new dependency was actually necessary for this task, not a convenience pull for something a few lines of code would do | **HUMAN DECISION**, triggered whenever a new dependency is added — stated per `method.md`'s existing rule to explain any new package before installing it, not a new gate here. | Explained to Jeferson before install, per the global CLAUDE.md rule already in force. | n/a — the explain-before-install rule is already in force. |

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
   ```

Do not commit yet. Git is initialized once, together with the first
commit, in Step 5 below — there is nothing meaningful to version until
the spec and plan exist.

## Step 1 — QUESTIONS (method.md Step 1)

Interview the user about the project in Portuguese. Every question
carries your own recommendation, so the user can just agree if they
have no opinion — phrase it like "Pergunta: ... Minha recomendação: ...
(pode só confirmar se topar)."

Before any question: if the user typed the idea together with the
command, restate it in one line and go straight to the critical
block. If not, ask for it first — one line, in Portuguese ("Qual é a
ideia? Uma ou duas frases bastam.") — and WAIT for the answer. Never
infer the idea from the folder name or any other context: ask.

Open with the CRITICAL BLOCK — one question at a time, one message
each, wait for the answer before the next:
1. Se precisa funcionar online/hospedado, ou se rodar só na máquina
   do usuário já resolve.
2. Se precisa de login/conta de usuário.
3. Se envolve pagamento — cobrar, receber ou repassar qualquer
   dinheiro de quem usa.
4. Se o projeto guarda dado pessoal de terceiros (nome, e-mail, foto,
   localização, o que for) — e de quem.

Any question in these classes — money, other people's data,
access/login, hosting, legal exposure — is ALWAYS asked alone, in its
own message, whenever it comes up, even late in the interview.

After the critical block is settled, related questions MAY be grouped
in one message — small groups, each question numbered and carrying its
own recommendation, so the user can answer item by item. Cover, at
minimum:
5. Quem usa isto (só você? outras pessoas? quantas, mais ou menos?).
6. Em que língua as pessoas que usam o produto vão ler a tela.
7. O que significa "pronto" para este projeto especificamente — o que
   precisa existir para você considerar a primeira versão utilizável.

Three rules for the whole interview:
- Dependency order: never ask a question whose answer depends on an
  answer not yet given.
- Facts vs decisions: anything researchable, research yourself; only
  genuine decisions reach the user as questions.
- Silent assumptions: before closing, list in Portuguese anything you
  assumed without asking, one line each, for the user to confirm or
  correct.

If an answer opens a new decision not on this list, ask about it too —
alone if it touches a critical class, grouped otherwise. Stop asking
once no decision is open — do not pad the list with questions that
have an obvious answer given what was already said.

## Step 2 — SPEC (method.md Step 2) — GATE 1

Write `SPEC.md` in the project root, in English, describing BEHAVIOUR
only — what the thing does from the point of view of whoever uses it,
never the technology it runs on. Structure it around the answers from
Step 1:

```markdown
# <Project Name>

<One sentence: what this is, for whom.>

## Who uses this

## What it does

<The concrete flows/features, from the user's point of view.>

## Data

<Personal data handled, if any — whose, and what fields. "None" if
Step 1's answer was none.>

## Access

<Login required or not.>

## Availability

<Must be online, or works offline.>

## Language

<Language end users read on screen.>

## Definition of done

<What "finished" means for this project — from Step 1's answer.>
```

Then summarize `SPEC.md` back to the user in Portuguese, in plain
language, and WAIT. This is a real gate: do not proceed to Step 3
until the user explicitly confirms the spec is right. If they ask for
changes, edit `SPEC.md` and summarize again — repeat until confirmed.

On the confirmation, append one line to the end of `SPEC.md`:
`Approved: <YYYY-MM-DD>` (today's date). If the spec is ever revised
and re-approved, append a new `Approved:` line — never edit or remove
an earlier one.

## Step 3 — STACK (method.md Step 3)

Decide the stack yourself — do not ask the user to choose between
options they have no basis to evaluate. Base the decision on what
`SPEC.md` actually requires (data storage needs, login, online
requirement, expected scale). Present it in Portuguese, already
decided:

- The technology chosen, in plain language (define any term the user
  has not seen yet, per the global language policy).
- Why it fits what `SPEC.md` asks for.
- What the runner-up option would have cost — in effort, money, or
  fragility — so the user understands the decision without needing to
  evaluate the alternatives themselves.

This is not a gate — do not wait for approval, just inform. Hold onto
the decision and its reasoning; it gets written into `STATE.md` in
Step 5, not before (there is no `STATE.md` yet).

## Step 4 — PLAN (method.md Step 4) — GATE 2

Before writing the cards: triage the project's security tier (T0–T3)
per the `SECURITY-MATRIX.md` written in Step 0, using the Step 1
critical answers and the approved SPEC. Tell the user, in Portuguese,
in one line, the tier and why. Then, as each card is written, copy
every in-scope row (ID + required check) into its "How we will check
it" when the card's work touches that surface. Coverage rule: every
in-scope row must land on at least one card; a row with no natural
home (e.g. `deployment`) goes on the card where it first becomes
checkable. A card touching no surface states "Security: none
applicable". Do not add a sixth field; do not add a second Gate-2
question.

Break the work into tasks and write:

- `PLAN.md` — index only, one line per task:
  ```markdown
  # PLAN

  <!-- TASK-001 — name — pending — depends-on: none -->
  ```
- `plan/TASK-XXX.md` — one card per task, exactly these five fields,
  nothing else:
  ```markdown
  # TASK-XXX — <name>

  ## What concretely exists when this is done

  ## How we will check it

  ## Files it touches

  ## Does it fit in one session?

  ## Status

  pending
  ```

If any task would not fit in a single session, split it into more
tasks now, at planning time — do not defer the split to when
`/next-task` reaches it.

Sizing proxies for "Does it fit in one session?": (a) one feature or
one slice of a feature; (b) touches at most ~5 files; (c) verification
adds at most 2 new checks to the entrypoint plus at most 1 human
check; (d) introduces at most 1 new concept or library. A task that
misses two or more proxies is split now.

Then ask exactly this one question, in Portuguese, and nothing else:

> Você reconhece o seu produto nesta lista?

This confirms the *product* being built, not the technical sequencing
of tasks — the user has no basis to approve or reject task order. If
they say no or ask for changes, revise `PLAN.md` and the cards and ask
again. WAIT for a yes before Step 5.

## Step 5 — finalize project files, git, first commit

Only after Gate 2 is confirmed:

1. Write `CLAUDE.md` in the project root:
   ````markdown
   # <Project Name>

   <One sentence: what this project does, from the user's point of view — same as SPEC.md's opening line.>

   ## Stack

   <Technology chosen in Step 3 — reason it was chosen.>

   Build: `<command, or "n/a" if none>`
   Run: `<command>`
   Test: `<command, or "n/a" if none yet>`
   Verify: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verify.ps1`

   ## Directory layout

   ```
   method.md        the method this project follows (do not edit)
   SECURITY-MATRIX.md  security checks for this project's tier (do not edit)
   friction.md       YOURS / MINE — friction log, appended verbatim
   SPEC.md           behaviour spec, agreed with the user
   STATE.md          project memory — read this first, every session
   PLAN.md           task index only — one line per task
   plan/TASK-XXX.md  one card per task
   scripts/verify.ps1  verify entrypoint — runs every accumulated check, writes the evidence the commit gate reads
   .claude/skills/   procedures (see "What does NOT go here" below)
   ```

   ## LANGUAGE POLICY

   - ENGLISH: all file names, folder names, code, comments, git messages,
     config files.
   - PORTUGUESE (pt-BR): every message, question, summary, and narration
     written to the user.
   - User-facing strings inside English files are Portuguese, marked
     `# user-facing (pt-BR)`.
   - Never translate a technical identifier into Portuguese.

   ## Narration rule

   - Before a block of work: one plain sentence on what is about to
     happen and why.
   - When a file is created or changed: one line on what it is for.
   - When done: what changed in practice for whoever will use the
     product.
   - Never narrate mechanics ("now I will open the file"). That is
     noise.

   ## Security — non-negotiable

   - No key, password, or token ever goes into a versioned file.
   - Never ask the user to paste a credential into the chat — teach them
     to use an environment variable instead.
   - Before installing any third-party package, say what it is and why
     it is needed; if a credential is already found in a file, stop and
     alert the user before continuing.

   ## Where things live

   State is in `STATE.md`. Task index is in `PLAN.md`. Task cards are in
   `plan/`. Start a session with `/next-task`.

   ## What does NOT go in this file

   - Procedures — those are skills, not text here.
   - Anything that must happen reliably every time — that is a hook, not
     a rule someone has to remember to follow.
   - Anything that changes as work progresses — that belongs in
     `STATE.md`, not here. This file describes what stays true for the
     life of the project; `STATE.md` describes what is true right now.
   ````
   (Fill the two `<...>` lines and the three commands; keep everything
   else verbatim — this section text is shared across every project
   this method runs on.)

2. Write `STATE.md` in the project root:
   ```markdown
   # STATE

   > Rule: if information exists only in the conversation, it does not
   > exist. Before any `/clear` it must be here.

   ## Project and goal

   <One sentence — same as CLAUDE.md's opening line.>

   ## Stack and why

   <Technology — reason, from Step 3's decision. One line each if more than one technology.>

   ## Tasks completed

   <Empty — nothing is done yet.>

   ## CURRENT TASK

   TASK-001 — <name>. Next action: run `/next-task`.

   ## Settled decisions

   <Key answers from Step 1, the SPEC approval — "SPEC approved: <YYYY-MM-DD>" — the stack decision from Step 3, and the security tier — "Security tier: TX — <reason>" — from Step 4's triage.>

   ## Open questions

   <Empty, unless something genuinely remains unresolved.>

   ## Things that broke once

   <Empty.>
   ```

3. Write `scripts/verify.ps1` with EXACTLY the content in the block
   below, then seed `$checks` with the stack's own test command from
   Step 3's decision, if one exists (the same command recorded as
   `Test:` in `CLAUDE.md`):

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

4. Run `git init` if the directory is not already a git repository.

5. Only if the stack chosen in Step 3 produces files that must never be
   versioned (dependency folders, build output, local files holding
   secrets), write a minimal `.gitignore` listing exactly those — no
   generic boilerplate beyond what this stack actually produces. Never
   ignore `.claude/last-verify.json`; if the stack's ignore rules cover
   `.claude/`, add the exception line `!.claude/last-verify.json`.

6. Stage `method.md`, `SECURITY-MATRIX.md`, `friction.md`, `SPEC.md`,
   `STATE.md`, `CLAUDE.md`, `PLAN.md`, `plan/*.md`, `scripts/verify.ps1`,
   and `.gitignore` if created, and make ONE commit, in English, e.g.:
   ```
   Initialize project: spec, stack, plan
   ```

## Step 6 — close

Tell the user, in Portuguese, in a few lines: the project was
initialized, how many tasks are in the plan, and what TASK-001 is.

Run `git show --stat` on the initial commit and show its RAW output
on screen — the user sees the commit and its file list directly, not
a sentence about them.

Then say, and mean literally:

> Rode `/clear` agora. Na próxima sessão, digite `/next-task` para
> começar a primeira tarefa.

Do not start Step 5 of `method.md` (building TASK-001) in this
session — that belongs to `/next-task`, in a fresh session.
