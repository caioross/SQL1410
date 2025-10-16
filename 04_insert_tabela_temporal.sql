-- 04_insert_tabela_temporal.sql

CREATE DATABASE db1410_empresaMuitoLegal;
GO

USE db1410_empresaMuitoLegal;
GO


CREATE TABLE clientes (
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	email_cliente VARCHAR(100),
	/* 
		datetime2 gera a data e hora com precisao
		a generated: essa coluna � gerada automaticamente pelo sistema 
		e marca o inicio do periodo de validade do registro
		(quando o registro se tornou atual)
		hidden: essa coluna nao aparece em selects padrao
		s� aparece se vc especificar ela diretamente
	*/
	data_inicio DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN,
	data_fim DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN,
	-- definir periodo de tempo durante o qual o registro � valido
	PERIOD FOR SYSTEM_TIME (data_inicio, data_fim)
) 
-- ativando o versionamento do sistema e criando uma tabela de historico
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.clientes_historico));
/* 
	cria a tabela de historico que armazenar� as versoes anteriores dos
	dados, por padrao o sql cria essa tabela automaticamente quando o 
	versionamento � habilitado, mas podemos criar explicitamente se 
	desejado
*/


CREATE TABLE clientes_historico(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	email_cliente VARCHAR(100),
	data_inicio DATETIME2,
	data_fim DATETIME2
);

INSERT INTO clientes (cliente_id, nome_cliente, email_cliente) VALUES
(6, 'Caio', 'caio@gmail.com'),
(7, 'Gustavo', 'gustavo@gmail.com'),
(8, 'Rodrigo', 'rodrigo@gmail.com'),
(9, 'Rafael', 'rafael@gmail.com')


SELECT * FROM clientes

UPDATE clientes
SET 
	nome_cliente = 'Caio Rossi',
	email_cliente = 'sem_email@gmail.com'
WHERE cliente_id = 6;

SELECT * FROM clientes_historico;

/*
	Inserindo dados em uma tabela temporaria
	essas tabelas sao uteis para armazenar dados temporarios
	que nao precisam persistir no banco de dados
*/
CREATE TABLE #clientes_temporarios (
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	email_cliente VARCHAR(100)
);

INSERT INTO #clientes_temporarios
(cliente_id, nome_cliente, email_cliente)
VALUES
(11, 'Albert Einstein', 'emc@gmail.com'),
(12, 'Stephen Hawking', 'hipervoid@gmail.com')

SELECT * FROM #clientes_temporarios