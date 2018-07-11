# language: ru

Функционал: Выполнение обновления информационной базы 
    Как специалист 1С
    Я хочу иметь инструмент пакетного обновление информационных баз
    Чтобы автоматизировать обновление при получении нового релиза конфигурации

Контекст: Контекст файловой базы для обновления
    Когда Я очищаю параметры команды "AutoUpdateIB" в контексте
    И Я устанавливаю путь выполнения команды "AutoUpdateIB" к текущей библиотеке
    И Я создаю временный каталог и сохраняю его в переменной "ТестоваяБаза"
    И Я создаю тестовую базу в каталоге "ТестоваяБаза"
    И Я включаю отладку лога с именем "oscript.app.AutoUpdateIB"
    И Я создаю ОчередьОбновленияRMQ
    И Я устанавливаю настройки ОчередьОбновленияRMQ сервер "rabbit" порт "15672" пользователь "guest" пароль "guest" виртуальный хост "%2f" очередь "all.update" 
    И Я отправляю настройку обновления в очередь
    """
    routing_key: all.update
    properties:
      type: update
      message_id: 2d2a9915-e59f-4359-8e3c-f5b29b8a5645
      reply_to: report.update
      content_type: application/json
    payload: 
      Версия: 1.0
      Наименование: 'РИБ Сводная Копия от 12.08.2013'
      Код: 695
      НастройкаПодключения:
        ФайловаяБаза: 
          ПутьККаталогу: <ТестоваяБаза>
        Пользователь: ''
        Пароль: ''
      Обновление: 
        Файл: 
          НомерРелиза: 1.1
          ПутьККаталогу: ./tests/fixtures/distr
      НастройкаОбновления:
        ВерсияПлатформы: 8.3 
        НаСервере: Истина
        Динамическое: Ложь
        ПредупрежденияКакОшибки: Ложь
        ИспользоватьПолныйДистрибутив: Истина
      ЗагрузитьКонфигурацию: Ложь
      КластерПриложений:
        Пользователь: ''
        Пароль: ''
      БлокировкаСеансов:
        Заблокировать: Ложь
        КодРазрешенияЗапуска: 123
      ПослеОбновления:
        ПутьКОбработке: ./tests/fixtures/epf/before-update.epf
      ПередОбновлением:   
        ПутьКОбработке: ./tests/fixtures/epf/after-update.epf
    """

Сценарий: Обновление конфигурации в режиме агента
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
