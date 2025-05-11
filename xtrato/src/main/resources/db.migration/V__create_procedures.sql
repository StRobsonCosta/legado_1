-- Procedure para registrar uma nova transação e atualizar saldo
CREATE OR REPLACE FUNCTION registrar_transacao(
    p_numero_conta VARCHAR,
    p_tipo VARCHAR,
    p_valor DECIMAL
) RETURNS VOID AS $$
DECLARE
    v_conta_id INTEGER;
BEGIN
    SELECT id INTO v_conta_id FROM contas WHERE numero_conta = p_numero_conta;

    IF p_tipo = 'DEBITO' THEN
        UPDATE contas SET saldo = saldo - p_valor WHERE id = v_conta_id;
    ELSIF p_tipo = 'CREDITO' THEN
        UPDATE contas SET saldo = saldo + p_valor WHERE id = v_conta_id;
    ELSE
        RAISE EXCEPTION 'Tipo de transação inválido';
    END IF;

    INSERT INTO transacoes(conta_id, tipo, valor)
    VALUES (v_conta_id, p_tipo, p_valor);
END;
$$ LANGUAGE plpgsql;

-- Procedure para gerar extrato consolidado de uma conta
CREATE OR REPLACE FUNCTION gerar_extrato(
    p_numero_conta VARCHAR
) RETURNS TEXT AS $$
DECLARE
    v_conta_id INTEGER;
    v_extrato TEXT := '';
    v_row RECORD;
BEGIN
    SELECT id INTO v_conta_id FROM contas WHERE numero_conta = p_numero_conta;

    FOR v_row IN
        SELECT tipo, valor, data_transacao
        FROM transacoes
        WHERE conta_id = v_conta_id
        ORDER BY data_transacao
    LOOP
        v_extrato := v_extrato || v_row.tipo || ' | ' || v_row.valor || ' | ' || v_row.data_transacao || E'\n';
    END LOOP;

    INSERT INTO extratos(conta_id, conteudo)
    VALUES (v_conta_id, v_extrato);

    RETURN v_extrato;
END;
$$ LANGUAGE plpgsql;
