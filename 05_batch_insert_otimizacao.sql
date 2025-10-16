-- 05_batch_insert_otimizacao.sql

/*
Este script demonstra cmo realizar inserções em lote 
utilizando as transações
Ou seja, inserir um grande volume de dados de forma 
eficiente dividindo em pequenos lotes 
('batches' ou 'chunks')
*/

USE db1410_empresaMuitoLegal;
GO

CREATE TABLE vendas (
	vendas_id INT IDENTITY(1,1) PRIMARY KEY,
	cliente_id INT,
	produto_id INT,
	quantidade INT,
	valor_total DECIMAL(10,2),
	data_venda DATETIME
);

-- Variaveis para o controle dos lotes
DECLARE @batch_size INT = 1000;
DECLARE @total_registros INT = 10000;
DECLARE @contador INT = 0;

-- tenta executar essa transação
BEGIN TRY
	
END TRY
BEGIN CATCH
	-- caso ocorra algum erro realizamos um rollback da transação
END CATCH