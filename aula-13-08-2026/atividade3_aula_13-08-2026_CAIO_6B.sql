
CREATE OR REPLACE FUNCTION public.fn_total_vendas_funcionario(p_funcionario_id integer)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_total NUMERIC(10,2);
BEGIN
	SELECT COALESCE(SUM(valor), 0.00) INTO v_total
	FROM vendas
	WHERE funcionario_id = p_funcionario_id;

	RETURN v_total;
END;
$function$;

create or replace procedure pr_bonificar_vendedores_massa()
language plpgsql as $$
declare 
	-- variáveis e cursores
	cur_vendedores cursor for
		select f.id, f.nome
		from funcionarios f
		join departamentos d
			on d.id = f.departamento_id
		where d.nome = 'Vendas e Comercial';

	v_id_funcionario integer;
	v_nome_funcionario varchar(150);
	v_total_vendas numeric(10,2);
begin
	open cur_vendedores;

	loop 
		fetch cur_vendedores into v_id_funcionario, v_nome_funcionario;
		exit when not found;
	
		v_total_vendas := fn_total_vendas_funcionario(v_id_funcionario);

		if v_total_vendas > 10000 then 
			update funcionarios
			set salario = salario + 500
			where id = v_id_funcionario;
			
			raise notice '% recebeu o bônus de R$ 500,00.', v_nome_funcionario;
		else
			raise notice '% não recebeu o bônus.', v_nome_funcionario;
		end if;
	end loop;

	close cur_vendedores;
end;
$$;

call pr_bonificar_vendedores_massa();
