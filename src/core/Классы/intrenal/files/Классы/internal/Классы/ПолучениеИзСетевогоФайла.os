#Использовать fs
#Использовать logos
#Использовать tempfiles

Перем ПутьКФайлу;
Перем ХешФайла;
Перем ХешСуммаСтрокой;

Перем Лог;

Функция ХешФайла() Экспорт
	
	Если ЗначениеЗаполнено(ХешСуммаСтрокой) Тогда
		Возврат ХешСуммаСтрокой;
	КонецЕсли;

	ХешСуммаСтрокой = ХешФайла.ХешСуммаСтрокой();

	Возврат ХешСуммаСтрокой;

КонецФункции

Функция Используется() Экспорт
	Возврат ЗначениеЗаполнено(ПутьКФайлу);
КонецФункции

Процедура Параметры(ВходящиеПараметры) Экспорт
	
	ПутьКФайлу = ВходящиеПараметры["ПутьКФайлу"];

	ХешФайла = Новый ПараметрыХешаФайла();
	ХешФайла.Настроить(ВходящиеПараметры["ХешФайла"]);

КонецПроцедуры

Процедура СверитьХешФайла(ПутьКФайлуСверки)
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.ДобавитьФайл(ПутьКФайлуСверки);
	ТекущийХеш = НРег(ХешированиеДанных.ХешСуммаСтрокой);
	ХешированиеДанных.Очистить();
	ХешированиеДанных = Неопределено;
	Если НЕ ТекущийХеш = ХешФайла() Тогда
		ТекстСообщения = СтрШаблон(
			"Не совпадают хеши файлов:
			|Контрольная сумма ожидаемая: %1
			|Контрольная сумма файла: %2",
			ХешФайла(),
			ТекущийХеш
		);
		ИнфИсключение = Новый ИнформацияОбОшибке(ТекстСообщения, ХешФайла());
		ВызватьИсключение ИнфИсключение;
	КонецЕсли;

КонецПроцедуры

Процедура Получить(Знач Каталог) Экспорт
	
	ФайлПолучения = Новый Файл(ПутьКФайлу);
	
	Если ФайлПолучения.ЭтоКаталог() Тогда
		ТекстСообщения = СтрШаблон(
			"Передан каталог вместо файла: %1",
			ФайлПолучения.ПолноеИмя
		);
		ИнфИсключение = Новый ИнформацияОбОшибке(ТекстСообщения, ХешФайла());
		ВызватьИсключение ИнфИсключение;
	
	КонецЕсли;

	ПолучитьФайлВКаталог(Каталог, ФайлПолучения);

КонецПроцедуры

Процедура ПолучитьФайлВКаталог(Знач Каталог, ФайлПолучения)


	ВременныйФайл = ВременныеФайлы.НовоеИмяФайла();
	НадоСверитьДанные = Ложь;
	КопироватьФайл(ФайлПолучения.ПолноеИмя, ВременныйФайл);

	Если Не ЗначениеЗаполнено(ХешФайла()) Тогда
		НадоСверитьДанные = Истина;
		ХешСуммаСтрокой = РассчитатьХешФайла(ВременныйФайл);
	КонецЕсли;

	ФайлПриемник = ФС.ПолныйПуть(ОбъединитьПути(Каталог, ХешФайла()) + ФайлПолучения.Расширение);

	Лог.Отладка("Получаю файл <%1> в временный файл <%2>" ,ФайлПолучения.ПолноеИмя, ВременныйФайл);

	Если НадоСверитьДанные 
		И ФС.ФайлСуществует(ФайлПриемник) Тогда
		ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
		ХешированиеДанных.ДобавитьФайл(ФайлПриемник);
		ТекущийХеш = НРег(ХешированиеДанных.ХешСуммаСтрокой);
		Если ТекущийХеш = ХешФайла() Тогда
			Лог.Отладка("Данный файл <%1> в уже существует кеше", ВременныйФайл);
			Возврат;
		КонецЕсли;
		ХешированиеДанных.Очистить();
		ХешированиеДанных = Неопределено;
	Иначе
		СверитьХешФайла(ВременныйФайл);
	КонецЕсли;

	Лог.Отладка("Перемещаю файл <%1> в кеш файла <%2>", ВременныйФайл, ФайлПриемник);
	ПереместитьФайл(ВременныйФайл, ФайлПриемник);

КонецПроцедуры

Функция РассчитатьХешФайла(Знач ПутьКФайлуРасчета)
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.ДобавитьФайл(ПутьКФайлуРасчета);
	ТекущийХеш = НРег(ХешированиеДанных.ХешСуммаСтрокой);
	ХешированиеДанных.Очистить();
	Возврат ТекущийХеш;
КонецФункции

Процедура ОписаниеПараметров(Знач Конструктор) Экспорт
	
	Конструктор
		.ПолеСтрока("ПутьКФайлу ПутьККаталогу path", "")
		.ПолеОбъект("ХешФайла hash", Новый ПараметрыХешаФайла)
		;

КонецПроцедуры

Процедура ПриСозданииОбъекта()
	ПутьКФайлу = "";

	Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB.file-copy");
	Лог.УстановитьУровень(УровниЛога.Отладка);

КонецПроцедуры