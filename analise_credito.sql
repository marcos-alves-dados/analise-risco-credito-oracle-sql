-- ============================================================================
-- PROJETO: Análise de Risco de Crédito e Inadimplência Bancária (Oracle SQL)
-- AUTOR: Marcos Antônio Alves Lima
-- OBJETIVO: Identificar o perfil de clientes inadimplentes e o volume financeiro
--           em atraso por faixa de renda e tipo de produto.
-- ============================================================================

-- 1. CRIAÇÃO DAS TABELAS (DDL)
CREATE TABLE clientes_banco (
    id_cliente NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    idade NUMBER,
    renda_mensal NUMBER(10, 2),
    score_credito NUMBER,
    uf VARCHAR2(2)
);

CREATE TABLE contratos_credito (
    id_contrato NUMBER PRIMARY KEY,
    id_cliente NUMBER,
    produto VARCHAR2(50),
    valor_emprestado NUMBER(12, 2),
    dias_atraso NUMBER,
    status_contrato VARCHAR2(20),
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES clientes_banco(id_cliente)
);

-- 2. INSERÇÃO DE DADOS SIMULADOS (DML)
INSERT INTO clientes_banco VALUES (1, 'Carlos Silva', 34, 4500.00, 720, 'SP');
INSERT INTO clientes_banco VALUES (2, 'Ana Souza', 28, 2800.00, 480, 'SP');
INSERT INTO clientes_banco VALUES (3, 'Roberto Mendes', 45, 9200.00, 810, 'RJ');
INSERT INTO clientes_banco VALUES (4, 'Juliana Costa', 31, 3100.00, 510, 'MG');
INSERT INTO clientes_banco VALUES (5, 'Fernando Lima', 52, 6800.00, 690, 'SP');
INSERT INTO clientes_banco VALUES (6, 'Patrícia Gomes', 24, 2200.00, 430, 'SP');

INSERT INTO contratos_credito VALUES (101, 1, 'Crédito Pessoal', 15000.00, 0, 'Adimplente');
INSERT INTO contratos_credito VALUES (102, 2, 'Cartão de Crédito', 4200.00, 45, 'Inadimplente');
INSERT INTO contratos_credito VALUES (103, 3, 'Financiamento Veículo', 48000.00, 0, 'Adimplente');
INSERT INTO contratos_credito VALUES (104, 4, 'Crédito Pessoal', 8500.00, 62, 'Inadimplente');
INSERT INTO contratos_credito VALUES (105, 5, 'Consignado', 22000.00, 5, 'Em Atraso Leve');
INSERT INTO contratos_credito VALUES (106, 6, 'Cartão de Crédito', 3100.00, 95, 'Inadimplente');

COMMIT;

-- 3. CONSULTAS ANALÍTICAS PARA TOMADA DE DECISÃO (DQL)

-- Consulta A: Total emprestado e taxa de inadimplência por produto bancário
SELECT 
    produto,
    COUNT(id_contrato) AS total_contratos,
    SUM(valor_emprestado) AS volume_total_r$,
    SUM(CASE WHEN dias_atraso > 30 THEN valor_emprestado ELSE 0 END) AS volume_inadimplente_r$,
    ROUND(
        (SUM(CASE WHEN dias_atraso > 30 THEN 1 ELSE 0 END) / COUNT(id_contrato)) * 100, 2
    ) AS taxa_inadimplencia_pct
FROM contratos_credito
GROUP BY produto
ORDER BY volume_inadimplente_r$ DESC;

-- Consulta B: Cruzamento de Score e Renda com os atrasos (JOIN + CASE)
SELECT 
    c.nome,
    c.uf,
    c.renda_mensal,
    c.score_credito,
    ct.produto,
    ct.valor_emprestado,
    ct.dias_atraso,
    CASE 
        WHEN ct.dias_atraso = 0 THEN 'Sem Risco'
        WHEN ct.dias_atraso BETWEEN 1 AND 30 THEN 'Risco Baixo (Preventivo)'
        ELSE 'Risco Alto (Cobrança)'
    END AS classificacao_risco
FROM clientes_banco c
INNER JOIN contratos_credito ct ON c.id_cliente = ct.id_cliente
WHERE ct.dias_atraso > 0
ORDER BY ct.dias_atraso DESC;
