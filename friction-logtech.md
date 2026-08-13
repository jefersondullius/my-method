# FRICTION

## YOURS

### 2026-08-12 — resolução de pergunta em aberto (audit-02-skills.md)

Contexto: a friction de 2026-08-12 ("a stack foi decidida (supabase) e nenhuma etapa...") citava um ponto NÃO VERIFICADO em `audit-02-skills.md` — se existe instalação de skill em escopo de projeto (só válida no projeto atual), distinta de escopo de usuário (válida em todos os projetos futuros). Essa pergunta foi respondida ao vivo nesta sessão, contra a documentação oficial:

- Skills soltas (não-plugin): `~/.claude/skills/` = pessoal, todos os projetos; `.claude/skills/` = projeto, só este projeto. Fonte: https://code.claude.com/docs/en/skills, acessado em 2026-08-12.
- Plugins (formato usado pela Supabase e pela Cloudflare): instalação aceita escopo `user`, `project` (grava em `.claude/settings.json`, versionado) ou `local` (grava em `.claude/settings.local.json`, não versionado); comando `claude plugin install <nome>@<marketplace> --scope project` — sem `--scope`, o padrão é escopo de usuário. Fonte: https://code.claude.com/docs/en/discover-plugins, acessado em 2026-08-12.

Resposta à pergunta pendente: SIM, existe instalação em escopo de projeto (e também escopo local), para ambos os formatos (skill solta e plugin). Instalar uma skill de stack específica não precisa contaminar o contexto de outros projetos.

Ação para a próxima rodada de manutenção: atualizar `audit-02-skills.md`, trocando o status de NÃO VERIFICADO para VERIFICADO, com as duas fontes acima — isso destrava a proposta (ainda não feita) de adicionar ao `method.md` um passo, logo após o Passo 3 (stack), que procure skills oficiais para a stack decidida antes do Passo 4 (plano).

### 2026-08-12 — sem tarefa corrente (commit de instalação das skills de stack)

Feito imediatamente antes: commit de `friction.md` + `.claude/settings.json` (skills Supabase e Cloudflare em escopo de projeto) + `.gitignore` foi tentado.

Achado: o gate de commit do método (hook que exige `.claude/last-verify.json` fresco) bloqueou o commit, mesmo este não sendo um commit de tarefa do `PLAN.md` — é configuração de ferramenta, fora do ciclo de uma `TASK-XXX`. O texto do `method.md` (Passo STEP 5, item d) descreve esse gate como parte do commit de uma tarefa especificamente ("The staged set must include `.claude/last-verify.json` together with the three status files — the commit gate denies a task commit missing any of them"), mas o hook, na prática, aplica a mesma exigência a QUALQUER commit no projeto, não só a commits de tarefa. Contornado rodando `scripts/verify.ps1` antes (passou trivialmente, já que `$checks` ainda está vazio nesta fase do projeto).

Ação para a próxima rodada de manutenção: decidir se o `method.md` deve descrever esse gate como valendo pra todo commit (não só commits de tarefa) — o que bateria com o comportamento real do hook — ou se o hook deveria ser ajustado pra só bloquear commits de tarefa, como o texto atual sugere. Enquanto isso não for decidido, qualquer commit fora do ciclo de tarefa (como este, de configuração/ferramenta) vai precisar rodar `verify.ps1` primeiro, mesmo sem checagens novas para justificar isso.

## MINE

### 2026-08-12 — sem tarefa corrente

Feito imediatamente antes: SPEC.md foi escrito e confirmado pelo usuário; a sessão estava prestes a começar o Passo 3 (decisão de stack).

Palavras do usuário (verbatim):

> chegamos no passo da stack e percebi que a decisão não considera nem custo em dinheiro (hospedagem, banco, autenticação — o que dispara cobrança quando o plano gratuito acaba) nem custo em sessões do meu plano Pro (uma stack que exige mais código e mais configuração consome mais sessões para o mesmo resultado). isso deveria ser parte da justificativa da stack em todo projeto, não algo que eu preciso lembrar de pedir.

### 2026-08-12 — sem tarefa corrente

Feito imediatamente antes: o primeiro commit do projeto foi criado (method.md, SECURITY-MATRIX.md, SPEC.md, STATE.md, CLAUDE.md, PLAN.md, fichas de tarefa, verify.ps1) e a sessão instruiu o usuário a rodar `/clear`.

Palavras do usuário (verbatim):

> a stack foi decidida (supabase) e nenhuma etapa do fluxo procurou ou sugeriu a skill oficial do supabase, que tem boas práticas recomendadas para desenvolver com ele. o passo 3 decide a stack e segue direto pro plano — não existe um momento que pergunte "existe uma skill oficial para o que acabei de escolher, e vale a pena adicionar a este projeto?"
>
> o momento certo dessa busca seria logo após o passo 3 (stack decidida), antes do passo 4 (plano) — porque se uma skill for adotada, ela pode mudar como as tarefas são construídas e verificadas, e as fichas do plano deveriam já nascer sabendo disso, do mesmo jeito que já nascem sabendo das linhas de segurança da matriz.
>
> um ponto em aberto de uma auditoria anterior (audit-02-skills.md) fica relevante aqui: skills de stack específica custam contexto em todo projeto futuro se instaladas em escopo de usuário, mesmo nos que não usam aquela stack — e ficou como NÃO VERIFICADO se existe instalação em escopo de projeto, que resolveria isso. antes de qualquer proposta de adicionar este passo ao method.md, essa pergunta precisa ser respondida, senão a proposta não sabe se é barata ou cara.

### 2026-08-12 — sem tarefa corrente

Feito imediatamente antes: a friction anterior sobre busca de skills oficiais da stack foi registrada, e a sessão confirmou o registro e instruiu o usuário a rodar `/clear`.

Palavras do usuário (verbatim):

> /my-method:friction só lembrei de pedir a busca de skills depois que o plano já estava pronto e o primeiro commit feito — mesmo sabendo, pela entrada de friction anterior, que o momento certo era logo após a stack. Isso é o segundo dado mostrando que "lembrar" não basta; reforça que isso precisa ser um passo do method.md, não hábito meu.

### 2026-08-12 — sem tarefa corrente

Feito imediatamente antes: a TASK-004 (gestão de funcionários e locais de trabalho) foi concluída e commitada, e a sessão foi limpa com `/clear`, sem nenhuma tarefa em andamento.

Palavras do usuário (verbatim):

> ideia: o method.md deveria deixar explícito que tarefas de funcionalidade e tarefas de acabamento visual são sempre separadas — construir funcional primeiro, capricho visual depois, em tarefa própria. Isso evitaria o que aconteceu aqui: telas funcionais mas feias, sem aviso de que o visual ficaria para depois. Ainda não sei se isso deveria ser regra fixa ou só uma prática recomendada — quero ver como o restante do logtech se comporta antes de propor a mudança no method.md.
