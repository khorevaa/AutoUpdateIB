
#Использовать "./internal"
#Использовать "./internal/files"
#Использовать "./internal/cache"
#Использовать "./internal/bindata"

#Использовать logos
#Использовать configor
#Использовать tempfiles

Перем Лог; // Класс Логирование
Перем КаталогКешаФайлов; // Путь к каталогу кеша файлов
Перем КешФайлов; 

Перем ПараметрыПодключения Экспорт;
Перем ПараметрыОбновленияКонфигурации Экспорт;
Перем ПараметрыОбновленияРасширений Экспорт;
Перем ПараметрыБлокировкиСеансов Экспорт;
Перем ПараметрыКластера Экспорт;
Перем ПараметрыРезервногоКопирования Экспорт;
Перем ПараметрыЗапускаПредприятия Экспорт;

Перем КонструкторПараметровНастройкиОбновления;

Функция БлокировкаСеансов() Экспорт
	Возврат ПараметрыБлокировкиСеансов.Заблокировать;
КонецФункции

Функция СозданиеБекапаИнформационнойБазы() Экспорт
	Возврат ПараметрыРезервногоКопирования.Свойство("СоздаватьБекап") 
			И ПараметрыРезервногоКопирования.СоздаватьБекап;
КонецФункции

Функция ЭтоФайловаяБаза() Экспорт

	Возврат ЗначениеЗаполнено(ПараметрыПодключения.ФайловаяБаза.ПутьККаталогу);
	
КонецФункции

Функция СтрокаПодключения() Экспорт
	
	ЭтоФайловаяБаза = ЗначениеЗаполнено(ПараметрыПодключения.ФайловаяБаза.ПутьККаталогу);
	
	Лог.Отладка("Путь к каталогу файловой базы <%1>", ПараметрыПодключения.ФайловаяБаза.ПутьККаталогу);

	Если ЭтоФайловаяБаза Тогда

		СтрокаПодключения = СтрШаблон("/F%1", ПараметрыПодключения.ФайловаяБаза.ПутьККаталогу);
	
	Иначе

		СервернаяБаза = ПараметрыПодключения.СервернаяБаза;
		СерверПриложений = СервернаяБаза.Сервер;
		// ПортСервера = СервернаяБаза.Порт; // TODO: Доделать добавление порта в строку подключения
		ИмяБазыНаСервере = СервернаяБаза.База;
		СтрокаПодключения = СтрШаблон("/S""%1\%2""", СерверПриложений, ИмяБазыНаСервере);

	КонецЕсли;

	// TODO: Получить строку подключения
	Возврат СтрокаПодключения;	
КонецФункции

Функция АвторизацияВИнформационнойБазе() Экспорт
	Возврат Новый Структура("Пользователь, Пароль", ПараметрыПодключения.Пользователь, ПараметрыПодключения.Пароль);;	
КонецФункции

Функция КлючРазрешенияЗапуска() Экспорт
	
	Лог.Отладка("Ключ разрешения запуска <%1>", ПараметрыПодключения.КлючРазрешенияЗапуска);
	Возврат ПараметрыПодключения.КлючРазрешенияЗапуска;	
КонецФункции

Функция ВерсияПлатформы() Экспорт
	Возврат ПараметрыПодключения.ВерсияПлатформы;	
КонецФункции

Функция НадоЧтоТоДелать() Экспорт
	Возврат НадоОбновитьКонфигурацию()
			ИЛИ НадоОбновитьРасширения()
			ИЛИ НадоЗапуститьВРежимеПредприятия()
			;
КонецФункции

Функция НадоОбновитьКонфигурацию() Экспорт
	Возврат ПараметрыОбновленияКонфигурации.Свойство("Обновление")
		И ЗначениеЗаполнено(ПараметрыОбновленияКонфигурации.Обновление)
		И ПараметрыОбновленияКонфигурации.Обновление.Количество() > 0;
КонецФункции

Функция НадоОбновитьРасширения() Экспорт
	Возврат ПараметрыОбновленияРасширений.Свойство("НаборРасширений")
			И ПараметрыОбновленияРасширений.НаборРасширений.Количество() > 0;
КонецФункции

Функция НадоЗапуститьВРежимеПредприятия() Экспорт
	Возврат ПараметрыЗапускаПредприятия.Количество() > 0;
КонецФункции

#Область Конструкторы_параметров

