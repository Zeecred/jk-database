# Databases

Este projeto serve apenas para criar os banco de dados iniciais.

Para tanto, existe um único comando que é do interesse de quem está implementando: `run.sh`

Ele vai se encarregar de criar o ambiente virtual para o Python e também de rodar os scripts necessários para criar os banco de dados e também o s usuários de cada um

Se os bancos de dados e/ou os usuários já existirem, tudo é preservado como está.

Por esta razão `run.sh` pode ser rodado tantas vezes como quiser.