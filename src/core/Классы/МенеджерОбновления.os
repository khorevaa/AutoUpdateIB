#Использовать workflow
#Использовать v8runner
#Использовать tempfiles

Перем Лог;
Перем ОшибкаПроцессаВыполнения;
Перем ОписаниеОшибкиОбновления;
Перем НастройкаОбновления;
Перем РабочийКонфигуратор;
Перем ЛокальныеВременныеФайлы;
Перем УправлениемСеансами;
Перем ДоступКБазеЗаблокирован;
Перем МассивСпособовВывода;

Функция ВыполнитьОбновление(НастройкаОбновления) Экспорт
	
	РезультатОбновления = Новый Структура("Выполнено, ОписаниеОшибки, Задача", Ложь, "", "");
	
	Если НЕ НастройкаОбновления.НадоЧтоТоДелать() Тогда
		Лог.Информация("Отсутствуют этапы обновления информационной базы");
		РезультатОбновления.ОписаниеОшибки = "Отсутствуют этапы обновления информационной базы";
		Возврат РезультатОбновления;
	КонецЕсли;
	
	Лог.Информация("Начало обновления информационной базы");
	
	РабочийКонфигуратор = НастроитьКонфигуратор(НастройкаОбновления);
	
	БизнесПроцессОбновления = СформироватьПроцессОбновления(НастройкаОбновления);
	
	БизнесПроцессОбновления.Запустить();

	Если БизнесПроцессОбновления.Завершен() Тогда
		
		ОписаниеОшибки = БизнесПроцессОбновления.ПолучитьОписаниеОшибки();
		
		Если ОписаниеОшибки = Неопределено Тогда
			РезультатОбновления.Выполнено = Истина;
		Иначе
			РезультатОбновления.ОписаниеОшибки = ПодробноеПредставлениеОшибки(ОписаниеОшибки.Ошибка); // TODO: Краткое - заменить
			РезультатОбновления.Задача = ОписаниеОшибки.Задача.Наименование();
		КонецЕсли;
		
	КонецЕсли;
	
	Лог.Информация("Завершено обновлении информационной базы");
	
	ЛокальныеВременныеФайлы.Удалить();
	
	Возврат РезультатОбновления;
	
КонецФункции

Процедура ДобавитьСпособВывода(ПроцессорВывода) Экспорт
	
	МассивСпособовВывода = Новый Массив();
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
	
	Если НастройкаОбновления.БлокировкаСеансов() Тогда
		Лог.Отладка("Добавляю задачу <БлокировкаСеансов>");
		ПараметрыБлокировкиСеансов = Новый Массив();
		ПараметрыБлокировкиСеансов.Добавить(НастройкаОбновления);
		БизнесПроцесс.ДобавитьЗадачу("БлокировкаСеансов", ЭтотОбъект, "БлокировкаСеансов", ПараметрыБлокировкиСеансов, КонтекстБизнесПроцесса);
	КонецЕсли; 

	Если НастройкаОбновления.СозданиеБекапаИнформационнойБазы() Тогда
		ПараметрыСозданияБекапа = Новый Массив();
		ПараметрыСозданияБекапа.Добавить(НастройкаОбновления.НастройкаСозданияБекапа);
		Лог.Отладка("Добавляю задачу <СозданиеБекапаИнформационнойБазы>");
		БизнесПроцесс.ДобавитьЗадачу("СозданиеБекапаИнформационнойБазы", ЭтотОбъект, "СозданиеБекапаИнформационнойБазы", ПараметрыСозданияБекапа, КонтекстБизнесПроцесса);
	КонецЕсли;
		
	Если НастройкаОбновления.НадоОбновитьКонфигурацию() Тогда
		
		Лог.Отладка("Добавляю задачу <ОбновлениеКонфигурации>");

		ПараметрыОбновленияКонфигурации = Новый Массив();
		ПараметрыОбновленияКонфигурации.Добавить(НастройкаОбновления.ПараметрыОбновленияКонфигурации);
		
		БизнесПроцесс.ДобавитьЗадачу("ОбновлениеКонфигурации", ЭтотОбъект, "ОбновлениеКонфигурации", ПараметрыОбновленияКонфигурации, КонтекстБизнесПроцесса);
		
	КонецЕсли;
	
	Если НастройкаОбновления.НадоОбновитьРасширения() Тогда
		
		Лог.Отладка("Добавляю задачу <ОбновлениеРасширенийКонфигурации>");
		ПараметрыОбновленияРасширения = Новый Массив();
		ПараметрыОбновленияРасширения.Добавить(НастройкаОбновления.ПараметрыОбновленияРасширений);
		БизнесПроцесс.ДобавитьЗадачу("ОбновлениеРасширенийКонфигурации", ЭтотОбъект, "ОбновлениеРасширенийКонфигурации", ПараметрыОбновленияРасширения, КонтекстБизнесПроцесса);
		
	КонецЕсли;
	
	Если НастройкаОбновления.БлокировкаСеансов() Тогда
		Лог.Отладка("Добавляю задачу <СнятьБлокировкуСеансов>");
		БизнесПроцесс.ДобавитьЗадачу("СнятьБлокировкуСеансов", ЭтотОбъект, "СнятьБлокировкуСеансов", , КонтекстБизнесПроцесса);
	КонецЕсли;
	
	Возврат БизнесПроцесс;
	
