create or replace function fn_trg_auditar_vendas()
returns trigger as $$
begin
    insert into log_auditorias (nome_tabela, operacao, usuario, data_hora, dados_antigos, dados_novos)
    values (
        'vendas',
        'UPDATE',
        current_user,
        now(),
        concat('ID: ', old.id, ' | Valor: ', old.valor, ' | Funcionário ID: ', old.funcionario_id, ' | Data: ', old.data),
        concat('ID: ', new.id, ' | Valor: ', new.valor, ' | Funcionário ID: ', new.funcionario_id, ' | Data: ', new.data)
    );

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_auditar_vendas
after update on vendas
for each row
execute function fn_trg_auditar_vendas();

update vendas set valor = 200 where id = 2;