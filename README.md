# my-method

Plugin do Claude Code (um "plugin" é um pacote de comandos/skills que
estende o Claude Code) que executa `method.md` — o método de trabalho
para construir produtos com o Claude fazendo a engenharia. O comando
principal é `/my-method:next-task`, que executa a próxima tarefa
pendente do projeto na pasta atual.

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

O comando `/my-method:next-task` só funciona sendo **digitado
diretamente** — ele tem `disable-model-invocation: true`, então o
Claude não pode disparar sozinho a partir de um pedido em linguagem
natural.
