# CHANGELOG

## 2026-08-12 — auditoria de custo (sessão 4/4) aplicada: plugin 0.3.1

Aplicada a proposta `notes/proposals/audit-04-cost-fixes-2026-08-12.md`,
os três itens "FAZER AGORA" da auditoria de custo que ainda faltavam
(o primeiro — o teste `/context` — já tinha sido rodado e registrado
direto no livro-caixa, sem precisar de proposta, porque não mudava
nada no kit).

- **`hooks.json` ganhou o campo `if`, restrito a `git commit`.** O hook
  `verify-gate.ps1` parava um `powershell.exe` novo a cada chamada
  Bash/PowerShell só para responder "pode" na maioria delas — agora só
  dispara quando o comando começa com `git commit`. Economia é de
  latência (~296ms por chamada evitada, medido), não de tokens; a
  lógica do gate não mudou, e nada que hoje chega até ela deixa de
  chegar.
- **A regra de narração parou de se repetir pela terceira vez em
  `next-task.md`.** O `CLAUDE.md` global e o `CLAUDE.md` que todo
  projeto recebe do `start-project` já carregam a mesma regra
  automaticamente, na mesma sessão, sem `/clear` entre as duas cargas
  — a terceira cópia não tinha fronteira de sessão para justificar.
- **Watchlist ganhou o Eixo F**: um gatilho observável ("`PLAN.md`
  chegar a 30 tarefas concluídas") para revisitar o único custo desta
  auditoria sem teto — o `PLAN.md` cresce uma linha por tarefa e,
  diferente do `STATE.md`, não tem limite de linhas. Nada foi mudado no
  comportamento hoje; é só um lembrete que sobrevive ao `/clear`.
- **Não aplicado, por decisão explícita da auditoria:** os ~457 tokens
  "always-on" que `claude plugin details` reportava para os seis
  comandos do plugin **não são reais** — um teste `/context` numa
  sessão nova, antes de invocar qualquer comando, mostrou que nenhum
  dos seis aparece na tabela de Skills (todos usam
  `disable-model-invocation: true`, que os exclui do índice de
  contexto inteiramente). Só o agente `security-reviewer` custa algo
  de fato, ~79 tokens — o mesmo valor que já constava, nunca
  contestado. Registrado em `notes/maintenance/LAST-CHECK.md`, entrada
  T2 (2026-08-12).

## 2026-08-12 — manutenção rodada 2 aplicada: método v8, plugin 0.3.0, e a linha 8.1 volta a rodar

Aplicada a proposta `notes/proposals/maintenance-2026-08-11.md` inteira,
sem vetos, na ordem do `update-method` MODE 2. Seis defeitos e quatro
candidatas; quatro candidatas recusadas com razão registrada.

- **O defeito que importa: `gitleaks git -s .` nunca foi um comando
  válido.** `-s`/`--source` só existe nos subcomandos `detect` e
  `protect`, depreciados desde a v8.19.0; o `git` recebe o caminho como
  argumento posicional. Quem seguisse a linha 8.1 da matriz ao pé da
  letra digitava um comando que sai com erro e **não varre nada** — e a
  8.1 é justamente a linha que faz valer "nenhuma chave em arquivo
  versionado". Corrigido para `gitleaks git .` na matriz e na cópia
  embutida do `start-project.md`. Não é regressão: estava errado desde
  o dia em que foi escrito, e passou incólume pela linha de base porque
  toda receita perguntava se a ferramenta estava viva e nenhuma
  perguntava se ela ainda aceitava a string digitada.
- **`method.md` → v8** (mudança externa, a primeira dessa classe): STEP
  5a agora diz que só o usuário troca o modelo/esforço **da sessão**. A
  frase antiga era mais larga que a evidência — a documentação lista
  seis formas de definir esforço, e uma é frontmatter de skill/subagente
  (que a v7 rejeitou de propósito, por valer só um turno). Nenhum
  comportamento mudou. Proveniência em `friction.md`.
- **Uma citação fabricada foi retirada.** O CHANGELOG e a proposta da v7
  atribuíam à documentação a frase `/model` "can only be invoked by the
  user, not by the model itself". Ela **não existe**: 0 ocorrências nas
  três superfícies checadas, incluindo os 7,1 MB do `llms-full.txt`
  inteiro. A conclusão da v7 continua de pé e agora se apoia na
  evidência real — a tabela de comandos marca com `[Skill]` exatamente
  as entradas que o Claude invoca sozinho, e nem `/model` nem `/effort`
  carregam a marca. Duas receitas da watchlist mandavam confirmar a
  frase inexistente; corrigidas, junto com a delegação do eixo D.
- **Fronteira de cobertura do Semgrep, registrada** em
  `research/13-testing-strategy.md` (seção nova) e na seção HONESTY da
  matriz: o ruleset `p/owasp-top-ten` **é** 2025 (517 de 559 regras),
  derrubando a "suspeita forte: 2021" do livro-caixa — mas `A10:2025` e
  "Software Supply Chain Failures" aparecem em **zero** regras. Rodada
  limpa do Semgrep não quer dizer "Top 10 de 2025 coberto".
- **Cartões de segurança devem preferir `opus` a `fable`.** Pedidos
  marcados como de cibersegurança são reexecutados no Opus 4.8, então
  `fable` cai **abaixo** do que `opus` resolve — recomendar o modelo de
  nome mais forte entregava o resultado mais fraco, bem no gatilho UP.
- **Watchlist**: terceira regra do preâmbulo (checar a *invocação*, não
  só o projeto — a regra que teria pego a 8.1), receitas do changelog
  agora cruzam com o GitHub Releases (a doc estava uma versão atrás),
  receita do headless agora lê o `<Note>` que anuncia `--bare` como
  futuro padrão do `-p` (o que quebraria as sondas 1 e 3 do health-check
  em silêncio), e `claude-security` entra na lista DEFERRED.
- **`update-method` aprendeu a sobreviver à própria morte:** o passo 3
  agora manda cair nos cinco arquivos de pesquisa quando os resumos de
  cinco linhas não sobreviveram à sessão. Foi exatamente o que
  aconteceu nesta rodada.
- **Recusadas, com razão no livro-caixa:** Betterleaks (real, MIT, mesmos
  mantenedores — mas paridade de detecção nunca foi medida e o gitleaks
  não está morto), `claude doctor` na sonda 1, a questão STATE.md vs
  memória automática, e comparar números de versão na sonda 1 (daria
  alarme falso permanente, como o livro-caixa já registrava).

Checagem mecânica pós-edição: **método 236 linhas, matriz 213 — 0
divergências** contra as cópias embutidas; `claude plugin validate`
com `✔ Validation passed`; inventário do kit inalterado (6 comandos, 1
agente, 1 hook). **Achado novo, encontrado pela checagem e não pela
pesquisa:** os dois templates embutidos (`CLAUDE.md`, `STATE.md`)
divergem dos arquivos em `kit/my-method/templates/` em 10 e 14 linhas —
contagem **idêntica no HEAD**, ou seja, anterior a esta mudança e não
causada por ela. Nenhum comando do kit lê `templates/`, então antes de
corrigir é preciso decidir qual das duas cópias é a canônica. Registrado
como defeito aberto para a rodada 3.

Rodada 2 também respondeu, com o usuário, os cinco gatilhos que não são
observáveis daqui: quatro NOT MET, e **`security-guidance` com a metade
do tier agora MET** — há um projeto T2 (login + dados pessoais de
terceiros) começando. Nada foi instalado: a ordem registrada manda
tentar Semgrep no verify + `/security-review` embutido primeiro. Fato
que bloqueia esse projeto hoje: **`semgrep` não está instalado nesta
máquina.**

## 2026-08-11 — testes da manutenção: T1–T5 e T8 PASSARAM, T4 fechou uma dúvida antiga

Seis testes da proposta, cada um em sessão nova headless com o plugin
carregado pelo arnês real, em `--permission-mode bypassPermissions` (o
modo mais permissivo que existe — se a trava nega mesmo assim, ela é
de verdade). T6 e T7 (a primeira rodada real de manutenção) ficaram
para uma sessão separada, por decisão do usuário.

- **T1 — health check num projeto my-method de verdade: PASSOU nas
  cinco sondas.** Inventário 6/1/1 conferido; `HEALTH: reviewer alive`;
  e a sonda do hook voltou **a razão do gate**, não a saída do git
  ("no verify evidence at .claude/last-verify.json") — a trava está
  viva e nada foi commitado. Dependências: `git` 2.45.1 e `npm` 10.9.3
  presentes, `semgrep`/`gitleaks`/`pip-audit` ausentes.
- **T2 — pasta vazia: PASSOU.** A sonda 3 reportou **INCONCLUSIVO** e
  se recusou a chamar isso de aprovação. Era o bug mais provável deste
  tipo de comando (sonda que "passa" porque nada a negou) e está
  fechado.
- **T3 — dentro deste repositório: PASSOU.** A sonda 1 comparou contra
  o kit em disco (6 arquivos de comando, 1 agente, 1 entrada de hook),
  achou a junção residual `my-method@skills-dir`, e a sonda 5 rodou
  `claude plugin validate` com `✔ Validation passed`.
- **T4 — sonda de obsolescência forçada: RESOLVEU A DÚVIDA.** Um
  sétimo comando descartável foi criado SEM bump de versão e SEM
  `/plugin update`; a sessão nova reportou **Skills (7)**. Ou seja: o
  arnês lê a fonte do kit AO VIVO — a "cópia congelada" que a
  documentação descreve não governa a descoberta de componentes aqui.
  **Consequência honesta: o bump de versão NÃO é o que entrega a
  mudança**, e a frase que eu tinha escrito no `update-method.md`
  dizendo o contrário foi corrigida no mesmo dia. O bump fica como
  registro de qual kit rodou e como reserva se o comportamento mudar
  para o que está documentado. Arquivo descartável removido.
- **T5 — `/update-method` fora do repo: PASSOU.** Recusou, explicou por
  quê, apontou o `/health-check` como alternativa, e criou **zero**
  arquivos na pasta.
- **T8 — negativo honesto: PASSOU.** Com o `security-reviewer.md`
  renomeado, a sonda 2 falhou com "Agent type 'security-reviewer' not
  found" — e a sonda 1, de forma independente, pegou o desencontro
  (esperava 1 agente, achou 0) e mandou rodar `/plugin update`. Dois
  detectores independentes para a mesma falha. Agente restaurado e
  conferido logo em seguida.

Duas correções de honestidade que os testes forçaram:

1. **O custo em tokens que eu estimei estava baixo.** A proposta dizia
   "~100 tokens a mais por sessão"; o real, medido por
   `claude plugin details`, foi de ~271 para **~457** — **+186**, quase
   o dobro do estimado (`health-check` ~70, `update-method` ~110).
2. **`plugin list` e `plugin details` discordam da versão** — 0.1.0
   contra 0.2.0 — porque o registro de instalação fica preso ao
   original enquanto os detalhes leem a fonte. É esperado, não é falha,
   e por isso a sonda 1 compara **inventário de componentes**, nunca
   número de versão.

Evento observado durante a aplicação, sem relação com o kit: o próprio
Claude Code se auto-atualizou no meio da sessão (2.1.227 → **2.1.228**,
binário substituído às 17:36), o que fez um `claude plugin validate`
falhar uma vez com "não é reconhecido" e passar no retry. É a premissa
do comando de manutenção se demonstrando sozinha: a pesquisa desta
mesma sessão tinha registrado 2.1.227 como a última versão.

## 2026-08-11 — manutenção do kit: `/health-check` e `/update-method` (plugin 0.2.0)

Aplicada a proposta `notes/proposals/maintenance-command-proposal.md`
na ordem dela, com os onze itens aprovados como estavam. `method.md`
NÃO foi tocado e não teve bump de versão — isto é ferramental do kit,
como a rec 4 foi; o método descreve como construir um produto, não
como manter o próprio plugin. As quatro cópias embutidas no
`start-project.md` também não mudaram, então a conferência byte a byte
não se aplica a esta aplicação.

- NOVO `kit/my-method/commands/health-check.md`: cinco sondas em
  segundos, só leitura — (1) inventário e instalação via
  `claude plugin list --json` + `claude plugin details`, comparados
  contra o kit em disco ou contra a linha literal do próprio comando;
  (2) o `security-reviewer` registra; (3) a trava de commit dispara,
  provada por `git commit --dry-run` ser NEGADO; (4) dependências
  presentes/ausentes, sem nunca instalar; (5) `claude plugin validate`
  dentro do repo do método. Regra central: sonda inconclusiva nunca
  vira "passou".
- NOVO `kit/my-method/commands/update-method.md`: dois modos. Sem
  argumento pesquisa cinco eixos por subagentes (práticas da
  Anthropic, vulnerabilidades, skills/agentes, modelos/mecanismos, e a
  varredura aberta), escreve proposta em `notes/proposals/` e PARA com
  instrução de `/clear`. Com `apply`, aplica uma proposta já aprovada.
  Só roda dentro deste repositório — ele edita o kit, e a regra de
  Boundaries proíbe alcançar fora da pasta atual.
- `kit/my-method/.claude-plugin/plugin.json`: **0.1.0 → 0.2.0**. Este
  bump é a decisão D-VER e existe por um achado desta sessão: a
  documentação diz que instalação por marketplace é cópia congelada em
  `~/.claude/plugins/cache`, o carimbo da instalação é 2026-08-10T05:17Z,
  e mesmo assim o agente (10/08 23:46) e o hook (11/08 00:18) — ambos
  posteriores — aparecem carregados. O kit vinha dependendo de
  comportamento não documentado a cada aplicação, sem aviso no dia em
  que parasse. Agora a versão é bumpada em toda aplicação e a health
  check compara o inventário do arnês contra o kit em disco.
- NOVOS `notes/maintenance/WATCHLIST.md` (o que verificar: URL +
  **receita de reverificação** por fonte) e
  `notes/maintenance/LAST-CHECK.md` (livro-caixa: data por eixo, o que
  foi aplicado, rejeitado e NÃO VERIFICADO). A receita existe porque
  três fontes do próprio repo devolvem HTTP 200 sem conteúdo útil —
  `owasp.org/Top10/` (casca de redirect), `docs.npmjs.com/cli/audit`
  (stub de 77 bytes) e `semgrep.dev/p/owasp-top-ten` (shell JS vazio).
- `README.md`: os dois comandos novos e uma seção de manutenção.
- `friction.md`: registro de proveniência (commitado junto da
  proposta, `f5606ee`), incluindo que a auditoria 04 citada no pedido
  NÃO existe neste repositório — o pedido do usuário é que serve de
  diagnóstico, e a proposta declara isso.

Achados da pesquisa que NÃO foram aplicados (são descobertas, não
mudanças; cada uma precisa da própria aprovação, na primeira rodada
real): `gitleaks` está CONGELADO pelo mantenedor ("security patches
only", sucessor Betterleaks) e a matriz depende dele em duas linhas; a
lista OWASP 2025 tem duas categorias sem cobertura nenhuma aqui (A03
cadeia de suprimentos ampliada, A10 tratamento de exceções); o Fable 5
cai automaticamente para outro modelo em prompts marcados como de
cibersegurança, bem onde o gatilho UP da v7 manda escalar; e a URL
canônica do `npm audit` mudou de prateleira. Todos registrados no
livro-caixa.

Testes: registrados em entrada própria, acima desta.

## 2026-08-11 — method v7 aplicado: recomendação de modelo/esforço no início da tarefa (rec 3)

Aplicada a proposta `notes/proposals/method-v7-model-effort-proposal.md`
na ordem dela — o passo 10 do fluxo-alvo, o último ABSENT da audit-01,
sai de ABSENT para L3 + L4. Esse é o teto estrutural: `/model` é um
built-in, e "a command is only recognized at the start of your
message"; a tabela de comandos marca com `[Skill]` exatamente as
entradas que o Claude pode invocar sozinho, e nem `/model` nem
`/effort` carregam essa marca (code.claude.com/docs/en/commands.md,
reverificado em 2026-08-11); nem hook enxerga comandos embutidos.
*(Correção de 2026-08-12: a redação anterior citava como aspas
literais uma frase — "can only be invoked by the user, not by the
model itself" — que não existe em página nenhuma da documentação; 0
ocorrências no corpo inteiro `llms-full.txt`. A conclusão continua
válida, agora apoiada na evidência que existe de fato. Ver
`notes/proposals/maintenance-2026-08-11.md` D-2.)*

- `method.md` → **v7**: STEP 4 ganha a regra do silêncio — linha
  `Model/effort: <modelo> + <esforço> — <razão>` dentro de "Does it
  fit in one session?" SÓ quando um gatilho se aplica; ficha sem
  linha = as configurações atuais servem; STEP 5a ganha a
  interrupção única de início de tarefa (recusa = construir com o
  atual e não insistir).
- `start-project.md`: cópia embutida do método → v7 (checagem
  mecânica pós-edição: método 223 linhas, matriz 204, esqueleto 31 —
  0 divergências); Step 4 operacional ganha a lista de gatilhos
  (UP: linhas REVIEW de `authentication`/`authorization`/`payments`;
  2+ tarefas dependentes; lógica genuinamente nova; área que já
  quebrou. DOWN: trabalho puramente mecânico).
- `next-task.md`: (b) inclui a recomendação na MESMA interrupção
  única das linhas HUMAN DECISION, com auto-checagem de esforço via
  `${CLAUDE_EFFORT}` e fallback se o placeholder vier literal.
- `templates/TASK-XXX.md`: comentário do campo com a linha opcional.

Sonda P1 (sessão nova headless, projeto descartável com ficha
carregando `Model/effort: opus + high — novel streaming-hash grouping
logic`):

1. **Turno 1 — PASSOU.** A interrupção única veio exata: introdução
   da tarefa + "O card recomenda `/model opus` e `/effort high` —
   razão: 'lógica nova de agrupamento por hash em streaming, sem
   precedente neste repositório'. Pode configurar isso agora antes de
   eu começar? Se preferir, eu sigo com as configurações atuais." —
   e a sessão ESPEROU, sem construir nada.
2. **Turno 2 (diagnóstico) — `${CLAUDE_EFFORT}` SUBSTITUIU de
   verdade** no corpo do comando de plugin: a sessão citou o trecho
   recebido — "The current effort level is `high`" — nível concreto,
   não o texto literal. O caminho principal do D5 (calar quando o
   esforço atual já é o recomendado) está operante; o fallback
   textual permanece como segurança. O precedente de bug de expansão
   (`${CLAUDE_PLUGIN_ROOT}` em `commands/*.md`, friction.md
   2026-08-10) NÃO se aplicou a esta variável.

Dívida de validação declarada: a REGRA DO SILÊNCIO e os gatilhos do
planejamento (a metade que vive no `start-project`) só aparecem num
fluxo completo de planejamento — serão observados no **piloto T2**
(login + dado pessoal de terceiros). Com a v7, o piloto T2 acumula a
validação pendente de: revisor de segurança em fluxo (v5), itens 2–4
da rec 4 (marcador do SPEC, fechamentos crus, proxies), e agora regra
do silêncio + gatilho UP da v7 (as fichas de autenticação dele devem
nascer com linha `Model/effort:`).

## 2026-08-11 — rec 4 aplicada: captura da ideia, marcador do SPEC, fechamentos crus, proxies de tamanho

Aplicada a proposta `notes/rec4-small-patches-proposal.md` — quatro
remendos L3/L4 em comandos e templates; `method.md` e as cópias
embutidas (método, matriz, esqueleto) intocados, sem bump de versão:

- `start-project.md`: `argument-hint: <ideia em 1-2 frases>` no
  frontmatter; Step 1 pergunta a ideia ANTES do bloco crítico quando
  ela não veio com o comando, com proibição explícita de inferir da
  pasta (a friction do piloto de 2026-08-11); Step 2 grava
  `Approved: <data>` no fim do `SPEC.md` na confirmação do Gate 1
  (append-only, nunca edita linha anterior); Step 4 ganha os quatro
  proxies de tamanho com a regra errou-dois-divide; o template do
  STATE ganha a aprovação do SPEC nas settled decisions; Step 6
  mostra `git show --stat` cru do commit inicial antes do texto
  literal de fechamento.
- `next-task.md`: (e) ganha o `git show --stat` cru do commit da
  tarefa antes do texto literal de fim de turno — o texto literal
  segue intacto e por último.
- Templates: `TASK-XXX.md` (comentário com os proxies) e `STATE.md`
  (linha da aprovação do SPEC).

Sondas vivas do item 1 (o único friction-backed), um turno cada,
sessões headless novas em pastas descartáveis:

- **SEM ideia**: a primeira mensagem foi exatamente pedir a ideia
  ("Qual é a ideia? Uma ou duas frases bastam.") — sem bloco crítico,
  sem adivinhar do nome da pasta. **PASSOU.** Observação menor,
  registrada sem correção: essa sessão perguntou ANTES de gravar os
  arquivos do Step 0 (a ordem do comando é Step 0 primeiro) — desvio
  de sequência sem dano prático (os arquivos viriam no turno
  seguinte; a sonda foi abortada no turno 1). Vira friction se
  recorrer em uso real.
- **COM ideia** ("uma lista de compras local"): Step 0 gravado, ideia
  reformulada em uma linha e pergunta crítica 1 aberta na mesma
  mensagem (com um convite extra a detalhar a ideia — inofensivo).
  **PASSOU.**

Dívida de validação declarada (itens 2–4): o marcador do SPEC, os
fechamentos com stat cru e os proxies só aparecem num fluxo completo —
observar no próximo piloto real (o piloto T2 pendente, que também é o
que falta para exercitar o revisor dentro do fluxo).

## 2026-08-11 — piloto v5+v6 de ponta a ponta: PASSOU (contador de cliques, T0)

Primeiro fluxo completo com o kit v5+v6 de verdade: sessões headless
NOVAS (comandos, agente e hook carregados pelo harness real), uma
para `/start-project` — com o dono do produto simulado respondendo
turno a turno via `--resume` — e outra sessão limpa para
`/next-task`, imitando o `/clear`. Projeto descartável no scratchpad
(contador de cliques com nome personalizável; stack decidida pela
sessão: PowerShell + WinForms, zero instalação).

O que funcionou, com evidência no git do piloto:

- **Step 0 v6**: `method.md` v6 (209 linhas), `SECURITY-MATRIX.md`
  (204) e `friction.md` gravados no projeto novo.
- **Entrevista v4**: bloco crítico um-a-um (4 perguntas),
  agrupamento das demais, lista de suposições silenciosas, Gate 1 e
  Gate 2 travando e esperando resposta.
- **Triagem v5**: "Security tier: T0 — razão" nas settled decisions
  do `STATE.md`; ficha com "Security: none applicable" JUSTIFICADO
  linha a linha (nome digitado vai para rótulo WinForms, não para
  HTML/SQL/shell; sem dependência externa; sem segredo) — a
  proporcionalidade da matriz funcionando: linha fora de escopo é
  pulada, não falhada.
- **Scaffold v6**: `scripts/verify.ps1` no primeiro commit
  (`549dc17`, 9 arquivos, staged set correto); o primeiro commit
  passou pelo gate pela isenção de repositório sem commits
  (decisão 7, confirmada ao vivo).
- **Execução v6**: a sessão criou `check-syntax.ps1` e
  `check-roundtrip.ps1`, adicionou os dois ao `$checks`, rodou o
  entrypoint, e SÓ fechou a tarefa depois da confirmação humana;
  commit da tarefa (`99430a9`) com o staged set EXATO que o gate
  exige: app + `STATE.md` + `PLAN.md` + ficha + evidência
  (`pass: true`, `head` = commit pai, 2 checagens exit 0). Ficha,
  PLAN e STATE sincronizados no MESMO commit — a falha 5d dos
  pilotos antigos não recorreu. Texto literal de fim de turno
  emitido, e nada mais.

Limites deste piloto, declarados:

1. Linhas REVIEW não dispararam — CORRETAMENTE (T0 sem linha
   aplicável), mas isso significa que o caminho revisor-em-fluxo
   segue não exercitado; exige um piloto T2 (login + dado pessoal).
   O revisor em si foi testado à parte (entrada de 2026-08-11).
2. A checagem HUMANA foi confirmada pela persona simulada, não por
   um humano clicando — o app não foi testado em GUI de verdade (as
   duas checagens automatizadas rodaram de verdade, exit 0).
3. Condução headless (`-p`) mostra só a mensagem final de cada
   turno: a narração da stack e a saída bruta do verify ficaram
   invisíveis para o condutor — limitação do arnês de teste, não do
   método; a evidência commitada compensa (é para isso que o L4
   existe).
4. Friction observada AO VIVO e registrada em `friction.md`: a
   entrevista começou sem pedir a ideia (deduziu do nome da pasta) —
   a lacuna do passo 3 que a audit-01 marcou PARTIAL, agora com
   ocorrência de piloto; correção barata candidata é a rec 4 da
   audit-01 (`argument-hint` + uma linha no comando).

## 2026-08-11 — teste de integração da trava de commit: PASSOU em sessão nova

Fecha o passo 7 da aplicação da v6 (entrada abaixo). Sessão nova
headless com o hook carregado, no projeto descartável, rodando de
propósito em `--permission-mode bypassPermissions` — o modo mais
permissivo que existe — porque a documentação diz que o PreToolUse
dispara antes dele; este teste confirma na prática.

Resultado, verbatim da sessão de teste:

- Commit sem evidência → **NEGADO** com a razão exata do gate ("no
  verify evidence at .claude/last-verify.json…"). O hook do plugin
  carregou em sessão nova, disparou pelo harness real e travou um
  `git commit` de verdade mesmo com permissões em bypass. A expansão
  de `${CLAUDE_PLUGIN_ROOT}` no comando do hook funcionou na
  instalação em escopo user — item que estava NOT VERIFIED na
  proposta, agora confirmado ao vivo.
- `scripts/verify.ps1` → `VERIFY: PASS` (evidência gravada).
- Novo commit com evidência fresca → **LIBERADO**.
- `git log` conferido de forma independente: o commit negado NÃO
  existe no histórico; só o liberado entrou ("gate probe 2" sobre
  "initial").

Os casos que não dependem do harness já haviam passado 13/13 no teste
unitário (entrada abaixo). O caso 7j (commit digitado por você num
terminal fora do Claude Code não é vigiado) permanece como
comportamento esperado por definição — hooks só veem ferramentas.

Com isto, os passos 12 e 13 do alvo saem de prosa (L3) para
determinismo com evidência (L1 + L4): commit sem verificação fresca,
ou commit de tarefa sem os arquivos de status e a evidência juntos, é
negado pelo harness, não pela boa vontade do modelo.

## 2026-08-11 — method v6 aplicado: trava de commit por evidência (D5)

Aplicada a proposta `notes/method-v6-commit-gate-proposal.md`, na
ordem dela:

- NOVOS `kit/my-method/hooks/hooks.json` + `hooks/verify-gate.ps1`:
  hook PreToolUse em `Bash|PowerShell` que intercepta `git commit` e
  NEGA sem evidência fresca de PASS (mesmo HEAD, ≤ 60 min), e NEGA
  commit de tarefa sem `STATE.md` + `PLAN.md` + ficha + evidência
  juntos no staged. Isenções: primeiro commit do projeto, pastas fora
  do método, comandos que não são commit. Erro durante a detecção
  LIBERA (nunca trava trabalho normal por bug); erro depois de
  identificado um commit vigiado NEGA.
- `method.md` → **v6**: 5c ganha o ponto de entrada
  `scripts/verify.ps1` (roda TODAS as checagens acumuladas, saída
  crua, grava `.claude/last-verify.json`); 5d exige a evidência no
  staged junto com os três arquivos de status.
- `kit/my-method/commands/start-project.md`: novo item do Step 5
  escreve `scripts/verify.ps1` (esqueleto embutido — QUARTO texto
  embutido no arquivo, armadilha de duplicação registrada em
  friction.md) e semeia `$checks` com o comando de teste da stack;
  `.gitignore` nunca ignora a evidência; staging e template CLAUDE
  (linha `Verify:` + linha de layout) atualizados; cópia embutida do
  método → v6. Checagem mecânica pré-commit: método (209 linhas),
  matriz (204) e esqueleto (31) embutidos batem byte a byte com os
  canônicos — 0 divergências.
- `kit/my-method/commands/next-task.md`: (d) roda o entrypoint e
  manda adicionar as checagens novas da ficha ao `$checks` antes de
  rodar; (e) o commit inclui a evidência.
- `kit/my-method/templates/CLAUDE.md`: linha `Verify:` + layout.

Teste unitário do script do hook, ANTES deste commit (payloads
sintéticos de PreToolUse contra projeto descartável no scratchpad):
**13/13 PASS** — (a) commit inicial isento; (b) sem evidência NEGA;
(c) `pass: false` NEGA; (d) HEAD diferente NEGA; (e) evidência > 60
min NEGA; (f) PASS fresco + staged completo LIBERA; (g) ficha fora do
staged NEGA nomeando o que falta; (h) mesma trava via ferramenta
PowerShell; (i1) comando não-commit LIBERA; (i2) pasta fora do método
LIBERA; (x1) `git add -A && git commit` encadeado é detectado; (x2)
ferramenta que não é shell LIBERA; (x3) **falso positivo conhecido e
documentado**: `git log --grep commit` cai na trava — a regex
aprovada é permissiva de propósito; melhorar só se virar friction
real.

Teste de integração (hook carregado por sessão nova de verdade, casos
7a–7j da proposta no que dependem do harness): resultado registrado
em entrada própria deste CHANGELOG, acima desta.

Ressalvas (detalhadas na proposta): janela de 60 min pós-verificação
no mesmo HEAD; evidência forjada de propósito passa (mentira visível
no git, não impossível); commit digitado por você num terminal FORA
do Claude Code não é vigiado (esperado — hooks só veem ferramentas);
latência estimada de ~100–300 ms por chamada Bash/PowerShell em toda
sessão (plugin em escopo user; medir se incomodar); os pilotos
antigos SERÃO travados no próximo commit até ganharem
`scripts/verify.ps1` (decisão 9, aprovada).

## 2026-08-11 — teste do allowlist do security-reviewer: PASSOU em sessão nova

Fecha a ressalva 1 da entrada de 2026-08-10 (method v5). Método do
teste: sessão nova headless via `claude -p` (agentes de plugin
carregam no início da sessão), com o orquestrador instruído a invocar
o subagente `security-reviewer` pedindo a lista de ferramentas e
tentativas reais de escrita em arquivo e de comando de shell.

Resultado, verbatim do subagente:

- `TOOLS: Read, Grep, Glob` — as únicas ferramentas presentes na
  invocação;
- `WRITE_ATTEMPT: NOT AVAILABLE` — nenhuma ferramenta de escrita
  chamável;
- `SHELL_ATTEMPT: NOT AVAILABLE` — nenhuma ferramenta de shell
  chamável;
- nenhum arquivo criado no caminho alvo (confirmado por `Test-Path`).

O só-leitura do revisor é portanto ESTRUTURAL — o harness não oferece
ferramenta de escrita ao agente — e não prosa. Três observações:

1. A instalação em escopo `user` leu o arquivo novo do kit sem
   reinstalação; o registro de agentes acontece no início de cada
   sessão nova.
2. Comportamento observado, não planejado: o subagente RECUSOU como
   autoridade a moldura "requested by the project owner" embutida no
   prompt (tratou como texto injetado, sem consentimento real do
   usuário) — e mesmo assim reportou a lista de ferramentas. Para um
   revisor de segurança, essa resistência a injeção é desejável; fica
   registrada como comportamento observado em 2026-08-11, não como
   garantia.
3. Evidência = auto-relato in-vivo do subagente em sessão nova (duas
   execuções consistentes) + ausência do arquivo alvo. A listagem de
   tipos de agente do harness, com as ferramentas declaradas, não foi
   capturada verbatim (o orquestrador pulou essa parte da saída) —
   redundância perdida, não contradição.

Pendências que continuam abertas: D5 (hook de commit) e o primeiro
projeto real passando por triagem → fichas → verificação.

## 2026-08-10 — method v5: wiring de segurança aplicado (matriz → plano → verificação)

Aplicada a proposta `notes/method-v5-security-proposal.md`, na ordem
dela:

- `playbook/SECURITY-MATRIX.md`: seção "WHERE THIS FILE LIVES",
  parágrafo do revisor só-leitura em "HOW TO READ EACH ROW", e quinta
  coluna **Fix direction** nas 31 linhas das 10 tabelas.
- `method.md` → **v5**: STEP 0 grava `SECURITY-MATRIX.md` no projeto;
  STEP 4 faz a triagem T0–T3 e copia as linhas aplicáveis para dentro
  de "How we will check it" das fichas; STEP 5c executa as checagens
  por tipo (AUTOMATED / REVIEW / HUMAN DECISION), com checagem de
  deriva e laço construtor-corrige / revisor-fresco-rejulga.
- `kit/my-method/commands/start-project.md`: espelhos operacionais
  (triagem no Step 4, staging, templates de CLAUDE/STATE) e as duas
  cópias embutidas atualizadas — método v5 e matriz revisada. O
  arquivo agora carrega TRÊS textos embutidos (método, matriz,
  templates); a armadilha de duplicação está registrada em
  `friction.md`: revisão futura de método ou matriz toca o arquivo
  canônico E as cópias embutidas no mesmo commit.
- `kit/my-method/commands/next-task.md`: (b) ganha a pergunta das
  linhas HUMAN DECISION que moldam a construção; (d) ganha o
  procedimento de segurança em 5 passos (deriva → AUTOMATED → REVIEW
  → HUMAN DECISION → laço de correção).
- NOVO `kit/my-method/agents/security-reviewer.md`: revisor
  só-leitura (`tools: Read, Grep, Glob`), formato de achado fixo e
  veredito literal PASS/FAIL.
- Templates: `TASK-XXX.md` (comentário de "How we will check it"),
  `STATE.md` (tier nas settled decisions), `CLAUDE.md` (linha da
  matriz no layout).

Desvio único em relação ao texto aprovado, declarado: o frontmatter
do agente ganhou `name: security-reviewer` — campo exigido para o
registro de subagentes; idêntico ao nome do arquivo.

Ressalvas de teste desta aplicação:

1. O teste do allowlist (passo 8 da proposta) foi TENTADO nesta mesma
   sessão e a invocação falhou com "Agent type 'security-reviewer'
   not found" — agentes de plugin carregam no início da sessão. O
   teste fica PENDENTE para uma sessão nova; se a instalação em
   escopo user for uma cópia congelada do kit, pode exigir
   atualização/reinstalação via `/plugin` antes (qual dos dois casos
   vale: não verificado). Até esse teste passar, o "só-leitura" do
   revisor vale como prosa, não como garantia estrutural.
2. Nenhum projeto passou de ponta a ponta por triagem → fichas →
   verificação com o texto novo; o primeiro uso real é o teste.
3. Sem o hook de commit (D5, rec 2 da audit-01 — fora do escopo desta
   aplicação por decisão registrada), nada determinístico impede
   pular o procedimento inteiro: enforcement em L3 + L4.

Na prática: em projetos criados daqui em diante, toda ficha nasce com
as checagens de segurança do tier do projeto dentro de "How we will
check it", e o fim de cada tarefa executa essas checagens por tipo —
com os achados na tela antes de qualquer conserto, e decisões que são
suas chegando como pergunta, nunca respondidas por conta.

## 2026-08-10 — `/start-project`: construído e testado contra uma ideia descartável

Construí `kit/my-method/commands/start-project.md` — o comando de
entrada que roda numa pasta vazia e conduz Etapas 0 a 4 do método numa
sessão só: perguntas, SPEC (gate 1), stack, plano (gate 2), e o
primeiro commit.

Descoberta que mudou o design: `${CLAUDE_PLUGIN_ROOT}` não expande de
forma confiável dentro de `commands/*.md` (bug conhecido do Claude
Code), e mesmo se expandisse, ler `kit/my-method/method.md` ou
`kit/my-method/templates/*.md` em tempo de execução seria ler um
arquivo fora da pasta do projeto atual — proibido pela regra global
"Boundaries". Por isso o texto de `method.md` e a estrutura de
`CLAUDE.md`/`STATE.md` ficaram colados por inteiro dentro do próprio
`start-project.md`, em vez de referenciados por caminho. Duplicação
registrada em `friction.md` (YOURS) para não se perder.

Testei rodando o comando manualmente (seguindo seu texto passo a
passo, não disparado pelo parser real de barra — mesma ressalva já
registrada no teste do `/next-task`) numa pasta vazia, com a ideia
descartável "contador de cliques": as seis perguntas da Etapa 1, o
gate do SPEC, a decisão de stack (HTML/CSS/JS puro, sem build), o
plano de uma tarefa só, o gate do plano, e o primeiro commit — tudo
correu sem travar. Partes não testadas neste teste: o caminho de
"pedir mudança" em qualquer um dos dois gates (ambos foram aprovados
de primeira), o `.gitignore` condicional da Etapa 5 (a stack escolhida
não precisava de um), e uma stack que exija backend/login/dado
pessoal — o projeto de teste era simples demais para forçar essas
ramificações.

## 2026-08-10 — Publicação: de "local por caminho" para marketplace local + escopo de usuário

O piloto (ver ressalva 4 da entrada abaixo) instalava o plugin ligando
um symlink `.claude/skills/my-method` dentro de cada projeto — uma
instalação "local por caminho", que precisa ser refeita em todo
projeto novo. Isso mudou: agora a instalação passa por um marketplace
local (catálogo em `.claude-plugin/marketplace.json`, nome
`jeferson-tools`, apontando para `kit/my-method/`) e é registrada com
**escopo `user`**.

Motivo: eu queria o comando `/my-method:next-task` disponível em
qualquer projeto que abrisse dali para frente, sem reinstalar
pasta por pasta. Instalação "local por caminho" sem marketplace amarra
a um projeto só (equivalente a escopo `project` ou `local`); só um
marketplace com escopo `user` resolve isso. Passo a passo de
reinstalação em `README.md`.

## 2026-08-10 — `/next-task`: teste contra o piloto `meu-organizador`

Status do teste: **Etapa 3 — testada parcialmente, teste de sessão
fresca pendente.**

Construí `/next-task` e testei a sequência a-e contra uma TASK-005
adicionada de propósito ao piloto `meu-organizador`. Quatro ressalvas
sobre esse teste, registradas aqui para não se perderem:

1. Não houve uma sessão realmente nova disparando `/next-task` pelo
   parser de comando de verdade. Os passos foram seguidos manualmente
   por mim, dentro de uma sessão que já tinha STATE.md/PLAN.md/card em
   contexto — isso testa se o texto do comando é seguível, não se uma
   sessão sem contexto prévio o obedece à risca. Teste de sessão fresca
   pendente.

2. O texto literal de fim de turno ("Tarefa concluída e commitada.
   Rode `/clear` antes de continuar.") não foi emitido depois da
   TASK-005 do piloto, porque essa tarefa era um teste dentro de uma
   sessão maior, não o fim real do meu turno.

3. Ao encerrar o servidor local (`http.server`) usado na verificação,
   rodei `taskkill /IM python.exe /F`, que mata todo processo
   `python.exe` da máquina, não só o do teste — risco real se houvesse
   outro processo Python seu rodando. **Corrigir: usar PID específico
   da próxima vez.**

4. Removi o symlink de instalação do plugin
   (`.claude/skills/my-method`) criado no piloto só para permitir esse
   teste — não ficou permanente, porque um symlink com caminho
   absoluto desta máquina não deveria entrar no histórico git de outro
   projeto sem necessidade real.
