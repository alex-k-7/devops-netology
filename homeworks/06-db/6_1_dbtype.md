### Домашнее задание к занятию "6.1. Типы и структура СУБД"

>#### Введение
>
>Перед выполнением задания вы можете ознакомиться с 
>[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).
> 
>
>#### Задача 1
>
>Архитектор ПО решил проконсультироваться у вас, какой тип БД 
>лучше выбрать для хранения определенных данных.
>
>Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:
>

>- Электронные чеки в json виде

MongoDB. Считаю, что документо-ориентированная СУБД, которая хранит данные в похожем на json формате, подойдет лучше всего.

>- Склады и автомобильные дороги для логистической компании

Думаю, здесь лучше использовать SQL базу. Скорее всего БД будет внушительной со множеством разных
не однотипных данных, которые лучше хранить во взаимосвязанных таблицах. 

>- Генеалогические деревья

Здесь подойдет иерархические база данных, мне кажется. Т.к. эти БД сами представляют собой древовидную структуру. 

>- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации

Для кэша хорошо подойдет NoSQL СУБД типа ключ—значение, например, Redis или Memcached, т.к. они
быстрые и имеют возможность присвоить данным Time-To-Live. 

>- Отношения клиент-покупка для интернет-магазина

Здесь напрашивается СУБД типа ключ—значение, но мне кажется подойдет и документо-ориентированная СУБД.
Простая БД, думаю, нет смысла использовать SQL.

>#### Задача 2
>
>Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
>CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
>(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):
>
>А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

>- Данные записываются на все узлы с задержкой до часа (асинхронная запись)

AP. PA/EL.

>- При сетевых сбоях, система может разделиться на 2 раздельных кластера

AP. PA/EC, EC/PC.

>- Система может не прислать корректный ответ или сбросить соединение
 
CP. EC/PC.

>#### Задача 3
>
>Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

Думаю, что технически могут. Совместить некоторые пункты принципов возможно, но они придумывались, 
как противопоставляющиеся друг другу. Либо надежность, либо быстродействие. Однако, в MongoDB, например,
сейчас как-то поддерживаются ACID транзакции. Т.е. данную БД можно считать BASE/ACID

>#### Задача 4
>
>Вам дали задачу написать системное решение, основой которого бы послужили:
>
>- фиксация некоторых значений с временем жизни
>- реакция на истечение таймаута
>
>Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
>Что это за система? Какие минусы выбора данной системы?

Это Redis. Из минусов в голову приходит только хранение данных в памяти (т.е. при сбоях питания данные
теряются). Но это одновременно и плюс - дает быстродействие. Также Redis не поддерживает автоматическую
отказоустойчивость и восстановление (при отказе ведущей реплики - необходимо вручную выбрать новую). 

