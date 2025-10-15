-- 02_insert_variaveis_avancado.sql

USE db1410_vendas;
GO

-- insere a colna de valor total que falta na tabela de vendas
ALTER TABLE vendas 
ADD valor_total DECIMAL(10,2);

/*
	a logica aqui é realizar multiplas inserções
	de forma controlada, usando variaveis
	para armazenar os dados
*/

-- iniciar a transação
BEGIN TRANSACTION;


DECLARE @cliente_id INT = 1; -- Cliente para o pedido (caio)
DECLARE @produto_id INT = 2; -- Produto Comprado (Notebook)
DECLARE @quantidade INT = 3; -- Quantidade comprada (3 unidades)
DECLARE @valor_total DECIMAL (10,2); -- Valor total do pedido
DECLARE @data_venda DATETIME = GETDATE(); -- Data Atual da venda
DECLARE @status_transacao VARCHAR(50);

SELECT @