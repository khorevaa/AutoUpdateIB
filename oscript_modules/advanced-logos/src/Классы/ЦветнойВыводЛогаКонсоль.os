#Использовать logos
//////////////////////////////////////////////////////////////////////////
//
// LOGOS: цветной вывод в консоль
//
//////////////////////////////////////////////////////////////////////////

Перем ЦветоваяСхема;
Перем КонсольВывода;
Перем ВывестиВЦвете;
Перем ФорматДатыСобытия;
Перем ЦветТекстаКонсоли;

Перем РаскладкаСообщения;

#Область Интерфейса_аппендера_логоса

// Выводит событие лога 
//
// Параметры:
//   СобытиеЛога - Объект - объект класса <СобытиеЛога>
//
Процедура ВывестиСобытие(Знач СобытиеЛога) Экспорт
	
	ФорматированнаяСообщение = РаскладкаСообщения.ПолучитьФорматированноеСообщение(СобытиеЛога);
		
	Если ВывестиВЦвете Тогда
	
		ЦветнойВывод(ФорматированнаяСообщение);

	Иначе
		
		Сообщить(ФорматированнаяСообщение);
	
	КонецЕсли;

КонецПроцедуры

// Устанавливает свойство аппендера, заданное в конфигурационном файле
//
Процедура УстановитьСвойство(Знач ИмяСвойства, Знач Значение) Экспорт
	
	Если НРег(ИмяСвойства) = "levelmap"  Тогда
		
		Если НРег(Значение) = "ru" Тогда
			УровниСообщенияНаРусском();
		КонецЕсли;

	ИначеЕсли НРег(ИмяСвойства) = "prefix" Тогда

		Если НРег(Значение) = "off" Тогда
			ОтключитьПрефиксы();
		КонецЕсли;
	ИначеЕсли НРег(ИмяСвойства) = "time" Тогда

		Если НРег(Значение) = "off" Тогда
			ОтключитьДатуСобытия();
		КонецЕсли;
	ИначеЕсли НРег(ИмяСвойства) = "color" Тогда

		Если НРег(Значение) = "off" Тогда
			ОтключитьЦвета();
		КонецЕсли;
							
	КонецЕсли;

КонецПроцедуры // УстановитьСвойство()

Процедура Закрыть() Экспорт
	КонсольВывода = Неопределено;
	ВыполнитьСборкуМусора();
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Отключение вывода сообщения события в цвете
//
Процедура ОтключитьЦвета() Экспорт
	ВывестиВЦвете = Ложь;
	РаскладкаСообщения.ОтключитьВыводМетокЦвета();
КонецПроцедуры

// Отключение вывода даты сообщения события
//
Процедура ОтключитьДатуСобытия() Экспорт
	РаскладкаСообщения.ОтключитьДатуСобытия();
КонецПроцедуры

// Отключение использования префиксов
//
Процедура ОтключитьПрефиксы() Экспорт
	РаскладкаСообщения.ОтключитьПрефиксы();
КонецПроцедуры

// Устанавливает карту уровней сообщений на русском языке
//
// УровниЛога.Отладка    		= "   ОТЛАДКА"
// УровниЛога.Информация 		= "ИНФОРМАЦИЯ"
// УровниЛога.Предупреждение 	= "  ВНИМАНИЕ"
// УровниЛога.Ошибка			- "    ОШИБКА"
// УровниЛога.КритичнаяОшибка 	= " КРИТИЧНАЯ"
//
Процедура УровниСообщенияНаРусском() Экспорт
	РаскладкаСообщения.УровниСообщенияНаРусском();
КонецПроцедуры

// Устанавливает карту уровней сообщений по умолчанию 
//
// УровниЛога.Отладка    		= "DEBUG"
// УровниЛога.Информация 		= " INFO"
// УровниЛога.Предупреждение 	= " WARN"
// УровниЛога.Ошибка			- "ERROR"
// УровниЛога.КритичнаяОшибка 	= "FATAL"
//
Процедура УровниСообщенияПоУмолчанию() Экспорт
	РаскладкаСообщения.УровниСообщенияПоУмолчанию();
КонецПроцедуры

// Устанавливает новую схему раскраски консоли
//
// Параметры:
//   НоваяЦветоваяСхема - Соответствие - можно задавать несколько ключей, все заполнять не обязательно
// 	                                     состоит из:
//                                       * УровниЛога (из перечисления УровниЛога)
//                                       * Префикс
//                                       * ДатаСобытия
//
Процедура УстановитьЦветовуюСхему(Знач НоваяЦветоваяСхема) Экспорт
	
	Для каждого КлючЗначение Из НоваяЦветоваяСхема Цикл
		ЦветоваяСхема.Вставить(Строка(КлючЗначение.Ключ), КлючЗначение.Значение);
	КонецЦикла;

КонецПроцедуры

