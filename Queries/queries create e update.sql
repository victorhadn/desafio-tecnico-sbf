CREATE TABLE DIM_CALENDARIO (data TEXT PRIMARY KEY,
ano INTEGER,
mes INTEGER,
dia INTEGER);

CREATE TABLE DIM_MARCA (id INTEGER PRIMARY KEY,
nome TEXT);

CREATE TABLE DIM_META (ano INTEGER,
mes INTEGER,
id_marca INTEGER,
vlr_meta REAL);

CREATE TABLE DIM_PRODUTO (id INTEGER PRIMARY KEY,
id_marca INTEGER,
nome TEXT,
categoria TEXT);

CREATE TABLE FATO_PEDIDO (id INTEGER PRIMARY KEY,
data TEXT,
sgl_uf_entrega TEXT,
vlr_total REAL);

CREATE TABLE FATO_PEDIDO_ITEM (id_pedido INTEGER,
id_produto INTEGER,
vlr_unitario REAL,
qtd_produto INTEGER,
flg_cancelado TEXT);

UPDATE DIM_CALENDARIO
SET mes_nome = CASE mes
    WHEN 1 THEN 'Janeiro'
    WHEN 2 THEN 'Fevereiro'
    WHEN 3 THEN 'Março'
    WHEN 4 THEN 'Abril'
    WHEN 5 THEN 'Maio'
    WHEN 6 THEN 'Junho'
    WHEN 7 THEN 'Julho'
    WHEN 8 THEN 'Agosto'
    WHEN 9 THEN 'Setembro'
    WHEN 10 THEN 'Outubro'
    WHEN 11 THEN 'Novembro'
    WHEN 12 THEN 'Dezembro'
    ELSE 'Desconhecido'
END;
