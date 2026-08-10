# FRICTION

## YOURS

### 2026-08-10 — instalação do esqueleto do plugin (kit/my-method)

Contexto: task em andamento era instalar localmente o esqueleto do plugin
`my-method` (ainda fora do fluxo formal do método — não chegamos à Etapa 3
nem à Etapa 4). O que foi feito imediatamente antes: confirmar a instalação
via `claude plugin list` e responder a uma pergunta do usuário sobre como
comandos futuros (`/next-task`, `/start-project`) vão disparar.

Descoberta: `commands/` e `skills/` são hoje o mesmo mecanismo dentro do
Claude Code — não existe mais um "comando clássico determinístico" separado
de skill. A garantia de "eu digito, ele executa sem o modelo decidir
sozinho" não vem de onde o plugin está instalado (skills-directory vs.
marketplace não muda nada nisso), e sim do campo de frontmatter
`disable-model-invocation: true` em cada comando individual. Mesmo assim,
esse campo garante só o disparo, não que os passos do comando sejam
seguidos ao pé da letra — o conteúdo carregado ainda é interpretado pelo
modelo. A única garantia dura de comportamento é hook.

Por que importa: lembrar disso ao construir `/next-task` e `/start-project`
(Etapa 3 do método, e a execução deles na Etapa 5) — ambos devem levar
`disable-model-invocation: true` no frontmatter.

### 2026-08-10 — construção do /start-project

Contexto: `/start-project` precisa gravar, num projeto novo, o texto de
`method.md` e os templates de `CLAUDE.md`/`STATE.md` que já existiam em
`kit/my-method/method.md` (a ser criado) e `kit/my-method/templates/`. O
que foi feito imediatamente antes: pesquisar se `${CLAUDE_PLUGIN_ROOT}`
permite que um arquivo de comando (`commands/*.md`) leia outro arquivo
empacotado no mesmo plugin.

Descoberta: `${CLAUDE_PLUGIN_ROOT}` é confiável em hooks e configuração
de servidor MCP, mas não expande de forma confiável dentro do conteúdo
de um comando (`commands/*.md`) — é um bug conhecido e aberto do Claude
Code. Além disso, mesmo se funcionasse, ler esse caminho significaria
ler um arquivo fora da pasta do projeto atual — o que a regra global
"Boundaries" do usuário proíbe explicitamente. Por isso `/start-project`
não lê `kit/my-method/method.md` nem `kit/my-method/templates/*.md` em
tempo de execução: o texto de `method.md` e a estrutura de
`CLAUDE.md`/`STATE.md` foram colados por inteiro dentro do próprio
`commands/start-project.md`.

Por que importa: isso cria duplicação de verdade — se o texto de
`method.md` (na raiz do repo) ou os templates em `kit/my-method/templates/`
mudarem no futuro, a cópia embutida em `commands/start-project.md`
precisa ser atualizada manualmente à parte, e nada garante hoje que as
duas fiquem sincronizadas. Se o método for revisado de novo (v4), checar
esse arquivo primeiro.

## MINE
