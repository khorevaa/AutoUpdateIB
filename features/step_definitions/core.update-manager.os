﻿// Реализация шагов BDD-фич/сценариев c помощью фреймворка https://github.com/artbear/1bdd
#Использовать asserts
#Использовать tempfiles

Перем БДД; //контекст фреймворка 1bdd

// Метод выдает список шагов, реализованных в данном файле-шагов
Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ЯСоздаюНастройкуОбновленияИзФайла");
	ВсеШаги.Добавить("ЯЗапускаяМенеджерОбновлениеПоНастройке");
	ВсеШаги.Добавить("РаботаМенеджераОбновленияЗавершенаУспешно");

	Возврат ВсеШаги;
КонецФункции

// Реализация шагов

// Процедура выполняется перед запуском каждого сценария
Процедура ПередЗапускомСценария(Знач Узел) Экспорт
	
КонецПроцедуры

// Процедура выполняется после завершения каждого сценария
Процедура ПослеЗапускаСценария(Знач Узел) Экспорт
	
КонецПроцедуры


//Я создаю настройку обновления из файла <tests/fixtures/catalog.yaml>
Процедура ЯСоздаюНастройкуОбновленияИзФайла(Знач ПутьКФайлу) Экспорт
	
	КаталогФайловойБазы = БДД.ПолучитьИзКонтекста("ТестоваяБаза");

	ЧтениеТекста = Новый ЧтениеТекста();
	ЧтениеТекста.Открыть(ПутьКФайлу, КодировкаТекста.UTF8);
	ТекстYaml = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	ТекстYaml = СтрЗаменить(ТекстYaml, "<ТестоваяБаза>", КаталогФайловойБазы);

	Процессор = Новый ПарсерYAML;
	Результат = Процессор.ПрочитатьYaml(ТекстYaml);
	
	СоответствиеСообщения = Результат["payload"];

	НастройкиОбновления = Новый НастройкаОбновления;
	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();

	НастройкиОбновления.УстановитьКешФайлов(ВременныйКаталог);

	НастройкиОбновления.Заполнить(СоответствиеСообщения);

	БДД.СохранитьВКонтекст("НастройкиОбновления", НастройкиОбновления);

КонецПроцедуры

//Я запуская менеджер обновление по настройке
Процедура ЯЗапускаяМенеджерОбновлениеПоНастройке() Экспорт

	НастройкиОбновления = БДД.ПолучитьИзКонтекста("НастройкиОбновления");
	ПроцессорОбновления = Новый МенеджерОбновления();
	РезультатВыполнения = ПроцессорОбновления.ВыполнитьОбновление(НастройкиОбновления);

	БДД.СохранитьВКонтекст("РезультатВыполнения", РезультатВыполнения);


КонецПроцедуры

//Работа менеджера обновления завершена успешно
Процедура РаботаМенеджераОбновленияЗавершенаУспешно() Экспорт

	РезультатВыполнения = БДД.ПолучитьИзКонтекста("РезультатВыполнения");
	Ожидаем.Что(РезультатВыполнения.Выполнено, СтрШаблон("Результат обновления не успешен задача <%2> по причине <%1>", РезультатВыполнения.ОписаниеОшибки, РезультатВыполнения.Задача)).Равно(Истина);

КонецПроцедуры