# Como fazer uma tarefa, do cartão ao merge

Este guia mostra o caminho completo de uma tarefa, passo a passo. Ele usa como exemplo a tarefa **`[AUTH-3] Backend - Função de hash de senha`**. Troque pelo código e pelo nome da sua.

Se você nunca usou Git em equipe, leia tudo uma vez antes de começar. Depois, use como lista de conferência.

## A ideia em uma imagem

```
quadro            sua máquina                      GitHub
------            -----------                      ------
pega o cartão ->  cria a branch -> faz a tarefa -> envia -> abre o PR
                                                              |
                                              testes automáticos rodam
                                                              |
                                                   o líder revisa e aprova
                                                              |
                                                 entra na develop -> cartão em Feito
```

Três regras valem sempre:

1. **Uma tarefa por vez.** Termine a sua antes de pegar outra.
2. **Mexa só nos arquivos listados no cartão.** Precisou de outro? Pergunte no cartão antes.
3. **Ninguém envia código direto para a `develop` nem para a `main`.** Tudo entra por Pull Request (PR).

## Palavras que você vai encontrar

| Palavra | O que é |
|---|---|
| **Repositório** | A pasta do projeto, guardada no GitHub com todo o histórico |
| **Branch** | Uma cópia paralela do código, só sua, onde você trabalha sem atrapalhar ninguém |
| **`develop`** | A branch do dia a dia. Todo código novo entra nela primeiro |
| **`main`** | A versão estável. Só o líder mexe nela |
| **Commit** | Um ponto salvo no histórico, com uma mensagem dizendo o que mudou |
| **Push** | Enviar os seus commits da sua máquina para o GitHub |
| **Pull Request (PR)** | O pedido para o seu código entrar na `develop`. É onde acontecem os testes e a revisão |
| **Merge** | O momento em que o código do PR entra de fato na `develop` |
| **Issue** | O cartão da tarefa. Cada Issue tem um número, como `#11` |
| **CI** | Os testes automáticos que o GitHub roda em todo PR |

## Antes da primeira tarefa (só uma vez)

Siga a seção **Rodando o projeto** do [README](../README.md): instalar o Docker e o Git, clonar o repositório, copiar o `.env.example` para `.env` e rodar `docker compose up --build`.

Depois confira que está tudo certo:

```bash
./scripts/dev.sh check
```

Tem que terminar com `OK: tudo passou.` Se não terminar, resolva isso antes de pegar uma tarefa, ou peça ajuda.

No Windows, rode os comandos deste guia pelo **Git Bash**.

## Passo 1: pegar o cartão

1. Abra o quadro do projeto e olhe a coluna **Pronto Pra Pegar**. Só pegue tarefa dessa coluna.
2. Escolha um cartão **sem** a etiqueta amarela `lider` e sem ninguém atribuído.
3. Abra o cartão e leia tudo: objetivo, como fazer, arquivos, critério de aceite.
4. Confira a seção **Depende de**. Todas as tarefas citadas ali precisam estar em **Feito**.
5. Em **Assignees**, clique em **assign yourself**. Isso avisa a equipe de que a tarefa é sua.
6. Arraste o cartão para **Em Andamento**.

Anote duas coisas do cartão, porque você vai usar adiante:

- o **número da Issue**, que aparece ao lado do título (exemplo: `#11`);
- a **branch sugerida** (exemplo: `feat/auth-3-hash-senha`).

## Passo 2: atualizar a sua `develop`

Antes de começar, traga para a sua máquina o que os colegas já entregaram:

```bash
git switch develop
git pull
```

- `git switch develop` vai para a branch `develop`.
- `git pull` baixa a versão mais nova do GitHub.

Faça isso **toda vez**, antes de criar a branch. Começar de uma `develop` velha é a causa mais comum de conflito.

## Passo 3: criar a branch da tarefa

Use o nome que está no cartão, em **Branch sugerida**:

```bash
git switch -c feat/auth-3-hash-senha
```

O `-c` cria a branch e já entra nela.

O nome segue um padrão, e o GitHub **recusa** o PR se ele estiver fora:

```
tipo/modulo-numero-descricao
feat/auth-3-hash-senha
```

- **tipo:** `feat` (funcionalidade nova), `fix` (correção), `docs` (documentação), `chore` (manutenção), `refactor`, `test`
- **modulo-numero:** o código do cartão em minúsculas (`AUTH-3` vira `auth-3`)
- **descricao:** poucas palavras, minúsculas, separadas por hífen, sem acento

## Passo 4: fazer a tarefa

1. Siga a seção **Como fazer** do cartão.
2. Mexa só nos arquivos da seção **Arquivos que podem ser alterados**.
3. Escreva o teste pedido em **Teste que prova**.
4. Vá conferindo os itens do **Critério de aceite**. A tarefa só está pronta quando todos estiverem atendidos.

Enquanto trabalha, rode os testes sempre que quiser:

```bash
./scripts/dev.sh test       # testes do backend
./scripts/dev.sh fe-lint    # conferência do código do frontend
```

**Travou por mais de 30 minutos?** Escreva um comentário no cartão dizendo o que tentou e peça ajuda. Pedir ajuda cedo faz parte do processo.

**Precisa de uma biblioteca nova?** Não instale. Abra uma Issue com o modelo **Pedido de dependência** e espere a resposta do líder.

## Passo 5: conferir antes de enviar

Rode o mesmo conjunto de verificações que o GitHub vai rodar:

```bash
./scripts/dev.sh check
```

Tem que terminar com `OK: tudo passou.`

