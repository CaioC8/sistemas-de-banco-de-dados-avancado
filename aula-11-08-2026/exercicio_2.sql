CREATE OR REPLACE PROCEDURE pr_registrar_venda(
    p_funcionario_id INT,
    p_valor NUMERIC,
    p_data DATE
)
AS $$
DECLARE
    v_departamento_id INT;
BEGIN
    SELECT departamento_id
    INTO v_departamento_id
    FROM funcionarios
    WHERE id = p_funcionario_id;

    IF v_departamento_id <> 2 THEN
        RAISE EXCEPTION 'Funcionário não pertence ao departamento de vendas.';
    END IF;

    INSERT INTO vendas (
        valor,
        funcionario_id,
        data
    )
    VALUES (
        p_valor,
        p_funcionario_id,
        p_data
    );

    RAISE NOTICE 'Venda registrada com sucesso.';
END;
$$ LANGUAGE plpgsql;

CALL pr_registrar_venda(5, 2500.00, '2026-08-11');