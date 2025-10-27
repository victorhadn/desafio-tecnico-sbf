Transformar a DIM_META em uma FATO_META tendo em vista que metas podem ser alteradas a cada mês e ano.

Já tem uma DIM_CALENDARIO com os dados imputados do csv, eu já chamei ela de DIM_CALENDARIO, mas deve existir uma DIM_CALENDARIO_COMPLETO com dados dos 365 dias do ano (366 se for ano bissexto).

Criar uma DIM_CLIENTE respeitando as diretrizes da LGPD e não trazer dados sensíveis do cliente, por exemplo (cpf, endereço, telefone, etc)
Teria apenas os seguintes campos: id_cliente, uf_cliente, regiao_uf, dt_ultima_compra.

Criaria a DIM_TRANSPORTADORA para se relacionar com a FATO_PEDIDO com os campos id_transportadora, nome_transportadora e cnpj.

Transformaria a FATO_PEDIDO em uma FATO_VENDAS e o campo data se tornaria dt_venda, traria também o id_cliente, id_data, id_produto e alguns outras colunas como desconto, valor_com_desconto, 
valor_frete (se houvesse) e id_transportadora.

Criaria uma DIM_ESTADO com os campos de UF, estado, capital, regiao_uf.

Criaria uma FATO_ESTOQUE com os campos de id_produto, nome_produto, categoria, marca, id_marca, qtd_estoque

Criaria uma DIM_CATEGORIA com os campos id_categoria, categoria, super_categoria, id_marca, marca.

---- DIM_CALENDARIO_COMPLETA:

CREATE TABLE DIM_CALENDARIO_COMPLETA (
    id_data INT PRIMARY KEY,
    data_completa DATE NOT NULL,
    dia INT NOT NULL,
    mes INT NOT NULL,
    ano INT NOT NULL,
    nome_mes VARCHAR(20) NOT NULL,
    nome_mes_abreviado VARCHAR(3) NOT NULL,
    dia_semana VARCHAR(20) NOT NULL,
    dia_semana_abreviado VARCHAR(3) NOT NULL,
    fim_de_semana BOOLEAN NOT NULL,
    trimestre INT NOT NULL,
    semestre INT NOT NULL,
    feriado BOOLEAN DEFAULT FALSE,
    nome_feriado VARCHAR(50),
    ano_bissexto BOOLEAN NOT NULL
);

