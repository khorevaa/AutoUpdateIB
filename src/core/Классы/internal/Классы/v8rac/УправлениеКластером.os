#Использовать v8runner
#Использовать logos
#Использовать 1commands

Перем Лог;
Перем ПутьКлиентаАдминистрирования;
Перем ЭтоWindows;

Перем АвторизацияАдминистратораКластера;
Перем АдресСервера;
Перем ПортСервера;

Перем КонтекстПодключения;

Перем ИндексЛокальныхКластеров;
Перем ИндексИнформационныхБаз;

Перем ИндексЛокальныхКластеровОбновлен;
Перем ИндексАвторизацийИнформационныхБаз;


Процедура УстановитьАвторизациюКластера(Знач Пользователь, Знач Пароль = "") Экспорт
	
	АвторизацияАдминистратораКластера = Новый Структура("Пользователь, Пароль", Пользователь, Пароль);

КонецПроцедуры

Процедура УстановитьАвторизациюИнформационнойБазы(Знач ИнформационнаяБаза, Знач Пользователь, Знач Пароль = "") Экспорт
	
	АвторизацияИБ = Новый Структура("Пользователь, Пароль", Пользователь, Пароль);

	ИндексАвторизацийИнформационныхБаз.Вставить(ИнформационнаяБаза, АвторизацияИБ);

КонецПроцедуры


Процедура УстановитьКластер(Знач АдресСерверКластера, Знач ПортСервераКластера = 1545, Знач ПринудительноСброситьИндексы = Ложь) Экспорт
	
	ИзменилсяКластер = Ложь;

	ТекущийАдресКластера = АдресСервера;
	ТекущийПортКластера = ПортСервера;

	МассивСтрок = СтрРазделить(АдресСерверКластера, ":");

	Если МассивСтрок.Количество() = 2 Тогда
		АдресСервера = МассивСтрок[0];
		ПортСервера = МассивСтрок[1];
	Иначе
		АдресСервера = АдресСерверКластера;
		ПортСервера = ПортСервераКластера;
	КонецЕсли;

	ИзменилсяКластер = НЕ ТекущийАдресКластера = АдресСервера
					   ИЛИ НЕ ТекущийПортКластера = ПортСервера;

	Если ПринудительноСброситьИндексы 
		ИЛИ ИзменилсяКластер Тогда
		
		СброситьИндексы();
		
	КонецЕсли;

КонецПроцедуры

Функция СписокЛокальныхКластеров() Экспорт
	
	Если Не ИндексЛокальныхКластеровОбновлен Тогда
		ОбновитьИндексЛокальныхКластеров();
	КонецЕсли;

	СписокКластеров = Новый Массив();

	Для каждого КлючЗначение Из ИндексЛокальныхКластеров Цикл
		СписокКластеров.Добавить(КлючЗначение.Ключ);
	КонецЦикла;

	Возврат СписокКластеров;
	
КонецФункции

Функция СписокИнформационныхБаз(Знач ИдентификаторКластера = Неопределено) Экспорт
	
	ТаблицаИнформационныхБазы = Новый ТаблицаЗначений();
	ТаблицаИнформационныхБазы.Колонки.Добавить("Имя");
	ТаблицаИнформационныхБазы.Колонки.Добавить("UID");
	ТаблицаИнформационныхБазы.Колонки.Добавить("Кластер");

	Для каждого ОписаниеИБ Из ИндексИнформационныхБаз Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаИнформационныхБазы.Добавить(), ОписаниеИБ.Значение);
	КонецЦикла;

	Возврат ТаблицаИнформационныхБазы;

КонецФункции

