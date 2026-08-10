# my-method

Plugin do Claude Code (um "plugin" é um pacote de comandos/skills que
estende o Claude Code) que executa `method.md` — o método de trabalho
para construir produtos com o Claude fazendo a engenharia. Comece um
projeto novo com `/my-method:start-project`, numa pasta vazia; depois
disso, `/my-method:next-task` executa a próxima tarefa pendente do
projeto na pasta atual, uma por sessão.

## Como este plugin foi publicado

Este repositório (`dev/my-method`) funciona como um **marketplace
local**. Um "marketplace", no Claude Code, é só um catálogo — um
arquivo `marketplace.json` que diz onde encontrar um ou mais plugins.
Não é preciso hospedar nada no GitHub: o catálogo pode apontar para
uma pasta comum do disco, e foi isso que fizemos aqui.

- Catálogo: `.claude-plugin/marketplace.json`, na raiz deste
  repositório.
- Nome do marketplace: `jeferson-tools`.
- Plugin catalogado: `my-method`, com o código-fonte em
  `kit/my-method/`.

## Como foi instalado

Instalado com **escopo `user`**. "Escopo" é onde o Claude Code
registra a instalação:

- `user` — disponível para você em qualquer projeto que você abrir,
  sem reinstalar pasta por pasta. **É este que usamos.**
- `project` — instalado para todos que colaboram num repositório
  específico.
- `local` — instalado só para você, só naquele repositório.

Para confirmar que a instalação está com o escopo certo, rode em
qualquer pasta:

```
claude plugin list
```

Deve aparecer `my-method@jeferson-tools` com `Scope: user`.

## Como reinstalar do zero em uma máquina nova

1. Clone (ou copie) este repositório em qualquer pasta da máquina
   nova.
2. Dentro de uma sessão do Claude Code, rode, ajustando o caminho
   para onde você colocou o repositório:

   ```
   /plugin marketplace add C:\caminho\para\my-method
   /plugin install my-method@jeferson-tools
   ```

   O segundo comando abre uma tela para escolher o escopo — escolha
   **User**.

3. Alternativa sem tela interativa, direto no terminal, já instalando
   com escopo `user`:

   ```
   claude plugin install my-method@jeferson-tools --scope user
   ```

4. Se o resumo da instalação disser `Run /reload-plugins to
   activate.`, rode `/reload-plugins`.

## Usando o plugin

Comandos disponíveis:

- `/my-method:start-project` — numa pasta vazia, conduz tudo antes da
  primeira linha de código: perguntas, SPEC (com gate de aprovação),
  stack, plano de tarefas (com gate de aprovação), e o primeiro
  commit. Roda uma vez por projeto, no início.
- `/my-method:next-task` — executa a próxima tarefa pendente do
  projeto na pasta atual. É o comando do dia a dia, uma tarefa por
  sessão.
- `/my-method:where-am-i` — só resume onde o projeto está agora
  (tarefa atual, decisões já fechadas, próximo passo). Não muda nada.
- `/my-method:friction` — registra, verbatim, uma reclamação sobre
  como o trabalho está sendo conduzido.

Todos os quatro só funcionam sendo **digitados diretamente** — cada um
tem `disable-model-invocation: true` no seu arquivo, então o Claude
não pode disparar nenhum sozinho a partir de um pedido em linguagem
natural.