WITH RECURSIVE calendario AS (
  SELECT DATE('2024-01-01') AS data
  UNION ALL
  SELECT DATE(data, '+1 day')
  FROM calendario
  WHERE data < '2024-12-31'
)
INSERT INTO DIM_CALENDARIO_COMPLETA (
    id_data,
    data_completa,
    dia,
    mes,
    ano,
    nome_mes,
    nome_mes_abreviado,
    dia_semana,
    dia_semana_abreviado,
    fim_de_semana,
    trimestre,
    semestre,
    feriado,
    nome_feriado,
    ano_bissexto
)
SELECT
    CAST(STRFTIME('%Y%m%d', data) AS INTEGER) AS id_data,
    data AS data_completa,
    CAST(STRFTIME('%d', data) AS INTEGER) AS dia,
    CAST(STRFTIME('%m', data) AS INTEGER) AS mes,
    CAST(STRFTIME('%Y', data) AS INTEGER) AS ano,
    CASE STRFTIME('%m', data)
        WHEN '01' THEN 'Janeiro'
        WHEN '02' THEN 'Fevereiro'
        WHEN '03' THEN 'Março'
        WHEN '04' THEN 'Abril'
        WHEN '05' THEN 'Maio'
        WHEN '06' THEN 'Junho'
        WHEN '07' THEN 'Julho'
        WHEN '08' THEN 'Agosto'
        WHEN '09' THEN 'Setembro'
        WHEN '10' THEN 'Outubro'
        WHEN '11' THEN 'Novembro'
        WHEN '12' THEN 'Dezembro'
    END AS nome_mes,
    CASE STRFTIME('%m', data)
        WHEN '01' THEN 'Jan'
        WHEN '02' THEN 'Fev'
        WHEN '03' THEN 'Mar'
        WHEN '04' THEN 'Abr'
        WHEN '05' THEN 'Mai'
        WHEN '06' THEN 'Jun'
        WHEN '07' THEN 'Jul'
        WHEN '08' THEN 'Ago'
        WHEN '09' THEN 'Set'
        WHEN '10' THEN 'Out'
        WHEN '11' THEN 'Nov'
        WHEN '12' THEN 'Dez'
    END AS nome_mes_abreviado,
    CASE STRFTIME('%w', data)
        WHEN '0' THEN 'Domingo'
        WHEN '1' THEN 'Segunda'
        WHEN '2' THEN 'Terça'
        WHEN '3' THEN 'Quarta'
        WHEN '4' THEN 'Quinta'
        WHEN '5' THEN 'Sexta'
        WHEN '6' THEN 'Sábado'
    END AS dia_semana,
    CASE STRFTIME('%w', data)
        WHEN '0' THEN 'Dom'
        WHEN '1' THEN 'Seg'
        WHEN '2' THEN 'Ter'
        WHEN '3' THEN 'Qua'
        WHEN '4' THEN 'Qui'
        WHEN '5' THEN 'Sex'
        WHEN '6' THEN 'Sáb'
    END AS dia_semana_abreviado,
    CASE WHEN STRFTIME('%w', data) IN ('0','6') THEN 1 ELSE 0 END AS fim_de_semana,
    CASE
        WHEN STRFTIME('%m', data) IN ('01','02','03') THEN 1
        WHEN STRFTIME('%m', data) IN ('04','05','06') THEN 2
        WHEN STRFTIME('%m', data) IN ('07','08','09') THEN 3
        WHEN STRFTIME('%m', data) IN ('10','11','12') THEN 4
    END AS trimestre,
    CASE
        WHEN STRFTIME('%m', data) BETWEEN '01' AND '06' THEN 1
        ELSE 2
    END AS semestre,
    CASE 
        WHEN data IN ('2024-01-01', '2024-02-12', '2024-02-13', '2024-03-29', 
                      '2024-04-21', '2024-05-01', '2024-09-07', '2024-10-12', 
                      '2024-11-02', '2024-11-15', '2024-12-25')
        THEN 1 ELSE 0 
    END AS feriado,
    CASE 
        WHEN data = '2024-01-01' THEN 'Ano Novo'
        WHEN data = '2024-02-12' THEN 'Carnaval (Segunda)'
        WHEN data = '2024-02-13' THEN 'Carnaval (Terça)'
        WHEN data = '2024-03-29' THEN 'Sexta-feira Santa'
        WHEN data = '2024-04-21' THEN 'Tiradentes'
        WHEN data = '2024-05-01' THEN 'Dia do Trabalhador'
        WHEN data = '2024-09-07' THEN 'Independência do Brasil'
        WHEN data = '2024-10-12' THEN 'Nossa Senhora Aparecida'
        WHEN data = '2024-11-02' THEN 'Finados'
        WHEN data = '2024-11-15' THEN 'Proclamação da República'
        WHEN data = '2024-12-25' THEN 'Natal'
    END AS nome_feriado,
    1 AS ano_bissexto
FROM calendario;

---- DIM_ESTADO:

CREATE TABLE DIM_ESTADO (
    id_estado SERIAL PRIMARY KEY,
    uf VARCHAR(2) NOT NULL UNIQUE,
    estado VARCHAR(50) NOT NULL,
    capital VARCHAR(50) NOT NULL,
    regiao_uf VARCHAR(20) NOT NULL
);



