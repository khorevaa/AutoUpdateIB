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
    И Я создаю КлиентRMQ
    И Я устанавливаю настройки КлиентRMQ сервер "localhost" порт "15672" пользователь "guest" пароль "guest" виртуальный хост "%2f" очередь "all.update" 
    И Я создаю файл настройки из файла <ПутьКФайлу> и сохраняю в переменную "FILE"
    И Я указываю параметры расширения для расширения <ИмяРасширения>, <ПутьКРасширению>, <БезопасныйРежим>
    И Я отправляю настройку обновления в очередь из файла "FILE"

    Допустим Я добавляю параметр "-v agent" для команды "AutoUpdateIB"
    И Я добавляю параметр "-u guest" для команды "AutoUpdateIB"
    И Я добавляю параметр "-p guest" для команды "AutoUpdateIB"
    И Я добавляю параметр "-q all.update" для команды "AutoUpdateIB"
    И Я добавляю параметр "--report-queue report.update" для команды "AutoUpdateIB"
    И Я добавляю параметр "-H %2f" для команды "AutoUpdateIB"
    И Я добавляю параметр "-P 15672" для команды "AutoUpdateIB"
    И Я добавляю параметр "-t 0" для команды "AutoUpdateIB"    
    И Я добавляю параметр "localhost" для команды "AutoUpdateIB"
    Когда Я выполняю команду "AutoUpdateIB"
    Тогда Вывод команды "AutoUpdateIB" содержит "Успешно выполнено задание рабочего процесса"
    И Вывод команды "AutoUpdateIB" не содержит "Внешнее исключение"
    И Код возврата команды "AutoUpdateIB" равен 0

    
Примеры:
    | Сценарий | ПутьКФайлу | ИмяРасширения | ПутьКРасширению | БезопасныйРежим | РезультатПроверки |
    | Расширение адаптация | tests/fixtures/one-base-extentions.yaml | Адаптация | tests/fixtures/cfe/Адаптация.cfe | Ложь | Проверка возможности применения расширения <Адаптация> - пройдена |
    | Расширение дополнение | tests/fixtures/one-base-extentions.yaml | Дополнение | tests/fixtures/cfe/Дополнение.cfe |  Ложь | Проверка возможности применения расширения <Дополнение> - пройдена |
    | Обновление расширений одной базы | tests/fixtures/one-base-extentions.yaml | Исправление | tests/fixtures/cfe/Исправление.cfe | Ложь | Проверка возможности применения расширения <Исправление> - пройдена |
 