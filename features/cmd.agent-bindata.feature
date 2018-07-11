# language: ru

Функционал: Выполнение обновления информационной базы 
    Как специалист 1С
    Я хочу иметь инструмент пакетного обновление информационных баз
    Чтобы автоматизировать обновление при получении нового релиза конфигурации

Структура сценария: <Сценарий>
    Дано Я очищаю параметры команды "AutoUpdateIB" в контексте
    И Я устанавливаю путь выполнения команды "AutoUpdateIB" к текущей библиотеке
    И Я создаю временный каталог и сохраняю его в переменной "ТестоваяБаза"
    И Я создаю тестовую базу в каталоге "ТестоваяБаза"
    И Я включаю отладку лога с именем "oscript.app.AutoUpdateIB"
    И Я создаю ОчередьОбновленияRMQ
    И Я устанавливаю настройки ОчередьОбновленияRMQ сервер "rabbit" порт "15672" пользователь "guest" пароль "guest" виртуальный хост "%2f" очередь "all.update" 
    И Я отправляю настройку обновления в очередь из файла <ПутьКФайлу> 

    Допустим Я добавляю параметр "agent" для команды "AutoUpdateIB"
    И Я добавляю параметр "-u guest" для команды "AutoUpdateIB"
    И Я добавляю параметр "-p guest" для команды "AutoUpdateIB"
    И Я добавляю параметр "-q all.update" для команды "AutoUpdateIB"
    И Я добавляю параметр "-H %2f" для команды "AutoUpdateIB"
    И Я добавляю параметр "-P 15672" для команды "AutoUpdateIB"
    И Я добавляю параметр "-t 0" для команды "AutoUpdateIB"    
    И Я добавляю параметр "rabbit" для команды "AutoUpdateIB"
    Когда Я выполняю команду "AutoUpdateIB"
    Тогда Вывод команды "AutoUpdateIB" содержит "Рабочий процесс завершил работу. Задание выполнено"
    И Вывод команды "AutoUpdateIB" не содержит "Внешнее исключение"
    И Код возврата команды "AutoUpdateIB" равен 0

    
Примеры:
    | Сценарий | ПутьКФайлу | 
    | Обновление из каталога | tests/fixtures/bindata-run-before.yaml | 
