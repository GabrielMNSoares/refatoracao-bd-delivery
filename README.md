# Refatoração do Banco de Dados – App de Delivery (Cenário 6)

Exercício 6 – Sprint Ágil de Refatoração de Banco de Dados (em dupla) – turma 1CDD1.

**Dupla:** Arthur Dias (Integrante A – Product Owner / Revisor) e Gabriel Marcelino (Integrante B – Scrum Master / Desenvolvedor).

**Quadro Kanban:** https://trello.com/b/GTRHJirs

## Problema

A tabela `Pedidos` guardava os itens do pedido em `lista_produtos`, um texto separado por vírgula
(ex.: `'X-Burger, Batata Frita, Coca-Cola 350ml'`). Isso viola a 1ª Forma Normal e impede relatórios
de pratos mais vendidos. Nome e telefone do cliente e nome do restaurante se repetiam a cada pedido,
e não havia chaves estrangeiras nem índices.

## Solução

Modelo em 3FN com cinco tabelas – `clientes`, `restaurantes`, `produtos`, `pedidos` e `itens_pedido` –
com PKs, FKs, CHECKs e índices. Os dados antigos são migrados separando a lista em linhas.

## Scripts (PostgreSQL 16)

| Arquivo | Conteúdo | Branch |
|---|---|---|
| `sql/01_legado_ddl_dml.sql` | Estado original (antes da refatoração) | `main` |
| `docs/modelagem-der.md` | DER em 3FN | `feature/modelagem-3fn` |
| `sql/02_ddl_tabelas.sql` | Tabelas, PKs, FKs e restrições | `feature/ddl-tabelas` |
| `sql/03_indices.sql` | Índices | `feature/indices` |
| `sql/04_migracao_dml.sql` | Migração de `lista_produtos` para `itens_pedido` | `feature/migracao-dml` |
| `sql/05_testes_validacao.sql` + `sql/run.sh` | Testes de validação dos dados | `test/validacao-dados` |
| `sql/06_consulta_mais_vendidos.sql` | Pratos mais vendidos e histórico por cliente | `feature/consulta-mais-vendidos` |
| `docs/backlog.md` | Backlog e planejamento da sprint | `docs/backlog` |
| `docs/relatorio-sprint.pdf` | Relatório da Sprint | `docs/relatorio` |

Para executar tudo em ordem:

```
cd sql && sh run.sh
```

## Fluxo de trabalho

Cada tarefa é feita em uma branch própria e entra na `main` por Pull Request revisado e aprovado pelo parceiro.
