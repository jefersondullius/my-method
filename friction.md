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

## MINE
