#Использовать logos

Перем Лог;

Перем ДвоичныеДанныеФайла;
Перем ХешФайла;
Перем ХешСуммаСтрокой;
Перем РасширениеФайла;

Функция ХешФайла() Экспорт
	
	Если ЗначениеЗаполнено(ХешСуммаСтрокой) Тогда
		Возврат ХешСуммаСтрокой;
	КонецЕсли;

	ХешСуммаСтрокой = ХешФайла.ХешСуммаСтрокой();

	Если НЕ ЗначениеЗаполнено(ХешСуммаСтрокой) Тогда
		РассчитатьХешФайла();
	КонецЕсли;

	Возврат ХешСуммаСтрокой;

КонецФункции

Функция Используется() Экспорт
	Возврат ЗначениеЗаполнено(ДвоичныеДанныеФайла) 
			И ЗначениеЗаполнено(РасширениеФайла);
КонецФункции

Процедура Параметры(ВходящиеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ВходящиеПараметры["ДвоичныеДанные"]) Тогда
		ДвоичныеДанныеФайла = Base64Значение(ВходящиеПараметры["ДвоичныеДанные"]);
	КонецЕсли;
	
	РасширениеФайла = ВходящиеПараметры["РасширениеФайла"];
	ИсправитьРасширение();
	ХешФайла = Новый ПараметрыХешаФайла();
	ХешФайла.Настроить(ВходящиеПараметры["ХешДанных"]);
	
КонецПроцедуры

Процедура ИсправитьРасширение()
	
	Если СтрНачинаетсяС(РасширениеФайла, ".") Тогда
		Возврат;
	КонецЕсли;

	РасширениеФайла = "." + РасширениеФайла;

КонецПроцедуры

Процедура РассчитатьХешФайла()

	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.Добавить(ДвоичныеДанныеФайла);
	ХешСуммаСтрокой = НРег(ХешированиеДанных.ХешСуммаСтрокой);
	ХешированиеДанных.Очистить();
	
КонецПроцедуры

Процедура Получить(Знач Каталог) Экспорт
	
	ПутьКФайлуПриемнику = ОбъединитьПути(Каталог, ХешФайла()) + РасширениеФайла;
	ФайлПриемник = Новый Файл(ПутьКФайлуПриемнику);
	ПолныйПутьКФайлуПриемнику = ФайлПриемник.ПолноеИмя;
	Лог.Отладка("Сохранение бинарных данных в файл <%1>", ПолныйПутьКФайлуПриемнику);
	ДвоичныеДанныеФайла.Записать(ПолныйПутьКФайлуПриемнику);

КонецПроцедуры

Процедура ОписаниеПараметров(Знач Конструктор) Экспорт
	
	Конструктор
		.ПолеСтрока("ДвоичныеДанные data", "")
		.ПолеСтрока("РасширениеФайла ext", "")
		.ПолеОбъект("ХешДанных hash", Новый ПараметрыХешаФайла)
		;

КонецПроцедуры

Процедура ПриСозданииОбъекта()

	Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB.bindata");
	Лог.УстановитьУровень(УровниЛога.Отладка);

КонецПроцедуры