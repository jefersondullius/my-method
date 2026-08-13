# Skill candidate: grilling (Matt Pocock)

**Queried name:** grilling

**EXISTS?** YES, under the exact queried name — live at `github.com/mattpocock/skills`, skill file `skills/productivity/grilling/SKILL.md` [1][4].

**Real current name:** `grilling` — the model-invoked interview *primitive*. Two user-invoked front doors just call it: `grill-me` (generic, writes nothing) and `grill-with-docs` (same interview, also writes docs) [4][5][6][9].

**Origin/author:** Matt Pocock — GitHub `mattpocock`, site `aihero.dev` (formerly the Total TypeScript educator). MIT-licensed repo `github.com/mattpocock/skills` [1][10]. `plugin.json`: `"author": {"name": "Matt Pocock", "url": "https://www.aihero.dev"}` [2], matching his independently-confirmed bio.

**Purpose (pt-BR):** É um skill (instrução reutilizável que o Claude carrega automaticamente) que interroga o usuário em rodadas de perguntas — cada uma já com a recomendação do próprio agente — até que um plano, decisão ou ideia esteja plenamente esclarecido, só liberando a execução depois que o usuário confirmar o entendimento compartilhado.

**Install command (verified):** Official plugin, whole 25-skill bundle incl. grilling: `claude plugins install mattpocock-skills`, or in-session `/plugin install mattpocock-skills` — "nothing to add first" [9]. Cross-agent editable copy: `npx skills@latest add mattpocock/skills` (interactive skill picker) [9]. No verified command installs `grilling` alone.

**In official marketplace?** YES. README states it directly: "It's in Claude Code's official marketplace" [9]. Confirmed live in `anthropics/claude-plugins-official`'s `.claude-plugin/marketplace.json`: entry `"name": "mattpocock-skills"`, category `development`, pinned sha `84fdeffd12f2...` [14] — identical to `mattpocock/skills`' current HEAD [11], so the catalog is current. (The repo also self-declares a `mattpocock` marketplace over `./` in its own `marketplace.json` [3], but no separate self-marketplace install command is documented, unlike some other authors.)

**Actively maintained:** YES. 212,551 stars, 18,363 forks, pushed 2026-08-07 [10]. HEAD commit `84fdeffd`, dated 2026-08-06T19:49:51Z [11] — 4 days before this check. Grilling-specific history: confirmation gate added 2026-07-03, self-grilling bugfix 2026-07-06, full round-based rework 2026-07-16, question-format polish through 2026-07-31 [12].

**Composition:** Each skill = one `SKILL.md` + one `agents/openai.yaml` (Codex-CLI display metadata only, not a Claude Code mechanism) [4][5][6][16]. No scripts, no bundled sub-agent files, no hooks anywhere in the repo's full 240-entry file tree [13]. `grill-with-docs` additionally invokes the separate `domain-modeling` skill at runtime [6][9].

**M1 — hook / always-on injection? NO.** The 240-entry recursive repo tree has zero paths containing "hook" [13]; raw `plugin.json` has only a flat `skills` array, no `hooks` key [2]; none of the three SKILL.md files mention SessionStart or hooks [4][5][6]. Only the ordinary skill name+description preload applies — `grilling` has no `disable-model-invocation` flag, so Claude can auto-select it [4].

**M2 — own artifact? NO for grilling/grill-me; YES for grill-with-docs.** Primary source, verbatim: "It is stateless. It writes no files and leaves no workspace behind. The only thing it leaves is a sharper version of the idea, in your own head." [8]. Sibling `grill-with-docs` writes `CONTEXT.md` and ADRs (Architecture Decision Records) "as it goes," via the `domain-modeling` skill [6][7][9].

**M3 — "you MUST" framing? NONE FOUND.** No "you MUST use this," "not negotiable," or equivalent appears in either SKILL.md, either docs page, or the README [4][5][6][7][8][9]. Closest imperative line is process-internal, not adoption-forcing: "Decisions are yours, and it must wait for them. An agent running `grilling` that answers its own decisions has broken the skill, not interpreted it liberally." [7]. README's strongest push: "Use them _every_ time you want to make a change" (italics, not caps) [9].

**Auto-trigger (verbatim frontmatter, `grilling`):**
> Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. [4]

(`grill-me` / `grill-with-docs` both set `disable-model-invocation: true` — they never auto-fire, only typed [5][6].)