Функция КонструкторПараметровПодключения()
	
	КонструкторПараметров = Новый КонструкторПараметров;
	
	ПодключениеКФайловойбазе = КонструкторПараметров.НовыеПараметры();
	ПодключениеКФайловойбазе.ПолеСтрока("ПутьККаталогу path dir", "");
	
	ПодключениеКСервернойбазе = КонструкторПараметров.НовыеПараметры();
	ПодключениеКСервернойбазе
							.ПолеСтрока("Сервер ИмяСервера server", "")
							.ПолеСтрока("Порт ПортСервера port", "")
							.ПолеСтрока("База ИмяБазыНаСервере ИмяБазы ib-name base", "")
							;
	
	КонструкторПараметров
						.ПолеСтрока("Пользователь user usr", "")
						.ПолеСтрока("Пароль password pwd", "")
						.ПолеОбъект("СервернаяБаза server", ПодключениеКСервернойбазе)
						.ПолеОбъект("ФайловаяБаза file", ПодключениеКФайловойбазе)
						.ПолеСтрока("ВерсияПлатформы v8version", "8.3")
						.ПолеСтрока("Наименование name ib-name", "")
						.ПолеСтрока("КлючРазрешенияЗапуска unlock-code uc", "")
						;
	
	Возврат КонструкторПараметров;
	
КонецФункции

Функция КонструкторПараметровБлокировкиСеансов()
	
	КонструкторПараметров = Новый КонструкторПараметров;
	
	КонструкторПараметров
						.ПолеБулево("Заблокировать block-session block-users block-ib", Ложь)
						.ПолеЧисло("ПериодОжиданияЗавершенияСеансов timer timer-work-off", 300)
						.ПолеБулево("НеБлокироватьСеансы with-nolock", Ложь)
						.ПолеСтрока("КлючРазрешенияЗапуска unlock-code uccode uc-code uc", "")
						.ПолеСтрока("ПараметрБлокировкиСеансов", "")
						.ПолеМассив("ФильтрСеансов filter", Тип("Строка"))
						.ПолеСтрока("СообщениеБлокировкиСеансов", "База заблокирована администратором")

	;
	
	Возврат КонструкторПараметров;
	
КонецФункции

Функция КонструкторПараметровКластера()
	
	КонструкторПараметров = Новый КонструкторПараметров;
	
	КонструкторПараметров
						.ПолеСтрока("Пользователь user usr", "")
						.ПолеСтрока("Пароль password pwd", "")
						.ПолеСтрока("Сервер server", "")
						.ПолеЧисло("Порт port", 1545)
						.ПолеСтрока("ПутьКлиентаАдминистрирования rac", "")
						.ПолеЧисло("ЧислоПопыток try", 1);
						;
					
	Возврат КонструкторПараметров;
	
КонецФункции

Функция КонструкторПараметровЗапускаПредприятия()
	
	КонструкторПараметров = Новый КонструкторПараметров;
	
	ПолеПолученияФайлов = Новый ПолучениеФайлов;
	
	КонструкторПараметров
						.ПолеБулево("ЗапуститьВыполнениеРегламентныхЗаданий execute-scheduled-jobs jobs", Ложь)
						.ПолеБулево("ОчиститьКешВызовов clear-cache", Ложь)
						.ПолеБулево("ПривилегированныйРежим privileged", Ложь)
						.ПолеБулево("РежимУправляемогоПриложения managed-application", Ложь)
						.ПолеСтрока("КлючЗапуска c param", "")
						.ПолеСтрока("ПутьКОбработке", "")
						.ПолеМассив("ДополнительныеКлючи add-keys", Тип("Строка"))
						.ПолеОбъект("Обработка epf", ПолеПолученияФайлов, Ложь)
						;
	Возврат КонструкторПараметров;
	
КонецФункции

Функция КонструкторПараметровОбновленияКонфигурации()
	
	КонструкторПараметров = Новый КонструкторПараметров;
	
	ПолеПолученияФайлов = Новый ПолучениеФайлов;
	
	КонструкторПараметровЗапускаПредприятия = КонструкторПараметровЗапускаПредприятия();

	КонструкторПараметров
						.ПолеБулево("НаСервере server update-on-server", Истина)
						.ПолеБулево("ДинамическоеОбновление dynamic", Ложь)
						.ПолеБулево("ПредупрежденияКакОшибки warnings-as-errors WarningsAsErrors", Ложь)
						.ПолеБулево("ЗагрузитьКонфигурацию load-cf", Ложь)
						.ПолеСтрока("ПутьКФайлуОбновления", "")
						.ПолеОбъект("Обновление update release", ПолеПолученияФайлов, Ложь)
						.ПолеМассив("ПередОбновлением before-update before", КонструкторПараметровЗапускаПредприятия())
						.ПолеМассив("ПослеОбновления after-update after", КонструкторПараметровЗапускаПредприятия())
	
						;
	Возврат КонструкторПараметров;
	
