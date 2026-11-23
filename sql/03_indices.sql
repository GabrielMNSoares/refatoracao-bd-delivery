-- =====================================================================
-- 03_indices.sql  |  ÍNDICES
-- Cenário 6 – App de Delivery de Comida
-- Acelera: histórico por cliente, pedidos por restaurante, filtros por
-- data/status e o relatório de pratos mais vendidos.
-- =====================================================================
SET search_path TO delivery;

-- Índices (FKs e filtros mais usados em relatórios)
CREATE INDEX idx_pedidos_cliente      ON pedidos (id_cliente);
CREATE INDEX idx_pedidos_restaurante  ON pedidos (id_restaurante);
CREATE INDEX idx_pedidos_data         ON pedidos (data_pedido);
CREATE INDEX idx_pedidos_status_data  ON pedidos (status, data_pedido);
CREATE INDEX idx_itens_produto        ON itens_pedido (id_produto);
