#Использовать workflow
#Использовать v8runner
#Использовать tempfiles
#Использовать "./internal/timer"

Перем Лог;
Перем ОшибкаПроцессаВыполнения;
Перем ОписаниеОшибкиОбновления;
Перем НастройкаОбновления;
Перем РабочийКонфигуратор;
Перем ЛокальныеВременныеФайлы;
Перем УправлениеСеансами;
Перем ДоступКБазеЗаблокирован;
Перем МассивСпособовВывода;
Перем ИгнорироватьОшибкуОбновленияКонфигурации;
Перем ИдентификаторРабочегоПроцесса;
Перем РезервноеКопирование;

Функция ВыполнитьОбновление(НастройкаОбновления) Экспорт
	
	РезультатОбновления = Новый Структура("Выполнено, ОписаниеОшибки, Задача", Ложь, "", "");
	
	Если НЕ НастройкаОбновления.НадоЧтоТоДелать() Тогда
		РезультатОбновления.ОписаниеОшибки = ПолучитьИнформацияОбОшибке("Отсутствуют этапы работы с информационной базой");
		Возврат РезультатОбновления;
	КонецЕсли;
	
	Таймер = Новый ТаймерВыполнения();
	
	Лог.Информация("Начало работы с информационной базой");
	
	РабочийКонфигуратор = НастроитьКонфигуратор(НастройкаОбновления);
	
	БизнесПроцессОбновления = СформироватьПроцессОбновления(НастройкаОбновления);
	
	БизнесПроцессОбновления.Запустить();

	Если БизнесПроцессОбновления.Завершен() Тогда
		
		ОписаниеОшибки = БизнесПроцессОбновления.ПолучитьОписаниеОшибки();
		
		Если ОписаниеОшибки = Неопределено Тогда
			РезультатОбновления.Выполнено = Истина;
		Иначе
			РезультатОбновления.ОписаниеОшибки = ОписаниеОшибки.Ошибка;
			РезультатОбновления.Задача = ОписаниеОшибки.Задача.Наименование();
		КонецЕсли;
		
	КонецЕсли;	

	Лог.Поля("ВремяВыполнения", Таймер.ВремяЗамера()).Информация("Завершена работа с информационной базой");
	
	ЛокальныеВременныеФайлы.Удалить();
	
	Возврат РезультатОбновления;
	
КонецФункции

Процедура ДобавитьСпособВывода(ПроцессорВывода) Экспорт
	
	МассивСпособовВывода.Добавить(ПроцессорВывода);
	Лог.ДобавитьСпособВывода(ПроцессорВывода);

КонецПроцедуры

