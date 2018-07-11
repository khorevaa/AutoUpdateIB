# AutoUpdateIB

[![Stars](https://img.shields.io/github/stars/khorevaa/AutoUpdateIB.svg?label=Github%20%E2%98%85&a)](https://github.com/khorevaa/AutoUpdateIB/stargazers)
[![Release](https://img.shields.io/github/tag/khorevaa/AutoUpdateIB.svg?label=Last%20release&a)](https://github.com/khorevaa/AutoUpdateIB/releases)
[![Открытый чат проекта https://gitter.im/EvilBeaver/oscript-library](https://badges.gitter.im/khorevaa/AutoUpdateIB.png)](https://gitter.im/EvilBeaver/oscript-library)

[![Build Status](https://travis-ci.org/khorevaa/AutoUpdateIB.svg?branch=master)](https://travis-ci.org/khorevaa/AutoUpdateIB)
[![Coverage Status](https://sonar.silverbulleters.org/api/badges/measure?key=opensource-AutoUpdateIB&metric=coverage&blinking=true)](https://coveralls.io/github/khorevaa/AutoUpdateIB?branch=master)

# Приложение для автоматизации обновления большого количества информационных баз

## История

В далеком 2009 году, была поставлена задача автоматизировать обновление ~250 баз с конфигурацией ББУ (нетипового релиза).

В качестве разработки была выбрана платформа `AutoIt` и родился проект [AutoUpdate1C](https://github.com/khorevaa/AutoUpdate1C)

Написана самая первая публикация на [Infostart](https://infostart.ru/public/19727/) с тех пор скрипт работает и обновляет несколько тысяч информационных баз.

Прошло много времени и появились замечательные инструменты [OScript](http://oscript.io/) и [RabbitMQ](www.rabbitmq.com)

И началась новая история....

## Описание

Данное приложение является логических продолжением проекта [AutoUpdate1C](https://github.com/khorevaa/AutoUpdate1C) с использованием языка [OScript](http://oscript.io/)

### Функциональные возможности

* Блокировка и отключение сеансов в информационной базе с использованием [irac](https://github.com/arkuznetsov/irac)
* Выполнение обновления конфигурации информационной базы
* Выполнение загрузки конфигурации в информационную базу
* Запуск обработок перед и после выполнения обновления/загрузки конфигурации информационной базы
* Работа в режиме агента сервиса очередей `RabbitMQ`

### Пример работы

* Одиночное обновление информационной базы

    ```shell

    Команда: update, u
    Выполняет одиночное обновление информационной базы 1С

    Строка запуска: AutoUpdateIB update [ОПЦИИ] -- DBCONNECTION PATH

    Аргументы:
    DBCONNECTION  Строка подключения к информационной базе (env $DB_CONNECTION)
    PATH          Путь к файлу или каталогу обновления

    Опции:
    -u, --db-user                         пользователь информационной базы (env $DB_USER)
    -p, --db-pwd                          пароль пользователя информационной базы (env $DB_PASSWORD, $IB_PWD)
    -U, --uc-code                         ключ разрешения запуска (env $DB_PASSWORD, $IB_PWD)
    -v, --v8version                       версия платформы для запуска (env $DB_PASSWORD, $IB_PWD) (по умолчанию 8.3)
    -L, --load-cf                         загрузка конфигурации вместо обновления (env $DB_PASSWORD, $IB_PWD)
    -F, --use-full-ditr                   использовать для обновления полный дистрибутив (env $DB_PASSWORD, $IB_PWD)
    -D, --update-dynamic                  использовать динамическое обновление (env $DB_PASSWORD, $IB_PWD)
    -W, --update-warnings-as-errors       при обновлении предупреждения как ошибки (env $DB_PASSWORD, $IB_PWD)
    -S, --update-server                   использовать обновление на сервере (env $DB_PASSWORD, $IB_PWD)
    -E, --update-extension                обновление расширения (env $DB_PASSWORD, $IB_PWD)
    -B, --block-db                        заблокировать информационную базу перед обновлением (env $DB_PASSWORD, $IB_PWD)
        --cluster-user                    пользователь для подключения к кластеру сервера 1С (env $DB_PASSWORD, $IB_PWD)
        --cluster-pwd                     пароль пользователя для подключения к кластеру сервера 1С (env $DB_PASSWORD, $IB_PWD)
        --cluster-port                    порт для подключения кластеру сервера 1С (env $DB_PASSWORD, $IB_PWD) (по умолчанию 1545)
        --run-after                       путь к обработке для запуска перед выполнением обновления (env $DB_PASSWORD, $IB_PWD)
        --run-before                      путь к обработке для запуска после выполнения обновления (env $DB_PASSWORD, $IB_PWD)

    ```

* Работа в режиме Агента

    ```shell
    Команда: agent, a
    Выполняет запуск в режиме агента обновления

    Строка запуска: AutoUpdateIB agent [ОПЦИИ] -- SERVER

    Аргументы:
    SERVER        Адрес сервера RabbitMQ (env $RMQ_SERVER)

    Опции:
    -u, --user                    пользователь сервера RabbitMQ (env $RMQ_USER)
    -p, --pwd                     пароль пользователя сервера RabbitMQ (env $RMQ_PWD, $RMQ_PASSWORD)
    -q, --queue                   имя очереди получения сообщений на сервере RabbitMQ (env $RMQ_QUEUE)
    -P, --port                    порт сервера RabbitMQ (env $RMQ_PORT) (по умолчанию 15672)
    -e, --exchange-name           имя точки ответа сервера RabbitMQ (env $RMQ_EXCHANGE_NAME)
    -R, --routing-key             ключ маршрутизации сервера RabbitMQ (env $RMQ_ROUTING_KEY)
    -H, --virtual-host            виртуальный хост на сервере RabbitMQ (env $RMQ_VHOST) (по умолчанию %2F)
    -t, --queue-timer             таймер опроса сервера очереди  (по умолчанию 60)
        --workers-dir             рабочий каталог процессов  (по умолчанию /home/khorevaa/.local/share/AutoUpdateIB)
    -M, --workers-max-count       количество рабочих процессов агента (0 - автоматический расчет)  (по умолчанию 0)
    -T, --worker-timeuot          таймаут перезапуска рабочего процесса агента при зависании  (по умолчанию 0)
    ```