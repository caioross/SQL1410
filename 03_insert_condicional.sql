-- 03_insert_condicional.sql

USE db1410_vendas;
GO

DROP TABLE IF EXISTS pedidos;
CREATE TABLE pedidos (
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	produto_id INT,
	quantidade INT,
	valor_total DECIMAL(10,2),
	data_pedido DATETIME,
	status_pedido VARCHAR(50)
);

CREATE SEQUENCE seq_pedido_id
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 10000000
	CACHE 10;

--- executar a partir daqui

DECLARE @cliente_id INT = 2;
DECLARE @produto_id INT = 4;
DECLARE @quantidade INT = 2;
DECLARE @valor_total DECIMAL (10,2);
DECLARE @status_pedido VARCHAR(50);

SELECT @valor_total = p.preco * @quantidade
FROM produtos p
WHERE p.produto_id = @produto_id;

IF @quantidade <= 0
BEGIN
	PRINT 'Erro: Quantidade invalida para o pedido';
	SET @status_pedido ='Erro';
END

-- Valores dos pedidos menor que 500 s�o invalidos

ELSE IF @valor_total < 500
BEGIN
	PRINT 'O Valor pedido � inferior a R$500,00';
	SET @status_pedido = 'Erro';
END

ELSE
	BEGIN
		PRINT 'Pedido valido. Realizando a inser��o na tabela...';
		SET @status_pedido = 'Pendente';

		INSERT INTO pedidos (
			pedido_id,
			cliente_id,
			produto_id,
			quantidade,
			valor_total,
			data_pedido,
			status_pedido
		) VALUES ( NEXT VALUE FOR
			seq_pedido_id,
			@cliente_id,
			@produto_id,
			@quantidade,
			@valor_total,
			GETDATE(),
			@status_pedido
		);
	END

SELECT * FROM pedidos 
