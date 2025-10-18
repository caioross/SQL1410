-- 08_delete_eficiente.sql

--CREATE DATABASE db1410_eficiente;
--GO

USE db1410_eficiente;
GO

DROP TABLE IF EXISTS clientes
CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	data_cadastro DATETIME
);

DROP TABLE IF EXISTS pedidos
CREATE TABLE pedidos(
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL(10,2)
);

INSERT INTO clientes (cliente_id, nome_cliente, data_cadastro)
SELECT TOP 100000
/*
gerar o valor sequencial de 1 até o inf por cada linha
O over exige ordenar, isso é um truque do instrutor
para dizer que nao quero em ordem pre-definida
*/
-- Gerar o cliente_id
ROW_NUMBER() OVER( ORDER BY (SELECT NULL)),
-- Gerar o nome_cliente com o numero da linha ex: "Cliente: 3432"
'Cliente: ' + 
	CAST(ROW_NUMBER() OVER( ORDER BY (SELECT NULL)) AS VARCHAR(10)),
--Gerar a data_cadastro da data de hoje subtraindo do dia o numero da linha 
DATEADD(DAY, -(ROW_NUMBER() OVER( ORDER BY (SELECT NULL)) % 3650), GETDATE())
FROM master.dbo.spt_values a , master.dbo.spt_values b;

-- Truncate remove todas as linhas da tabela, ele é mais eficiente
-- que o delete pois não registra a remoção das linhas
-- TRUNCATE TABLE clientes;

INSERT INTO pedidos (pedido_id, cliente_id, data_pedido, valor_total)
SELECT TOP 100000
	ROW_NUMBER() OVER( ORDER BY (SELECT NULL)),
	(ABS(CHECKSUM(NEWID())) % 100000) + 1,
	DATEADD(
		DAY, 
		-(ROW_NUMBER() OVER( ORDER BY (SELECT NULL)) % 3650),
		GETDATE()
	),
	CAST(RAND() * 1000 AS DECIMAL(10,2))
FROM master.dbo.spt_values a, master.dbo.spt_values b;

-- para ver os 10 primeiros registros de cada tabela
SELECT TOP 10 * FROM clientes
SELECT TOP 10 * FROM pedidos

-- para ver a quantidade de registros em cada tabela
SELECT COUNT(*) AS Quantidade FROM clientes
SELECT COUNT(*) AS Quantidade FROM pedidos

BEGIN TRY 
	BEGIN TRANSACTION
	-- declarando as variaveis de controle do lote
		DECLARE @batch_size INT = 1000;
		DECLARE @row_count INT;

		-- inicializando a variavel de controle da contagem de
		-- registros exclusivos
		SET @row_count = 1

		-- looping para excluir os dados em lote
		WHILE @row_count > 0 
			BEGIN
				-- Excluir os dados em lotes de 1000
				DELETE TOP (@batch_size)
				FROM clientes
				WHERE data_cadastro < DATEADD(YEAR, -5, GETDATE());

				-- obtendo a contagem de registros na iteração atual
				SET @row_count = @@ROWCOUNT;

				-- exibindo o progresso
				PRINT 'Excluidos' + 
				CAST(@row_count AS VARCHAR) + 
				' registros de clientes'

				-- esperar 1 segundo entre lotes, visando evitar blocks
				-- por parte do servidor
				WAITFOR DELAY '00:00:01';
			END
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF  @@TRANCOUNT > 0 
	BEGIN
		ROLLBACK TRANSACTION;
	END
	PRINT 'Erro durante a exclusão:' + ERROR_MESSAGE();
END CATCH;