Процедура УстановитьБлокировкиИнформационнойБазы(Знач ИнформационнаяБаза, 
												 Знач ОписаниеБлокировкиСеансов = Неопределено,
												 Знач БлокировкаРеглЗаданий = Ложь,
												 Знач АвторизацияИБ = Неопределено)
	


	Если Не АвторизацияИБ = Неопределено Тогда
		
		Если АвторизацияИБ.Свойство("Пользователь") Тогда
			
			ПарольПользователя = "";
			Если АвторизацияИБ.Свойство("Пароль") Тогда
				ПарольПользователя = АвторизацияИБ.Пароль;
			КонецЕсли;
			
			УстановитьАвторизациюИнформационнойБазы(ИнформационнаяБаза, АвторизацияИБ.Пользователь, ПарольПользователя);

		КонецЕсли;
	
	КонецЕсли;
	// КлючиАвторизацииВБазе = КлючиАвторизацииВБазе();
	
	// ИдентификаторКластера = ИдентификаторКластера();
	// ИдентификаторБазы = ИдентификаторБазы();
	КлючЗначенияБлокировки = ?(Блокировать, "on", "off");

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить("infobase");
	ПараметрыЗапуска.Добавить("update");
	ПараметрыЗапуска.Добавить(СтрШаблон("--scheduled-jobs-deny=%1", КлючЗначенияБлокировки));




	КлючРазрешенияЗапуска = ПараметрыБлокировки.КлючРазрешенияЗапуска;
	СообщениеОБлокировке = ПараметрыБлокировки.СообщениеОБлокировке;;
	ВремяБлокировки = ПараметрыБлокировки.ВремяСтартаБлокировки;
	
	КлючЗначенияБлокировки = "on";
	
	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить("infobase");
	ПараметрыЗапуска.Добавить("update");
	
	ПараметрыЗапуска.Добавить(СтрШаблон("--sessions-deny=%1", КлючЗначенияБлокировки));
	ПараметрыЗапуска.Добавить(СтрШаблон("--denied-message=""%1""", СообщениеОБлокировке));
	ПараметрыЗапуска.Добавить(СтрШаблон("--permission-code=%1", КлючРазрешенияЗапуска));

	ПараметрыЗапуска.Добавить(СтрШаблон("--denied-from=%1", ВремяБлокировки));
	// ПараметрыЗапуска.Добавить(СтрШаблон("--denied-to=""%1""", КлючРазрешенияЗапуска);

	ВыполнитьВИнформационнойБазе(ПараметрыЗапуска);
	
	Лог.Отладка("Сеансы запрещены");


	// КомандаВыполнения = СтрокаЗапускаКлиента() + 
	// 	СтрШаблон("infobase update --infobase=""%3""%4 --cluster=""%1""%2 --scheduled-jobs-deny=%5",
	// 		ИдентификаторКластера,
	// 		КлючиАвторизацииВКластере(),
	// 		ИдентификаторБазы,
	// 		КлючиАвторизацииВБазе,
	// 		?(Блокировать, "on", "off")
	// 	) + " "+мНастройки.АдресСервераАдминистрирования;
		
	// ЗапуститьПроцесс(КомандаВыполнения);
	
	Лог.Отладка("Регламентные задания " + ?(Блокировать, "запрещены", "разрешены"));
	
КонецПроцедуры

Процедура ОбновитьПараметрыИнформационнойБазы(Знач ИнформационнаяБаза, Знач ПараметрыИнформационнойБазы)

	Параметры = СтандартныеПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("infobase");
	ПараметрыЗапуска.Добавить("update");

	ПараметрыЗапуска.Добавить(КлючИдентификатораБазы(ИнформационнаяБаза));
	ПараметрыЗапуска.Добавить(КлючИдентификатораКластераБазы(ИнформационнаяБаза));

	ДобавитьПараметрыАвторизацииИнформационнойБазы(ПараметрыКоманды, ИнформационнаяБаза);

	Для каждого КлючЗначение Из ПараметрыИнформационнойБазы Цикл
		ПараметрыЗапуска.Добавить(СтрШаблон("%1=%2", КлючЗначение.Ключ, КлючЗначение.Значение));		
	КонецЦикла;

	ВыполнитьКоманду(Параметры)
	
КонецПроцедуры

#Область Поиск_версии_платформы

#КонецОбласти

#Область Вспомогательные_процедуры_и_функции

Процедура СброситьИндексы()
	
	ИндексЛокальныхКластеров = Новый Соответствие();
	ИндексИнформационныхБаз = Новый Соответствие();
	ИндексЛокальныхКластеровОбновлен = Ложь;

КонецПроцедуры

Функция ОписаниеИнформационнойБазы(Знач ИмяБазы, Знач UID, Знач Кластер)
	
	ОписаниеИБ = Новый Структура();
	ОписаниеИБ.Вставить("Имя", ИмяБазы);
	ОписаниеИБ.Вставить("UID", UID);
	ОписаниеИБ.Вставить("Кластер", Кластер);

	Возврат ОписаниеИБ;

КонецФункции