// Устанавливает произвольную карту уровней сообщений
//
// Параметры:
//   НоваяКартаУровней - Соответствие - карта соответствия уровней лога их названиям
//
Процедура УстановитьКартуУровней(Знач НоваяКартаУровней) Экспорт
	
	РаскладкаСообщения.УстановитьКартуУровней(НоваяКартаУровней);

КонецПроцедуры

// Устанавливает произвольный формат вывода даты
//
// Параметры:
//   ФорматДаты - Строка - строковое представление формата для вывода даты
//
Процедура УстановитьФорматДатыСобытия(Знач ФорматДаты) Экспорт
	РаскладкаСообщения.УстановитьФорматДатыСобытия(ФорматДаты);
КонецПроцедуры

#КонецОбласти

#Область Вывод_сообщения

Процедура ЦветнойВывод(Знач ФорматированнаяСообщение)
	
	ЦветТекстаКонсоли = КонсольВывода.ЦветТекста;

	МассивСтрок = СтрРазделить(ФорматированнаяСообщение, "|", Истина);

	Для каждого ЭлементыВывода Из МассивСтрок Цикл
		
		Если СтрНачинаетсяС(ЭлементыВывода, "C=") Тогда
			КодЦвета = Сред(ЭлементыВывода, 3, 1);
			ЦветЭлемента =  ПолучитьЦветЭлемента(КодЦвета);
			УстановитьЦветТекста(ЦветЭлемента);
		
		Иначе
			КонсольВывода.Вывести(ЭлементыВывода);
			УстановитьЦветТекстаПоУмолчанию();
	
		КонецЕсли;

	КонецЦикла;

	УстановитьЦветТекстаПоУмолчанию();
	КонсольВывода.Вывести(Символы.ПС);

КонецПроцедуры

#КонецОбласти

Функция ПолучитьЦветЭлемента(Знач КодЦвета)
	
	ЦветЭлемента = ЦветТекстаКонсоли;
	
	Если ВРЕГ(КодЦвета) = "D" Тогда
		ЦветЭлемента = ЦветоваяСхема["ДатаСобытия"];
	ИначеЕсли ВРЕГ(КодЦвета) = "T" Тогда
		ЦветЭлемента = ЦветТекстаКонсоли;
	ИначеЕсли ВРЕГ(КодЦвета) = "P" Тогда
		ЦветЭлемента = ЦветоваяСхема["Префикс"];;
	Иначе
		
		ЦветЭлемента = ЦветоваяСхема[КодЦвета];

		Если ЦветЭлемента = Неопределено Тогда
			ЦветЭлемента = ЦветТекстаКонсоли;
		КонецЕсли;

	КонецЕсли;

	Возврат ЦветЭлемента;
				
КонецФункции

#Область Цветной_вывод_в_консоль

Процедура УстановитьЦветТекста(Знач ЦветТекста)
	
	КонсольВывода.ЦветТекста = ЦветТекста;
	
КонецПроцедуры

Процедура УстановитьЦветТекстаПоУмолчанию()
	
	КонсольВывода.ЦветТекста = ЦветТекстаКонсоли;
	
КонецПроцедуры

#КонецОбласти

#Область Вспомогательные_процедуры_и_функции

Функция ЦветоваяСхемаПоУмолчанию()
	
	КартаСхемы = Новый Соответствие();
	КартаСхемы.Вставить(Строка(УровниЛога.Отладка), 		ЦветКонсоли.Синий);
	КартаСхемы.Вставить(Строка(УровниЛога.Информация), 		ЦветКонсоли.Зеленый);
	КартаСхемы.Вставить(Строка(УровниЛога.Предупреждение), 	ЦветКонсоли.Желтый);
	КартаСхемы.Вставить(Строка(УровниЛога.Ошибка), 			ЦветКонсоли.Красный);
	КартаСхемы.Вставить(Строка(УровниЛога.КритичнаяОшибка), ЦветКонсоли.Красный);
	КартаСхемы.Вставить("ДатаСобытия", 				ЦветКонсоли.Малиновый);
	КартаСхемы.Вставить("Префикс", 					ЦветКонсоли.Бирюза);

	Возврат КартаСхемы;

КонецФункции

#КонецОбласти

Процедура ПриСозданииОбъекта(Знач ПВыводитьВЦвете = Истина, 
							Знач ПИспользоватьПрефиксы = Истина, 
							Знач ПВыводитьДату = Истина)
	
	КонсольВывода = Новый Консоль();
	
	ЦветоваяСхема = ЦветоваяСхемаПоУмолчанию();

	РаскладкаСообщения = Новый УлучшенныйФорматЛога(ПВыводитьВЦвете);
	ПИспользоватьПрефиксы = Истина;
	Если НЕ ПИспользоватьПрефиксы Тогда
		ОтключитьПрефиксы();
	КонецЕсли;

	ВывестиВЦвете = Истина;
	ПВыводитьДату = Истина;
	Если НЕ ПВыводитьДату Тогда
		ОтключитьДатуСобытия();
	КонецЕсли;

	УстановитьФорматДатыСобытия("[yyyy/MM/dd HH:mm:ss.%1]");
	
КонецПроцедуры

