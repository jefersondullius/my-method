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

### 2026-08-10 — origem da revisão v4 do Step 1 (registro de proveniência)

Contexto: auditoria 02 (avaliação de skills, sessão 2 de 4). Tarefa em
andamento: avaliar a skill `grilling` (Matt Pocock) sem instalá-la — teste
de mecanismo aprovado (sem hook, sem artefato próprio, sem "you MUST") e
técnica extraída em `notes/research-skills/grilling.md` e no adendo de
`notes/audit-02-skills.md`. O que foi feito imediatamente antes: avaliação
de riscos da mudança de cadência, respondida ao usuário antes de qualquer
edição (pergunta engolida em grupo; concordância em bloco; atribuição de
respostas; e como o Gate 1 mitiga cada um).

Descoberta: o usuário decidiu incorporar ao Step 1 três aditivos (ordem
por dependência; fato≠decisão; suposições silenciosas) e uma mudança de
cadência (bloco crítico um-por-vez — offline/online, login, pagamento,
dado de terceiros — e depois agrupamento autorizado), escolhendo a
variante com salvaguarda: classes críticas (dinheiro, dado de terceiros,
acesso/login, hospedagem, exposição legal) nunca entram em grupo, em
nenhum ponto da entrevista. Esta mudança NÃO nasceu de atrito observado
em piloto: nasceu de uma comparação deliberada com a skill `grilling`,
por decisão explícita do usuário.

Por que importa: a regra do método é mudar só com friction concreta; esta
é a primeira exceção consciente, e este registro existe para manter
honesta a origem da mudança. A proposta completa está em
`notes/method-v4-step1-proposal.md` e só vira `method.md` (e espelhos —
ver a entrada anterior sobre a cópia embutida no `start-project.md`)
depois da aprovação explícita do usuário sobre o texto.

## MINE
