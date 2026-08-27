create or replace function fn_trg_ajustar_meta_venda()
returns trigger as $$
begin
    if new.valor = 0 then
        insert into log_auditorias (nome_tabela, operacao, usuario, data_hora, dados_antigos, dados_novos)
        values (
            'vendas',
            'UPDATE',
            current_user,
            now(),
            concat('ID: ', old.id, ' | Valor: ', old.valor, ' | Funcionário ID: ', old.funcionario_id, ' | Data: ', old.data),
            concat('ID: ', new.id, ' | Valor: ', new.valor, ' | Funcionário ID: ', new.funcionario_id, ' | Data: ', new.data)
        );

        raise notice 'A venda % do funcionário % foi zerada/estornada.', new.id, new.funcionario_id;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_ajustar_meta_venda
after update on vendas
for each row
execute function fn_trg_ajustar_meta_venda();