КонецФункции

Функция КонструкторПараметровОбновленияРасширений()
	
	ПолеПолученияФайлов = Новый ПолучениеФайлов;
	
	НаборРасширений = Новый КонструкторПараметров;
	НаборРасширений.ПолеСтрока("Имя name");
	НаборРасширений.ПолеСтрока("ПутьКФайлуОбновления", "");
	НаборРасширений.ПолеОбъект("Обновление update release", ПолеПолученияФайлов, Ложь);
	НаборРасширений.ПолеБулево("Удалить delete", Ложь);
	НаборРасширений.ПолеБулево("Включить enable", Ложь);
	НаборРасширений.ПолеБулево("Отключить disable", Ложь);
	НаборРасширений.ПолеБулево("БезопасныйРежим safe-mode", Ложь);
	НаборРасширений.ПолеБулево("ЗащитаОтОпасныхДействий unsafe-action-protection", Ложь);

	КонструкторПараметров = Новый КонструкторПараметров;
	КонструкторПараметров.ПолеМассив("НаборРасширений ext array data", НаборРасширений)
						.ПолеБулево("ОтключитьВсеРасширения disable-all", Ложь)
						.ПолеБулево("ЗагрузкаРасширенийВКонфигураторе load-in-config", Ложь)
						.ПолеБулево("РежимУправляемогоПриложения managed-application", Ложь)
						.ПолеСтрока("ПутьКОбработкиОбновленияРасширения", "")
						.ПолеОбъект("ОбновлениеРасширений ext-update", ПолеПолученияФайлов, Ложь)
						.ПолеМассив("ПередОбновлением before-update before", КонструкторПараметровЗапускаПредприятия())
						.ПолеМассив("ПослеОбновления after-update after", КонструкторПараметровЗапускаПредприятия())
						;
						
	Возврат КонструкторПараметров;
	
КонецФункции

Функция КонструкторПараметровРезервногоКопирования()
	
	КонструкторПараметров = Новый КонструкторПараметров;
	
	// ПолеПолученияФайлов = Новый ПолучениеФайлов;
	
	// КонструкторПараметров
	// .ПолеБулево("НаСервере server update-on-server", Истина)
	// .ПолеБулево("ДинамическоеОбновление dynamic ", Ложь)
	// .ПолеБулево("ПредупрежденияКакОшибки warnings-as-errors WarningsAsErrors", Ложь)
	// .ПолеБулево("ЗагрузитьКонфигурацию load-cf", Ложь)
	// .ПолеСтрока("ПутьКФайлуОбновления", "")
	// .ПолеСтрока("ПутьКОбработкеПередОбновлением", "")
	// .ПолеСтрока("ПутьКОбработкеПослеОбновления", "")
	// .ПолеОбъект("Обновление update release", ПолеПолученияФайлов)
	// .ПолеОбъект("ПередОбновлением pre-update", ПолеПолученияФайлов)
	// .ПолеОбъект("ПослеОбновления post-update", ПолеПолученияФайлов)
	;
	Возврат КонструкторПараметров;
	
КонецФункции

#КонецОбласти

Процедура ПолучитьФайлЕслиТребуется(Параметры, КлючСвойства, КлючСвойстваЗаписи)
	
	ПараметрыПолученияФайлов = Неопределено;

	Лог.Отладка("Получаю параметры файла для свойства <%1>", КлючСвойства);
	Если НЕ Параметры.Свойство(КлючСвойства, ПараметрыПолученияФайлов) Тогда
		Лог.Отладка("Отсутствуют параметры файла для свойства <%1>", КлючСвойства);
		Возврат;
	КонецЕсли;

	ПутьКФайлу = "";

	ПолучениеФайлов = Новый ПолучениеФайлов();
	ФайлНадоПолучать = ПолучениеФайлов.Параметры(ПараметрыПолученияФайлов);
	
	Если Не ФайлНадоПолучать Тогда
		Возврат;
	КонецЕсли;

	ХешФайла = ПолучениеФайлов.ХешФайла();
	ПутьКФайлу = КешФайлов.ПолучитьФайл(ХешФайла);

	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
		
		Лог.Отладка("Файл <хеш: %1> в кеше не найден", ХешФайла);
		ПутьКФайлуВременный = ПолучениеФайлов.Получить();

		РезультатДобавления = КешФайлов.ДобавитьФайл(ПутьКФайлуВременный, ХешФайла, ПолучениеФайлов.ХешФункция());

		Если РезультатДобавления Тогда
			ПутьКФайлу = КешФайлов.ПолучитьФайл(ХешФайла);
		КонецЕсли;

	КонецЕсли;

	Лог.Отладка("Получен файл <%1> для свойства <%2> в кеш", ПутьКФайлу, КлючСвойстваЗаписи);
	Параметры.Вставить(КлючСвойстваЗаписи, ПутьКФайлу);
	Параметры.Удалить(КлючСвойства); 

