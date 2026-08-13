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

### 2026-08-11 — piloto contador: entrevista começou sem pedir a ideia

Contexto: piloto de ponta a ponta v5+v6 (contador de cliques, projeto
descartável no scratchpad), sessões headless conduzidas durante a sessão 3
da auditoria. O que foi feito imediatamente antes: `/my-method:start-project`
disparado numa pasta vazia, sem a ideia junto do comando.

Descoberta: o Step 1 abriu a primeira pergunta crítica ANTES de saber qual
era a ideia — e recomendou "local" deduzindo do NOME DA PASTA
("pilot-v6-contador"). A ideia só entrou porque a persona a ofereceu junto
com a primeira resposta. É exatamente a lacuna do passo 3 do alvo que a
audit-01 marcou PARTIAL ("interrogation starts blind") — agora com
ocorrência observada em piloto, não só em análise.

Por que importa: a correção barata já está especificada na audit-01 (rec 4):
`argument-hint` no frontmatter de `start-project.md` + uma linha no início
do Step 1 do comando ("se a ideia não veio com o comando, pergunte em uma
linha antes do bloco crítico"). É mudança de comando, não de `method.md` —
o método já diz o que perguntar; é o comando que começa cego. Aplicar só
com aprovação explícita, como sempre.

### 2026-08-11 — proposta da rec 4 (quatro remendos pequenos) — registro de proveniência

Contexto: continuação da sessão 3 da auditoria, depois do piloto v5+v6 de
ponta a ponta. O que foi feito imediatamente antes: o usuário pediu a
proposta da rec 4 da audit-01 por escrito antes de aplicar.

Descoberta: a rec 4 é o pacote de quatro remendos L3/L4 da audit-01 —
captura da ideia (`argument-hint` + perguntar antes do bloco crítico),
marcador `Approved:` no SPEC.md no Gate 1, fechamento de `start-project` e
`next-task` mostrando `git show --stat` cru, e critérios de tamanho na
ficha. Proveniência mista, declarada item a item: a captura da ideia é
LASTREADA EM FRICTION observada (entrada do piloto, 2026-08-11, logo
acima); os outros três vêm da análise da audit-01 (passos 5, 8/13, 7),
aprovados em trabalho por este pedido. `method.md` NÃO é tocado por nenhum
item — é tudo mecânica de comando/template, sem bump de versão e sem tocar
as cópias embutidas (método, matriz, esqueleto).

Por que importa: a proposta completa está em
`notes/rec4-small-patches-proposal.md` e só é aplicada depois da aprovação
explícita do usuário sobre o texto. Fora do escopo, nomeados lá: a extensão
L1 do hook para travar escrita de plano antes do SPEC aprovado (ficou
barata agora que o verify-gate existe, mas é mudança de comportamento do
hook — proposta própria), e a rec 3 (recomendação de modelo/esforço no
início da tarefa, passo 10, ainda ABSENT).

### 2026-08-11 — proposta da rec 3 (modelo/esforço no início da tarefa) — registro de proveniência

Contexto: continuação da sessão 3 da auditoria, depois da rec 4 aplicada.
O que foi feito imediatamente antes: o usuário pediu a proposta da rec 3
da audit-01 (passo 10 do fluxo-alvo, o único ainda ABSENT) por escrito,
sem aplicar.

Descoberta: TERCEIRA exceção consciente à regra "mudar só com friction de
piloto" (depois da v4/grilling e da v5/segurança) — não nasceu de entrada
de friction, e sim da rec 3 da audit-01 a pedido explícito do usuário;
honestidade mantida: a própria audit-01 registrou a ocorrência ao vivo
("a sessão de auditoria começou em configurações herdadas até o usuário
trocar à mão"), mas sem entrada de piloto. Mecanismo re-verificado ao
vivo em 2026-08-11 por subagente: /model segue só-usuário
(code.claude.com/docs/en/commands.md), frontmatter model:/effort: segue
de escopo de turno, nada mudou desde 2026-08-10 — e existe a substituição
`${CLAUDE_EFFORT}` (skills.md), que o desenho aproveita para calar a
recomendação quando o esforço atual já é o recomendado.

Por que importa: proposta completa em
`notes/proposals/method-v7-model-effort-proposal.md` (novo diretório
notes/proposals/, escolhido pelo usuário); só vira method.md v7 (e
espelhos — a cópia embutida do método em start-project.md é a única das
quatro que muda) depois da aprovação explícita do usuário sobre o texto.
Regra central do desenho, vinda do documento original do método: o
SILÊNCIO é o padrão — linha `Model/effort:` na ficha só quando um gatilho
se aplica; ficha sem linha significa que as configurações atuais servem.

### 2026-08-11 — proposta da manutenção do kit (health-check + update-method) — registro de proveniência

Contexto: sessão seguinte à aplicação da v7. O que foi feito imediatamente
antes: o usuário pediu, por escrito e sem aplicar, a proposta de um comando de
manutenção do plugin — reverificação de práticas da Anthropic, vulnerabilidades,
skills/agentes, modelos, mais uma varredura aberta — com uma health check
separada e instantânea.

Descoberta: o pedido manda ler `notes/audit-04-maintainability.md` e
`notes/audit-plan.md` PRIMEIRO, e nenhum dos dois existe neste repositório
(28 commits, um branch, nenhuma deleção no histórico; a sessão 4 da série de
auditorias nunca rodou). A proposta foi escrita sobre o próprio pedido do
usuário como diagnóstico, e isso está declarado na proveniência dela — não se
cita uma auditoria que não existe. A frase que virou o centro do desenho da
varredura aberta é do usuário, não do repo: "reverificação só reconfere o que eu
já sabia perguntar".

Quatro achados ao vivo desta sessão, todos reproduzíveis por comando:
(F1) `semgrep`, `gitleaks` e `pip-audit` NÃO estão instalados nesta máquina —
cinco linhas AUTOMATED da matriz dependem deles; (F2) `claude plugin details
my-method` imprime o inventário do kit pela boca do próprio arnês (4 skills, 1
agente, 1 hook, ~271 tokens sempre-ligados) — a sonda de saúde mais útil
disponível, que nenhum desenho anterior tinha; (F3) a documentação diz que
instalação por marketplace é CÓPIA CONGELADA em cache, e o carimbo de instalação
é 2026-08-10T05:17Z, mas o agente (23:46) e o hook (00:18 do dia 11) — ambos
posteriores — aparecem carregados; ou seja, o kit vem dependendo de um
comportamento não documentado a cada aplicação, sem aviso no dia em que parar;
(F4) sobrou uma junção `.claude/skills/my-method` da era pré-marketplace,
sombreada pela instalação e não carregada.

A pesquisa dos eixos B e D (delegada a subagentes, arquivos em
`notes/research-maintenance/`) já funcionou como meia primeira rodada e achou
quatro coisas: gitleaks está CONGELADO por decisão do mantenedor ("security
patches only", sucessor Betterleaks) e a matriz depende dele em duas linhas; a
lista OWASP 2025 tem duas categorias que este repo não cobre em lugar nenhum
(A03 cadeia de suprimentos ampliada, A10 tratamento de exceções); o Fable 5 cai
automaticamente para outro modelo em prompts que os classificadores dele marcam
como de cibersegurança — bem onde o gatilho UP da v7 manda escalar; e três das
próprias fontes do repo devolvem HTTP 200 sem conteúdo útil, o que fez a
watchlist ganhar uma coluna de RECEITA de reverificação em vez de só a URL.

Por que importa: F3 é a origem da decisão D-VER da proposta (bumpar `version` no
`plugin.json` a cada aplicação, e comparar o inventário do arnês contra o kit em
disco). A proposta completa está em
`notes/proposals/maintenance-command-proposal.md` e só vira comando depois da
aprovação explícita do usuário sobre o texto. Ela também introduz uma QUARTA
classe de proveniência — **mudança externa** — ao lado do atrito de piloto e das
três exceções conscientes (v4/grilling, v5/segurança, v7/modelo-esforço), com a
regra que a limita: mudança externa que QUEBRA algo é defeito e vira correção;
mudança externa que só HABILITA algo novo é candidata, e a resposta padrão é não.

### 2026-08-12 — primeira rodada real de manutenção — registro de proveniência

Contexto: a pesquisa dos cinco eixos rodou em 2026-08-11 (arquivos
`notes/research-maintenance/2026-08-11-axis-{A..E}.md`), mas a sessão terminou
antes do passo 3 do `update-method` — a proposta nunca foi escrita. Esta sessão
retomou do ponto exato e escreveu
`notes/proposals/maintenance-2026-08-11.md`. Nada foi aplicado.

Atrito real do próprio comando, e a primeira coisa que ele aprendeu sobre si:
o passo 3 manda ler **apenas** os resumos de cinco linhas dos subagentes. Esses
resumos vivem no contexto da sessão que delegou e **não sobrevivem** a um
`/clear` nem a uma sessão interrompida. Os cinco arquivos de pesquisa
sobrevivem — são o registro durável — mas o comando não diz para cair neles.
Virou a candidata C-8 da proposta, com o texto exato.

Achados que valem a rodada (a lista completa está na proposta):
(D-1) **`gitleaks git -s .` não é invocação válida** — `-s`/`--source` só existe
nos subcomandos `detect` e `protect`, ambos depreciados desde a v8.19.0; o
`git` recebe o caminho como argumento posicional. A linha 8.1 da matriz — a que
faz valer a regra "nenhuma chave em arquivo versionado" — manda digitar um
comando que sai com erro e não varre nada. Estava errada desde que foi escrita,
e passou incólume pela linha de base inteira porque **toda receita do eixo B
perguntava "a ferramenta está viva?" e nenhuma perguntava "ela ainda aceita a
string que a gente digita?"**. Daí a candidata C-3, que vira regra da watchlist.
(D-2) Uma **citação fabricada**: `/model` "can only be invoked by the user, not
by the model itself", atribuída ao commands.md e "verificada ao vivo" —
**0 ocorrências** no corpo inteiro da documentação (7,1 MB de `llms-full.txt`).
A conclusão da v7 continua de pé, e por evidência mais forte (a tabela marca com
`[Skill]` exatamente as entradas que o Claude pode invocar sozinho, e `/model`
não a carrega); só a citação precisa ser corrigida, em `CHANGELOG.md:129-132` e
na proposta da v7. Duas receitas da watchlist mandavam confirmar essa frase
inexistente — uma rodada futura ou reportaria regressão falsa ou inventaria a
confirmação.

Duas coisas que a rodada **derrubou**, e que estavam registradas como verdade:
o ruleset `p/owasp-top-ten` do Semgrep **não** é 2021 (517 das 559 regras
carregam código 2025 — a "suspeita forte" do livro-caixa estava errada), e o
Betterleaks **existe mesmo**, MIT, v1.7.4, 17 releases em 6 meses, mesmos
mantenedores do gitleaks — mas a recomendação segue **não**, porque paridade de
detecção não foi medida e o gitleaks ainda funciona.

Dois subagentes **discordaram** entre si, e isso ficou registrado em vez de
resolvido no silêncio: se a sonda 1 do health-check deve comparar números de
versão (o eixo C está certo — o livro-caixa já diz que a divergência é esperada,
comparar daria alarme falso permanente), e qual marcação o changelog da doc usa.

Por que importa: esta é a primeira vez que o kit encontra um defeito **em si
mesmo** por manutenção agendada em vez de por atrito de piloto — exatamente o
que a classe **mudança externa** foi criada para carregar. E o defeito mais caro
não veio de nada ter mudado lá fora: veio de uma receita que perguntava a
pergunta errada desde o começo.

### 2026-08-12 — método v8 por mudança externa — registro de proveniência

Primeira revisão do método que **não** veio de atrito de piloto nem de exceção
consciente: veio da manutenção agendada. Classe **mudança externa**, a quarta
origem possível, criada em 2026-08-11 e usada pela primeira vez aqui.

O que mudou: uma palavra no STEP 5a. Dizia "Only the user can switch model or
effort"; agora diz "switch **the session's** model or effort". A frase antiga
era mais larga do que a evidência sustenta —
`code.claude.com/docs/en/model-config` (acessado em 2026-08-11) lista seis
formas de definir esforço, e a sexta é frontmatter de skill ou de subagente,
que o próprio método v7 rejeitou de propósito por ser válida só por um turno.
Ou seja: o modelo não troca o esforço **da sessão**, que é do que o passo
fala — mas "só o usuário troca esforço, ponto" é falso, e um leitor futuro ia
achar a documentação contradizendo o método.

Por que valeu um bump de versão por uma palavra: o custo é o procedimento
inteiro (v7 → v8, nota de origem, esta entrada, cópia embutida). O que se
compra é uma frase que carrega peso — ela é a justificativa de por que o
método interrompe o usuário no início da tarefa em vez de trocar sozinho. Uma
frase load-bearing imprecisa no método canônico custa mais caro do que um
número de versão feio.

Regra que a classe carrega, e que esta rodada exercitou dos dois lados:
mudança externa que QUEBRA algo é defeito e vira correção (foram seis: D-1 a
D-6); mudança externa que só HABILITA algo novo é candidata e a resposta
padrão é não (foram oito candidatas, quatro aceitas — e as quatro aceitas
passaram pelo teste de adoção porque removem algo ou fecham lacuna já nomeada,
não porque pareciam boas).

Um detalhe que merece registro próprio: o defeito mais caro da rodada (D-1, o
`gitleaks git -s .`) **não veio de nada ter mudado lá fora**. A string estava
errada desde o dia em que foi escrita e sobreviveu a uma linha de base inteira
porque toda receita perguntava "a ferramenta está viva?" e nenhuma perguntava
"ela ainda aceita o que a gente digita?". Manutenção agendada encontrou um
defeito de origem, não uma regressão. Vale saber que ela serve para isso
também.

### 2026-08-13 — método v9 aplicado: atrito de logtech + atrito deste repositório — registro de proveniência

Contexto: leitura de `friction-logtech.md` (atrito de um projeto real,
logtech, copiado para este repositório) e escrita de
`notes/proposals/logtech-friction-proposal-2026-08-13.md`. O que foi
feito imediatamente antes: os cinco itens da proposta foram aprovados
pelo usuário, um a um, item 3 com modificação (`find-skills` + skills
de comunidade além das oficiais).

Descoberta: primeira vez que uma proposta deste repositório nasce do
`friction.md` de um projeto real em vez de comparação ou manutenção
agendada — e primeira vez que a mesma rodada mistura essa origem com
atrito real deste próprio repositório. Dois dos cinco itens (STEP 1 e
STEP 5c) não tinham lastro em `friction-logtech.md`; viraram atrito
real só depois que o usuário pediu explicação do que cada gap
significava e confirmou ao vivo ("sim, trate as duas como friction
real.", 2026-08-13) — registrado abaixo, em MINE, antes desta entrada.
Proveniência mantida separada por item, tanto na proposta quanto no
CHANGELOG: STEP 3, STEP 3b e STEP 5d citam `friction-logtech.md`; STEP
1 e STEP 5c citam este `friction.md`.

Por que importa: detalhe completo, item a item (texto exato, antes/
depois, custo/perda/rollback) está em
`notes/proposals/logtech-friction-proposal-2026-08-13.md` e no
CHANGELOG (`2026-08-13 — método v9 aplicado`). Checagem mecânica
pós-edição: método 290 linhas — 0 divergências contra a cópia embutida
em `start-project.md`; `claude plugin validate` com `✔ Validation
passed`; plugin 0.3.1 → 0.4.0.

## MINE

### 2026-08-13 — sem tarefa corrente (revisão da proposta de atrito do logtech)

Contexto: sessão lendo `friction-logtech.md` (atrito de um projeto real,
logtech, copiado para este repositório) e escrevendo
`notes/proposals/logtech-friction-proposal-2026-08-13.md`. O que foi
feito imediatamente antes: a proposta apontou que dois itens pedidos
pelo usuário — pergunta sobre restrições legais no Passo 1, e um passo
para quando o SPEC precisa reabrir no meio do projeto — não tinham
nenhuma entrada correspondente em `friction-logtech.md`, e por isso não
foram propostos; o assistente explicou o que cada um significaria, a
pedido do usuário.

Palavras do usuário (verbatim):

> sim, trate as duas como friction real.

### 2026-08-13 — sem tarefa corrente

Feito imediatamente antes: commit e push do lote de mudanças da sessão (método v9 e pesquisa de skills) foram feitos, e o assistente reportou de volta ao usuário que a decisão sobre a skill `brainstorming`/`superpowers` continuava em aberto.

Palavras do usuário (verbatim):

> ideia: quando uma skill relevante para uma tarefa está disponível (instalada ou guardada  (exemplo: frontend-design)), a ficha da tarefa deveria citar explicitamente que ela deve ser usada — em vez de confiar só no disparo automático por descrição, que é mecanismo frágil (imposição instrucional, não estrutural, como o próprio kit já reconhece para next-task/start-project). Sem isso, corro o risco de instalar/guardar uma skill e "esquecer" que ela existe na hora de construir. Ainda não aconteceu de fato — é hipótese antecipada, não atrito observado.
