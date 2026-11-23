# Modelagem – DER em 3ª Forma Normal

## Antes

Uma única tabela `pedidos` com `lista_produtos` em texto (vários produtos na mesma coluna) e os dados do
cliente e do restaurante repetidos em cada linha.

## Depois

```mermaid
erDiagram
    CLIENTES ||--o{ PEDIDOS : faz
    RESTAURANTES ||--o{ PEDIDOS : recebe
    RESTAURANTES ||--o{ PRODUTOS : oferece
    PEDIDOS ||--|{ ITENS_PEDIDO : contem
    PRODUTOS ||--o{ ITENS_PEDIDO : aparece_em

    CLIENTES {
        int id_cliente PK
        varchar nome
        varchar telefone UK
    }
    RESTAURANTES {
        int id_restaurante PK
        varchar nome UK
    }
    PRODUTOS {
        int id_produto PK
        int id_restaurante FK
        varchar nome
        numeric preco_atual
    }
    PEDIDOS {
        int id_pedido PK
        int id_cliente FK
        int id_restaurante FK
        varchar status
        timestamp data_pedido
        numeric valor_total
    }
    ITENS_PEDIDO {
        int id_pedido PK, FK
        int id_produto PK, FK
        int quantidade
        numeric preco_unitario
    }
```

## Decisões

- **1FN:** cada produto do pedido vira uma linha em `itens_pedido`; nomes repetidos na lista viram `quantidade`.
- **2FN:** em `itens_pedido`, a PK é composta (`id_pedido`, `id_produto`) e `quantidade` e `preco_unitario` dependem dela inteira.
- **3FN:** dados do cliente e do restaurante saem de `pedidos` e ficam em tabelas próprias, ligadas por FK.
- **Preço:** `preco_unitario` fica gravado no item para manter o valor histórico mesmo se o cardápio mudar.
