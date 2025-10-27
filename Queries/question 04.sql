- Criaria uma FT_DADOS_CLIENTE que traria informações de cada cliente (dados sensíveis) e um campo de data (dt_ultima_atualizacao) trazendo um dado mais recente do cliente e assim não perderia o 
histórico.
Por exemplo: JOÃO tem um endereço av. pará, 342, Belém-PA. João Trocou o endereço para av. josé campos, 211, Curitiba-PR. Diferentemente de uma tabela Dimensão (que traria apenas o dado
mais recente do cliente), tendo uma tabela fato, uma linha existiria para o primeiro endereço e outra linha para o segundo endereço (mantendo o historico de alterações) e para ver o dado mais
recente do cliente pegaria a MAX(dt_ultima_atualizacao) agrupado por id_cliente.

- Utilizaria um RBAC (controle de acesso restrito) para armazenar esses dados sensíveis de cada cliente, apenas algumas equipes teriam permissão.


---- FT_DADOS_CLIENTE:

CREATE TABLE FT_DADOS_CLIENTE (
    id_fato_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    nome_cliente TEXT NOT NULL,
    cpf TEXT,
    endereco TEXT,
    cidade TEXT,
    estado TEXT,
    cep TEXT,
    telefone TEXT,
    email TEXT,
    dt_ultima_atualizacao DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES DIM_CLIENTE(id_cliente)
);


-- João Silva
INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (1, 'João Silva', '123.456.789-00', 'Av. Pará, 342', 'Belém', 'PA', '66000-000', '(91) 99999-1234', 'joao@email.com', '2024-01-10');

INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (1, 'João Silva', '123.456.789-00', 'Av. José Campos, 211', 'Curitiba', 'PR', '80000-000', '(41) 98888-4321', 'joao@email.com', '2025-03-15');

-- Maria Oliveira
INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (2, 'Maria Oliveira', '987.654.321-00', 'Rua das Flores, 45', 'Recife', 'PE', '50000-000', '(81) 98877-1122', 'maria.oliveira@email.com', '2024-02-20');

INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (2, 'Maria Oliveira', '987.654.321-00', 'Av. Atlântica, 900', 'Rio de Janeiro', 'RJ', '22000-000', '(21) 97777-8899', 'maria.oliveira@email.com', '2025-04-08');

-- Pedro Santos
INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (3, 'Pedro Santos', '555.444.333-22', 'Rua Central, 120', 'Curitiba', 'PR', '80010-000', '(41) 91234-5678', 'pedro.santos@email.com', '2024-03-10');

INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (3, 'Pedro Santos', '555.444.333-22', 'Rua das Palmeiras, 80', 'Florianópolis', 'SC', '88000-000', '(48) 97654-3210', 'pedro.santos@email.com', '2025-01-05');

-- Ana Souza
INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (4, 'Ana Souza', '222.333.444-55', 'Av. Brasil, 1000', 'São Paulo', 'SP', '01000-000', '(11) 98888-5555', 'ana.souza@email.com', '2024-04-01');

INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (4, 'Ana Souza', '222.333.444-55', 'Rua das Acácias, 50', 'Campinas', 'SP', '13000-000', '(19) 97777-6666', 'ana.souza@email.com', '2025-02-20');

-- Carlos Mendes
INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (5, 'Carlos Mendes', '111.222.333-44', 'Rua Afonso Pena, 234', 'Belo Horizonte', 'MG', '30130-000', '(31) 99999-8888', 'carlos.mendes@email.com', '2024-05-15');

INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (5, 'Carlos Mendes', '111.222.333-44', 'Av. Goiás, 120', 'Goiânia', 'GO', '74000-000', '(62) 98888-9999', 'carlos.mendes@email.com', '2025-06-01');

-- Beatriz Lima
INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (6, 'Beatriz Lima', '444.555.666-77', 'Rua dos Girassóis, 70', 'Natal', 'RN', '59000-000', '(84) 98811-2233', 'beatriz.lima@email.com', '2024-06-22');

INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (6, 'Beatriz Lima', '444.555.666-77', 'Av. Paulista, 1500', 'São Paulo', 'SP', '01310-000', '(11) 97711-3344', 'beatriz.lima@email.com', '2025-01-10');

-- Felipe Alves
INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (7, 'Felipe Alves', '777.888.999-00', 'Rua 7 de Setembro, 98', 'Porto Alegre', 'RS', '90000-000', '(51) 91234-1111', 'felipe.alves@email.com', '2024-02-14');

INSERT INTO FT_DADOS_CLIENTE (id_cliente, nome_cliente, cpf, endereco, cidade, estado, cep, telefone, email, dt_ultima_atualizacao)
VALUES (7, 'Felipe Alves', '777.888.999-00', 'Av. das Torres, 500', 'Joinville', 'SC', '89200-000', '(47) 98888-0000', 'felipe.alves@email.com', '2025-05-05');

---- Pegando o último dado de cada cliente:

SELECT f.*
FROM FT_DADOS_CLIENTE f
INNER JOIN (
    SELECT id_cliente, MAX(dt_ultima_atualizacao) AS max_data
    FROM FT_DADOS_CLIENTE
    GROUP BY id_cliente
) c
ON f.id_cliente = c.id_cliente AND f.dt_ultima_atualizacao = c.max_data;

SELECT * 
FROM FT_DADOS_CLIENTE f
WHERE f.nome_cliente like '%João Silva%'


---- RBAC_USUARIO (ROLE-BASED ACCESS CONTROL)

CREATE TABLE RBAC_USUARIO (
    id_usuario INTEGER PRIMARY KEY,
    nome_usuario TEXT NOT NULL,
    papel TEXT CHECK(papel IN ('ADMIN', 'SEGURANCA', 'MARKETING', 'OPERACIONAL'))
);

INSERT INTO RBAC_USUARIO (id_usuario, nome_usuario, papel) VALUES
(1, 'Ana (Admin)', 'ADMIN'),
(2, 'Carlos (Segurança)', 'SEGURANCA'),
(3, 'Beatriz (Marketing)', 'MARKETING'),
(4, 'Rafael (Operacional)', 'OPERACIONAL');


--- CRIANDO VIEW CHAMADA VW_FT_DADOS_CLIENTE_COMPLETO

CREATE VIEW VW_FT_DADOS_CLIENTE_COMPLETO AS
SELECT *
FROM FT_DADOS_CLIENTE;


--- CRIANDO VIEW CHAMADAS VW_FT_DADOS_CLIENTE_LIMITADO

CREATE VIEW VW_FT_DADOS_CLIENTE_LIMITADO AS
SELECT 
    id_cliente,
    '*** DADO RESTRITO ***' AS cpf,
    SUBSTR(endereco, 1, 5) || '...' AS endereco,
    cidade,
    estado,
    dt_ultima_atualizacao
FROM FT_DADOS_CLIENTE;

SELECT * FROM VW_FT_DADOS_CLIENTE_COMPLETO


SELECT * FROM VW_FT_DADOS_CLIENTE_LIMITADO