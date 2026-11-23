-- =====================================================================
-- 01_legado_ddl_dml.sql  |  ESTADO ORIGINAL (antes da refatoração)
-- Cenário 6 – App de Delivery de Comida
-- Problema: itens do pedido salvos separados por vírgula em lista_produtos
-- SGBD: PostgreSQL 16
-- =====================================================================
DROP SCHEMA IF EXISTS legado CASCADE;
CREATE SCHEMA legado;

CREATE TABLE legado.pedidos (
    id_pedido      SERIAL PRIMARY KEY,
    cliente_nome   VARCHAR(100) NOT NULL,
    cliente_fone   VARCHAR(20),
    restaurante    VARCHAR(100) NOT NULL,
    lista_produtos TEXT         NOT NULL,   -- ex.: 'X-Burger, Batata Frita, Coca-Cola 350ml'
    valor_total    NUMERIC(10,2) NOT NULL,
    status         VARCHAR(20)  NOT NULL,
    data_pedido    TIMESTAMP    NOT NULL
);

INSERT INTO legado.pedidos (cliente_nome, cliente_fone, restaurante, lista_produtos, valor_total, status, data_pedido) VALUES
('Ana Souza',   '11990000001', 'Burger House',  'X-Burger, Batata Frita, Coca-Cola 350ml',            52.90, 'ENTREGUE',  '2026-11-01 19:10'),
('Bruno Lima',  '11990000002', 'Pizzaria Napoli','Pizza Margherita, Coca-Cola 2L',                    68.00, 'ENTREGUE',  '2026-11-01 20:05'),
('Ana Souza',   '11990000001', 'Burger House',  'X-Burger, X-Burger, Batata Frita',                    71.70, 'ENTREGUE',  '2026-11-03 12:40'),
('Carla Dias',  '11990000003', 'Sushi Kento',   'Combo Sushi 20 peças, Temaki Salmão',                 89.90, 'ENTREGUE',  '2026-11-04 21:15'),
('Bruno Lima',  '11990000002', 'Pizzaria Napoli','Pizza Calabresa, Pizza Margherita, Coca-Cola 2L',   112.00,'ENTREGUE',  '2026-11-06 19:55'),
('Diego Alves', '11990000004', 'Burger House',  'X-Bacon, Batata Frita, Coca-Cola 350ml',              58.90, 'CANCELADO', '2026-11-07 13:20'),
('Carla Dias',  '11990000003', 'Sushi Kento',   'Temaki Salmão, Temaki Salmão, Yakisoba',              74.50, 'EM_ROTA',   '2026-11-09 20:30'),
('Ana Souza',   '11990000001', 'Pizzaria Napoli','Pizza Calabresa, Coca-Cola 2L',                      70.00, 'PREPARANDO','2026-11-10 19:00'),
('Diego Alves', '11990000004', 'Burger House',  'X-Burger, Coca-Cola 350ml',                           38.90, 'ENTREGUE',  '2026-11-10 12:15'),
('Bruno Lima',  '11990000002', 'Burger House',  'X-Bacon, X-Burger, Batata Frita, Batata Frita',       97.60, 'ENTREGUE',  '2026-11-11 20:45');
