--- 1. RECEITA TOTAL (R$)

--- Valor total das vendas realizadas em um determinado período, considerando descontos e frete. 

SELECT 
    SUM(valor_total) AS receita_total
FROM FATO_VENDAS;

--- 2. TICKET MÉDIO (R$)

--- Valor médio gasto por cliente por transação. Representa o quanto, em média, cada venda contribui para a receita total.

SELECT 
    SUM(valor_total) / COUNT(DISTINCT id_venda) AS ticket_medio
FROM FATO_VENDAS;


--- 3. VENDAS VS META (%)

--- Compara o total de vendas realizadas com a meta estipulada, calculando o percentual de atingimento.

SELECT 
    c.nome_mes,
    (SUM(v.valor_total) / SUM(m.valor_meta)) * 100 AS percentual_meta
FROM FATO_VENDAS v
JOIN FATO_META m ON v.id_categoria = m.id_categoria 
JOIN DIM_CALENDARIO_COMPLETA c ON v.id_data = c.id_data
GROUP BY c.nome_mes
ORDER BY c.nome_mes DESC;

SELECT * FROM FATO_VENDAS


--- TOP 5 CATEGORIAS POR RECEITA

--- Identifica as cinco categorias com maior volume de vendas em receita.

SELECT 
    c.categoria,
    SUM(v.valor_total) AS receita_total
FROM FATO_VENDAS v
JOIN DIM_CATEGORIA c ON v.id_categoria = c.id_categoria
GROUP BY c.categoria
ORDER BY receita_total DESC
LIMIT 5;


--- 5. TOP 5 MARCAS POR RECEITA

--- Aponta as marcas que mais geram receita dentro do portfólio da empresa.

SELECT 
    c.marca,
    SUM(v.valor_total) AS receita_total
FROM FATO_VENDAS v
JOIN DIM_CATEGORIA c ON v.id_categoria = c.id_categoria
GROUP BY c.marca
ORDER BY receita_total DESC
LIMIT 5;


--- 6. VENDAS POR REGIÃO

--- Mostra o total de vendas realizadas em cada região geográfica do Brasil.

SELECT 
    cli.regiao_uf,
    SUM(v.valor_total) AS receita_total
FROM FATO_VENDAS v
JOIN DIM_CLIENTE cli ON v.id_cliente = cli.id_cliente
GROUP BY cli.regiao_uf
ORDER BY receita_total DESC;


--- 7. RECEITA MÉDIA POR CLIENTE

--- Média de receita gerada por cliente ativo no período analisado.

SELECT 
    SUM(valor_total) / COUNT(DISTINCT id_cliente) AS receita_media_cliente
FROM FATO_VENDAS;


--- 8. CUSTO MÉDIO DE FRETE (R$)

--- Valor médio gasto com frete por pedido realizado.

SELECT 
    AVG(valor_frete) AS custo_medio_frete
FROM FATO_VENDAS
WHERE valor_frete > 0;

--- 9. VENDAS POR TRANSPORTADORA

--- Apresenta a receita total de vendas associada a cada transportadora.

SELECT 
    t.nome_transportadora,
    SUM(v.valor_total) AS receita_total
FROM FATO_VENDAS v
JOIN DIM_TRANSPORTADORA t ON v.id_transportadora = t.id_transportadora
GROUP BY t.nome_transportadora
ORDER BY receita_total DESC;


--- 10. VENDAS POR TRIMESTRE / SEMESTRE

--- Mostra o volume total de vendas agrupado por trimestre e semestre, permitindo análise de sazonalidade.

SELECT 
    cal.trimestre,
    cal.semestre,
    SUM(v.valor_total) AS receita_total
FROM FATO_VENDAS v
JOIN DIM_CALENDARIO_COMPLETA cal ON v.id_data = cal.id_data
GROUP BY cal.trimestre, cal.semestre
ORDER BY cal.trimestre;