Функция ПолучитьПутьКRAC(ТекущийПуть, Знач ВерсияПлатформы = "")
	
	Если НЕ ПустаяСтрока(ТекущийПуть) Тогда 
		ФайлУтилиты = Новый Файл(ТекущийПуть);
		Если ФайлУтилиты.Существует() Тогда 
			Лог.Отладка("Текущая версия rac " + ФайлУтилиты.ПолноеИмя);
			Возврат ФайлУтилиты.ПолноеИмя;
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(ВерсияПлатформы) Тогда 
		ВерсияПлатформы = "8.3";
	КонецЕсли;
	
	Конфигуратор = Новый УправлениеКонфигуратором;
	ПутьКПлатформе = Конфигуратор.ПолучитьПутьКВерсииПлатформы(ВерсияПлатформы);
	Лог.Отладка("Используемый путь для поиска rac " + ПутьКПлатформе);
	КаталогУстановки = Новый Файл(ПутьКПлатформе);
	Лог.Отладка(КаталогУстановки.Путь);
	
	
	ИмяФайла = ?(ЭтоWindows, "rac.exe", "rac");
	
	ФайлУтилиты = Новый Файл(ОбъединитьПути(Строка(КаталогУстановки.Путь), ИмяФайла));
	Если ФайлУтилиты.Существует() Тогда 
		Лог.Отладка("Текущая версия rac " + ФайлУтилиты.ПолноеИмя);
		Возврат ФайлУтилиты.ПолноеИмя;
	КонецЕсли;
	
	Возврат ТекущийПуть;
	
КонецФункции

Процедура ДобавитьПараметрыАвторизацииКластера(Знач ПараметрыЗапуска)
	
	Если ЗначениеЗаполнено(АвторизацияАдминистратораКластера.Пользователь) Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--cluster-user=""%1""", АвторизацияАдминистратораКластера.Пользователь));
		Если ЗначениеЗаполнено(АвторизацияАдминистратораКластера.Пароль) Тогда
			ПараметрыЗапуска.Добавить(СтрШаблон("--cluster-pwd=""%1""", АвторизацияАдминистратораКластера.Пароль));
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьПараметрыАвторизацииИнформационнойБазы(Знач ПараметрыЗапуска, Знач ИнформационнаяБаза)
	
	АвторизацияИБ = ИндексАвторизацийИнформационныхБаз[ИнформационнаяБаза];
	
	Если АвторизацияИБ = Неопределено Тогда
		АвторизацияИБ = ИндексАвторизацийИнформационныхБаз[ИмяКлючяВсеБазы];
	КонецЕсли;

	Если АвторизацияИБ = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(АвторизацияИБ.Пользователь) Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--infobase-user=""%1""", АвторизацияИБ.Пользователь));
		Если ЗначениеЗаполнено(АвторизацияИБ.Пароль) Тогда
			ПараметрыЗапуска.Добавить(СтрШаблон("--infobase-pwd=""%1""", АвторизацияИБ.Пароль));
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры


Функция СтандартныеПараметрыЗапуска()
	
	// Лог.Отладка("КлючСоединенияСБазой "+КлючСоединенияСБазой());
	// Лог.Отладка("ИмяПользователя <"+мКонтекстКоманды.ИмяПользователя+">");

	ПараметрыЗапуска = Новый Массив;
	// ПараметрыЗапуска.Добавить("DESIGNER");
	// ПараметрыЗапуска.Добавить(КлючСоединенияСБазой());
	

	// Если мОчищатьФайлИнформации Тогда
	// 	ПараметрыЗапуска.Добавить("/Out " + ОбернутьВКавычки(ФайлИнформации()));
	// Иначе
	// 	ПараметрыЗапуска.Добавить("/Out " + ОбернутьВКавычки(ФайлИнформации()) + " -NoTruncate");
	// КонецЕсли;

	// Если Не ПустаяСтрока(мКонтекстКоманды.ИмяПользователя) Тогда
	// 	ПараметрыЗапуска.Добавить("/N" + ОбернутьВКавычки(мКонтекстКоманды.ИмяПользователя));
	// КонецЕсли;
	// Если Не ПустаяСтрока(мКонтекстКоманды.Пароль) Тогда
	// 	ПараметрыЗапуска.Добавить("/P" + ОбернутьВКавычки(мКонтекстКоманды.Пароль));
	// КонецЕсли;
	// ПараметрыЗапуска.Добавить("/WA+");
	// Если Не ПустаяСтрока(мКонтекстКоманды.КлючРазрешенияЗапуска) Тогда
	// 	ПараметрыЗапуска.Добавить("/UC" + ОбернутьВКавычки(мКонтекстКоманды.КлючРазрешенияЗапуска));
	// КонецЕсли;
	// Если НЕ ПустаяСтрока(мКонтекстКоманды.КодЯзыка) Тогда
	// 	ПараметрыЗапуска.Добавить("/L"+мКонтекстКоманды.КодЯзыка);
	// КонецЕсли;
	// Если НЕ ПустаяСтрока(мКонтекстКоманды.КодЯзыкаСеанса) Тогда
	// 	ПараметрыЗапуска.Добавить("/VL"+мКонтекстКоманды.КодЯзыкаСеанса);
	// КонецЕсли;
	// ПараметрыЗапуска.Добавить("/DisableStartupMessages");
	// ПараметрыЗапуска.Добавить("/DisableStartupDialogs");

	Возврат ПараметрыЗапуска; 