Функция СформироватьПроцессОбновления(НастройкаОбновления)
	
	БизнесПроцесс = Новый БизнесПроцесс("Процесс обновления информационной базы");
	БизнесПроцесс.ПриОшибкеВыполненияЗадачи(ЭтотОбъект, "ОбработкаОшибкиВыполнения");
	КонтекстБизнесПроцесса = БизнесПроцесс.ПолучитьКонтекст();
	
	БизнесПроцессОбработкиОшибок = Новый БизнесПроцесс("Процесс обработки ошибки обновления информационной базы");
	КонтекстБизнесПроцесса.Добавить("БПОбработкиОшибки", БизнесПроцессОбработкиОшибок);
	КонтекстБизнесПроцесса.Добавить("ДоступКБазеЗаблокирован", Ложь);
	
	ПараметрыПолученияДанных = Новый Массив();
	ПараметрыПолученияДанных.Добавить(НастройкаОбновления);
	БизнесПроцесс.ДобавитьЗадачу("ПолучениеДанныхДляОбновления", ЭтотОбъект, "ПолучениеДанныхДляОбновления", ПараметрыПолученияДанных);
	Лог.Поля("ИмяЗадачи", "ПолучениеДанныхДляОбновления", "КоличествоПараметров", ПараметрыПолученияДанных.Количество()).Отладка("Добавлена задача");

	Если НастройкаОбновления.БлокировкаСеансов() Тогда
		ПараметрыБлокировкиСеансов = Новый Массив();
		ПараметрыБлокировкиСеансов.Добавить(НастройкаОбновления);
		БизнесПроцесс.ДобавитьЗадачу("БлокировкаСеансов", ЭтотОбъект, "БлокировкаСеансов", ПараметрыБлокировкиСеансов, КонтекстБизнесПроцесса);
		Лог.Поля("ИмяЗадачи", "БлокировкаСеансов", "КоличествоПараметров", ПараметрыБлокировкиСеансов.Количество()).Отладка("Добавлена задача");
	КонецЕсли; 

	Если НастройкаОбновления.СозданиеБекапаИнформационнойБазы() Тогда
		ПараметрыРезервногоКопирования = Новый Массив();
		ПараметрыРезервногоКопирования.Добавить(НастройкаОбновления.ПараметрыРезервногоКопирования);
		ПараметрыРезервногоКопирования.Добавить(НастройкаОбновления);
		
		БизнесПроцесс.ДобавитьЗадачу("СоздатьРезервнуюКопию", ЭтотОбъект, "СоздатьРезервнуюКопию", ПараметрыРезервногоКопирования, КонтекстБизнесПроцесса);
		Лог.Поля("ИмяЗадачи", "СоздатьРезервнуюКопию", "КоличествоПараметров", ПараметрыРезервногоКопирования.Количество()).Отладка("Добавлена задача");
	КонецЕсли;
		
	Если НастройкаОбновления.НадоОбновитьКонфигурацию() Тогда
		
		ПараметрыОбновленияКонфигурации = Новый Массив();
		ПараметрыОбновленияКонфигурации.Добавить(НастройкаОбновления.ПараметрыОбновленияКонфигурации);
		
		БизнесПроцесс.ДобавитьЗадачу("ОбновлениеКонфигурации", ЭтотОбъект, "ОбновлениеКонфигурации", ПараметрыОбновленияКонфигурации, КонтекстБизнесПроцесса);
		Лог.Поля("ИмяЗадачи", "ОбновлениеКонфигурации", "КоличествоПараметров", ПараметрыОбновленияКонфигурации.Количество()).Отладка("Добавлена задача");
		
	КонецЕсли;
	
	Если НастройкаОбновления.НадоОбновитьРасширения() Тогда
		
		ПараметрыОбновленияРасширения = Новый Массив();
		ПараметрыОбновленияРасширения.Добавить(НастройкаОбновления.ПараметрыОбновленияРасширений);
		БизнесПроцесс.ДобавитьЗадачу("ОбновлениеРасширенийКонфигурации", ЭтотОбъект, "ОбновлениеРасширенийКонфигурации", ПараметрыОбновленияРасширения, КонтекстБизнесПроцесса);
		Лог.Поля("ИмяЗадачи", "ОбновлениеРасширенийКонфигурации", "КоличествоПараметров", ПараметрыОбновленияРасширения.Количество()).Отладка("Добавлена задача");
	
	КонецЕсли;

	Если НастройкаОбновления.НадоЗапуститьВРежимеПредприятия() Тогда
		
		ПараметрыЗапуска = Новый Массив();
		ПараметрыЗапуска.Добавить(НастройкаОбновления.ПараметрыЗапускаПредприятия);
		БизнесПроцесс.ДобавитьЗадачу("ЗапуститьВРежимеПредприятия", ЭтотОбъект, "ЗапуститьВРежимеПредприятия", ПараметрыЗапуска, КонтекстБизнесПроцесса);
		Лог.Поля("ИмяЗадачи", "ЗапуститьВРежимеПредприятия", "КоличествоПараметров", ПараметрыЗапуска.Количество()).Отладка("Добавлена задача");
	
	КонецЕсли;
	
	Если НастройкаОбновления.БлокировкаСеансов() Тогда
		БизнесПроцесс.ДобавитьЗадачу("СнятьБлокировкуСеансов", ЭтотОбъект, "СнятьБлокировкуСеансов", , КонтекстБизнесПроцесса);
		Лог.Поля("ИмяЗадачи", "СнятьБлокировкуСеансов", "КоличествоПараметров", 0).Отладка("Добавлена задача");
		КонецЕсли;

	Если НастройкаОбновления.СозданиеБекапаИнформационнойБазы() Тогда
		БизнесПроцесс.ДобавитьЗадачу("УдалитьФайлРезервнойКопии", ЭтотОбъект, "УдалитьФайлРезервнойКопии", , КонтекстБизнесПроцесса);
		Лог.Поля("ИмяЗадачи", "УдалитьФайлРезервнойКопии", "КоличествоПараметров", 0).Отладка("Добавлена задача");
	КонецЕсли;
	
	Возврат БизнесПроцесс;
	
