# language: ru

Функционал: Выполнение обновления информационной базы 
    Как специалист 1С
    Я хочу иметь инструмент пакетного обновление информационных баз
    Чтобы автоматизировать обновление при получении нового релиза конфигурации

Структура сценария: <Сценарий>
    Дано Я создаю временный каталог и сохраняю его в переменной "ТестоваяБаза"
    И Я создаю тестовую базу в каталоге "ТестоваяБаза"
    И Я включаю отладку лога с именем "oscript.app.AutoUpdateIB.UpdateManager"
       
    Допустим Я создаю настройку обновления из файла <ПутьКФайлу> 
    Когда Я запуская менеджер обновление по настройке
    Тогда Работа менеджера обновления завершена успешно

 Примеры:
    | Сценарий | ПутьКФайлу | 
    | Обновление из каталога | tests/fixtures/catalog.yaml | 
    | Обновление (cfu) из каталога | tests/fixtures/catalog-cfu.yaml | 
    | Использование бинарных данных перед обновлением | tests/fixtures/bindata-run-before.yaml | 