INSERT INTO DIM_ESTADO (id_estado, uf, estado, capital, regiao_uf) VALUES
(1,'AC', 'Acre', 'Rio Branco', 'Norte'),
(2,'AL', 'Alagoas', 'Maceió', 'Nordeste'),
(3,'AP', 'Amapá', 'Macapá', 'Norte'),
(4,'AM', 'Amazonas', 'Manaus', 'Norte'),
(5,'BA', 'Bahia', 'Salvador', 'Nordeste'),
(6,'CE', 'Ceará', 'Fortaleza', 'Nordeste'),
(7,'DF', 'Distrito Federal', 'Brasília', 'Centro-Oeste'),
(8,'ES', 'Espírito Santo', 'Vitória', 'Sudeste'),
(9,'GO', 'Goiás', 'Goiânia', 'Centro-Oeste'),
(10,'MA', 'Maranhão', 'São Luís', 'Nordeste'),
(11,'MT', 'Mato Grosso', 'Cuiabá', 'Centro-Oeste'),
(12,'MS', 'Mato Grosso do Sul', 'Campo Grande', 'Centro-Oeste'),
(13,'MG', 'Minas Gerais', 'Belo Horizonte', 'Sudeste'),
(14,'PA', 'Pará', 'Belém', 'Norte'),
(15,'PB', 'Paraíba', 'João Pessoa', 'Nordeste'),
(16,'PR', 'Paraná', 'Curitiba', 'Sul'),
(17,'PE', 'Pernambuco', 'Recife', 'Nordeste'),
(18,'PI', 'Piauí', 'Teresina', 'Nordeste'),
(19,'RJ', 'Rio de Janeiro', 'Rio de Janeiro', 'Sudeste'),
(20,'RN', 'Rio Grande do Norte', 'Natal', 'Nordeste'),
(21,'RS', 'Rio Grande do Sul', 'Porto Alegre', 'Sul'),
(22,'RO', 'Rondônia', 'Porto Velho', 'Norte'),
(23,'RR', 'Roraima', 'Boa Vista', 'Norte'),
(24,'SC', 'Santa Catarina', 'Florianópolis', 'Sul'),
(25,'SP', 'São Paulo', 'São Paulo', 'Sudeste'),
(26,'SE', 'Sergipe', 'Aracaju', 'Nordeste'),
(27,'TO', 'Tocantins', 'Palmas', 'Norte')

---- DIM_CLIENTE:

CREATE TABLE DIM_CLIENTE (
    id_cliente SERIAL PRIMARY KEY,
	id_estado INT NOT NULL,
    uf_cliente VARCHAR(2) NOT NULL,
    regiao_uf VARCHAR(20) NOT NULL,
    dt_ultima_compra DATE
);


INSERT INTO DIM_CLIENTE (id_cliente, id_estado, uf_cliente, regiao_uf, dt_ultima_compra) VALUES
(1, 25, 'SP', 'Sudeste', '2024-01-15'),
(2, 19, 'RJ', 'Sudeste', '2024-01-18'),
(3, 13, 'MG', 'Sudeste', '2024-02-05'),
(4, 21, 'RS', 'Sul', '2024-02-12'),
(5, 16, 'PR', 'Sul', '2024-02-20'),
(6, 24, 'SC', 'Sul', '2024-03-01'),
(7, 5, 'BA', 'Nordeste', '2024-01-22'),
(8, 6, 'CE', 'Nordeste', '2024-02-28'),
(9, 17, 'PE', 'Nordeste', '2024-03-10'),
(10, 9, 'GO', 'Centro-Oeste', '2024-01-30'),
(11, 7, 'DF', 'Centro-Oeste', '2024-02-15'),
(12, 11, 'MT', 'Centro-Oeste', '2024-03-05'),
(13, 14, 'PA', 'Norte', '2024-01-25'),
(14, 4, 'AM', 'Norte', '2024-02-18'),
(15, 1, 'AC', 'Norte', '2024-03-12'),
(16, 25, 'SP', 'Sudeste', '2024-03-14'),
(17, 19, 'RJ', 'Sudeste', '2024-02-22'),
(18, 13, 'MG', 'Sudeste', '2024-01-28'),
(19, 21, 'RS', 'Sul', '2024-03-08'),
(20, 16, 'PR', 'Sul', '2024-02-25');

