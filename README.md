# 📊 Análise de Risco de Crédito e Inadimplência (Oracle SQL)

## 🎯 Objetivo do Projeto
Simular a rotina da área de *Risco de Crédito / MIS* de uma instituição financeira, estruturando uma base de dados relacional no *Oracle* para identificar produtos com maior índice de inadimplência (atrasos acima de 30 dias) e classificar clientes por faixa de risco.

## 🛠️ Ferramentas e Técnicas Utilizadas
- *Banco de Dados:* Oracle SQL
- *Modelagem:* Criação de tabelas relacionais com Chaves Primárias (PRIMARY KEY) e Estrangeiras (FOREIGN KEY).
- *Análise de Dados:* Cruzamento de tabelas (INNER JOIN), agregações (SUM, COUNT, GROUP BY) e regras de negócio condicionais (CASE WHEN).

## 📈 Principais Indicadores Extraídos
1. *Taxa de Inadimplência por Produto:* Identificação de quais linhas de crédito (ex: Cartão de Crédito vs. Consignado) concentram maior perda financeira.
2. *Régua de Cobrança Preventiva:* Segmentação automática da carteira em Sem Risco, Risco Baixo e Risco Alto com base nos dias de atraso e Score do cliente.
