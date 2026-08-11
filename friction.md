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

### 2026-08-10 — origem da revisão v5 (wiring de segurança) — registro de proveniência

Contexto: auditoria 03 (sessão 3 de 4) — avaliação da arquitetura de agentes
para a parte de segurança do passo 12 do alvo. O que foi feito imediatamente
antes: `notes/audit-03-agents.md` commitada, com veredito por um "terceiro
desenho" (D1–D5) — a proposta de 4 agentes do usuário dobrada no esqueleto
existente do método.

Descoberta: o usuário aprovou o terceiro desenho e pediu a proposta escrita
antes de aplicar. A revisão NÃO nasce de atrito de piloto: nasce da lacuna
da auditoria 01 (matriz ligada a nada, rec 1) mais o desenho aprovado na
auditoria 03 — segunda exceção consciente à regra "mudar só com friction
concreta" (a primeira foi a v4/Step 1). Escopo da proposta: D1–D4 (coluna
"Fix direction" na matriz; triagem de tier no planejamento; execução por
tipo com revisor só-leitura `security-reviewer`; laço construtor-corrige /
revisor-fresco-rejulga). D5 (hook de commit, rec 2 da audit-01) fica FORA —
aprovação à parte, para não esconder o custo dele dentro desta.

Por que importa: a proposta completa está em
`notes/method-v5-security-proposal.md` e só vira `method.md` v5 (e espelhos)
depois da aprovação explícita do usuário sobre o texto. Atenção à armadilha
de duplicação já registrada: com a v5, `commands/start-project.md` passa a
carregar TRÊS cópias embutidas (método, matriz, templates) — qualquer
revisão futura da matriz ou do método precisa tocar o arquivo canônico E as
cópias embutidas no mesmo commit.

### 2026-08-11 — origem da revisão v6 (trava de commit por evidência) — registro de proveniência

Contexto: continuação da sessão 3 da auditoria, depois da v5 aplicada e do
teste do allowlist do security-reviewer aprovado. O que foi feito
imediatamente antes: o usuário pediu a proposta do D5 por escrito antes de
aplicar ("Escreva a proposta do D5 antes de aplicar", 2026-08-11).

Descoberta: diferente da v4 e da v5, esta mudança é LASTREADA EM FRICTION
observada — as notas 5c/5d do próprio method.md registram, nos pilotos,
verificação pulada/rotulada "humana" sem tentativa e arquivos de status
dessincronizados. Não é exceção à regra "mudar só com friction concreta";
é a regra funcionando. Desenho: rec 2 da auditoria 01 (único investimento
L1 recomendado) + D5 da auditoria 03 (deixado fora da v5 de propósito para
aprovação separada de custo). Mecânica de hooks re-verificada ao vivo em
2026-08-11 por subagente (URLs na proposta).

Por que importa: a proposta completa está em
`notes/method-v6-commit-gate-proposal.md` e só vira method.md v6 (e
espelhos) depois da aprovação explícita do usuário sobre o texto. Aviso de
duplicação atualizado: com a v6, `commands/start-project.md` passa a
embutir QUATRO textos (método, matriz, templates, esqueleto do
verify.ps1) — qualquer revisão futura toca o canônico E as cópias no mesmo
commit. Ressalva honesta que a proposta carrega: a trava prova que a
verificação RODOU e PASSOU há pouco; se as checagens são as CERTAS continua
sendo julgamento (L3), e evidência forjada de propósito é mentira visível
no git (L4), não impossível.

## MINE
