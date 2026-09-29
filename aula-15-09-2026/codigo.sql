create extension pageinspect;

select * from page_header(get_raw_page('funcionarios', 0));

select lp, lp_off, lp_flags, lp_len from heap_page_items(get_raw_page('funcionarios', 0));

-- ver página e tupla onde estão fisicamente os registros
select *, ctid from funcionarios;

insert into funcionarios(nome, salario, departamento_id) VALUES ("CAIO", 1000000, 1);
update funcionarios set nome ='caiozinho' where id = 18;
delete from funcionarios where id = 18;

-- reorganizar as tuplas e páginas para evitar espaços em branco
vacuum full funcionarios;

create table vendas_massa as select * from vendas where 1 = 0;

insert into vendas_massa (valor, funcionario_id, data) 
select (random() * 5000)::numeric(10, 2),
       (1 + floor(random() * 15))::int,
       current_date - (floor(random() * 365))::int
from generate_series(1, 50000);

select * from vendas_massa;

-- descobrir numero de páginas
SELECT
    MAX(
        split_part(
            trim(both '()' from ctid::text),
            ',',
            1
        )::bigint
    ) + 1 AS total_paginas
FROM vendas_massa;

-- descobrir tamanho físico
SELECT pg_size_pretty(pg_relation_size('vendas_massa'));