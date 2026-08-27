create or replace function fn_trg_padronizar_nome_funcionario()
returns trigger as $$
begin
    new.nome := upper(new.nome);

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_padronizar_nome_funcionario
before insert or update of nome on funcionarios
for each row
execute function fn_trg_padronizar_nome_funcionario();

select * from funcionarios where id = 1;

update funcionarios set nome = 'Pafuncio' where id = 1;