| Se aparecer | O que fazer |
|---|---|
| Erro do `ruff` sobre formatação | Rode `./scripts/dev.sh format`, que arruma sozinho, e rode o `check` de novo |
| Teste falhando (`FAILED`) | Leia a mensagem: ela mostra o arquivo, a linha e o que era esperado. Corrija e rode de novo |
| Erro do `eslint` (frontend) | A mensagem mostra o arquivo e a linha. Corrija e rode de novo |

Não envie com o `check` falhando: o PR vai falhar do mesmo jeito no GitHub.

## Passo 6: salvar (commit) e enviar (push)

Veja o que você mudou:

```bash
git status
```

Confira que só aparecem os arquivos da sua tarefa. Se aparecer `.env` ou outro arquivo estranho, **não adicione**.

Adicione os arquivos e faça o commit:

```bash
git add backend/app/modules/auth/service.py backend/tests/test_auth_service.py
git commit -m "feat(auth): adiciona hash de senha"
```

A mensagem segue o formato `tipo(modulo): o que foi feito`, com o verbo no presente.

Envie para o GitHub:

```bash
git push -u origin feat/auth-3-hash-senha
```

O `-u` só é necessário no primeiro envio da branch. Nos próximos, basta `git push`.

Pode fazer vários commits pequenos ao longo da tarefa. Eles viram um só na hora do merge.

## Passo 7: abrir o Pull Request

1. Abra o repositório no GitHub. Vai aparecer uma faixa amarela com o botão **Compare & pull request**. Clique nele.
2. Confira no topo: **base: `develop`** ← **compare: `feat/auth-3-hash-senha`**. A base tem que ser a `develop`.
3. No título, use a mesma frase do commit: `feat(auth): adiciona hash de senha`.
4. Preencha o modelo que já vem na descrição:
   - **O que mudou e por quê:** uma ou duas frases.
   - **`Closes #11`:** troque pelo número da **sua** Issue. Sem isso o PR é recusado, e o cartão não anda sozinho.
   - **Como testar:** o comando ou os passos para conferir.
   - **Checklist:** marque só o que for verdade.
5. Clique em **Create pull request**.

O cartão vai sozinho para **Em Revisão**. Se não for, arraste.

## Passo 8: acompanhar os testes e a revisão

No fim da página do PR aparecem três verificações:

| Verificação | O que confere |
|---|---|
| `backend` | Formatação, migrações e testes do backend |
| `frontend` | Formatação e build do frontend |
| `governanca` | Nome da branch no padrão e Issue citada com `Closes #N` |

Elas levam alguns minutos. O líder só revisa PR com as **três verdes**.

**Se alguma ficar vermelha:** clique em **Details** ao lado dela para ler o erro. Corrija na sua máquina, na mesma branch, e envie de novo:

```bash
git add <arquivos>
git commit -m "fix(auth): corrige teste do hash"
git push
```

O PR se atualiza sozinho e os testes rodam de novo. **Não abra outro PR.**

**Se o líder pedir mudanças:** leia os comentários, corrija na mesma branch e envie do mesmo jeito. Responda aos comentários dizendo o que fez. Pedido de mudança é normal e acontece com todo mundo.

## Passo 9: depois do merge

Quando o líder aprova e faz o merge, a Issue fecha e o cartão vai para **Feito** sozinho. A sua branch é apagada do GitHub automaticamente.

Na sua máquina, volte para a `develop`, atualize e apague a branch antiga:

```bash
git switch develop
git pull
git branch -D feat/auth-3-hash-senha
```

Pronto. Volte ao Passo 1 e pegue a próxima.

## Problemas comuns

**"Comecei a mexer e percebi que estou na `develop`, não na minha branch."**
Se ainda não fez commit, é só criar a branch agora: `git switch -c feat/auth-3-hash-senha`. As suas mudanças vão junto.

**"O PR diz que tem conflito com a `develop`."**
Alguém entregou uma mudança no mesmo trecho que você. Atualize a sua branch:

```bash
git switch develop
git pull
git switch feat/auth-3-hash-senha
git merge develop
```

O Git marca os trechos em conflito com `<<<<<<<` e `>>>>>>>`. Abra o arquivo, deixe a versão certa, apague as marcas, e então `git add`, `git commit` e `git push`. Na dúvida, chame o líder antes de resolver.

**"A verificação `governanca` ficou vermelha."**
Ou o nome da branch está fora do padrão, ou falta o `Closes #N` na descrição do PR. A descrição você edita no próprio PR. O nome da branch não dá para trocar no PR: crie outra branch com o nome certo a partir da sua (`git switch -c nome-certo`), envie e abra um PR novo, fechando o antigo.

**"Adicionei o `.env` sem querer."**
Se ainda não fez push: `git restore --staged .env`. Se já enviou, avise o líder **na hora**: a senha ou a chave que estava lá precisa ser trocada.

**"Preciso mexer em um arquivo que não está no cartão."**
Pare e comente no cartão. Pode ser que outra pessoa esteja mexendo nele, ou que seja um arquivo que só o líder altera (`main.py`, `core/`, migrações, dependências, Docker).

**"Não sei se a tarefa está pronta."**
Está pronta quando todos os itens do **Critério de aceite** estão atendidos e o `./scripts/dev.sh check` passa.

## Resumo para colar na parede

```bash
git switch develop && git pull              # 1. atualizar
git switch -c feat/auth-3-hash-senha        # 2. criar a branch
# ... fazer a tarefa ...
./scripts/dev.sh check                      # 3. conferir
git add <arquivos>                          # 4. salvar
git commit -m "feat(auth): adiciona hash de senha"
git push -u origin feat/auth-3-hash-senha   # 5. enviar
# 6. abrir o PR contra a develop, com "Closes #11"
# 7. esperar as três verificações verdes e a aprovação
git switch develop && git pull              # 8. depois do merge
```
