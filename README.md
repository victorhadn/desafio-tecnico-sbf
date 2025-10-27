# Desafio Técnico - Analytics Engineer
- Repositório criado para armazenar os scripts em SQL do teste técnico para a vaga de Senior Analytics Engineer

## Stack Técnica

- Fonte dos dados - arquivos csv (data, marca, meta, pedido, pedido_item e produto)
- Banco de Origem - Criação do banco para inserção dos dados no DB Browser - SQLite
- Consumo - DB Browser (queries de consulta das tabelas do SQLite)


## Respostas e ideias das questões 1 a 5

- Questão 01:

<img width="562" height="659" alt="image" src="https://github.com/user-attachments/assets/98286383-42ab-4e9c-8253-cfced7b2d330" />

- Questão 02:

<img width="507" height="196" alt="image" src="https://github.com/user-attachments/assets/686f2d60-80e3-4580-9e5a-b0ddbb92f2c2" />

- Questão 03:
  
1 - Transformar a DIM_META em uma FATO_META tendo em vista que metas podem ser alteradas a cada mês e ano.

2 - Já tem uma DIM_CALENDARIO com os dados imputados do csv, eu já chamei ela de DIM_CALENDARIO, mas deve existir uma DIM_CALENDARIO_COMPLETO com dados dos 365 dias do ano (366 se for ano bissexto).

3 - Criar uma DIM_CLIENTE respeitando as diretrizes da LGPD e não trazer dados sensíveis do cliente, por exemplo (cpf, endereço, telefone, etc)
Obs: Teria apenas os seguintes campos: id_cliente, uf_cliente, regiao_uf, dt_ultima_compra.

4 - Criaria a DIM_TRANSPORTADORA para se relacionar com a FATO_PEDIDO com os campos id_transportadora, nome_transportadora e cnpj.

5 - Transformaria a FATO_PEDIDO em uma FATO_VENDAS e o campo data se tornaria dt_venda, traria também o id_cliente, id_data, id_produto e alguns outras colunas como desconto, valor_com_desconto, 
valor_frete (se houvesse) e id_transportadora.

6 - Criaria uma DIM_ESTADO com os campos de UF, estado, capital, regiao_uf.

7 - Criaria uma FATO_ESTOQUE com os campos de id_produto, nome_produto, categoria, marca, id_marca, qtd_estoque

8 - Criaria uma DIM_CATEGORIA com os campos id_categoria, categoria, super_categoria, id_marca, marca.

- Questão 04:

1 - Criaria uma FT_DADOS_CLIENTE que traria informações de cada cliente (dados sensíveis) e um campo de data (dt_ultima_atualizacao) trazendo um dado mais recente do cliente e assim não perderia o 
histórico.

Por exemplo: JOÃO tem um endereço av. pará, 342, Belém-PA. João Trocou o endereço para av. josé campos, 211, Curitiba-PR. Diferentemente de uma tabela Dimensão (que traria apenas o dado
mais recente do cliente), tendo uma tabela fato, uma linha existiria para o primeiro endereço e outra linha para o segundo endereço (mantendo o historico de alterações) e para ver o dado mais
recente do cliente pegaria a MAX(dt_ultima_atualizacao) agrupado por id_cliente.

2 - Utilizaria um RBAC (controle de acesso restrito) para armazenar esses dados sensíveis de cada cliente, apenas algumas equipes teriam permissão.

- Questão 05:

1. RECEITA TOTAL (R$)

- Valor total das vendas realizadas em um determinado período, considerando descontos e frete. 


2. TICKET MÉDIO (R$)

- Valor médio gasto por cliente por transação. Representa o quanto, em média, cada venda contribui para a receita total.


3. VENDAS VS META (%)

- Compara o total de vendas realizadas com a meta estipulada, calculando o percentual de atingimento.


 TOP 5 CATEGORIAS POR RECEITA

- Identifica as cinco categorias com maior volume de vendas em receita.


5. TOP 5 MARCAS POR RECEITA

- Aponta as marcas que mais geram receita dentro do portfólio da empresa.


6. VENDAS POR REGIÃO

- Mostra o total de vendas realizadas em cada região geográfica do Brasil.


7. RECEITA MÉDIA POR CLIENTE

- Média de receita gerada por cliente ativo no período analisado.


8. CUSTO MÉDIO DE FRETE (R$)

- Valor médio gasto com frete por pedido realizado.

9. VENDAS POR TRANSPORTADORA

- Apresenta a receita total de vendas associada a cada transportadora.

10. VENDAS POR TRIMESTRE / SEMESTRE

- Mostra o volume total de vendas agrupado por trimestre e semestre, permitindo análise de sazonalidade.