---- DIM_TRANSPORTADORA:

CREATE TABLE DIM_TRANSPORTADORA (
    id_transportadora SERIAL PRIMARY KEY,
    nome_transportadora VARCHAR(100) NOT NULL,
    cnpj VARCHAR(14) UNIQUE NOT NULL
);

DELETE FROM DIM_TRANSPORTADORA

INSERT INTO DIM_TRANSPORTADORA (id_transportadora, nome_transportadora, cnpj) VALUES
(1,'Transportadora Express', '12345678000195'),
(2,'Logística Rápida', '98765432000186'),
(3,'Entregas Seguras', '45678912000174'),
(4,'Frete Nacional', '32165498000123');

---- DIM_CATEGORIA:

CREATE TABLE DIM_CATEGORIA (
    id_categoria SERIAL PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL,
    super_categoria VARCHAR(50) NOT NULL,
    id_marca INT NOT NULL,
    marca VARCHAR(50) NOT NULL
);

DROP TABLE DIM_CATEGORIA

INSERT INTO DIM_CATEGORIA (id_categoria, categoria, super_categoria, id_marca, marca) VALUES
-- Calçados Esportivos
(1, 'Tênis de Corrida', 'Calçados Esportivos', 1, 'Nike'),
(2, 'Tênis de Basquete', 'Calçados Esportivos', 2, 'Adidas'),
(3, 'Chuteiras Society', 'Calçados Esportivos', 3, 'Puma'),
(4, 'Tênis de Skate', 'Calçados Esportivos', 4, 'Vans'),
(5, 'Sapatilhas de Pilates', 'Calçados Esportivos', 5, 'Reebok'),

-- Roupas Esportivas
(6, 'Camisetas Dry Fit', 'Roupas Esportivas', 1, 'Nike'),
(7, 'Shorts de Corrida', 'Roupas Esportivas', 2, 'Adidas'),
(8, 'Calças de Moletom', 'Roupas Esportivas', 3, 'Puma'),
(9, 'Jaquetas Esportivas', 'Roupas Esportivas', 4, 'Under Armour'),
(10, 'Legging Fitness', 'Roupas Esportivas', 5, 'Reebok'),

-- Equipamentos
(11, 'Bolas de Futebol', 'Equipamentos', 2, 'Adidas'),
(12, 'Raquetes de Tênis', 'Equipamentos', 6, 'Wilson'),
(13, 'Luvas de Boxe', 'Equipamentos', 7, 'Everlast'),
(14, 'Bolas de Basquete', 'Equipamentos', 1, 'Nike'),
(15, 'Redes de Vôlei', 'Equipamentos', 8, 'Mikasa'),

-- Suplementos
(16, 'Whey Protein', 'Suplementos', 9, 'Growth'),
(17, 'BCAA', 'Suplementos', 10, 'Integral Medica'),
(18, 'Creatina', 'Suplementos', 11, 'Max Titanium'),
(19, 'Pré-Treino', 'Suplementos', 12, 'Darkness'),
(20, 'Vitaminas', 'Suplementos', 13, 'Natura'),

-- Acessórios
(21, 'Garrafas Squeeze', 'Acessórios', 4, 'Under Armour'),
(22, 'Caneleiras', 'Acessórios', 2, 'Adidas'),
(23, 'Joelheiras', 'Acessórios', 3, 'Puma'),
(24, 'Pulsedeiras', 'Acessórios', 1, 'Nike'),
(25, 'Toalhas Esportivas', 'Acessórios', 5, 'Reebok');


