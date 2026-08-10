# CHANGELOG

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
