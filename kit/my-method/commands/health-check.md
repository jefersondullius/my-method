---
description: Instant health check of the my-method kit — the plugin loads, the commands resolve, the security reviewer registers, the commit gate fires, the security tools exist. Read-only, runs in seconds, changes nothing.
disable-model-invocation: true
---

You are checking that the my-method kit is intact and operational in
THIS session, before real work starts. This command is READ-ONLY: it
writes no file, installs nothing, fixes nothing, changes no setting.
If a probe fails you report it — you do not repair it.

Last full maintenance run: 2026-08-11
Kit inventory at that run: 6 skills, 1 agent, 1 hook

Run the five probes below in order, then summarize. Show the RAW
OUTPUT of every command you run — the actual result, not a sentence
about it.

## Probe 1 — is the right plugin loaded, and is it the current one?

1. This command executing at all proves the plugin loaded in this
   session. Say so in one line.
2. Run `claude plugin list --json` and show its raw output. Check:
   `my-method@jeferson-tools` is present, `scope` is `user`, `enabled`
   is true, and `errors` is empty. Report any OTHER entry carrying the
   name `my-method` — a leftover `.claude/skills/my-method` link is
   known to appear as `my-method@skills-dir`, not loaded, and is
   harmless; say it is there.
3. Run `claude plugin details my-method` and show its raw output.
   Compare its component inventory against the expected one:
   - If `method.md` and `kit/my-method/.claude-plugin/plugin.json`
     both exist here, you are in the method repo: compare against the
     kit on disk — count `kit/my-method/commands/*.md`,
     `kit/my-method/agents/*.md`, and the hook entries in
     `kit/my-method/hooks/hooks.json`.
   - Otherwise compare against the line "Kit inventory at that run" at
     the top of this file.
   A MISMATCH means the plugin the harness is running is not the kit
   that was last applied. Report it as FAILED and say the fix:
   `/plugin update my-method@jeferson-tools` (or reinstall), then
   `/reload-plugins`. Do not run either — report only.

## Probe 2 — does the security reviewer register?

Invoke the `security-reviewer` subagent ONCE, with a trivial prompt:
ask it to reply with the single line `HEALTH: reviewer alive` and
nothing else, giving it no diff to judge.

- If it replies, the agent is registered, and read-only by definition
  (its allowlist is `Read, Grep, Glob`).
- If the invocation fails with "agent type not found", report FAILED:
  the kit cannot run REVIEW security rows in this state.
- If a file named `security-reviewer.md` exists under `.claude/agents/`
  in this folder, say so: a project or user agent of the same name
  overrides the plugin's, so the reviewer that answered may not be the
  kit's.

## Probe 3 — does the commit gate fire?

Conclusive only inside a my-method project. Decide first:

- If `method.md`, `PLAN.md` and `STATE.md` all exist here AND
  `git rev-parse HEAD` succeeds (at least one commit), the gate is
  armed — run the probe.
- Otherwise report probe 3 as INCONCLUSIVE and say why in one line:
  the gate deliberately allows everything outside a my-method project
  and exempts a repository's first commit. Never report it as passed.

The probe, when armed:

```
git commit --dry-run --allow-empty -m "health probe"
```

- **DENIED by the gate** — the expected result and the proof the hook
  is live. Show the gate's reason raw. Nothing was committed.
- **Git's own output came back** (branch/status text) — the hook is
  NOT firing. Report FAILED: this is the kit's only Level-1
  mechanism, and without it verification-before-commit is back to
  being prose. Note that plugin hook changes need `/reload-plugins`
  or a restart to take effect.

Judge by WHICH text came back — the gate's reason, or git's own
output. Do not judge by the exit code: with nothing staged, a dry run
exits non-zero while having done nothing wrong. A dry run changes
nothing in either case.

## Probe 4 — do the dependencies exist?

Run each and show the raw output; report PRESENT with the version
line, or ABSENT. Install nothing, ever:

```
git --version
semgrep --version
gitleaks version
npm --version
pip-audit --version
```

`git` ABSENT is fatal — nothing in the method works without it. The
four scanners are needed only by the AUTOMATED rows of
`SECURITY-MATRIX.md` that a project's tier actually pulls in: a T0
project needs none of them; a project that stores anything, calls an
API, or has login needs the ones its rows name. Report what is missing
and which rows it would block. An absent scanner is not a failure of
the kit — it is a fact the user needs BEFORE a project starts, not
during its first verification.

## Probe 5 — is the kit itself well-formed? (method repo only)

Only if `kit/my-method/.claude-plugin/plugin.json` exists here, run:

```
claude plugin validate ./kit/my-method
```

Show the raw output. This checks `plugin.json`, the frontmatter of
every command and agent, and `hooks/hooks.json` for schema errors.
Outside the method repo, skip this probe and say it was skipped.

## Summary — Portuguese, at most 10 lines

One line per probe: PASSOU / FALHOU / INCONCLUSIVO, each with its
concrete consequence in plain language ("o revisor de segurança não
registrou — linhas REVIEW não vão rodar neste estado").

Then one closing line: how old the last full maintenance run is,
counting from the date at the top of this file to today — and, only if
that is more than 30 days, the sentence:
"Vale rodar `/my-method:update-method` antes de começar."

Add nothing else: no recommendations beyond that line, no offer to
fix, no questions. This command only reports.