КонецФункции

Процедура ОбработкаОшибкиВыполнения(ЗадачаБизнесПроцесса, ПродолжитьВыполнение, СтандартнаяОбработка) Экспорт
	
	БизнесПроцессЗадачи = ЗадачаБизнесПроцесса.БизнесПроцесс();
	
	Лог.Отладка("Обработка ошибки задачи <%1> по причине <%2>", ЗадачаБизнесПроцесса.Наименование());
	
	КонтекстБизнесПроцесса = БизнесПроцессЗадачи.ПолучитьКонтекст();
	
	БизнесПроцессОбработкиОшибок = КонтекстБизнесПроцесса.Получить("БПОбработкиОшибки");
	БизнесПроцессОбработкиОшибок.УстановитьКонтекст(КонтекстБизнесПроцесса);
	
	БизнесПроцессОбработкиОшибок.Запустить();
	
КонецПроцедуры

Процедура ПолучениеДанныхДляОбновления(НастройкаОбновления) Экспорт
	
	НастройкаОбновления.ПолучитьФайлыОбновления();
	
КонецПроцедуры

Процедура СозданиеБекапаИнформационнойБазы(КонтекстВыполнения, НастройкаБекапа) Экспорт
	
	// TODO: Сделать формирование бекапа
	
КонецПроцедуры

Функция НастроитьКонфигуратор(НастройкаПодключения)
	
	Конфигуратор = Новый УправлениеКонфигуратором;
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
	
	УправлениемСеансами = Новый УправлениемСеансамиОбновления;
	УправлениемСеансами.УстановитьНастройки(НастройкиУправленияСеансами);
	
КонецПроцедуры

Процедура БлокировкаСеансов(КонтекстВыполнения, ПараметрыБлокировкиСеансов) Экспорт
	
	Если УправлениемСеансами = Неопределено Тогда
		НастроитьУправлениемСеансами(ПараметрыБлокировкиСеансов);
	КонецЕсли;

	Лог.Информация("Блокировка доступа к информационной базе");	
	УправлениемСеансами.БлокировкаДоступа();
	
КонецПроцедуры

Процедура ОбновлениеРасширенийКонфигурации(КонтекстВыполнения, ПараметрыОбновления) Экспорт
	
	Обновлятор = Новый ОбновляторРасширений;
	ДобавитьСпособыВыводаВОбъект(Обновлятор);
	Обновлятор.УстановитьУправлениеКонфигуратором(РабочийКонфигуратор);
	Обновлятор.УстановитьНастройкиОбновления(ПараметрыОбновления);
	Обновлятор.Запустить();
	
КонецПроцедуры

Процедура ОбновлениеКонфигурации(КонтекстВыполнения, ПараметрыОбновления) Экспорт
	
	Обновлятор = Новый ОбновляторКонфигурации;
	ДобавитьСпособыВыводаВОбъект(Обновлятор);
	Обновлятор.УстановитьУправлениеКонфигуратором(РабочийКонфигуратор);
	Обновлятор.УстановитьНастройкиОбновления(ПараметрыОбновления);
	Обновлятор.Запустить();
	
КонецПроцедуры

Процедура ДобавитьСпособыВыводаВОбъект(Класс)
	
	Для каждого СпособВывода Из МассивСпособовВывода Цикл
		Класс.ДобавитьСпособВывода(СпособВывода);
	КонецЦикла;

КонецПроцедуры

Процедура СнятьБлокировкуСеансов(КонтекстВыполнения) Экспорт
	
	Если КонтекстВыполнения.Получить("ДоступКБазеЗаблокирован")Тогда
		Лог.Информация("Разблокировка доступа к информационной базе");
		
		
		УправлениемСеансами.РазблокироватьДоступ();		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриСозданииОбъекта()
	
	ЛокальныеВременныеФайлы = Новый МенеджерВременныхФайлов;
	ДоступКБазеЗаблокирован = Ложь;
	МассивСпособовВывода = Новый Массив();
	Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB.UpdateManager");
	
КонецПроцедуры