КонецФункции

Процедура ОбработкаОшибкиВыполнения(ЗадачаБизнесПроцесса, ПродолжитьВыполнение, СтандартнаяОбработка) Экспорт
	
	БизнесПроцессЗадачи = ЗадачаБизнесПроцесса.БизнесПроцесс();

	ОписаниеОшибкиЗадачи = КраткоеПредставлениеОшибки(ЗадачаБизнесПроцесса.ПолучитьОписаниеОшибки().Ошибка);
	
	Лог.Поля("ИмяЗадачи", ЗадачаБизнесПроцесса.Наименование(), "ОписаниеОшибки", ОписаниеОшибкиЗадачи).Ошибка("Обработка ошибки выполнения задачи");
	
	КонтекстБизнесПроцесса = БизнесПроцессЗадачи.ПолучитьКонтекст();
	
	Если Не ОшибкаТребуетВосстановленияРезервнойКопии(ОписаниеОшибкиЗадачи) Тогда
		
		КонтекстБизнесПроцесса.Добавить("НадоВосстановитьРезервнуюКопию", Ложь);

	КонецЕсли;

	БизнесПроцессОбработкиОшибок = КонтекстБизнесПроцесса.Получить("БПОбработкиОшибки");
	БизнесПроцессОбработкиОшибок.УстановитьКонтекст(КонтекстБизнесПроцесса);
	
	БизнесПроцессОбработкиОшибок.Запустить();
	
КонецПроцедуры

Функция ОшибкаТребуетВосстановленияРезервнойКопии(Знач ОписаниеОшибкиЗадачи)
	
	МассивОшибок = СписокОшибокНеТребующихВосстановленияРезервнойКопии();

	Возврат МассивОшибок.Найти(СокрЛП(ОписаниеОшибкиЗадачи)) = Неопределено;

КонецФункции

Функция СписокОшибокНеТребующихВосстановленияРезервнойКопии()
	
	МассивОшибок = Новый Массив();
	МассивОшибок.Добавить("Файл не содержит доступных обновлений");

	Возврат МассивОшибок;

КонецФункции

Процедура ДобавитьРабочийПроцессВЛог(Знач ПИдентификаторРабочегоПроцесса) Экспорт

	Лог = Лог.Поля("РабочийПроцесс", ПИдентификаторРабочегоПроцесса);
	ИдентификаторРабочегоПроцесса = ПИдентификаторРабочегоПроцесса; 

КонецПроцедуры

Процедура ПередатьРабочийПроцессВОбъект(Знач ОбъектПриемник)
	
	Если Не ИдентификаторРабочегоПроцесса = Неопределено Тогда
		ОбъектПриемник.ДобавитьРабочийПроцессВЛог(ИдентификаторРабочегоПроцесса);
	КонецЕсли;

КонецПроцедуры

Процедура ПолучениеДанныхДляОбновления(НастройкаОбновления) Экспорт
	
	НастройкаОбновления.ПолучитьФайлыОбновления();
	
КонецПроцедуры

