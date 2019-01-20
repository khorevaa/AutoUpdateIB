#Использовать json
#Использовать types

Перем ТочкаОбмена Экспорт; // Строка
Перем КлючМаршрутизации Экспорт; // Строка
Перем РазмерКонтента Экспорт; // Число
Перем КодировкаКонтента Экспорт; // Строка
Перем ПовторнаяДоставка Экспорт; // Булево
Перем КоличествоСообщенийПосле Экспорт; // Число
Перем ДанныеСообщения Экспорт; // Строка

Перем Параметры; // Структура
Перем Заголовки; // Соответствие, ключи только строки

Перем ДоступныеСвойстваСообщения;
Перем ДоступныеПараметрыСообщения;
Перем Лог;


Функция Параметр(Знач ИмяПараметра, Знач ЗначениеПараметра) Экспорт
	
	Параметры.Вставить(ИмяПараметра, ЗначениеПараметра);
	
	Возврат ЭтотОбъект;
	
КонецФункции

Процедура УстановитьПараметры(Знач ПараметрыСообщения) Экспорт
	
	Для каждого КлючЗначение Из ПараметрыСообщения Цикл
		Параметр(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;

КонецПроцедуры

Процедура УстановитьЗаголовки(Знач ЗаголовкиСообщения) Экспорт
	
	Для каждого КлючЗначение Из ЗаголовкиСообщения Цикл
		Заголовок(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;

КонецПроцедуры

Функция Параметры() Экспорт

	Возврат КопированиеТипа.Скопировать(Параметры);
	
КонецФункции

Функция Заголовки() Экспорт

	Возврат КопированиеТипа.Скопировать(Заголовки);
	
КонецФункции

Функция ЗначениеПараметра(Знач ИмяПараметра) Экспорт
	
	Значение = Неопределено;
	Параметры.Свойство(ИмяПараметра, Значение);
	Возврат Значение;

КонецФункции

Функция ЗначениеЗаголовка(Знач ИмяЗаголовка) Экспорт
	
	Возврат Заголовки[ИмяЗаголовка];

КонецФункции

Функция Заголовок(Знач ИмяЗаголовка, Знач ЗначениеЗаголовка) Экспорт
	
	Заголовки.Вставить(ИмяЗаголовка, ЗначениеЗаголовка);
	
	Возврат ЭтотОбъект;
	
КонецФункции

Процедура ИзСоответствия(ВходящееСоответствие) Экспорт
	
	МассивСвойствОбъекта = СтрРазделить("exchange, redelivered, payload_bytes, payload_encoding, message_count, routing_key", ", ");
	ЭтоСтруктура = ПроверкаТипа.ЭтоСтруктура(ВходящееСоответствие);
	ЭтоСоответствие = ПроверкаТипа.ЭтоЛюбоеСоответствие(ВходящееСоответствие);
	Для каждого СвойствоОбъекта Из МассивСвойствОбъекта Цикл
		
		ИмяКлюча = ДоступныеСвойстваСообщения[СвойствоОбъекта];
		
		Если ЭтоСтруктура Тогда
		
			ЗначениеКлюча = Неопределено;

			Если НЕ ВходящееСоответствие.Свойство(СвойствоОбъекта, ЗначениеКлюча) Тогда
				Продолжить;
			КонецЕсли;

		ИначеЕсли ЭтоСоответствие Тогда
			
			ЗначениеКлюча = ВходящееСоответствие.Получить(СвойствоОбъекта);
		Иначе
			
			ВызватьИсключение СтрШаблон("Передан не поддерживаемый тип <%1>", ТипЗнч(ВходящееСоответствие));

		КонецЕсли;

		
		УстановитьСвойствоОбъекта(ЭтотОбъект, ИмяКлюча, ЗначениеКлюча);
		
	КонецЦикла;

	ВходящиеДанныеСообщения = ВходящееСоответствие["payload"];
	Лог.Отладка("Конвертирую данные сообщения");
	Если НЕ ПроверкаТипа.ЭтоСтрока(ВходящиеДанныеСообщения) Тогда
		ДанныеСообщения = СериализоватьВJSON(ВходящиеДанныеСообщения);
		Лог.Отладка("Данные сообщения: %1", ДанныеСообщения);
	КонецЕсли;

	ВходящиеПараметры = ВходящееСоответствие["properties"];
	
	МассивПараметровОбъекта = СтрРазделить("content_type, content_encoding, priority, correlation_id, reply_to, expiration, message_id, timestamp, type, user_id, app_id, cluster_id", ", ");
	
	Для каждого ПараметрОбъекта Из МассивПараметровОбъекта Цикл
		
		ИмяКлюча = ДоступныеПараметрыСообщения[ПараметрОбъекта];
		ЗначениеКлюча = ВходящееСоответствие.Получить(ПараметрОбъекта);
		
		УстановитьСвойствоОбъекта(Параметры, ИмяКлюча, ЗначениеКлюча);
		
	КонецЦикла;
	
	ВходящиеЗаголовки = ВходящееСоответствие["headers"];

	Если ПроверкаТипа.ЭтоЛюбоеСоответствие(ВходящиеЗаголовки) Тогда
		УстановитьЗаголовки(ВходящиеЗаголовки);	
	КонецЕсли;

КонецПроцедуры

Процедура ИзJSON(Знач JSONСообщение) Экспорт
	
	Парсер = Новый ПарсерJSON;
	Результат = Парсер.ПрочитатьJSON(JSONСообщение);
	
	ИзСоответствия(Результат);
	
КонецПроцедуры

Процедура УстановитьСвойствоОбъекта(ПриемникСвойств, Знач ИмяСвойства, Знач ЗначениеСвойства)
	
	Если ПроверкаТипа.ЭтоЛюбаяСтруктура(ПриемникСвойств)
		Или ПроверкаТипа.ЭтоЛюбоеСоответствие(ПриемникСвойств) Тогда
		
		ПриемникСвойств.Вставить(ИмяСвойства, ЗначениеСвойства);
		
	Иначе
		
		Если ЗначениеСвойства = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ЭтотОбъект[ИмяСвойства] = ЗначениеСвойства;

	КонецЕсли;
	
КонецПроцедуры

Функция ВСоответствие() Экспорт
	
	СоответствиеОбъекта = Новый Структура();
	
	Для каждого СвойствоОбъекта Из ДоступныеСвойстваСообщения Цикл
		
		Если СвойствоОбъекта.Ключ = "properties" 
			ИЛИ СвойствоОбъекта.Ключ = "headers"
			ИЛИ СвойствоОбъекта.Ключ = "payload" Тогда
			Продолжить;
		КонецЕсли;

		СоответствиеОбъекта.Вставить(СвойствоОбъекта.Ключ, ЭтотОбъект[СвойствоОбъекта.Значение]);

	КонецЦикла;
	
	Если НРег(КодировкаКонтента) = "string" Тогда
		СоответствиеОбъекта.Вставить("payload", СериализоватьВJSON(ДанныеСообщения));
	КонецЕсли;

	СтруктураПараметров = Новый Структура;

	Для каждого ПараметрыОбъекта Из ДоступныеПараметрыСообщения Цикл
		
		Если НЕ Параметры.Свойство(ПараметрыОбъекта.Значение) Тогда
			Продолжить;
		КонецЕсли;

		СтруктураПараметров.Вставить(ПараметрыОбъекта.Ключ, Параметры[ПараметрыОбъекта.Значение]);

	КонецЦикла;
	
	СоответствиеОбъекта.Вставить("properties", СтруктураПараметров);
	СоответствиеОбъекта.Вставить("headers", Заголовки);

	Возврат СоответствиеОбъекта;

КонецФункции

Функция ВJSON() Экспорт
	
	ОбъектСериализации = ВСоответствие();

	ТекстJSON = СериализоватьВJSON(ОбъектСериализации);
	
	Возврат ТекстJSON;
	
КонецФункции

Функция СериализоватьВJSON(Знач ОбъектСериализации) Экспорт
	
	ПарсерJSON = Новый ПарсерJSON;
	ТекстJSON = ПарсерJSON.ЗаписатьJSON(ОбъектСериализации);
	
	Возврат ТекстJSON;
	
КонецФункции

Процедура ПриСозданииОбъекта()
	
	Параметры = Новый Структура();
	Заголовки = Новый Соответствие();
	ДоступныеСвойстваСообщения = СтруктураСвойствСообщения();
	ДоступныеПараметрыСообщения = СтруктураПараметровСообщения();
	
	ТочкаОбмена = "";
	КлючМаршрутизации = "";
	РазмерКонтента = 0;
	КодировкаКонтента = "string";
	ПовторнаяДоставка = Ложь;
	КоличествоСообщенийПосле = 0;
	
	Лог = Логирование.ПолучитьЛог("oscript.lib.AutoUpdateIB.rmq");

КонецПроцедуры

Функция СтруктураСвойствСообщения()
	
	СтруктураКлючей = Новый Структура();
	СтруктураКлючей.Вставить("exchange", "ТочкаОбмена");
	СтруктураКлючей.Вставить("redelivered", "ПовторнаяДоставка");
	СтруктураКлючей.Вставить("payload_bytes", "РазмерКонтента");
	СтруктураКлючей.Вставить("payload_encoding", "КодировкаКонтента"); // Доступно только string или base64
	СтруктураКлючей.Вставить("payload", "ДанныеСообщения");
	СтруктураКлючей.Вставить("message_count", "КоличествоСообщенийПосле");
	СтруктураКлючей.Вставить("routing_key", "КлючМаршрутизации");
	СтруктураКлючей.Вставить("properties", "Параметры");
	СтруктураКлючей.Вставить("headers", "Заголовки");
	
	// TODO: Сделать обратную связь
	
	Возврат СтруктураКлючей;
	
КонецФункции

Функция СтруктураПараметровСообщения()
	
	СтруктураКлючей = Новый Структура();
	СтруктураКлючей.Вставить("content_type", "ТипКонтента");
	СтруктураКлючей.Вставить("content_encoding", "КодировкаКонтента");
	СтруктураКлючей.Вставить("priority", "Приоритет");
	СтруктураКлючей.Вставить("correlation_id", "КлючСоотвествия");
	СтруктураКлючей.Вставить("reply_to", "АдресОтвета");
	СтруктураКлючей.Вставить("expiration", "ВремяЖизниСообщения");
	СтруктураКлючей.Вставить("message_id", "КлючСообщения");
	СтруктураКлючей.Вставить("timestamp", "МоментВремени");
	СтруктураКлючей.Вставить("type", "Тип");
	СтруктураКлючей.Вставить("user_id", "КлючПользователя");
	СтруктураКлючей.Вставить("app_id", "КлючПриложения");
	СтруктураКлючей.Вставить("cluster_id", "КлючКластера");
	
	// TODO: Сделать обратную связь
	
	Возврат СтруктураКлючей;
	
КонецФункции