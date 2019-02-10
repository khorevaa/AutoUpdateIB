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

Данное приложение является логическим продолжением проекта [AutoUpdate1C](https://github.com/khorevaa/AutoUpdate1C) с использованием языка [OScript](http://oscript.io/)

Это приложение обеспечивает массовое развертывание новых конфигураций!

> Приложение ориентировано на работу с серверными базами 1С

### Функциональные возможности

* Блокировка и отключение сеансов в информационной базе с использованием [v8rac](https://github.com/khorevaa/v8rac)
* Выполнение обновления конфигурации информационной базы
* Выполнение загрузки конфигурации в информационную базу
* Выполнение обновления расширений конфигурации
* Выполнение обработок в режиму предприятия
* Создание резервной копии, и восстановление в случае ошибки
* Запуск обработок перед и после выполнения обновления/загрузки конфигурации информационной базы
* Работа в режиме агента сервиса очередей `RabbitMQ`
* Обработка информационных базе в пакетном режиме
* Сборка в режиме `exe`. Работа без установки дополнительных библиотек и приложений

### Пример работы

* Одиночное обновление информационной базы

    ```shell

  
    ```

* Работа в режиме Агента

    ```shell
 
    ```
    
## Установка

Для установки необходимо:
* Скачать файл AutoUpdateIB.exe из раздела [releases](https://github.com/khorevaa/AutoUpdateIB/releases)
* Воспользоваться командой:

```shell
    AutoUpdateIB.exe --help
```

## Публичный интерфейс

[Документация публичного интерфейса (в разработке)](docs/README.md)

## Доработка

Актуальный [TODO](TODO)

Доработка проводится по git-flow. Жду ваших PR.

## Лицензия

Смотри файл [`LICENSE`](LICENSE).
