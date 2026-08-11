# CHANGELOG

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
