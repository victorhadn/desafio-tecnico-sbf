-- Variação das Vendas por Categoria (Abril vs. Março de 2024)

WITH VendasMensais AS (
    SELECT
        DP.categoria,
        DC.mes,
        SUM(FPI.vlr_unitario * FPI.qtd_produto) AS valor_total_vendido
    FROM
        FATO_PEDIDO_ITEM AS FPI
    JOIN
        FATO_PEDIDO AS FP ON FPI.id_pedido = FP.id
    JOIN
        DIM_PRODUTO AS DP ON FPI.id_produto = DP.id
    JOIN
        DIM_CALENDARIO AS DC ON FP.data = DC.data
    WHERE DC.data BETWEEN '2024-03-01' AND '2024-04-30'
        AND FPI.flg_cancelado = 'N'
    GROUP BY
        DP.categoria, DC.mes
),
VendasAgrupadasPorMes AS (
    SELECT
        categoria,
        SUM(CASE WHEN mes = 3 THEN valor_total_vendido ELSE 0 END) AS Vendas_Marco_2024,
        SUM(CASE WHEN mes = 4 THEN valor_total_vendido ELSE 0 END) AS Vendas_Abril_2024
    FROM
        VendasMensais
    GROUP BY
        categoria
)
SELECT
    categoria,
    Vendas_Marco_2024,
    Vendas_Abril_2024,
    ROUND(
        (Vendas_Abril_2024 - Vendas_Marco_2024) * 100.0 / NULLIF(Vendas_Marco_2024, 0),
        2
    ) AS Variacao_Percentual_MoM
FROM
    VendasAgrupadasPorMes
ORDER BY
    Variacao_Percentual_MoM DESC;