---- FATO_META:

CREATE TABLE FATO_META (
    id_meta SERIAL PRIMARY KEY,
    id_data INT NOT NULL,
    id_categoria INT,
    valor_meta DECIMAL(15,2) NOT NULL,
    tipo_meta VARCHAR(50) NOT NULL, 
    dt_criacao_meta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_atualizacao_meta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_data) REFERENCES DIM_CALENDARIO_COMPLETA(id_data),
    FOREIGN KEY (id_categoria) REFERENCES DIM_CATEGORIA(id_categoria)
);

SELECT * FROM DIM_CALENDARIO_COMPLETA

DROP TABLE FATO_META

INSERT INTO FATO_META (id_meta, id_data, id_categoria, valor_meta, tipo_meta, dt_criacao_meta, dt_atualizacao_meta) VALUES
(1, 20240101, 1, 75000.00, 'vendas', '2023-12-15 10:00:00', '2023-12-15 10:00:00'),
(2, 20240101, 2, 50000.00, 'vendas', '2023-12-15 10:00:00', '2023-12-15 10:00:00'),
(3, 20240101, 3, 30000.00, 'vendas', '2023-12-15 10:00:00', '2023-12-15 10:00:00'),
(4, 20240101, 4, 40000.00, 'vendas', '2023-12-15 10:00:00', '2023-12-15 10:00:00'),
(5, 20240101, 5, 20000.00, 'vendas', '2023-12-15 10:00:00', '2023-12-15 10:00:00'),
(6, 20240201, 6, 80000.00, 'vendas', '2024-01-25 14:30:00', '2024-01-25 14:30:00'),
(7, 20240201, 7, 55000.00, 'vendas', '2024-01-25 14:30:00', '2024-01-25 14:30:00'),
(8, 20240201, 8, 35000.00, 'vendas', '2024-01-25 14:30:00', '2024-01-25 14:30:00'),
(9, 20240201, 9, 45000.00, 'vendas', '2024-01-25 14:30:00', '2024-01-25 14:30:00'),
(10, 20240201, 10, 25000.00, 'vendas', '2024-01-25 14:30:00', '2024-01-25 14:30:00'),
(11, 20240301, 11, 85000.00, 'vendas', '2024-02-20 09:15:00', '2024-02-20 09:15:00'),
(12, 20240301, 12, 60000.00, 'vendas', '2024-02-20 09:15:00', '2024-02-20 09:15:00'),
(13, 20240301, 1, 40000.00, 'vendas', '2024-02-20 09:15:00', '2024-02-20 09:15:00'),
(14, 20240301, 2, 50000.00, 'vendas', '2024-02-20 09:15:00', '2024-02-20 09:15:00'),
(15, 20240301, 3, 30000.00, 'vendas', '2024-02-20 09:15:00', '2024-02-20 09:15:00'),
(16, 20240101, 4, 300, 'quantidade', '2023-12-15 10:00:00', '2023-12-15 10:00:00'),
(17, 20240201, 5, 400, 'quantidade', '2024-01-25 14:30:00', '2024-01-25 14:30:00'),
(18, 20240301, 6, 250, 'quantidade', '2024-02-20 09:15:00', '2024-02-20 09:15:00');


---- FATO_VENDAS:

CREATE TABLE FATO_VENDAS (
    id_venda SERIAL PRIMARY KEY,
    id_data INT NOT NULL,
    id_cliente INT NOT NULL,
    id_produto INT NOT NULL,
    id_transportadora INT,
    id_categoria INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0,
    valor_com_desconto DECIMAL(10,2) NOT NULL,
    valor_frete DECIMAL(10,2) DEFAULT 0,
    valor_total DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (id_data) REFERENCES DIM_CALENDARIO_COMPLETA(id_data),
    FOREIGN KEY (id_cliente) REFERENCES DIM_CLIENTE(id_cliente),
    FOREIGN KEY (id_transportadora) REFERENCES DIM_TRANSPORTADORA(id_transportadora),
    FOREIGN KEY (id_categoria) REFERENCES DIM_CATEGORIA(id_categoria)
);

