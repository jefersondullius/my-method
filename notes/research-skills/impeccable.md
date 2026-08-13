# impeccable — verification (live, 2026-08-13)

**Queried name:** impeccable

**EXISTS?** YES — one plausible candidate, well corroborated: `pbakaus/impeccable` (Paul Bakaus), a design plugin for Claude Code/Cursor/Codex. There is no official Anthropic skill called "impeccable" — the marketing line "the missing upgrade to Anthropic's impeccable skill" on the project's own site (https://impeccable.style/, accessed 2026-08-13) is wordplay on the adjective, not a reference to a real Anthropic product (confirmed by reading the page directly).

**Purpose (pt-BR):** Um plugin de design de terceiros que dá ao Claude "fluência de design" para frontend — 23 subcomandos (`/impeccable polish`, `/impeccable audit`, `/impeccable critique`, `/impeccable live`, etc.), incluindo um modo de iteração ao vivo no navegador e um detector automatizado de anti-padrões visuais.

## Q1 — o plugin empacota uma skill só ou várias?

Uma skill só, com 23 subcomandos internos — não é um bundle de skills separadas. Confirmado no `.claude-plugin/plugin.json` do próprio repositório: `"description": "Design fluency for frontend development. 1 skill with 23 commands..."` [https://github.com/pbakaus/impeccable/blob/main/.claude-plugin/plugin.json — acesso 2026-08-13]. Instalação: `/plugin marketplace add pbakaus/impeccable` (marketplace único; não há "escolher só uma parte" porque já é uma skill só) ou `npx impeccable install`.

## Q2 — dá para copiar manualmente o SKILL.md, fora do /plugin?

**Licença:** Apache License 2.0, confirmada no `LICENSE` da raiz do repositório, copyright "2026 Paul Bakaus" [https://github.com/pbakaus/impeccable — acesso 2026-08-13]. Permite cópia/redistribuição.

**Mas a função real não mora no SKILL.md.** O `SKILL.md` publicado (`.claude/skills/impeccable/SKILL.md`, 11.005 bytes) referencia diretamente:
- pasta `scripts/` com **36 arquivos** .mjs/.js, várias centenas de KB no total — inclui `live-browser.js` (500KB, motor do "Live Mode"), `hook-lib.mjs` (95KB), `serve-question.mjs` (99KB), e o subsistema `detector/` (8 subpastas + 4 arquivos, incluindo `detect-antipatterns-browser.js` de 390KB);
- pasta `reference/` com **36 arquivos markdown**, um por subcomando (`audit.md`, `critique.md`, `live.md`, `hooks.md`, etc.), alguns com dezenas de KB.
[https://api.github.com/repos/pbakaus/impeccable/contents/.claude/skills/impeccable/scripts, .../reference, .../scripts/detector — acesso 2026-08-13]

Copiar só o `SKILL.md` perde quase toda a função prática: Live Mode, o detector de anti-padrões automatizado, hooks de pré-edição, e o conteúdo detalhado de cada subcomando (que vive em `reference/`, não no SKILL.md).

## Q3 — trade-off

Via `/plugin`: pacote completo (scripts + reference + hooks) + atualizações automáticas do marketplace do autor. Cópia manual do só-SKILL.md: reduz a skill a um resumo de alto nível dos comandos, sem o motor funcional por trás — na prática vira texto de orientação, não a ferramenta real. Para preservar a função seria preciso copiar `scripts/` + `reference/` inteiros, o que anula a vantagem de "só o corpo" e ainda deixaria hooks de fora (hooks não se copiam junto de uma pasta de skill isolada — só entram com o plugin inteiro instalado via `/plugin`).

## NOT VERIFIED

- Contagem exata de regras do detector de anti-padrões: o README do próprio projeto cita "59 regras determinísticas", um resumo de terceiros (chaseai.io) cita "44 regras anti-slop" — número atual exato não confirmado.

## Sources
- https://impeccable.style/ — acesso 2026-08-13
- https://github.com/pbakaus/impeccable (+ `.claude-plugin/plugin.json`, `LICENSE`) — acesso 2026-08-13
- https://api.github.com/repos/pbakaus/impeccable/contents/.claude/skills/impeccable/scripts — acesso 2026-08-13
- https://api.github.com/repos/pbakaus/impeccable/contents/.claude/skills/impeccable/reference — acesso 2026-08-13
- https://api.github.com/repos/pbakaus/impeccable/contents/.claude/skills/impeccable/scripts/detector — acesso 2026-08-13