## Technique summary
- Models the subject as a **design tree**: every decision branches into the decisions hanging off it [4][7].
- Works in **rounds**, not strictly one-at-a-time by default (changed from one-at-a-time on 2026-07-16 [12]): each round asks the whole **frontier** — "every decision whose prerequisites are already settled... and nothing else" [4][7].
- Fixed question format, a recommendation embedded every time: numbered/titled behind ❓, body, then "➡️ <recommended answer>" alone on its own line [4]. Docs flag a rough edge: the recommendation sometimes argues *against* the question as worded, so agreeing means answering "no" [7].
- Facts vs. decisions split: "Finding facts is your job, never the user's" — dispatches a background sub-agent to look things up rather than ask; a running lookup doesn't block the round, only questions depending on it wait [4]. The agent answering its own decision questions is explicitly named a broken run, "not interpreted it liberally" [7].
- Ordering rule: two questions never share a round if one depends on the other's answer [7].
- Stop condition 1: done when "the frontier is empty" — every branch visited, nothing silently assumed [4].
- Stop condition 2, a separate gate: "it will not act on what you agreed until you confirm you have reached a shared understanding" [4][7].
- No hard question cap by design; steer it in plain language to wrap up, or split the task if a session runs very long [7].
- `grill-me`'s wrapper doc adds user-side rules not in `grilling` itself: push back on shallow questions, say "I don't know" when true, avoid the "agreed, agreed, agreed" passivity failure mode; stop on "ungrillable" look/feel questions and prototype instead [8].
- After questioning: no autonomous build. Base skills write nothing and hand back a sharpened idea in-conversation only; the user may carry it into `/to-spec` (spec/ticket, no re-interview) or into `grill-with-docs`, which writes `CONTEXT.md`/ADRs as the same interview runs [6][8][9].
- Current scope is contested internally: an open issue argues grilling/grill-me should extend beyond plans/designs to arbitrary opinions and claims — not implemented as of this check [15].

## NOT VERIFIED
- The 212,551-star count is reported as-is from the live GitHub API [10], not cross-checked elsewhere; secondary aggregator sites (skillselion.com, claudeskills.info, claudepluginhub.com, vibehackers.io) quote unverifiable figures ("787k installs," "53k stars in 90 days") excluded from this report.
- A non-interactive flag to install only `grilling` via `npx skills` — README documents only an interactive picker [9]; no such command is reported.
- Whether an already-installed user's local copy matches the exact HEAD state described here, vs. an older pinned version.

## Sources
[1] github.com/mattpocock/skills — accessed 2026-08-10
[2] raw.githubusercontent.com/mattpocock/skills/main/.claude-plugin/plugin.json — accessed 2026-08-10
[3] raw.githubusercontent.com/mattpocock/skills/main/.claude-plugin/marketplace.json — accessed 2026-08-10
[4] raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grilling/SKILL.md — accessed 2026-08-10
[5] raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grill-me/SKILL.md — accessed 2026-08-10
[6] raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/grill-with-docs/SKILL.md — accessed 2026-08-10
[7] raw.githubusercontent.com/mattpocock/skills/main/docs/productivity/grilling.md — accessed 2026-08-10
[8] raw.githubusercontent.com/mattpocock/skills/main/docs/productivity/grill-me.md — accessed 2026-08-10
[9] raw.githubusercontent.com/mattpocock/skills/main/README.md — accessed 2026-08-10
[10] api.github.com/repos/mattpocock/skills — accessed 2026-08-10
[11] api.github.com/repos/mattpocock/skills/commits — accessed 2026-08-10
[12] api.github.com/repos/mattpocock/skills/commits?path=skills/productivity/grilling — accessed 2026-08-10
[13] api.github.com/repos/mattpocock/skills/git/trees/main?recursive=1 — accessed 2026-08-10
[14] raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json — accessed 2026-08-10
[15] github.com/mattpocock/skills/issues/527 — accessed 2026-08-10
[16] raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grilling/agents/openai.yaml — accessed 2026-08-10

## Addendum (live, 2026-08-13) — manual-copy question

**Q1 reconfirmed + a non-interactive path found:** repo still has 25 skills total, `grilling` one of them; the official marketplace still only offers the whole 25-skill bundle (`mattpocock-skills`) via `/plugin`. New finding: the `npx skills` CLI (the same tool behind `find-skills`, maintained at `vercel-labs/skills`) documents a **non-interactive `--skill` flag**, e.g. `npx skills add vercel-labs/agent-skills --skill frontend-design --skill skill-creator`, with wildcard `*` and a `-y` flag for CI use [https://raw.githubusercontent.com/vercel-labs/skills/main/README.md — accessed 2026-08-13]. By the same documented, repo-agnostic syntax, `npx skills add mattpocock/skills --skill grilling` should select only that skill — not run live this session, but the flag is real and not specific to any one source repo. Default install mode creates symlinks to a canonical copy; a `--copy` flag makes an independent copy — either way the result is an editable local `SKILL.md`, not a closed/managed install.

**Q2 — manual copy:** MIT license reconfirmed via the repo's root `LICENSE` file, "Copyright (c) 2026 Matt Pocock" [https://raw.githubusercontent.com/mattpocock/skills/main/LICENSE — accessed 2026-08-13]. Folder contents reconfirmed via the GitHub API: only `SKILL.md` + `agents/openai.yaml` (Codex-CLI metadata, irrelevant to Claude Code) [https://api.github.com/repos/mattpocock/skills/contents/skills/productivity/grilling — accessed 2026-08-13]. Zero technical dependency on other files or skills — cross-references to other skills in the repo are textual handoffs only. Manual copy of just `SKILL.md` preserves 100% of the function.

**Q3 — trade-off:** No functional loss. Manual copy (by hand, or via the `--skill` flag) avoids installing the other 24 unrelated skills that the official marketplace route would bring along; loses only the marketplace's auto-update.

**Status 2026-08-13:** already resolved in an earlier session — nothing to do.