КонецПроцедуры

Процедура ПолучитьФайлыОбновления() Экспорт
	
	Лог.Отладка("Получение файлов в кеш");

	КешФайлов.Обновить();

	// Получение файлов обновления конфигурации
	ПолучитьФайлЕслиТребуется(ПараметрыОбновленияКонфигурации, "Обновление", "ПутьКФайлуОбновления");
	ПолучитьОбработкиДляМассиваОбработчиков(ПараметрыОбновленияКонфигурации.ПередОбновлением);
	ПолучитьОбработкиДляМассиваОбработчиков(ПараметрыОбновленияКонфигурации.ПослеОбновления);

	// Получение файлов обновления расширений
	ПолучитьФайлЕслиТребуется(ПараметрыОбновленияРасширений, "ОбновлениеРасширений", "ПутьКОбработкиОбновленияРасширения");
	
	Если Не ЗначениеЗаполнено(ПараметрыОбновленияРасширений.ПутьКОбработкиОбновленияРасширения) Тогда
		ПараметрыОбновленияРасширений.ПутьКОбработкиОбновленияРасширения = ПолучитьВнутреннююОбработкуОбновленияРасширений()
	КонецЕсли;
	
	ПолучитьОбработкиДляМассиваОбработчиков(ПараметрыОбновленияРасширений.ПередОбновлением);
	ПолучитьОбработкиДляМассиваОбработчиков(ПараметрыОбновленияРасширений.ПослеОбновления);

	МассивРасширений = ПараметрыОбновленияРасширений.НаборРасширений;

	Для каждого РасширениеМассива Из МассивРасширений Цикл
		ПолучитьФайлЕслиТребуется(РасширениеМассива, "Обновление", "ПутьКФайлуОбновления");
	КонецЦикла;

	// Получение файлов для запуска в режиме предприятия
	ПолучитьОбработкиДляМассиваОбработчиков(ПараметрыЗапускаПредприятия);

КонецПроцедуры

Процедура ПолучитьОбработкиДляМассиваОбработчиков(Обработчики)
	
	Для каждого Обработчик Из Обработчики Цикл
		
		ПолучитьФайлЕслиТребуется(Обработчик, "Обработка", "ПутьКОбработке");

		Если ПустаяСтрока(Обработчик.ПутьКОбработке) Тогда
			Обработчик.ПутьКОбработке = ПолучитьВнутреннююОбработкуЗавершенияРаботы();
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Функция ПолучитьВнутреннююОбработкуОбновленияРасширений()
	
	ИмяФайлаОбработки = "ОбновлениеРасширений.epf";

	Возврат ПолучитьВнутреннююОбработку(ИмяФайлаОбработки);

КонецФункции

Функция ПолучитьВнутреннююОбработкуЗавершенияРаботы()
	
	ИмяФайлаОбработки = "ЗавершитьРаботу.epf";

	Возврат ПолучитьВнутреннююОбработку(ИмяФайлаОбработки);

КонецФункции

Функция ПолучитьВнутреннююОбработку(Знач ИмяФайлаОбработки)
	
	ЗагрузчикДвоичныхДанных = Новый ЗагрузчикЗапакованныхФайловAutoUpdateIB;
	
	ХешФайла = ЗагрузчикДвоичныхДанных.ПолучитьХешФайла(ИмяФайлаОбработки);
	
	Лог.Отладка("Получению встроенную обработку %1 <хеш: %2>", ИмяФайлаОбработки, ХешФайла);
	
	ПутьКФайлу = КешФайлов.ПолучитьФайл(ХешФайла);

	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
		Лог.Отладка("Файл <хеш: %1> в кеше не найден", ХешФайла);
	
		ПутьКФайлуВременный = ЗагрузчикДвоичныхДанных.ПолучитьВременныйПутьКФайлу(ИмяФайлаОбработки);
	
		РезультатДобавления = КешФайлов.ДобавитьФайл(ПутьКФайлуВременный, ХешФайла, ХешФункция.MD5);

		Если РезультатДобавления Тогда
			ПутьКФайлу = КешФайлов.ПолучитьФайл(ХешФайла);
		Иначе
			Лог.Отладка("Файл <хеш: %1> не удалось добавить в кеше", ХешФайла);
		КонецЕсли;

	КонецЕсли;

	Лог.Отладка("Получен файл <%1> внутренней обработки <%2>", ПутьКФайлу, ИмяФайлаОбработки);
	
	Возврат ПутьКФайлу;

