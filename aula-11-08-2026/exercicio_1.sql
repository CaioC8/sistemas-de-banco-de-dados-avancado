CREATE OR REPLACE FUNCTION fn_calcular_comissao(
    p_funcionario_id INT,
    p_mes INT,
    p_ano INT
)
RETURNS NUMERIC
AS $$
DECLARE
    v_valor_vendas NUMERIC(10, 2);
BEGIN
    SELECT COALESCE(SUM(valor), 0)
    INTO v_valor_vendas
    FROM vendas
    WHERE funcionario_id = p_funcionario_id
      AND EXTRACT(YEAR FROM data) = p_ano
      AND EXTRACT(MONTH FROM data) = p_mes;

    IF v_valor_vendas > 5000 THEN
        RETURN v_valor_vendas * 0.10;
    ELSIF v_valor_vendas <= 5000 THEN
        RETURN v_valor_vendas * 0.05;
    ELSE
        RETURN 0.00;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT fn_calcular_comissao(5, 5, 2026);