INSERT INTO FATO_VENDAS (id_venda, id_data, id_cliente, id_produto, id_transportadora, id_categoria, quantidade, valor_unitario, desconto, valor_com_desconto, valor_frete, valor_total) VALUES
(1, 20240102, 1, 101, 1, 1, 1, 250.00, 0.00, 250.00, 25.00, 275.00),
(2, 20240101, 2, 102, 2, 6, 2, 80.00, 24.00, 136.00, 0.00, 136.00),
(3, 20240101, 3, 103, 3, 11, 1, 120.00, 0.00, 120.00, 25.00, 145.00),
(4, 20240101, 4, 104, 1, 16, 3, 90.00, 40.50, 229.50, 0.00, 229.50),
(5, 20240101, 5, 105, 2, 21, 1, 35.00, 0.00, 35.00, 25.00, 60.00),
(6, 20240201, 6, 106, 3, 2, 1, 280.00, 42.00, 238.00, 25.00, 263.00),
(7, 20240201, 7, 107, 1, 7, 2, 85.00, 0.00, 170.00, 0.00, 170.00),
(8, 20240201, 8, 108, 2, 12, 1, 150.00, 22.50, 127.50, 25.00, 152.50),
(9, 20240201, 9, 109, 3, 17, 2, 95.00, 28.50, 161.50, 0.00, 161.50),
(10, 20240201, 10, 110, 1, 22, 1, 40.00, 0.00, 40.00, 25.00, 65.00),
(11, 20240301, 11, 111, 2, 3, 1, 220.00, 0.00, 220.00, 25.00, 245.00),
(12, 20240301, 12, 112, 3, 8, 3, 75.00, 33.75, 191.25, 0.00, 191.25),
(13, 20240301, 13, 113, 1, 13, 1, 180.00, 27.00, 153.00, 25.00, 178.00),
(14, 20240301, 14, 114, 2, 18, 2, 100.00, 0.00, 200.00, 0.00, 200.00),
(15, 20240301, 15, 115, 3, 23, 1, 45.00, 6.75, 38.25, 25.00, 63.25),
(16, 20240101, 16, 116, 1, 4, 1, 190.00, 0.00, 190.00, 25.00, 215.00),
(17, 20240101, 17, 117, 2, 9, 2, 110.00, 33.00, 187.00, 0.00, 187.00),
(18, 20240201, 18, 118, 3, 14, 1, 85.00, 0.00, 85.00, 25.00, 110.00),
(19, 20240201, 19, 119, 1, 19, 3, 70.00, 31.50, 178.50, 0.00, 178.50),
(20, 20240301, 20, 120, 2, 24, 1, 50.00, 7.50, 42.50, 25.00, 67.50);

---- FATO_ESTOQUE:

CREATE TABLE FATO_ESTOQUE (
    id_estoque SERIAL PRIMARY KEY,
    id_data INT NOT NULL,
    id_produto INT NOT NULL,
    id_categoria INT NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    qtd_estoque INT NOT NULL,
    qtd_minima INT NOT NULL,
    qtd_maxima INT NOT NULL,
	tamanho VARCHAR(10) NULL,
	cor VARCHAR(30) NULL,
    situacao_estoque VARCHAR(20) NOT NULL, 
    FOREIGN KEY (id_data) REFERENCES DIM_CALENDARIO_COMPLETA(id_data),
    FOREIGN KEY (id_categoria) REFERENCES DIM_CATEGORIA(id_categoria)
);

DROP TABLE FATO_ESTOQUE


