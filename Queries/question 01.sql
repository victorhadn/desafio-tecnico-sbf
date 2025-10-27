---Top 10 Produtos Mais Vendidos por Mês e Região UF

WITH VendasAgregadas AS (
    SELECT
        FP.sgl_uf_entrega,
        DC.mes,
        DC.mes_nome, 
        DP.nome AS nome_produto,
        SUM(FPI.qtd_produto) AS qtd_total_vendida
    FROM
        FATO_PEDIDO AS FP
    JOIN
        FATO_PEDIDO_ITEM AS FPI ON FP.id = FPI.id_pedido 
    JOIN
        DIM_CALENDARIO AS DC ON FP.data = DC.data
    JOIN
        DIM_PRODUTO AS DP ON FPI.id_produto = DP.id 
    WHERE
        FPI.flg_cancelado = 'N' 
    GROUP BY
        1, 2, 3, 4
),
RankeamentoProdutos AS (
    SELECT
        sgl_uf_entrega,
        mes,
        mes_nome,
        nome_produto,
        qtd_total_vendida,
        ROW_NUMBER() OVER(
            PARTITION BY sgl_uf_entrega, mes
            ORDER BY qtd_total_vendida DESC
        ) AS rank_vendas
    FROM
        VendasAgregadas
)
SELECT
    mes_nome AS Mes,
    sgl_uf_entrega AS UF,
    nome_produto AS Produto,
    qtd_total_vendida as Quantidade_Total_Vendida,
    rank_vendas AS Ranking
FROM
    RankeamentoProdutos
WHERE
    rank_vendas <= 10
ORDER BY
    Mes, 
    UF,
    Ranking;