Процедура СоздатьРезервнуюКопию(Знач КонтекстВыполнения, Знач ПараметрыРезервногоКопирования, Знач НастройкаОбновления) Экспорт
	
	РезервноеКопирование = Новый РезервноеКопирование;
	ДобавитьСпособыВыводаВОбъект(РезервноеКопирование);
	ПередатьРабочийПроцессВОбъект(РезервноеКопирование);
	РезервноеКопирование.УстановитьУправлениеКонфигуратором(РабочийКонфигуратор);

	РезервноеКопирование.УстановитьНастройки(ПараметрыРезервногоКопирования, НастройкаОбновления);

	РезервноеКопирование.СоздатьРезервнуюКопию();

	Если РезервноеКопирование.ПриОшибкеВосстановитьИзКопии() Тогда
		
		КонтекстВыполнения.Добавить("РезервнаяКопияСделана", Истина);
		БизнесПроцессОбработкиОшибок = КонтекстВыполнения.Получить("БПОбработкиОшибки");
		БизнесПроцессОбработкиОшибок.ДобавитьЗадачуВНачало("ВосстановитьРезервнуюКопию", ЭтотОбъект, "ВосстановитьРезервнуюКопию", , КонтекстВыполнения);
		Лог.Поля("Событие", "При ошибке", "ИмяЗадачи", "ВосстановитьРезервнуюКопию", "КоличествоПараметров", 0).Отладка("Добавлена задача");

		Если РезервноеКопирование.НадоУдалитьФайлРезервнойКопии() Тогда
			БизнесПроцессОбработкиОшибок.ДобавитьЗадачу("УдалитьФайлРезервнойКопии", ЭтотОбъект, "УдалитьФайлРезервнойКопии", , КонтекстВыполнения);
			Лог.Поля("Событие", "При ошибке", "ИмяЗадачи", "УдалитьФайлРезервнойКопии", "КоличествоПараметров", 0).Отладка("Добавлена задача");
		КонецЕсли;
		
		КонтекстВыполнения.Добавить("НадоВосстановитьРезервнуюКопию", Истина);

	КонецЕсли;
		
КонецПроцедуры

Процедура ВосстановитьРезервнуюКопию(Знач КонтекстВыполнения) Экспорт
	
	Если Не ЗначениеЗаполнено(РезервноеКопирование) Тогда
		Возврат;
	КонецЕсли;

	Если КонтекстВыполнения.Получить("РезервнаяКопияСделана")
		И КонтекстВыполнения.Получить("НадоВосстановитьРезервнуюКопию")
		Тогда
	
		РезервноеКопирование.ВосстановитьРезервнуюКопию();		

	КонецЕсли;

КонецПроцедуры

Процедура УдалитьФайлРезервнойКопии(КонтекстВыполнения) Экспорт
	
	Если Не ЗначениеЗаполнено(РезервноеКопирование) Тогда
		Возврат;
	КонецЕсли;

	Если КонтекстВыполнения.Получить("РезервнаяКопияСделана") 
		И РезервноеКопирование.НадоУдалитьФайлРезервнойКопии() Тогда
		
		РезервноеКопирование.УдалитьФайлРезервнойКопии();		

	КонецЕсли;

КонецПроцедуры

Функция НастроитьКонфигуратор(НастройкаПодключения)
	
	Конфигуратор = Новый УправлениеКонфигуратором;
	
	Лог.Поля("СтрокаПодключения", НастройкаПодключения.СтрокаПодключения(),
			"КлючРазрешенияЗапуска", НастройкаПодключения.КлючРазрешенияЗапуска(),
			"ВерсияПлатформы", НастройкаПодключения.ВерсияПлатформы()
			).Отладка("Настройка конфигуратора");

	Конфигуратор.КаталогСборки(ЛокальныеВременныеФайлы.СоздатьКаталог());
	
	АвторизацияВИнформационнойБазе = НастройкаПодключения.АвторизацияВИнформационнойБазе();
	Конфигуратор.УстановитьКонтекст(НастройкаПодключения.СтрокаПодключения(),
									АвторизацияВИнформационнойБазе.Пользователь,
									АвторизацияВИнформационнойБазе.Пароль);

	Конфигуратор.ИспользоватьВерсиюПлатформы(НастройкаПодключения.ВерсияПлатформы());
	Конфигуратор.УстановитьКлючРазрешенияЗапуска(НастройкаПодключения.КлючРазрешенияЗапуска());

	Возврат Конфигуратор;
	
КонецФункции

Процедура НастроитьУправлениемСеансами(НастройкиУправленияСеансами)
	
	УправлениеСеансами = Новый УправлениеСеансами;
	ПередатьРабочийПроцессВОбъект(УправлениеСеансами);
	ДобавитьСпособыВыводаВОбъект(УправлениеСеансами);
	УправлениеСеансами.УстановитьНастройки(НастройкиУправленияСеансами);
	
КонецПроцедуры

