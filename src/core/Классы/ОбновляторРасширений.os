#Использовать v8runner
#Использовать logos
#Использовать types
#Использовать json
#Использовать "./internal"

Перем РабочийКонфигуратор;
Перем Лог;

Перем НаборРасширений;

Перем ПутьКОбработкеПередОбновлением; // Путь к файлу обработки перед обновлением 
Перем ПутьКОбработкеПослеОбновления; // Путь к файлу обработки после обновлением 
Перем ПутьКОбработкиОбновленияРасширения; // Путь к файлу обработки обновления расширений 
Перем ОтключитьВсеРасширения;

Перем МассивПроцессоровВывода;

Процедура ПриСозданииОбъекта()
	
	Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB.EpfUpdater");
	ОтключитьВсеРасширения = Ложь;
	МассивПроцессоровВывода = Новый Массив();
КонецПроцедуры

Процедура ДобавитьСпособВывода(Знач ПроцессорВывода) Экспорт
	МассивПроцессоровВывода.Добавить(ПроцессорВывода);
	Лог.ДобавитьСпособВывода(ПроцессорВывода);
КонецПроцедуры

Процедура УстановитьУправлениеКонфигуратором(НовоеУправлениеКонфигуратором) Экспорт
	РабочийКонфигуратор = НовоеУправлениеКонфигуратором;
КонецПроцедуры

Процедура УстановитьНастройкиОбновления(НастройкиОбновления) Экспорт
	
	НаборРасширений = КопированиеТипа.Скопировать(НастройкиОбновления.НаборРасширений);

	НастройкиОбновления.Свойство("ПутьКОбработкеПередОбновлением", ПутьКОбработкеПередОбновлением);
	НастройкиОбновления.Свойство("ПутьКОбработкеПослеОбновления", ПутьКОбработкеПослеОбновления);
	НастройкиОбновления.Свойство("ПутьКОбработкиОбновленияРасширения", ПутьКОбработкиОбновленияРасширения);
	НастройкиОбновления.Свойство("ОтключитьВсеРасширения", ОтключитьВсеРасширения);

	Если ПустаяСтрока(ПутьКОбработкиОбновленияРасширения) Тогда
		ПутьКОбработкиОбновленияРасширения = ПолучитьВнутреннююОбработкаОбновленияРасширений()
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьВнутреннююОбработкаОбновленияРасширений()
	Возврат "";
КонецФункции

Процедура Запустить() Экспорт
	
	ВыполнитьОбработкуПриСобытии("ПередОбновлением");
	
	Попытка
		ВыполнитьОбновление();
	Исключение
		
		ИнформацияОбОшибке = НоваяИнформацияОбОшибке("Ошибка обновления расширений информационной базы: %1", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Лог.КритичнаяОшибка(ИнформацияОбОшибке);
		ВызватьИсключение ИнформацияОбОшибке;
		
	КонецПопытки;
	
	ВыполнитьОбработкуПриСобытии("ПослеОбновления");
	 
КонецПроцедуры

// TODO: Переделать на обновление через предприятие
Процедура ВыполнитьОбновление()
	
	Лог.Информация("Обновление расширений информационной базы");	

	ФайлДанныхДляОбработки = ВременныеФайлы.СоздатьФайл();
	
	ЗаписатьДанныеДляОбработки(ФайлДанныхДляОбработки);
	
	ФайлОтчетаОбработки = ВременныеФайлы.СоздатьФайл();
	
	КлючЗапуска = СтрШаблон("%1|%2", ФайлДанныхДляОбработки, ФайлОтчетаОбработки);

	ВыполнитьОбработку(ПутьКОбработкиОбновленияРасширения, КлючЗапуска);
	
	Лог.Отладка("Читаю текст сообщения рабочего процесса агента");
	ОбработатьДанныеЛогаОбновленияРасширений(ФайлОтчетаОбработки);

КонецПроцедуры

Процедура ОбработатьДанныеЛогаОбновленияРасширений(Знач ПутьКФайлу)
	
	ТекстФайла = ПрочитатьФайл(ПутьКФайлу);

	СтруктурированныйЛог = ИзJson(ТекстФайла);

	Для каждого СтрокаЛога Из СтруктурированныйЛог Цикл
		
		СообщениеЛога = СтрокаЛога["Сообщение"];
		УровеньСообщения = СтрокаЛога["Уровень"];
		ДополнительныеДанные = СтрокаЛога["ДополнительныеДанные"];
		УстановитьДополнительныеДанныеСообщения(ДополнительныеДанные);

		Если УровеньСообщения = УровниЛога.Информация Тогда
			Лог.Информация(СообщениеЛога);
		ИначеЕсли УровеньСообщения = УровниЛога.Ошибка Тогда
			Лог.Ошибка(СообщениеЛога);
		ИначеЕсли УровеньСообщения = УровниЛога.Отладка Тогда
			Лог.Отладка(СообщениеЛога);
		ИначеЕсли УровеньСообщения = УровниЛога.КритичнаяОшибка Тогда
			Лог.КритичнаяОшибка(СообщениеЛога);
		ИначеЕсли УровеньСообщения = УровниЛога.Предупреждение Тогда
			Лог.Предупреждение(СообщениеЛога);
		Иначе
			Лог.Отладка(СообщениеЛога)
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура УстановитьДополнительныеДанныеСообщения(ДополнительныеДанныеСообщения)
	
	Для каждого ПроцессорВывода Из МассивПроцессоровВывода Цикл
		
		Если Не ТипЗнч(ПроцессорВывода) = Тип("ВыводЛогаВRabbitMQ") Тогда
			Продолжить;
		КонецЕсли;

		ПроцессорВывода.ДополнительныеДанныеСообщения = ДополнительныеДанныеСообщения;

	КонецЦикла;

КонецПроцедуры

Функция ПрочитатьФайл(Знач ПутьКФайлу)
	
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу);
	ТекстФайла = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	Возврат ТекстФайла;