INSERT INTO FATO_ESTOQUE (id_estoque, id_data, id_produto, id_categoria, nome_produto, categoria, marca, qtd_estoque, qtd_minima, qtd_maxima, situacao_estoque, tamanho, cor) VALUES
(1, 20240101, 101, 1, 'Nike Tênis de Corrida 40', 'Tênis de Corrida', 'Nike', 45, 30, 180, 'normal', '40', 'Preto'),
(2, 20240101, 102, 6, 'Adidas Camisetas Dry Fit M', 'Camisetas Dry Fit', 'Adidas', 120, 50, 250, 'normal', 'M', 'Branco'),
(3, 20240101, 103, 11, 'Puma Bolas de Futebol', 'Bolas de Futebol', 'Puma', 85, 20, 120, 'normal', 'Único', 'Branco'),
(4, 20240101, 104, 16, 'Growth Whey Protein', 'Whey Protein', 'Growth', 350, 100, 450, 'normal', 'Único', NULL),
(5, 20240101, 105, 21, 'Under Armour Garrafas Squeeze', 'Garrafas Squeeze', 'Under Armour', 25, 20, 120, 'baixo', 'Único', 'Azul'),
(6, 20240201, 101, 1, 'Nike Tênis de Corrida 40', 'Tênis de Corrida', 'Nike', 28, 30, 180, 'baixo', '40', 'Preto'),
(7, 20240201, 102, 6, 'Adidas Camisetas Dry Fit M', 'Camisetas Dry Fit', 'Adidas', 180, 50, 250, 'normal', 'M', 'Branco'),
(8, 20240201, 103, 11, 'Puma Bolas de Futebol', 'Bolas de Futebol', 'Puma', 15, 20, 120, 'baixo', 'Único', 'Branco'),
(9, 20240201, 104, 16, 'Growth Whey Protein', 'Whey Protein', 'Growth', 480, 100, 450, 'excesso', 'Único', NULL),
(10, 20240201, 105, 21, 'Under Armour Garrafas Squeeze', 'Garrafas Squeeze', 'Under Armour', 65, 20, 120, 'normal', 'Único', 'Azul'),
(11, 20240301, 101, 1, 'Nike Tênis de Corrida 40', 'Tênis de Corrida', 'Nike', 35, 30, 180, 'normal', '40', 'Preto'),
(12, 20240301, 102, 6, 'Adidas Camisetas Dry Fit M', 'Camisetas Dry Fit', 'Adidas', 240, 50, 250, 'excesso', 'M', 'Branco'),
(13, 20240301, 103, 11, 'Puma Bolas de Futebol', 'Bolas de Futebol', 'Puma', 22, 20, 120, 'normal', 'Único', 'Branco'),
(14, 20240301, 104, 16, 'Growth Whey Protein', 'Whey Protein', 'Growth', 420, 100, 450, 'normal', 'Único', NULL),
(15, 20240301, 105, 21, 'Under Armour Garrafas Squeeze', 'Garrafas Squeeze', 'Under Armour', 18, 20, 120, 'baixo', 'Único', 'Azul'),
(16, 20240301, 106, 2, 'Adidas Tênis de Basquete 42', 'Tênis de Basquete', 'Adidas', 60, 30, 180, 'normal', '42', 'Vermelho'),
(17, 20240301, 107, 7, 'Puma Shorts de Corrida G', 'Shorts de Corrida', 'Puma', 85, 50, 250, 'normal', 'G', 'Preto'),
(18, 20240301, 108, 12, 'Wilson Raquetes de Tênis', 'Raquetes de Tênis', 'Wilson', 35, 20, 120, 'normal', 'Único', NULL),
(19, 20240301, 109, 17, 'Integral Medica BCAA', 'BCAA', 'Integral Medica', 280, 100, 450, 'normal', 'Único', NULL),
(20, 20240301, 110, 22, 'Adidas Caneleiras', 'Caneleiras', 'Adidas', 42, 20, 120, 'normal', 'Único', 'Preto');