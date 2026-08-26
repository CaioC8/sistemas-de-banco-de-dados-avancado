create or replace function fn_trg_validar_valor_venda()
returns trigger as $$
begin
    if new.valor <= 0 then
        raise exception 'Operação cancelada: o valor da venda não pode ser menor ou igual a zero.';
    end if;

    if new.data > current_date then
        raise exception 'Operação cancelada: a data da venda não pode ser no futuro.';
    end if;

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_validar_valor_venda
before insert or update on vendas
for each row
execute function fn_trg_validar_venda();

insert into vendas (valor, funcionario_id, data) values (0, 1, '2026-10-10');