CREATE TABLE log_auditorias (
    id SERIAL PRIMARY KEY,
    nome_tabela VARCHAR(50) NOT NULL,
    operacao VARCHAR(10) NOT NULL, 
    usuario VARCHAR(50) NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dados_antigos TEXT,
    dados_novos TEXT
);

create or replace function fn_trg_validar_reducao_salario()
returns trigger as $$
begin
    if new.salario < old.salario then
        raise exception 'Operação cancelada: O salário do funcionário % não pode ser diminuido', old.nome;
    end if;
    
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_validar_reducao_salario
before update on funcionarios
for each row
execute function fn_trg_validar_reducao_salario();

select * from funcionarios where id = 1;
update funcionarios set salario = 1 where id = 1;

create or replace function fn_trg_auditar_exclusao_funcionario()
returns trigger as $$
begin
    insert into log_auditorias (nome_tabela, operacao, usuario, data_hora, dados_antigos)
    values (
        'funcionarios',
        'DELETE',
        current_user,
        now(),
        concat('ID: ', old.id, ' | Nome: ', old.nome, ' | Salário: ', old.salario)
    );

    return old;
end;
$$ language plpgsql;

create or replace trigger trg_auditar_exclusao_funcionario
after delete on funcionarios
for each row
execute function fn_trg_auditar_exclusao_funcionario();

delete from funcionarios where id = 1;

select * from log_auditorias;