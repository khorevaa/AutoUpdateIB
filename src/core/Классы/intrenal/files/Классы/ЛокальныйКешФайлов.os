#Использовать logos
#Использовать fs
#Использовать json
#Использовать crypto

Перем Лог;

Перем КаталогКешаФайлов;
Перем ИндексКешаФайлов;

Перем ПутьКФайлуБлокировкиКеша;
Перем ПутьКФайлуДанныхКеша;
Перем КлючПодписиФайлов; // TODO: Сделать чтение из файла

Перем ДатаОбновленияДанныхКеша;

Функция ДобавитьФайл(Знач ПутьКФайлу, Знач ХешСумма, Знач ИмяХешФункции = "MD5", Знач ОжиданиеВозможности = Истина) Экспорт
	
	ФайлДобавляемогоФайла = Новый Файл(ПутьКФайлу);
	
	Если НЕ ФайлДобавляемогоФайла.Существует() Тогда
		ВызватьИсключение СтрШаблон("Файл <%1> не существует. Добавление в индекс невозможно", ПутьКФайлу);
	КонецЕсли;
	
	Если ФайлЕстьВИндексе(ХешСумма) Тогда
		Лог.Отладка("Файла <%1> найден в индексе с хеш суммой <%2>", ПутьКФайлу, ХешСумма);
		Возврат Истина;
	КонецЕсли;
	
	ПроверочнаяХешСумма = ПолучитьХешФайла(Новый ДвоичныеДанные(ФайлДобавляемогоФайла.ПолноеИмя), Строка(ИмяХешФункции));
	Если НЕ НРег(ПроверочнаяХешСумма) = НРег(ХешСумма) Тогда
		ВызватьИсключение СтрШаблон("Не совпадает хеш сумма <%1> для переданного файла. Добавление в индекс невозможно
		| хеш сумма: <%2>
		| рассчитанная <%3>", ПутьКФайлу, ХешСумма, ПроверочнаяХешСумма);
	КонецЕсли;
	
	Если Заблокирован() Тогда
	
		Если НЕ ОжиданиеВозможности Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ПодождатьРазблокировки(60);

	КонецЕсли;

	КлючБлокировки = Новый УникальныйИдентификатор();
	Заблокировать(КлючБлокировки);
	
	РасширениеФайла = ФайлДобавляемогоФайла.Расширение;
	ИмяФайла = ФайлДобавляемогоФайла.ИмяБезРасширения;
	
	ПодписьХешСуммы = ПодписатьХеш(ХешСумма);
			
	ПутьКФайлуКеша = ПутьКФайлуКеша(ХешСумма, РасширениеФайла);
	
	Попытка
		
		КопироватьФайл(ПутьКФайлу, ПутьКФайлуКеша);

		ИндексКешаФайлов.Вставить(ХешСумма, ОписаниеФайлаКеша(ИмяФайла, РасширениеФайла, ХешСумма, ПодписьХешСуммы));
		ЗаписатьИндексКеша();
		Разблокировать(КлючБлокировки);
		
	Исключение
		Разблокировать(КлючБлокировки);
		Лог.Отладка("Не удалось добавить файл <%1> к кэш по причине <%2>", ПутьКФайлу, ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьФайл(Знач ХешСумма) Экспорт
	
	ПутьКФайлуКеша = "";
	ДанныеФайлаИндексе = ИндексКешаФайлов.Получить(ХешСумма);
	
	Если ДанныеФайлаИндексе = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	ПутьКФайлуКеша = ПутьКФайлуКеша(ДанныеФайлаИндексе.ХешСумма, ДанныеФайлаИндексе.РасширениеФайла);
	
	Если НЕ ФС.ФайлСуществует(ПутьКФайлуКеша) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ПутьКФайлуКеша;
	
КонецФункции

Функция НадоОбновитьКеш() 

	ТекущаяДатаИзмененияДанныхКеша = ПолучитьДатуФайлаКеша();

	Возврат ТекущаяДатаИзмененияДанныхКеша > ДатаОбновленияДанныхКеша;
	
КонецФункции

Процедура ПодождатьРазблокировки(Знач ТаймаутОжидания)
	
	ДатаТаймаута = ТекущаяДата() + ТаймаутОжидания;

	ТекущееСостояниеБлокировки = Заблокирован();

	Пока Истина Цикл
		
		Если ДатаТаймаута < ТекущаяДата() Тогда
			ВызватьИсключение "Не дождались разблокировки кеша файлов";
		Иначе
			
			ТекущееСостояниеБлокировки = ОжидатьРазблокировки()
		
		КонецЕсли;

		Если НЕ ТекущееСостояниеБлокировки Тогда
			Прервать;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Функция ОжидатьРазблокировки()

	Приостановить(5*1000);

	Возврат Заблокирован();
	
КонецФункции

Функция ПутьКФайлуКеша(Знач ХешСумма, Знач РасширениеФайла)
	
	Возврат ОбъединитьПути(КаталогКешаФайлов, СтрШаблон("%1%2", ХешСумма, РасширениеФайла));
	
КонецФункции

Функция ФайлЕстьВИндексе(Знач ХешСумма)
	
	Возврат НЕ ИндексКешаФайлов.Получить(ХешСумма) = Неопределено;
	
КонецФункции

Процедура ПрочитатьИндексХешСумм()
	
	ИндексКешаФайлов = Новый Соответствие();
	
	Если НЕ ФС.ФайлСуществует(ПутьКФайлуДанныхКеша) Тогда
		Возврат;	
	КонецЕсли;
	
	ТекстФайла = ПрочитатьФайл(ПутьКФайлуДанныхКеша);
	
	Если ПустаяСтрока(ТекстФайла) Тогда
		Возврат;
	КонецЕсли;

	Лог.Отладка("Путь к файлу кеша <%1>", ПутьКФайлуДанныхКеша);
	Лог.Отладка("Данные файла кеша <%1>", ТекстФайла);
	
	ДанныеИндекса = ИЗJson(ТекстФайла);
	
	Для каждого ЭлементИндекса Из ДанныеИндекса Цикл
		
		ОписаниеФайла = ОписаниеФайлаКеша(ЭлементИндекса["name"], ЭлементИндекса["ext"], ЭлементИндекса["hash"], ЭлементИндекса["sig"]);
		
		ИндексКешаФайлов.Вставить(ОписаниеФайла.ХешСумма, ОписаниеФайла);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьИндексКеша()
	
	МассивОбъектов = Новый Массив();
	
	Для каждого ХешФайла Из ИндексКешаФайлов Цикл
		
		ОписаниеФайла = ХешФайла.Значение;
		
		ОписаниеЗаписи = ОписаниеФайлаКешаДляЗаписи(ОписаниеФайла.ИмяФайла, 
						ОписаниеФайла.РасширениеФайла,
						ОписаниеФайла.ХешСумма,
						ОписаниеФайла.Подпись);
		
		МассивОбъектов.Добавить(ОписаниеЗаписи);
		
	КонецЦикла;
	
	ТекстФайла = ВJson(МассивОбъектов);
	
	ЗаписатьФайл(ПутьКФайлуДанныхКеша, ТекстФайла);
	
КонецПроцедуры

Функция ПроверитьПодпись(Знач ХешСумма, Знач Подпись)
	
	Возврат ПодписатьХеш(ХешСумма) = Подпись;
	
КонецФункции

Функция ОписаниеФайлаКеша(Знач ИмяФайла, Знач РасширениеФайла, Знач ХешСумма, Знач Подпись)
	
	ОписаниеФайла = Новый Структура();
	ОписаниеФайла.Вставить("ИмяФайла", ИмяФайла);
	ОписаниеФайла.Вставить("РасширениеФайла", РасширениеФайла);
	ОписаниеФайла.Вставить("ХешСумма", ХешСумма);
	ОписаниеФайла.Вставить("Подпись", Подпись);
	
	Возврат ОписаниеФайла;
	
КонецФункции

Функция ПолучитьДатуФайлаКеша()
	
	ФайлКеша = Новый Файл(ПутьКФайлуДанныхКеша);
	Если ФайлКеша.Существует() Тогда
		Возврат ФайлКеша.ПолучитьВремяИзменения();	
	Иначе
		Возврат Дата(1,1,1,1);
	КонецЕсли;
		
КонецФункции

Функция ОписаниеФайлаКешаДляЗаписи(Знач ИмяФайла, Знач РасширениеФайла, Знач ХешСумма, Знач Подпись)
	
	ОписаниеФайла = Новый Структура();
	ОписаниеФайла.Вставить("name", ИмяФайла);
	ОписаниеФайла.Вставить("ext", РасширениеФайла);
	ОписаниеФайла.Вставить("hash", ХешСумма);
	ОписаниеФайла.Вставить("sig", Подпись);
	
	Возврат ОписаниеФайла;
	
КонецФункции

Функция ПолучитьХешФайла(ДвоичныеДанныеФайла, Знач ИмяХешФункции = "MD5")
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункцияПоИмени(ИмяХешФункции));
	ХешированиеДанных.Добавить(ДвоичныеДанныеФайла);
	ХешСуммаСтрокой = ХешированиеДанных.ХешСуммаСтрокой;
	ХешированиеДанных.Очистить();
	
	Возврат ХешСуммаСтрокой;
	
КонецФункции

Функция ПодписатьХеш(Знач ХешСумма)
	
	ДвоичныеДанныеПодписи = ПолучитьДвоичныеДанныеИзСтроки(КлючПодписиФайлов);
	ДвоичныеДанныеХешСумма = ПолучитьДвоичныеДанныеИзСтроки(ХешСумма);
	ПодписанныеДанные = Шифрование.HMAC(ДвоичныеДанныеПодписи, ДвоичныеДанныеХешСумма, ХешФункция.SHA256);
	
	Возврат ПодписанныеДанные;
	
КонецФункции

Функция ХешФункцияПоИмени(Знач ИмяХешФункции)
	
	Возврат ХешФункция[ИмяХешФункции];
	
КонецФункции

Функция ВJson(Знач ДанныеСериализации)
	
	ПарсерJSON = Новый ПарсерJSON;
	Возврат ПарсерJSON.ЗаписатьJSON(ДанныеСериализации);
	
КонецФункции

Функция ИЗJson(ТекстJSON)
	
	Парсер = Новый ПарсерJSON;
	Результат = Парсер.ПрочитатьJSON(ТекстJSON);
	
	Возврат Результат;
	
КонецФункции

Процедура Обновить() Экспорт
	
	Если НадоОбновитьКеш() Тогда
		ПрочитатьИндексХешСумм();
	КонецЕсли;

КонецПроцедуры

Процедура Разблокировать(Знач ИдентификаторПроцесса) 
	
	Если НЕ Заблокирован() Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторПроцессаИзФайла = СокрЛП(ПрочитатьФайл(ПутьКФайлуБлокировкиКеша));
	
	Если НЕ НРег(ИдентификаторПроцесса) = НРег(ИдентификаторПроцессаИзФайла) Тогда
		ВызватьИсключение СтрШаблон("Файл кеша заблокирован другим процессом <%1> != <%2>", ИдентификаторПроцесса, ИдентификаторПроцессаИзФайла);
	КонецЕсли;
	
	УдалитьФайлБлокировки();
	
КонецПроцедуры

Процедура СнятьБлокировку() 
	
	УдалитьФайлБлокировки();
	
КонецПроцедуры

Процедура УдалитьФайлБлокировки()
	
	Если Заблокирован() Тогда
		УдалитьФайлы(ПутьКФайлуБлокировкиКеша);
	КонецЕсли;
	
КонецПроцедуры

Процедура Заблокировать(Знач ИдентификаторПроцесса) Экспорт
	
	Если Заблокирован() Тогда
		ВызватьИсключение "Файл кеша уже заблокирован другим процессом";
	КонецЕсли;
	
	ЗаписатьФайл(ПутьКФайлуБлокировкиКеша, ИдентификаторПроцесса);
	
КонецПроцедуры

Процедура ЗаписатьФайл(Знач ПутьКФайлу, Знач СодержаниеФайла)
	
	ЗаписьТекста = Новый ЗаписьТекста(ПутьКФайлу);
	ЗаписьТекста.Записать(СодержаниеФайла);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Функция ПрочитатьФайл(Знач ПутьКФайлу)
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу);
	ТекстФайла = ЧтениеТекста.Прочитать();;
	ЧтениеТекста.Закрыть();
	Возврат ТекстФайла;
