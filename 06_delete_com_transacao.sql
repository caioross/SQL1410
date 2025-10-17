-- 06_delete_com_transacao.sql

USE db1410_empresaMuitoLegal
GO

DROP TABLE IF EXISTS pedidos
CREATE TABLE pedidos (
	pedido_id INT PRIMARY KEY IDENTITY(1,1),
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL(10,2),
	FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- confirme se possui clientes e veja seus IDs
SELECT * FROM clientes
SELECT * FROM pedidos

INSERT INTO pedidos
(cliente_id, data_pedido, valor_total)
VALUES
(1, '2025-01-01', 150.00),
(2, '2025-01-02', 170.00),
(3, '2025-01-04', 250.00),
(4, '2025-01-08', 380.00);


BEGIN TRY
	BEGIN TRANSACTION
		DELETE FROM pedidos WHERE cliente_id = 3;
		DELETE FROM pedidos WHERE cliente_id = 4;
	COMMIT TRANSACTION;
	PRINT 'Exclusões foram realizadas com sucesso!'
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 
	BEGIN
		ROLLBACK TRANSACTION
	END
	PRINT 'Erro durante a exclusão: ' + ERROR_MESSAGE();
END CATCH