Процедура БлокировкаСеансов(КонтекстВыполнения, ПараметрыБлокировкиСеансов) Экспорт
	
	Если УправлениеСеансами = Неопределено Тогда
		НастроитьУправлениемСеансами(ПараметрыБлокировкиСеансов);
	КонецЕсли;

	УправлениеСеансами.БлокировкаДоступа();
	
	КонтекстВыполнения.Добавить("ДоступКБазеЗаблокирован", Истина);
	БизнесПроцессОбработкиОшибок = КонтекстВыполнения.Получить("БПОбработкиОшибки");
	БизнесПроцессОбработкиОшибок.ДобавитьЗадачу("СнятьБлокировкуСеансов", ЭтотОбъект, "СнятьБлокировкуСеансов", , КонтекстВыполнения);
	Лог.Поля("Событие", "При ошибке","ИмяЗадачи", "СнятьБлокировкуСеансов", "КоличествоПараметров", 0).Отладка("Добавлена задача");

КонецПроцедуры

Процедура ОбновлениеРасширенийКонфигурации(КонтекстВыполнения, ПараметрыОбновления) Экспорт
	
	Обновлятор = Новый ОбновляторРасширений;
	ПередатьРабочийПроцессВОбъект(Обновлятор);
	ДобавитьСпособыВыводаВОбъект(Обновлятор);
	Обновлятор.УстановитьУправлениеКонфигуратором(РабочийКонфигуратор);
	Обновлятор.УстановитьНастройкиОбновления(ПараметрыОбновления);
	Обновлятор.Запустить();
	
КонецПроцедуры

Процедура ЗапуститьВРежимеПредприятия(КонтекстВыполнения, ПараметрыЗапускаПредприятия) Экспорт

	ЗапускПредприятия = Новый ЗапускПредприятия;
	ПередатьРабочийПроцессВОбъект(ЗапускПредприятия);
	ДобавитьСпособыВыводаВОбъект(ЗапускПредприятия);

	Для каждого ПараметрыЗапуска Из ПараметрыЗапускаПредприятия Цикл
		ЗапускПредприятия.УстановитьУправлениеКонфигуратором(РабочийКонфигуратор);
		ЗапускПредприятия.УстановитьНастройки(ПараметрыЗапуска);
		ЗапускПредприятия.Запустить();
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновлениеКонфигурации(КонтекстВыполнения, ПараметрыОбновления) Экспорт

	КонтекстВыполнения.Добавить("ОбновлениеКонфигурацииУспешно", Ложь);

	Обновлятор = Новый ОбновляторКонфигурации;
	ПередатьРабочийПроцессВОбъект(Обновлятор);
	ДобавитьСпособыВыводаВОбъект(Обновлятор);
	Обновлятор.УстановитьУправлениеКонфигуратором(РабочийКонфигуратор);
	Обновлятор.УстановитьНастройкиОбновления(ПараметрыОбновления);
	Обновлятор.Запустить();

	КонтекстВыполнения.Добавить("ОбновлениеКонфигурацииУспешно", Истина);
	КонтекстВыполнения.Добавить("НадоВосстановитьРезервнуюКопию", Ложь);
	
КонецПроцедуры

Процедура ДобавитьСпособыВыводаВОбъект(Знач Класс)
	
	Для каждого СпособВывода Из МассивСпособовВывода Цикл
		Класс.ДобавитьСпособВывода(СпособВывода);
	КонецЦикла;

КонецПроцедуры

Процедура СнятьБлокировкуСеансов(КонтекстВыполнения) Экспорт
	
	Если КонтекстВыполнения.Получить("ДоступКБазеЗаблокирован")Тогда
	
		УправлениеСеансами.РазблокироватьДоступ();		

	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьИнформацияОбОшибке(Знач ТекстОписанияОшибки);

	Попытка
		ВызватьИсключение ТекстОписанияОшибки
	Исключение
		Возврат ИнформацияОбОшибке();
	КонецПопытки;
	
КонецФункции


Процедура ПриСозданииОбъекта()
	
	ЛокальныеВременныеФайлы = Новый МенеджерВременныхФайлов;
	ДоступКБазеЗаблокирован = Ложь;
	МассивСпособовВывода = Новый Массив();
	Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB").Поля("Префикс", "manager");
	//Лог.УстановитьУровень(УровниЛога.Отладка);

КонецПроцедуры