КонецФункции

Функция Заблокирован() Экспорт
	
	Возврат ФС.ФайлСуществует(ПутьКФайлуБлокировкиКеша);
	
КонецФункции

Процедура ОчиститьФайлыКеша() Экспорт
	
	КлючБлокировки = Новый УникальныйИдентификатор();
	
	Заблокировать(КлючБлокировки);
	
	МассивФайловКеша = НайтиФайлы(КаталогКешаФайлов, ПолучитьМаскуВсеФайлы(), Ложь);
	
	Для каждого ФайлМассива Из МассивФайловКеша Цикл
		
		Если ФайлМассива.ПолноеИмя = ПутьКФайлуБлокировкиКеша Тогда
			Продолжить;
		КонецЕсли;
		
		УдалитьФайлы(ФайлМассива.ПолноеИмя);
		
	КонецЦикла;
	
	Обновить();	
	ЗаписатьИндексКеша();
	
	Разблокировать(КлючБлокировки);
	
КонецПроцедуры

Процедура ПриСозданииОбъекта(Знач ПутьККаталогуКеша)
	
	КаталогКешаФайлов = ПутьККаталогуКеша;
	
	КлючПодписиФайлов = "МируМир";
	
	ИмяФайлаКеша = ".cache.data";
	ИмяФайлаБлокировкиКеша = ".cache.lock";
	
	ПутьКФайлуДанныхКеша = ОбъединитьПути(КаталогКешаФайлов, ИмяФайлаКеша);
	ПутьКФайлуБлокировкиКеша = ОбъединитьПути(КаталогКешаФайлов, ИмяФайлаБлокировкиКеша);
	
	Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB.cache");
	Лог.УстановитьУровень(УровниЛога.Отладка);
	
	ПрочитатьИндексХешСумм();

	ДатаОбновленияДанныхКеша = ПолучитьДатуФайлаКеша();
	
	
КонецПроцедуры