КонецФункции

Функция КлючИдентификатораКластера(Знач Кластер)

	ИдентификаторКластера = ИндексЛокальныхКластеров[Кластер];

	Если ИдентификаторКластера = Неопределено Тогда
		ВызватьИсключение "Не найден кластер: " + Кластер;
	КонецЕсли;

	Возврат СтрШаблон("--cluster=%1", ИдентификаторКластера);
	
КонецФункции

Функция КлючИдентификатораБазы(Знач ИнформационнаяБаза)

	ОписаниеИБ = ИндексИнформационныхБаз[ИнформационнаяБаза];

	Если ИдентификаторБазы = Неопределено Тогда
		ВызватьИсключение "Не найдена информационная база: " + ИнформационнаяБаза;
	КонецЕсли;
	
	Возврат СтрШаблон("--infobase=""%1""", ОписаниеИБ.UID);
	
КонецФункции

Функция КлючИдентификатораКластераБазы(Знач Кластер)

	ОписаниеИБ = ИндексИнформационныхБаз[ИнформационнаяБаза];

	Если ИдентификаторБазы = Неопределено Тогда
		ВызватьИсключение "Не найдена информационная база: " + ИнформационнаяБаза;
	КонецЕсли;

	Возврат СтрШаблон("--cluster=%1", ОписаниеИБ.Кластер);
	
КонецФункции

Процедура ОбновитьИндексИнформационныхБаз(Знач Кластер, Знач Принудительно = Ложь) 
	
	Если Не Принудительно 
		И Не ИндексЛокальныхКластеров[Кластер] = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Лог.Отладка("Получаю список баз кластера");

	Параметры = СтандартныеПараметрыЗапуска();
	Параметры.Добавить("infobase");
	Параметры.Добавить("summary");
	Параметры.Добавить("list");
	Параметры.Добавить(КлючИдентификатораКластера(Кластер));

	СписокБазВКластере = СокрЛП(ВыполнитьКоманду(Параметры));

	Данные = РазобратьПоток(СписокБазВКластере);
	
	ОчиститьИндексИнформационныхБазы(Кластер);
	
	ИндексИБКластера = Новый Соответствие();

	Для Каждого Элемент Из Данные Цикл
		
		ОписаниеИБ = ОписаниеИнформационнойБазы(Элемент["name"], Элемент["infobase"], Кластер);

		Лог.Отладка("База <%1> (%2) добавлена в индекс", ОписаниеИБ.Имя,  ОписаниеИБ.UID);
		
		ИндексИнформационныхБаз.Вставить(ОписаниеИБ.Имя, ОписаниеИБ);
		ИндексИнформационныхБаз.Вставить(ОписаниеИБ.UID, ОписаниеИБ);
		ИндексИБКластера.Вставить(ОписаниеИБ.UID, ОписаниеИБ);

	КонецЦикла;

	ИндексЛокальныхКластеров[Кластер] = ИндексИБКластера;

КонецПроцедуры

Процедура ОчиститьИндексИнформационныхБазы(Знач Кластер)
	
	ИндексИБКластера = ИндексЛокальныхКластеров[Кластер];

	Если ИндексИБКластера = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Для каждого КлючЗначение Из ИндексИБКластера Цикл
		ОписаниеИБ = КлючЗначение.Значение;
		ИндексИнформационныхБаз.Удалить(ОписаниеИБ.Имя);
		ИндексИнформационныхБаз.Удалить(ОписаниеИБ.UID);
	КонецЦикла;

КонецПроцедуры

Процедура ОбновитьИндексЛокальныхКластеров()
	
	Лог.Отладка("Получаю список кластеров");

	Параметры = СтандартныеПараметрыЗапуска();
	Параметры.Добавить("cluster");
	Параметры.Добавить("list");

	СписокКластеров = ВыполнитьКоманду(Параметры);
	
	Данные = РазобратьПоток(СписокКластеров);

	Для Каждого Элемент Из Данные Цикл
		
		UIDКластера = Элемент["cluster"];

		Лог.Отладка("Локальный кластер <%1> добавлена в индекс", UIDКластера);
		
		ИндексЛокальныхКластеров.Вставить(UIDКластера);

	КонецЦикла;

	ИндексКластераОбновлен = Истина;

КонецПроцедуры


