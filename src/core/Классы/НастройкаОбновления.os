
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
Перем ИдентификаторНастройки Экспорт;

Перем КонструкторПараметровНастройкиОбновления;

Функция БлокировкаСеансов() Экспорт
	Возврат ПараметрыБлокировкиСеансов.Заблокировать;
КонецФункции

Функция СозданиеБекапаИнформационнойБазы() Экспорт
	Возврат ПараметрыРезервногоКопирования.Свойство("СоздатьРезервнуюКопию") 
			И ПараметрыРезервногоКопирования.СоздатьРезервнуюКопию;
КонецФункции

Функция ИмяИнформационнойБазы() Экспорт
	
	ИмяБазы = ПараметрыПодключения.Наименование;

	Если Не ЗначениеЗаполнено(ИмяБазы) Тогда
		
		Если Не ЭтоФайловаяБаза() Тогда
			ИмяБазы = ПараметрыПодключения.СервернаяБаза.База;
		Иначе
		
			Лог.Ошибка("Для файловой базы обязательно задание имени"); // TODO Сделать получение 2-х последних каталогов из каталога ИБ	
		
		КонецЕсли;

	КонецЕсли;
	
	Возврат ИмяБазы;

КонецФункции

Функция ЭтоФайловаяБаза() Экспорт

	Возврат ЗначениеЗаполнено(ПараметрыПодключения.ФайловаяБаза.ПутьККаталогу);
	
КонецФункции

Функция СтрокаПодключения() Экспорт
	
	ЭтоФайловаяБаза = ЭтоФайловаяБаза();
	

	Если ЭтоФайловаяБаза Тогда

		Лог.Отладка("Путь к каталогу файловой базы <%1>", ПараметрыПодключения.ФайловаяБаза.ПутьККаталогу);
		СтрокаПодключения = СтрШаблон("/F""%1""", ПараметрыПодключения.ФайловаяБаза.ПутьККаталогу);
	
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
	Возврат ПараметрыПодключения.КлючРазрешенияЗапуска;	
КонецФункции

Функция Идентификатор() Экспорт
	Возврат ИдентификаторНастройки;	
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

Процедура ДобавитьРабочийПроцессВЛог(Знач ИдентификаторРабочегоПроцесса) Экспорт

	Лог = Лог.Поля("РабочийПроцесс", ИдентификаторРабочегоПроцесса);
	
КонецПроцедуры


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
						.ПолеБулево("ПродолжитьПриОшибке continue-on-error", Ложь)
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
	
	ПолеПолученияФайлов = Новый ПолучениеФайлов;
	
	КонструкторПараметров
				.ПолеБулево("СоздатьРезервнуюКопию create-backup do", Ложь)
				.ПолеБулево("ПриОшибкеВосстановитьИзКопии restore-on-error", Ложь)
				.ПолеСтрока("ПутьККаталогуРезервныхКопий backup-dir", "")
				.ПолеБулево("ВосстановитьРезервнуюКопию restore", Ложь)
				.ПолеБулево("ОставитьФайлРезервнойКопии keep-file", Ложь)
				.ПолеСтрока("ПутьКФайлуРезервнойКопии", "")
				.ПолеСтрока("ИмяФайлаРезервнойКопии file-name", "/%b/%d-{yyyyMMdd_HHmm}/1Cv8.dt")
				.ПолеОбъект("РезервнаяКопия backup-file", ПолеПолученияФайлов, Ложь)
	;
	Возврат КонструкторПараметров;
	
КонецФункции

#КонецОбласти

Процедура ПолучитьФайлЕслиТребуется(Параметры, КлючСвойства, КлючСвойстваЗаписи)
	
	ПараметрыПолученияФайлов = Неопределено;

	Если НЕ Параметры.Свойство(КлючСвойства, ПараметрыПолученияФайлов) Тогда
		Лог.Поля("КлючСвойства", КлючСвойства).Отладка("Отсутствует свойство в параметрах");
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
		
		Лог.Поля("ХешФайла", ХешФайла).Отладка("Получаю файл");
		ПутьКФайлуВременный = ПолучениеФайлов.Получить();

		РезультатДобавления = КешФайлов.ДобавитьФайл(ПутьКФайлуВременный, ХешФайла, ПолучениеФайлов.ХешФункция());

		Если РезультатДобавления Тогда
			ПутьКФайлу = КешФайлов.ПолучитьФайл(ХешФайла);
		КонецЕсли;

		Лог.Поля("ХешФайла", ХешФайла, "ПутьКФайлу", ПутьКФайлу, "КлючСвойства", КлючСвойстваЗаписи).Отладка("Получен файл в кеш");
	
	Иначе
		Лог.Поля("ХешФайла", ХешФайла, "ПутьКФайлу", ПутьКФайлу).Отладка("Файл найден в кеше");
	КонецЕсли;
	
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
	
	Лог.Поля("ХешФайла", ХешФайла, "ИмяФайла", ИмяФайлаОбработки).Отладка("Получению встроенных файлов");

	ПутьКФайлу = КешФайлов.ПолучитьФайл(ХешФайла);

	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
	
		ПутьКФайлуВременный = ЗагрузчикДвоичныхДанных.ПолучитьВременныйПутьКФайлу(ИмяФайлаОбработки);
	
		РезультатДобавления = КешФайлов.ДобавитьФайл(ПутьКФайлуВременный, ХешФайла, ХешФункция.MD5);

		Если РезультатДобавления Тогда
			ПутьКФайлу = КешФайлов.ПолучитьФайл(ХешФайла);
			Лог.Поля("ХешФайла", ХешФайла, "ПутьКФайлу", ПутьКФайлу).Отладка("Получен файл из кеша");
		Иначе
			Лог.Поля("ХешФайла", ХешФайла, "ПутьКФайлу", ПутьКФайлу).Отладка("Не удалось добавить в кеше");
		КонецЕсли;

	КонецЕсли;

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
	ПараметрыОбновленияКонфигурации = СтруктураПараметров.ПараметрыОбновленияКонфигурации;
	ПараметрыОбновленияРасширений = СтруктураПараметров.ПараметрыОбновленияРасширений;
	ПараметрыБлокировкиСеансов = СтруктураПараметров.ПараметрыБлокировкиСеансов;
	ПараметрыКластера = СтруктураПараметров.ПараметрыКластера;
	ПараметрыРезервногоКопирования = СтруктураПараметров.ПараметрыРезервногоКопирования;
	ПараметрыЗапускаПредприятия = СтруктураПараметров.ПараметрыЗапускаПредприятия;

	ИдентификаторНастройки = СтруктураПараметров.Идентификатор;

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
	
	Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB").Поля("Префикс", "config");
	// Лог = Логирование.ПолучитьЛог("oscript.lib.configor.constructor");
	//Лог.УстановитьУровень(УровниЛога.Отладка);

	КонструкторПараметров = Новый КонструкторПараметров();
	КонструкторПараметров.ПолеСтрока("Версия version", "1.0")
						 .ПолеСтрока("Наименование name", "")
					     .ПолеСтрока("Идентификатор id uid", "")
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