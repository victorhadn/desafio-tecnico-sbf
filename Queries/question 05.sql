--- 1. RECEITA TOTAL (R$)

--- Valor total das vendas realizadas em um determinado período, considerando descontos e frete. 

WITH vendas_periodo AS (
    SELECT
        cc.nome_mes,
        cc.ano,
        cc.mes,
        SUM(v.valor_total) AS receita_total
    FROM FATO_VENDAS AS v
    INNER JOIN DIM_CALENDARIO_COMPLETA AS cc
        ON cc.id_data = v.id_data
    WHERE cc.data_completa BETWEEN '2024-01-01' AND '2024-10-31'
    GROUP BY cc.nome_mes, cc.ano, cc.mes
)
SELECT
    nome_mes,
    ano,
    ROUND(COALESCE(receita_total, 0.00), 2) AS receita_total
FROM vendas_periodo
ORDER BY receita_total DESC

SELECT * FROM DIM_CALENDARIO_COMPLETA

--- 2. TICKET MÉDIO (R$)

--- Valor médio gasto por cliente por transação. Representa o quanto, em média, cada venda contribui para a receita total.

WITH vendas_cliente AS (
    SELECT
        id_cliente,
        id_venda,
        SUM(valor_total) AS valor_total_venda
    FROM FATO_VENDAS
    GROUP BY id_cliente, id_venda
)
SELECT
    id_cliente,
    ROUND(AVG(valor_total_venda), 2) AS ticket_medio
FROM vendas_cliente
GROUP BY id_cliente
ORDER BY ticket_medio DESC


--- 3. VENDAS VS META (%)

--- Compara o total de vendas realizadas com a meta estipulada, calculando o percentual de atingimento.

SELECT 
    c.nome_mes,
    c.ano,
    ROUND(
        (SUM(v.valor_total) / NULLIF(SUM(m.valor_meta), 0)) * 100,
        2
    ) AS percentual_meta
FROM FATO_VENDAS AS v
INNER JOIN FATO_META AS m 
    ON v.id_categoria = m.id_categoria
INNER JOIN DIM_CALENDARIO_COMPLETA AS c 
    ON v.id_data = c.id_data
GROUP BY c.nome_mes, c.ano
ORDER BY percentual_meta DESC


--- TOP 5 CATEGORIAS POR RECEITA

--- Identifica as cinco categorias com maior volume de vendas em receita.

SELECT 
    c.categoria,
    ROUND(SUM(v.valor_total), 2) AS receita_total
FROM FATO_VENDAS AS v
INNER JOIN DIM_CATEGORIA AS c 
    ON v.id_categoria = c.id_categoria
GROUP BY c.categoria
ORDER BY receita_total DESC
LIMIT 5;

--- 5. TOP 5 MARCAS POR RECEITA

--- Aponta as marcas que mais geram receita dentro do portfólio da empresa.

SELECT 
    c.marca,
    ROUND(SUM(v.valor_total), 2) AS receita_total
FROM FATO_VENDAS AS v
INNER JOIN DIM_CATEGORIA AS c 
    ON v.id_categoria = c.id_categoria
GROUP BY c.marca
ORDER BY receita_total DESC
LIMIT 5;


--- 6. VENDAS POR REGIÃO

--- Mostra o total de vendas realizadas em cada região geográfica do Brasil.

SELECT 
    cli.regiao_uf,
    ROUND(SUM(v.valor_total), 2) AS receita_total
FROM FATO_VENDAS AS v
INNER JOIN DIM_CLIENTE AS cli 
    ON v.id_cliente = cli.id_cliente
GROUP BY cli.regiao_uf
ORDER BY receita_total DESC;


--- 7. RECEITA MÉDIA POR CLIENTE

--- Média de receita gerada por cliente no período analisado.

SELECT 
    v.id_cliente,
    ROUND(SUM(v.valor_total) / NULLIF(COUNT(DISTINCT v.id_venda), 0), 2) AS receita_media_cliente
FROM FATO_VENDAS AS v
GROUP BY v.id_cliente
ORDER BY receita_media_cliente DESC;


--- 8. CUSTO MÉDIO DE FRETE (R$)

--- Valor médio gasto com frete por pedido realizado.

SELECT 
    id_venda,
	AVG(valor_frete) AS custo_medio_frete
FROM FATO_VENDAS
GROUP BY id_venda
ORDER BY valor_frete DESC

select * from FATO_VENDAS

--- 9. VENDAS POR TRANSPORTADORA

--- Apresenta a receita total de vendas associada a cada transportadora.

SELECT 
    t.nome_transportadora,
    SUM(v.valor_total) AS receita_total
FROM FATO_VENDAS v
JOIN DIM_TRANSPORTADORA t ON v.id_transportadora = t.id_transportadora
GROUP BY t.nome_transportadora
ORDER BY receita_total DESC


--- 10. VENDAS POR TRIMESTRE / SEMESTRE

--- Mostra o volume total de vendas agrupado por trimestre e semestre, permitindo análise de sazonalidade.

SELECT
    cal.trimestre,
    cal.semestre,
    SUM(v.valor_total) AS receita_total
FROM FATO_VENDAS v
JOIN DIM_CALENDARIO_COMPLETA cal ON v.id_data = cal.id_data
GROUP BY cal.trimestre, cal.semestre
ORDER BY cal.trimestre

SELECT * FROM FATO_VENDAS