Функция СтрокаЗапускаКлиента()
	
	Перем ПутьКлиентаАдминистрирования;
	
	Если ЭтоWindows Тогда 
		ПутьКлиентаАдминистрирования = ОбернутьПутьВКавычки(ПутьКлиентаАдминистрирования);
	Иначе
		ПутьКлиентаАдминистрирования = ПутьКлиентаАдминистрирования;
	КонецЕсли;
	
	Возврат ПутьКлиентаАдминистрирования;
	
КонецФункции

Функция ИспользуетсяАвторизацияКластера()

	Возврат ЗначениеЗаполнено(АвторизацияАдминистратораКластера.Пользователь);
	
КонецФункции

Функция ЕстьПараметрКластер(ПараметрыКоманды, ИмяПараметра)
	
	Для каждого Параметр Из ПараметрыКоманды Цикл
		
		Если СтрНайти(Параметр, ИмяПараметра) > 0 Тогда
			Возврат Истина;
		КонецЕсли
	КонецЦикла;

	Возврат Ложь;

КонецФункции

Функция ВыполнитьКоманду(Знач ПараметрыКоманды) Экспорт

	КомандаВыполнения = ПутьКлиентаАдминистрирования;
	АдресСервераАдминистрирования = СтрШаблон("%1:%2", АдресСервера, ПортСервера);
	
	Команда = Новый Команда();
	Команда.УстановитьКоманду(КомандаВыполнения);
	Команда.ДобавитьПараметры(ПараметрыКоманды);

	Если ЕстьПараметрКластер(ПараметрыКоманды, "--cluster") Тогда
		ДобавитьПараметрыАвторизацииКластера(ПараметрыКоманды);
	КонецЕсли;

	Команда.ДобавитьПараметр(АдресСервераАдминистрирования);
	Команда.УстановитьИсполнениеЧерезКомандыСистемы(Ложь);
	КодВозврата = Команда.Исполнить();

	Если КодВозврата <> 0 Тогда
		ВызватьИсключение Команда.ПолучитьВывод();
	КонецЕсли;

	Возврат Команда.ПолучитьВывод();
	
КонецФункции


Функция РазобратьПотокВывода(Знач Поток) Экспорт
	
	ТД = Новый ТекстовыйДокумент;
	ТД.УстановитьТекст(Поток);
	
	СписокОбъектов = Новый Массив;
	ТекущийОбъект = Неопределено;
	
	Для Сч = 1 По ТД.КоличествоСтрок() Цикл
		
		Текст = ТД.ПолучитьСтроку(Сч);
		Если ПустаяСтрока(Текст) или ТекущийОбъект = Неопределено Тогда
			Если ТекущийОбъект <> Неопределено и ТекущийОбъект.Количество() = 0 Тогда
				Продолжить; // очередная пустая строка подряд
			КонецЕсли;
			 
			ТекущийОбъект = Новый Соответствие;
			СписокОбъектов.Добавить(ТекущийОбъект);
		КонецЕсли;
		
		СтрокаРазбораИмя      = "";
		СтрокаРазбораЗначение = "";
		
		Если РазобратьНаКлючИЗначение(Текст, СтрокаРазбораИмя, СтрокаРазбораЗначение) Тогда
			ТекущийОбъект[СтрокаРазбораИмя] = СтрокаРазбораЗначение;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущийОбъект <> Неопределено и ТекущийОбъект.Количество() = 0 Тогда
		СписокОбъектов.Удалить(СписокОбъектов.ВГраница());
	КонецЕсли; 
	
	Возврат СписокОбъектов;
	
КонецФункции

Функция РазобратьНаКлючИЗначение(Знач СтрокаРазбора, Ключ, Значение)
	
	ПозицияРазделителя = Найти(СтрокаРазбора, ":");
	Если ПозицияРазделителя = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Ключ     = СокрЛП(Лев(СтрокаРазбора, ПозицияРазделителя - 1));
	Значение = СокрЛП(Сред(СтрокаРазбора, ПозицияРазделителя + 1));
	
	Возврат Истина;
	
КонецФункции

Процедура ПриСозданииОбъекта()

	Лог = Логирование.ПолучитьЛог("oscript.lib.v8rac");
	// Лог = Логирование.ПолучитьЛог("oscript.lib.commands");
	// Лог.УстановитьУровень(УровниЛога.Отладка);

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
	ИндексЛокальныхКластеровОбновлен = Ложь;
	
	ИндексИнформационныхБаз = Новый Соответствие();
	ИндексЛокальныхКластеров = Новый Соответствие();
	ИндексАвторизацийИнформационныхБаз = Новый Соответствие();

	ИмяКлючяВсеБазы = "all";

КонецПроцедуры


#КонецОбласти
