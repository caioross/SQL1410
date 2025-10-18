-- 09_alter_avancada.sql

CREATE DATABASE db1410_alterAvancada;
GO

USE db1410_alterAvancada;
GO

DROP TABLE IF EXISTS clientes;
CREATE TABLE clientes (
	cliente_id INT,
	nome_cliente VARCHAR(100),
	data_cadastro DATETIME
	/*
		em resumo: "crie uma restrição chamada PK_clientes_cliente_id
		que torne a coluna cliente_id a chave primaria da tabela"
		Isso garante a unicidade e identificação exclusiva de cada
		cliente na tabela clientes
	*/
	CONSTRAINT PK_clientes_cliente_id PRIMARY KEY (cliente_id)
);

INSERT INTO clientes
(cliente_id, nome_cliente, data_cadastro)
VALUES
(1, 'Caio', '2025-01-02'),
(2, 'Rodrigo', '2025-01-03'),
(3, 'Rafael', '2025-01-04'),
(4, 'Gustavo', '2025-01-05');

-- Passo 01: Remover a chave primaria existente
ALTER TABLE clientes
DROP CONSTRAINT PK_clientes_cliente_id;

-- Passo 02: Adicionar uma nova chave 
ALTER TABLE clientes
ADD CONSTRAINT PK_clientes_cliente_id_2 PRIMARY KEY (cliente_id);



-- Adicionando um indice para otimizar a consulta
-- por data nesse exemplo
CREATE NONCLUSTERED INDEX IX_clientes_data_cadastro 
ON clientes(data_cadastro);

-- Alterar um tipo... coisa simples!!!!
ALTER TABLE clientes
ALTER COLUMN nome_cliente TEXT;

-- Adicionando uma nova coluna
ALTER TABLE clientes
ADD email_cliente VARCHAR(150);

-- Verificar se o indice existe na tabela
SELECT * FROM sys.indexes WHERE name = 'IX_clientes_data_cadastro' ;

-- provando que funciona =)
ALTER TABLE clientes
DROP CONSTRAINT PK_clientes_cliente_id_2