КонецФункции

Процедура УстановитьКешФайлов(Знач ПутьККаталогу) Экспорт
	
	КаталогКешаФайлов = ПутьККаталогу;
	КешФайлов = Новый ЛокальныйКешФайлов(КаталогКешаФайлов);
	
КонецПроцедуры

Процедура Заполнить(ВходящееСоответствие) Экспорт
	
	Если Не (ПроверкаТипа.ЭтоЛюбоеСоответствие(ВходящееСоответствие)
		ИЛИ ПроверкаТипа.ЭтоЛюбаяСтруктура(ВходящееСоответствие))Тогда
		ВызватьИсключение СтрШаблон("Передан некорректный тип <%1> для заполнения настройки обновления", ТипЗнч(ВходящееСоответствие));
	КонецЕсли;

	Лог.Отладка("Заполняю настройки обновления");

	КонструкторПараметровНастройкиОбновления.ИзСоответствия(ВходящееСоответствие);
	
	СтруктураПараметров = КонструкторПараметровНастройкиОбновления.ВСтруктуру();
	ПараметрыПодключения = СтруктураПараметров.ПараметрыПодключения;

	Лог.Отладка("Ключ разрешения запуска <%1>", ПараметрыПодключения.КлючРазрешенияЗапуска);
	
	ПараметрыОбновленияКонфигурации = СтруктураПараметров.ПараметрыОбновленияКонфигурации;
	ПараметрыОбновленияРасширений = СтруктураПараметров.ПараметрыОбновленияРасширений;
	ПараметрыБлокировкиСеансов = СтруктураПараметров.ПараметрыБлокировкиСеансов;
	ПараметрыКластера = СтруктураПараметров.ПараметрыКластера;
	ПараметрыРезервногоКопирования = СтруктураПараметров.ПараметрыРезервногоКопирования;
	ПараметрыЗапускаПредприятия = СтруктураПараметров.ПараметрыЗапускаПредприятия;

	ПроверитьКорректностьЗаполнения();

КонецПроцедуры

Процедура ПроверитьКорректностьЗаполнения()

	// TODO: Сделать проверку
	// ВызватьИсключение "Параметры заполнены не корректно";
	
КонецПроцедуры

Функция Лог() Экспорт
	Возврат Лог;
КонецФункции

Процедура ДобавитьСпособВывода(ПроцессорВывода) Экспорт
	Лог.ДобавитьСпособВывода(ПроцессорВывода);
КонецПроцедуры

#Область Интерфейс_конструктора_параметров

#КонецОбласти

Процедура ПриСозданииОбъекта()
	
	Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB.config");
	// Лог = Логирование.ПолучитьЛог("oscript.lib.configor.constructor");
	//Лог.УстановитьУровень(УровниЛога.Отладка);

	ВыводВКонсоль = Новый ВыводЛогаВКонсоль();
	ДобавитьСпособВывода(ВыводВКонсоль);

	КонструкторПараметров = Новый КонструкторПараметров();
	КонструкторПараметров.ПолеСтрока("Версия version", "1.0")
						 .ПолеСтрока("Наименование name", "")
					     .ПолеОбъект("ПараметрыПодключения ib-connect", КонструкторПараметровПодключения())
						 .ПолеОбъект("ПараметрыОбновленияКонфигурации configuration", КонструкторПараметровОбновленияКонфигурации())
						 .ПолеОбъект("ПараметрыОбновленияРасширений ext extensions", КонструкторПараметровОбновленияРасширений())
						 .ПолеОбъект("ПараметрыБлокировкиСеансов sessions block-sessions", КонструкторПараметровБлокировкиСеансов())
						 .ПолеОбъект("ПараметрыКластера cluster", КонструкторПараметровКластера())
						 .ПолеОбъект("ПараметрыРезервногоКопирования backup", КонструкторПараметровРезервногоКопирования())
						 .ПолеМассив("ПараметрыЗапускаПредприятия enterprise run", КонструкторПараметровЗапускаПредприятия())
						;	
	КонструкторПараметровНастройкиОбновления = КонструкторПараметров;
	
КонецПроцедуры