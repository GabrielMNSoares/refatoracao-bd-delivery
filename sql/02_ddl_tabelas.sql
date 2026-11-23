-- =====================================================================
-- 02_ddl_tabelas.sql  |  NOVA ESTRUTURA (3FN) – tabelas, PKs, FKs e CHECKs
-- Cenário 6 – App de Delivery de Comida
-- Resolve: 1FN violada (lista em uma coluna), redundância de cliente e
-- restaurante e ausência de chaves estrangeiras. Índices: 03_indices.sql
-- =====================================================================
DROP SCHEMA IF EXISTS delivery CASCADE;
CREATE SCHEMA delivery;
SET search_path TO delivery;

CREATE TABLE clientes (
    id_cliente  SERIAL       PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL,
    telefone    VARCHAR(20)  NOT NULL,
    CONSTRAINT uq_clientes_telefone UNIQUE (telefone)
);

CREATE TABLE restaurantes (
    id_restaurante SERIAL       PRIMARY KEY,
    nome           VARCHAR(100) NOT NULL,
    CONSTRAINT uq_restaurantes_nome UNIQUE (nome)
);

CREATE TABLE produtos (
    id_produto     SERIAL        PRIMARY KEY,
    id_restaurante INT           NOT NULL REFERENCES restaurantes (id_restaurante),
    nome           VARCHAR(100)  NOT NULL,
    preco_atual    NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (preco_atual >= 0),
    CONSTRAINT uq_produto_restaurante UNIQUE (id_restaurante, nome)
);

CREATE TABLE pedidos (
    id_pedido      SERIAL        PRIMARY KEY,
    id_cliente     INT           NOT NULL REFERENCES clientes (id_cliente),
    id_restaurante INT           NOT NULL REFERENCES restaurantes (id_restaurante),
    status         VARCHAR(20)   NOT NULL
                   CHECK (status IN ('PREPARANDO','EM_ROTA','ENTREGUE','CANCELADO')),
    data_pedido    TIMESTAMP     NOT NULL DEFAULT now(),
    valor_total    NUMERIC(10,2) NOT NULL CHECK (valor_total >= 0)
);

-- Tabela associativa: 1 pedido tem N itens; 1 produto aparece em N pedidos
CREATE TABLE itens_pedido (
    id_pedido      INT           NOT NULL REFERENCES pedidos  (id_pedido)  ON DELETE CASCADE,
    id_produto     INT           NOT NULL REFERENCES produtos (id_produto),
    quantidade     INT           NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
    PRIMARY KEY (id_pedido, id_produto)
);
