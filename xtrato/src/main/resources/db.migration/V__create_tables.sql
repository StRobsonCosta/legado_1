-- Tabela de contas bancárias
CREATE TABLE contas (
    id SERIAL PRIMARY KEY,
    numero_conta VARCHAR(20) NOT NULL UNIQUE,
    nome_cliente VARCHAR(100) NOT NULL,
    saldo DECIMAL(15, 2) NOT NULL DEFAULT 0.00
);

-- Tabela de transações
CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    conta_id INTEGER NOT NULL REFERENCES contas(id),
    tipo VARCHAR(10) NOT NULL, -- DEBITO ou CREDITO
    valor DECIMAL(15, 2) NOT NULL,
    data_transacao TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Tabela de extratos
CREATE TABLE extratos (
    id SERIAL PRIMARY KEY,
    conta_id INTEGER NOT NULL REFERENCES contas(id),
    data_geracao TIMESTAMP NOT NULL DEFAULT NOW(),
    conteudo TEXT -- conteúdo do extrato em texto ou base64 PDF
);