КонецФункции

Процедура ЗаписатьДанныеДляОбработки(Знач ПутьКФайлу)

	ДанныеСериализации = Новый Структура();
	ДанныеСериализации.Вставить("ОтключитьВсеРасширения", ОтключитьВсеРасширения);
	ДанныеСериализации.Вставить("НаборРасширений", НаборРасширений);

	ТекстJSON = ВJson(ДанныеСериализации);

	ЗаписьТекста = Новый ЗаписьТекста(ПутьКФайлу);
	ЗаписьТекста.Записать(ТекстJSON);
	ЗаписьТекста.Закрыть();

КонецПроцедуры

Функция ВJson(Знач ДанныеСериализации)
	
	ПарсерJSON = Новый ПарсерJSON;
	Возврат ПарсерJSON.ЗаписатьJSON(ДанныеСериализации);

КонецФункции

Функция ИзJson(ТекстJSON)
	
	Парсер = Новый ПарсерJSON;
	Результат = Парсер.ПрочитатьJSON(ТекстJSON);

	Возврат Результат;

КонецФункции

Функция НоваяИнформацияОбОшибке(Знач Сообщение,
	Знач Параметр1 = Неопределено, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	Если ЕстьЗаполненныеПараметры(Параметр1, Параметр2, Параметр3,
		Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9) Тогда
		
		Сообщение = СтрШаблон(Сообщение, Параметр1,
		Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	КонецЕсли;
	
	Возврат Сообщение;
	
КонецФункции

Функция ЕстьЗаполненныеПараметры(Знач Параметр1 = Неопределено, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	Если НЕ Параметр1 = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли НЕ Параметр2 = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли НЕ Параметр3 = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли НЕ Параметр4 = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли НЕ Параметр5 = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли НЕ Параметр6 = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли НЕ Параметр7 = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли НЕ Параметр8 = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли НЕ Параметр9 = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура ВыполнитьОбработкуПриСобытии(ИмяСобытия)
	
	КлючЗапуска = "";

	Если ИмяСобытия = "ПередОбновлением" Тогда
		ПутьКФайлуОбработки = ПутьКОбработкеПередОбновлением;
	ИначеЕсли ИмяСобытия = "ПередОбновлением" Тогда
		ПутьКФайлуОбработки = ПутьКОбработкеПослеОбновления;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПутьКФайлуОбработки) Тогда
		
		Попытка
			
			ВыполнитьОбработку(ПутьКФайлуОбработки, КлючЗапуска);
			
		Исключение
			
			ИнформацияОбОшибке = НоваяИнформацияОбОшибке("Ошибка выполнения события <%1> обновления. Описание ошибки: <%2>", ИмяСобытия, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение ИнформацияОбОшибке;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьОбработку(Знач ПутьКФайлуОбработки, Знач КлючЗапуска = "")
	
	ФайлОбработки = Новый Файл(ПутьКФайлуОбработки);
	
	Если НЕ ФайлОбработки.Существует() Тогда
		ВызватьИсключение НоваяИнформацияОбОшибке("Файл обработки <%1> не найден", ФайлОбработки.ПолноеИмя);
	КонецЕсли;
	
	ПараметрыЗапускаОбработки = СтрШаблон("/Execute ""%1""", ФайлОбработки.ПолноеИмя);
	РабочийКонфигуратор.ЗапуститьВРежимеПредприятия(КлючЗапуска, Ложь, ПараметрыЗапускаОбработки);
	
КонецПроцедуры