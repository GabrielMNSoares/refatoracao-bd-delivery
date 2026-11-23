-- =====================================================================
-- 04_migracao_dml.sql  |  MIGRAÇÃO legado.pedidos -> delivery.*
-- Itens repetidos na lista viram quantidade (ex.: 'X-Burger, X-Burger' = 2).
-- Preço unitário: não existia no legado; usamos o preço médio do pedido
-- (valor_total / nº de itens) como ESTIMATIVA e documentamos isso.
-- =====================================================================
SET search_path TO delivery;

-- 1) Clientes (distintos por telefone)
INSERT INTO clientes (nome, telefone)
SELECT DISTINCT ON (cliente_fone) cliente_nome, cliente_fone
FROM legado.pedidos
ORDER BY cliente_fone, data_pedido DESC;

-- 2) Restaurantes
INSERT INTO restaurantes (nome)
SELECT DISTINCT restaurante FROM legado.pedidos;

-- 3) Pedidos (preserva o id original para rastreabilidade)
INSERT INTO pedidos (id_pedido, id_cliente, id_restaurante, status, data_pedido, valor_total)
SELECT p.id_pedido, c.id_cliente, r.id_restaurante, p.status, p.data_pedido, p.valor_total
FROM legado.pedidos p
JOIN clientes     c ON c.telefone = p.cliente_fone
JOIN restaurantes r ON r.nome     = p.restaurante;

SELECT setval(pg_get_serial_sequence('delivery.pedidos','id_pedido'),
              (SELECT MAX(id_pedido) FROM pedidos));

-- 4) "Explodir" a lista separada por vírgula em linhas
CREATE TEMP TABLE tmp_itens AS
SELECT p.id_pedido,
       r.id_restaurante,
       btrim(item)                                        AS produto,
       p.valor_total,
       COUNT(*) OVER (PARTITION BY p.id_pedido)           AS qtd_itens_pedido
FROM legado.pedidos p
JOIN restaurantes r ON r.nome = p.restaurante
CROSS JOIN LATERAL unnest(string_to_array(p.lista_produtos, ',')) AS item;

-- 5) Catálogo de produtos
INSERT INTO produtos (id_restaurante, nome, preco_atual)
SELECT id_restaurante, produto,
       ROUND(AVG(valor_total / qtd_itens_pedido), 2)
FROM tmp_itens
GROUP BY id_restaurante, produto;

-- 6) Itens do pedido
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario)
SELECT t.id_pedido, pr.id_produto, COUNT(*), pr.preco_atual
FROM tmp_itens t
JOIN produtos pr ON pr.id_restaurante = t.id_restaurante AND pr.nome = t.produto
GROUP BY t.id_pedido, pr.id_produto, pr.preco_atual;

DROP TABLE tmp_itens;
