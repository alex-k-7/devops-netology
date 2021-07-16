>### Домашнее задание к занятию "6.2. SQL"
>
>#### Введение
>
>Перед выполнением задания вы можете ознакомиться с 
>[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).
>
>#### Задача 1
>
>Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
>в который будут складываться данные БД и бэкапы.
>
>Приведите получившуюся команду или docker-compose манифест.

```text
docker run -tid -p 5432:5432 --name pgsql -v volumes/db:/var/lib/postgresql/data -v volumes/bcp:/bcp -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=123456 postgres:12
```

>#### Задача 2
>
>В БД из задачи 1: 
>- создайте пользователя test-admin-user и БД test_db
>- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
>- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
>- создайте пользователя test-simple-user  
>- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
>
>Таблица orders:
>- id (serial primary key)
>- наименование (string)
>- цена (integer)
>
>Таблица clients:
>- id (serial primary key)
>- фамилия (string)
>- страна проживания (string, index)
>- заказ (foreign key orders)
>
>Приведите:

>- итоговый список БД после выполнения пунктов выше,

```text
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
```

>- описание таблиц (describe)

```text
test_db=# \d+ orders
                                                        Table "public.orders"
 Column  |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
---------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id      | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 фамилия | character varying(20) |           |          |                                    | extended |              |
 цена    | integer               |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap
```

```text
test_db=# \d+ clients
                                                      Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default               | Storage  | Stats target | Description
-------------------+---------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 фамилия           | text    |           |          |                                     | extended |              |
 страна проживания | text    |           |          |                                     | extended |              |
 заказ             | integer |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap
```
>- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```text
SELECT grantee, table_catalog, table_schema, table_name, privilege_type FROM information_schema.table_privileges WHERE table_schema='public';
```

>- список пользователей с правами над таблицами test_db
```text
     grantee      | table_catalog | table_schema | table_name | privilege_type
------------------+---------------+--------------+------------+----------------
 postgres         | test_db       | public       | orders     | INSERT
 postgres         | test_db       | public       | orders     | SELECT
 postgres         | test_db       | public       | orders     | UPDATE
 postgres         | test_db       | public       | orders     | DELETE
 postgres         | test_db       | public       | orders     | TRUNCATE
 postgres         | test_db       | public       | orders     | REFERENCES
 postgres         | test_db       | public       | orders     | TRIGGER
 test-simple-user | test_db       | public       | orders     | INSERT
 test-simple-user | test_db       | public       | orders     | SELECT
 test-simple-user | test_db       | public       | orders     | UPDATE
 test-simple-user | test_db       | public       | orders     | DELETE
 test-admin-user  | test_db       | public       | orders     | INSERT
 test-admin-user  | test_db       | public       | orders     | SELECT
 test-admin-user  | test_db       | public       | orders     | UPDATE
 test-admin-user  | test_db       | public       | orders     | DELETE
 test-admin-user  | test_db       | public       | orders     | TRUNCATE
 test-admin-user  | test_db       | public       | orders     | REFERENCES
 test-admin-user  | test_db       | public       | orders     | TRIGGER
 postgres         | test_db       | public       | clients    | INSERT
 postgres         | test_db       | public       | clients    | SELECT
 postgres         | test_db       | public       | clients    | UPDATE
 postgres         | test_db       | public       | clients    | DELETE
 postgres         | test_db       | public       | clients    | TRUNCATE
 postgres         | test_db       | public       | clients    | REFERENCES
 postgres         | test_db       | public       | clients    | TRIGGER
 test-simple-user | test_db       | public       | clients    | INSERT
 test-simple-user | test_db       | public       | clients    | SELECT
 test-simple-user | test_db       | public       | clients    | UPDATE
 test-simple-user | test_db       | public       | clients    | DELETE
 test-admin-user  | test_db       | public       | clients    | INSERT
 test-admin-user  | test_db       | public       | clients    | SELECT
 test-admin-user  | test_db       | public       | clients    | UPDATE
 test-admin-user  | test_db       | public       | clients    | DELETE
 test-admin-user  | test_db       | public       | clients    | TRUNCATE
 test-admin-user  | test_db       | public       | clients    | REFERENCES
 test-admin-user  | test_db       | public       | clients    | TRIGGER
(36 rows)
```

