# CHANGELOG

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
