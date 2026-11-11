# Planejamento das sprints

Este documento tem duas partes:

1. **O plano:** as sete sprints do MVP, com a meta e os cartões de cada uma.
2. **O modelo:** como montar uma sprint, como ajustar o plano quando algo muda e os modelos prontos para copiar.

O quadro do GitHub Projects é a fonte da verdade do dia a dia. Este documento é a referência do raciocínio: quando o quadro e o documento divergirem, atualize o documento.

## Como o plano foi montado

**Sprint** é uma semana de trabalho com uma lista fechada de cartões e uma meta. No fim da semana, a meta precisa estar funcionando.

O plano segue quatro regras:

| Regra | O que significa |
|---|---|
| **Uma meta por sprint** | Cada sprint entrega algo que dá para demonstrar, não uma mistura de cartões soltos |
| **Dependência vem antes** | Um cartão só entra na sprint se tudo de que ele depende está em uma sprint anterior, ou antes dele na mesma sprint |
| **Capacidade de 5 a 5,5 dias** | Soma dos tamanhos: `P` vale meio dia e `M` vale um dia |
| **Do alicerce para a tela** | Primeiro o que os outros usam (login, banco), depois as regras, por último a interface |

A capacidade de 5 a 5,5 dias supõe uma pessoa em tempo integral. Com menos tempo, veja [Se a sua capacidade for menor](#se-a-sua-capacidade-for-menor).

## Visão geral

| Sprint | Semana | Meta | Cartões | Dias |
|---|---|---|---|---|
| 1 | 16/11 a 22/11 | O professor se cadastra e faz login pela API | 9 | 5,5 |
| 2 | 23/11 a 29/11 | As ementas viram cursos e assuntos no banco e aparecem na API | 8 | 5,5 |
| 3 | 30/11 a 06/12 | A IA devolve questões válidas a partir de um assunto | 8 | 5 |
| 4 | 07/12 a 13/12 | O professor cria, lista e baixa em PDF uma atividade pela API | 6 | 5 |
| 5 | 14/12 a 20/12 | O aluno responde pelo link (API) e o professor entra pela tela de login | 6 | 5 |
| 6 | 21/12 a 27/12 | Todas as telas navegáveis, com dados de exemplo e login real | 5 | 5 |
| 7 | 28/12 a 03/01 | Sistema completo, testado de ponta a ponta e publicado | 7 | 5 |

Total: 49 cartões, 36 dias de trabalho.

As sprints 6 e 7 caem nas semanas de Natal e Ano-Novo. Se você não for trabalhar nesses dias, empurre as duas uma ou duas semanas para a frente no campo `Sprint` do quadro.

## Sprint 1: login na API (16/11 a 22/11)

**Meta:** o professor se cadastra e faz login pela API.

**Como demonstrar:** em `http://localhost:8000/docs`, cadastrar um professor, fazer login e receber um token.

| Ordem | Cartão | Tarefa | Tipo | Tam. | Depende de |
|---|---|---|---|---|---|
| 1 | `INFRA-4` (#4) | Dependências de login (bcrypt e PyJWT) | Infra | P | — |
| 2 | `INFRA-3` (#3) | Registrar os routers dos módulos na API | Infra | P | — |
| 3 | `AUTH-1` (#9) | Modelo Usuario e migração da tabela | Banco | P | — |
| 4 | `AUTH-2` (#10) | Schemas de cadastro, login e token | Backend | P | — |
| 5 | `AUTH-3` (#11) | Função de hash de senha | Backend | P | AUTH-2, INFRA-4 |
| 6 | `AUTH-4` (#12) | Funções para criar e validar o token (JWT) | Backend | P | INFRA-4 |
| 7 | `AUTH-5` (#13) | Rota de cadastro de professor | Backend | M | AUTH-1, AUTH-3, INFRA-3 |
| 8 | `AUTH-6` (#14) | Rota de login que devolve o token | Backend | M | AUTH-5, AUTH-4 |
| 9 | `AUTH-7` (#15) | Proteção de rotas (usuário atual) | Backend | P | AUTH-4, AUTH-1 |

## Sprint 2: cursos e ementas (23/11 a 29/11)

**Meta:** as ementas viram cursos e assuntos no banco e aparecem na API.

**Como demonstrar:** importar um PDF de ementa e ver os assuntos dele em `GET /cursos/{id}/assuntos`.

| Ordem | Cartão | Tarefa | Tipo | Tam. | Depende de |
|---|---|---|---|---|---|
| 1 | `CURSOS-1` (#16) | Modelos Curso e Assunto e migração | Banco | P | AUTH-1 |
| 2 | `CURSOS-2` (#17) | Schemas de curso e assunto | Backend | P | — |
| 3 | `CURSOS-3` (#18) | Funções de listagem de cursos e assuntos | Backend | P | CURSOS-1, CURSOS-2 |
| 4 | `CURSOS-4` (#19) | Rotas de cursos e assuntos | Backend | P | CURSOS-3, AUTH-7, INFRA-3 |
| 5 | `INFRA-5` (#5) | Estrutura do importador e dependência de PDF (PyMuPDF) | Infra | M | — |
| 6 | `IMPORTADOR-1` (#20) | Ler o texto de um PDF de ementa | Backend | P | INFRA-5 |
| 7 | `IMPORTADOR-2` (#21) | Separar o texto da ementa em assuntos | Backend | M | IMPORTADOR-1 |
| 8 | `IMPORTADOR-3` (#22) | Gravar curso e assuntos no banco | Backend | M | IMPORTADOR-2, CURSOS-1 |

## Sprint 3: a IA gera questões (30/11 a 06/12)

**Meta:** a IA devolve questões válidas a partir de um assunto.

**Como demonstrar:** rodar os testes do módulo `ia` e mostrar uma lista de questões no formato certo, no modo de teste e com a chave real.

| Ordem | Cartão | Tarefa | Tipo | Tam. | Depende de |
|---|---|---|---|---|---|
| 1 | `IMPORTADOR-4` (#23) | Importar todas as ementas de uma pasta | Backend | P | IMPORTADOR-3 |
| 2 | `INFRA-6` (#6) | Dependência do cliente da IA (openai) | Infra | P | — |
| 3 | `IA-1` (#24) | Schemas das questões geradas pela IA | Backend | P | — |
| 4 | `IA-2` (#25) | Montar o pedido (prompt) para a IA | Backend | P | IA-1 |
| 5 | `IA-3` (#26) | Modo de teste da IA (questões prontas, sem gastar a chave) | Backend | P | IA-1 |
| 6 | `IA-4` (#27) | Chamar o Grok e conferir a resposta | Backend | M | IA-2, IA-3, INFRA-6 |
| 7 | `ATIVIDADES-1` (#28) | Modelos Atividade e Questao e migração | Banco | M | CURSOS-1 |
| 8 | `ATIVIDADES-2` (#29) | Schemas de atividade e questão | Backend | P | IA-1 |

Os dois últimos cartões não fazem parte da meta: eles adiantam o alicerce da Sprint 4. Se a sprint apertar, são os primeiros a sair.

## Sprint 4: atividades na API (07/12 a 13/12)

**Meta:** o professor cria, lista e baixa em PDF uma atividade pela API.

**Como demonstrar:** em `/docs`, criar uma atividade, vê-la na lista e baixar o PDF da prova e o do gabarito.

| Ordem | Cartão | Tarefa | Tipo | Tam. | Depende de |
|---|---|---|---|---|---|
| 1 | `ATIVIDADES-3` (#30) | Rota para criar atividade com a IA | Backend | M | ATIVIDADES-1, ATIVIDADES-2, IA-4, AUTH-7, INFRA-3 |
| 2 | `ATIVIDADES-4` (#31) | Rotas para listar e ver atividades | Backend | M | ATIVIDADES-3 |
| 3 | `INFRA-7` (#7) | Dependência de geração de PDF (reportlab) | Infra | P | — |
| 4 | `ATIVIDADES-5` (#32) | Gerar o PDF da prova e do gabarito | Backend | M | ATIVIDADES-4, INFRA-7 |
| 5 | `ENVIOS-1` (#33) | Modelos Envio e Resposta e migração | Banco | M | ATIVIDADES-1 |
| 6 | `ENVIOS-2` (#34) | Schemas da página do aluno e dos envios | Backend | P | IA-1 |

Os dois últimos cartões adiantam o alicerce da Sprint 5.

## Sprint 5: o aluno responde (14/12 a 20/12)

**Meta:** o aluno responde pelo link (API) e o professor entra pela tela de login. No fim desta sprint, o backend está completo.

**Como demonstrar:** em `/docs`, abrir a atividade pelo código do link, enviar respostas e ver a nota nos resultados. No navegador, entrar pela tela de login.

| Ordem | Cartão | Tarefa | Tipo | Tam. | Depende de |
|---|---|---|---|---|---|
| 1 | `ENVIOS-3` (#35) | Rota do link do aluno (questões sem gabarito) | Backend | P | ENVIOS-2, ATIVIDADES-1, INFRA-3 |
| 2 | `ENVIOS-4` (#36) | Receber e corrigir as respostas do aluno | Backend | M | ENVIOS-3, ENVIOS-1 |
| 3 | `ENVIOS-5` (#37) | Resultados da atividade e correção de resposta aberta | Backend | M | ENVIOS-4, AUTH-7 |
| 4 | `INFRA-8` (#8) | Dependência de rotas do frontend (react-router-dom) | Infra | P | — |
| 5 | `FRONTEND-1` (#38) | Rotas, páginas base e cliente da API | Frontend | M | INFRA-8 |
| 6 | `AUTH-8` (#39) | Tela de login | Frontend | M | FRONTEND-1, AUTH-6 |

## Sprint 6: as telas (21/12 a 27/12)

**Meta:** todas as telas navegáveis, com dados de exemplo e login real.

**Como demonstrar:** entrar pelo login e navegar por painel, criar atividade, ver atividade e página do aluno.

| Ordem | Cartão | Tarefa | Tipo | Tam. | Depende de |
|---|---|---|---|---|---|
| 1 | `AUTH-9` (#40) | Guardar o token e proteger as páginas do professor | Frontend | M | AUTH-8 |
| 2 | `FRONTEND-2` (#41) | Painel do professor (visual) | Frontend | M | FRONTEND-1 |
| 3 | `FRONTEND-3` (#42) | Tela de criar atividade (visual) | Frontend | M | FRONTEND-1 |
| 4 | `FRONTEND-4` (#43) | Tela de ver atividade (visual) | Frontend | M | FRONTEND-2 |
| 5 | `FRONTEND-5` (#44) | Página do aluno (visual) | Frontend | M | FRONTEND-1 |

## Sprint 7: ligar tudo e publicar (28/12 a 03/01)

**Meta:** sistema completo, testado de ponta a ponta e publicado.

**Como demonstrar:** no endereço público, entrar como professor, criar uma atividade, baixar o PDF, responder como aluno pelo link e ver o resultado.

| Ordem | Cartão | Tarefa | Tipo | Tam. | Depende de |
|---|---|---|---|---|---|
| 1 | `FRONTEND-6` (#45) | Ligar o painel e a tela de ver atividade à API | Frontend | P | FRONTEND-4, AUTH-9, ATIVIDADES-4 |
| 2 | `FRONTEND-7` (#46) | Ligar a tela de criar atividade à API | Frontend | P | FRONTEND-3, AUTH-9, CURSOS-4, ATIVIDADES-3 |
| 3 | `FRONTEND-8` (#47) | Botões de baixar PDF e copiar link | Frontend | P | FRONTEND-6, ATIVIDADES-5 |
| 4 | `FRONTEND-9` (#48) | Ligar a página do aluno à API | Frontend | P | FRONTEND-5, ENVIOS-4 |
| 5 | `FRONTEND-10` (#49) | Tela de resultados da atividade | Frontend | M | FRONTEND-6, ENVIOS-5 |
| 6 | `INFRA-9` (#50) | Teste completo do sistema na develop | Infra | M | FRONTEND-7, FRONTEND-8, FRONTEND-9, FRONTEND-10, IMPORTADOR-4 |
| 7 | `INFRA-10` (#51) | Promover a develop para a main e publicar | Infra | M | INFRA-9 |

Esta é a sprint com menos folga: o teste completo costuma revelar defeitos. Conte com uma Sprint 8 só para correções.

## Se este projeto tivesse uma equipe

O plano acima é para uma pessoa, por isso o frontend só começa na Sprint 5. Com três pessoas, o frontend correria em paralelo desde a Sprint 1: os cartões "visual" (`FRONTEND-2` a `FRONTEND-5`) não dependem do backend, justamente para isso. O total de trabalho é o mesmo, 36 dias, mas o prazo cairia para cerca de três sprints.

## Se a sua capacidade for menor

Não mude a ordem dos cartões: mude só onde cada sprint termina.

1. Calcule a sua capacidade em dias. Exemplo: 2 horas por dia, 5 dias por semana, são 10 horas, cerca de **1,5 dia** de trabalho por sprint.
2. Percorra a lista na ordem deste documento e vá somando os tamanhos.
3. Quando a soma passar da capacidade, o cartão vai para a sprint seguinte.
4. Reescreva a meta de cada sprint para o que cabe nela.

Com 1,5 dia por sprint, a Sprint 1 fica com `INFRA-4`, `INFRA-3` e `AUTH-1`, e a meta vira "a tabela de usuários existe e as bibliotecas de login estão instaladas".

## O ciclo de uma sprint

| Quando | O que fazer | Tempo |
|---|---|---|
| **Segunda-feira** (planejamento) | Confirmar a meta e a lista. Mover para `Pronto Pra Pegar` os cartões da sprint que não têm dependência pendente | 15 min |
| **Durante a semana** | A cada cartão que chega em `Feito`, mover para `Pronto Pra Pegar` os cartões que ele destravou | 2 min |
| **Sexta-feira** (revisão) | Fazer a demonstração descrita em "Como demonstrar". A meta foi atingida? | 15 min |
| **Sexta-feira** (retrospectiva) | Anotar: o que funcionou, o que atrapalhou, o que mudar na próxima | 10 min |

Lista de conferência do planejamento:

- [ ] A sprint anterior foi fechada: nada dela ficou em `Em Andamento` ou `Em Revisão` sem decisão.
- [ ] A meta cabe em uma frase e dá para demonstrar.
- [ ] Todo cartão da sprint tem o campo `Sprint` preenchido.
- [ ] A soma dos tamanhos não passa da capacidade.
- [ ] Nenhum cartão depende de algo que está em uma sprint futura.
- [ ] Os cartões sem dependência pendente estão em `Pronto Pra Pegar`.

## Como ajustar o plano

O plano vai mudar, e isso é esperado. O que não pode acontecer é mudar sem registrar. Para cada situação, a regra:

### Apareceu uma tarefa nova

1. Crie a Issue com o modelo **Tarefa**. O título segue o padrão `[MODULO-N] Tipo - Nome`, usando o próximo número livre do módulo.
2. Preencha arquivos, dependências, critério de aceite e tamanho. Sem isso o cartão não sai do `Backlog`.
3. Decida a sprint:
   - **Sem ela a meta da sprint atual não se cumpre:** entra na sprint atual, e você **tira** um cartão de tamanho igual, o último da lista.
   - **Pode esperar:** entra na primeira sprint futura em que as dependências dela já estarão prontas.
4. Se algum cartão existente passa a depender dela, edite a seção "Depende de" desse cartão.

A regra de ouro: **entrou um, sai um.** A capacidade da sprint não aumenta porque apareceu trabalho novo.

### Apareceu um defeito (bug)

1. Crie a Issue com a etiqueta `bug`, dizendo: o que você fez, o que esperava e o que aconteceu.
2. Classifique:
   - **Grave** (quebra a `develop`, perde dado, expõe senha ou chave): entra na sprint atual, na frente de tudo.
   - **Atrapalha, mas dá para contornar:** entra na próxima sprint.
   - **Detalhe:** fica no `Backlog` até sobrar tempo.
3. A branch usa o tipo `fix`: `fix/auth-12-login-email-maiusculo`.
4. Todo defeito corrigido ganha um teste que falhava antes da correção. É o que impede o defeito de voltar.

### A tarefa estava errada ou incompleta

- **Ainda não foi começada:** edite o cartão. Se o tamanho mudou, confira a soma da sprint.
- **Já está em andamento:** comente no cartão o que mudou e por quê, e ajuste o critério de aceite. Não troque o critério em silêncio.
- **Já está em `Feito`:** não reabra. Crie um cartão novo (`fix` ou `refactor`) que cita o antigo. O histórico do que foi entregue fica intacto.

### A tarefa é maior do que parecia

Se um cartão `M` passou de um dia e meio, pare e divida: termine a parte que funciona sozinha, abra o PR dela e crie um cartão novo para o restante. PR grande demais não se revisa direito.

### A sprint terminou e sobrou cartão

1. Não estique a sprint. Ela acaba na data, com o que ficou pronto.
2. Cartão não começado volta para `Backlog` ou `Pronto Pra Pegar` e muda o campo `Sprint` para a próxima.
3. Cartão começado continua na próxima sprint, **no topo da lista**.
4. Empurre para a frente o mesmo tanto de cartões do fim da próxima sprint, para a capacidade fechar.
5. Na retrospectiva, anote o motivo: estimativa otimista, dependência esquecida, defeito inesperado. Se acontecer em duas sprints seguidas, a capacidade real é menor do que a planejada: recalcule.

### A sprint terminou antes do prazo

Puxe o primeiro cartão da próxima sprint cujas dependências estão prontas e mude o campo `Sprint` dele para a atual. Se acontecer em duas sprints seguidas, aumente a capacidade.

## Modelos para copiar

### Modelo de sprint

```markdown
## Sprint N: nome curto (dd/mm a dd/mm)

**Meta:** uma frase com o que estará funcionando no fim.

**Como demonstrar:** os passos que provam a meta.

| Ordem | Cartão | Tarefa | Tipo | Tam. | Depende de |
|---|---|---|---|---|---|
| 1 | `MODULO-N` (#00) | Nome da tarefa | Backend | P | — |

**Capacidade:** X dias · **Planejado:** Y dias
```

### Modelo de retrospectiva

```markdown
## Retrospectiva da Sprint N

- **Meta atingida?** sim / não / em parte
- **Planejado:** X cartões (Y dias) · **Feito:** X cartões (Y dias)
- **O que funcionou:**
- **O que atrapalhou:**
- **O que muda na próxima sprint:**
- **Cartões que passaram para a próxima:**
```

### Modelo de cartão de defeito

```markdown
Título: [MODULO-N] Tipo - Corrigir <o que está errado>

**O que eu fiz:** os passos para reproduzir
**O que eu esperava:**
**O que aconteceu:**
**Gravidade:** grave / atrapalha / detalhe

### Critério de aceite
- [ ] O caso acima funciona
- [ ] Existe um teste que falhava antes da correção
```

## Como ver as sprints no quadro

- **Campo `Sprint`:** cada cartão mostra a sprint dele. Para mudar, abra o cartão e troque o valor do campo.
- **Filtro da sprint em andamento:** na caixa de filtro do quadro, digite `sprint:@current`. Para a próxima, `sprint:@next`.
- **Criar sprints novas:** no quadro, **três pontinhos → Settings → Sprint → Add iteration**.