>#### Задача 3
>
>Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

>Таблица orders
>
>|Наименование|цена|
>|------------|----|
>|Шоколад| 10 |
>|Принтер| 3000 |
>|Книга| 500 |
>|Монитор| 7000|
>|Гитара| 4000|
>
>Таблица clients
>
>|ФИО|Страна проживания|
>|------------|----|
>|Иванов Иван Иванович| USA |
>|Петров Петр Петрович| Canada |
>|Иоганн Себастьян Бах| Japan |
>|Ронни Джеймс Дио| Russia|
>|Ritchie Blackmore| Russia|
>
>Используя SQL синтаксис:
>- вычислите количество записей для каждой таблицы 
>- приведите в ответе:
>    - запросы 
>    - результаты их выполнения.
```text
test_db=# select count (*) from clients;
 count
-------
     5
(1 row)
```
```text
test_db=# select count (*) from orders;
 count
-------
     5
(1 row)
```

>#### Задача 4
>
>Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
>
>Используя foreign keys свяжите записи из таблиц, согласно таблице:
>
>|ФИО|Заказ|
>|------------|----|
>|Иванов Иван Иванович| Книга |
>|Петров Петр Петрович| Монитор |
>|Иоганн Себастьян Бах| Гитара |
>
>Приведите SQL-запросы для выполнения данных операций.
>
>Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 >
>Подсказк - используйте директиву `UPDATE`.

```text
UPDATE clients SET "заказ"=(SELECT id FROM orders WHERE "наименование"='Книга') WHERE "фамилия"='Иванов Иван Иванович';
UPDATE clients SET "заказ"=(SELECT id FROM orders WHERE "наименование"='Монитор') WHERE "фамилия"='Петров Петр Петрович';
UPDATE clients SET "заказ"=(SELECT id FROM orders WHERE "наименование"='Гитара') WHERE "фамилия"='Иоганн Себастьян Бах';
```
```text
test_db=# SELECT фамилия FROM clients where заказ>0;
       фамилия
----------------------
 Иванов Иван Иванович
 Петров Петр Петрович
 Иоганн Себастьян Бах
(3 rows)
```


>##### Задача 5
>
>Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
>(используя директиву EXPLAIN).
>
>Приведите получившийся результат и объясните что значат полученные значения.

```text
test_db=# explain select фамилия from clients where заказ>0;
                       QUERY PLAN
--------------------------------------------------------
 Seq Scan on clients  (cost=0.00..1.06 rows=3 width=33)
   Filter: ("заказ" > 0)
(2 rows)
```
Seq Scan — последовательное чтение данных таблицы clients.

cost - приблизительная стоимость запуска и приблизительная общая стоимость.

rows - число строк.

width - средний размер строк.


>##### Задача 6
>
>Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
>
>Остановите контейнер с PostgreSQL (но не удаляйте volumes).
>
>Поднимите новый пустой контейнер с PostgreSQL.
>
>Восстановите БД test_db в новом контейнере.
>
>Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

Делаем дамп базы и запускаем новый контейнер:
```text
root@vagrant:~# docker exec -ti pgsql pg_dump -U postgres -d test_db > /root/volumes/bcp/dump.sql
root@vagrant:~# docker stop pgsql
root@vagrant:~# docker run -tid -p 5432:5432 --name pgsql_2 -v /root/volumes/db_2:/var/lib/postgresql/data -v /root/volumes/bcp:/bcp -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=123456 postgres:12
```
Далее создаем базу пользователей в новом контейнере: 
```text
CREATE DATABASE test_db;
CREATE USER "test-simple-user";
CREATE USER "test-admin-user";
```
И восстанавливаем базу:
```text
root@vagrant:~# docker exec -ti pgsql_2 psql -U postgres -d test_db -f /bcp/dump.sql
```