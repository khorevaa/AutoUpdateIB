Перем ФорматДатыСобытия;
Перем КартаУровней;
Перем ПараметрыЗаписиJSON;

Функция ПолучитьФорматированноеСообщение(Знач СобытиеЛога) Экспорт
   
    // СобытиеЛога - Объект с методами
    //   * ПолучитьУровень() - Число - уровень лога
    //   * ПолучитьСообщение() - Строка - текст сообщения
    //   * ПолучитьИмяЛога() - Строка - имя лога
    //   * ПолучитьВремяСобытия() - Число - Универсальная дата-время события в миллисекундах
    //   * ПолучитьДополнительныеПоля() - Соответствие - дополнительные поля события
   
    Сообщение = СобытиеЛога.ПолучитьСообщение();
    УровеньСообщения = СобытиеЛога.ПолучитьУровень();
    ДатаСобытия = СобытиеЛога.ПолучитьВремяСобытия();
    ДопПоля = СобытиеЛога.ПолучитьДополнительныеПоля();
    ИмяЛога = СобытиеЛога.ПолучитьИмяЛога();

    ФорматированноеСообщение = СформироватьФорматированныеСообщение(ДатаСобытия, УровеньСообщения, 
                                                                    Сообщение,
                                                                    ДопПоля, ИмяЛога);

    Возврат ФорматированноеСообщение;
 
КонецФункции

Функция СформироватьФорматированныеСообщение(Знач ДатаСобытияВМилисекундах, Знач УровеньСообщения, Знач Сообщение, Знач ДопПоля, Знач ИмяЛога)
    
    ДатаВСекундах = ДатаСобытияВМилисекундах/1000;
    ДатаСобытия = Дата("00010101") + ДатаВСекундах;
    МилисекундыСобытия = Цел((ДатаВСекундах - Цел(ДатаВСекундах))*1000);
    
    ФорматированнаяДатаСобытия = ФорматироватьДатуСобытия(ДатаСобытия, МилисекундыСобытия);

    СтруктураЛога = Новый Соответствие();
    СтруктураЛога.Вставить("time", ФорматированнаяДатаСобытия);
    СтруктураЛога.Вставить("level", ФорматироватьУровеньСообщения(УровеньСообщения));
    СтруктураЛога.Вставить("msg", Сообщение);
    СтруктураЛога.Вставить("log", ИмяЛога);
    
    Для каждого ПолеЛога Из ДопПоля Цикл
        СтруктураЛога.Вставить(ПолеЛога.Ключ, ПолеЛога.Значение);	
    КонецЦикла;

    ЗаписьJSON = Новый ЗаписьJSON();
    ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);

    ЗаписатьJSON(ЗаписьJSON, СтруктураЛога);

    Возврат ЗаписьJSON.Закрыть();

КонецФункции

// Устанавливает произвольный формат вывода даты
//
// Параметры:
//   ФорматДаты - Строка - строковое представление формата для вывода даты
//
Процедура УстановитьФорматДатыСобытия(Знач ФорматДаты)
    ФорматДатыСобытия = СтрШаблон("ДФ='%1'", ФорматДаты);
КонецПроцедуры

Функция ФорматироватьДатуСобытия(Знач ДатаСобытия, Знач МилисекундыСобытия)
    Возврат СтрШаблон(Формат(ДатаСобытия, ФорматДатыСобытия), МилисекундыСобытия);
КонецФункции

Функция ФорматироватьУровеньСообщения(Знач УровеньСообщения)
    
    СтрокаУровня = КартаУровней[УровеньСообщения];

    Если СтрокаУровня = Неопределено Тогда
        СтрокаУровня = КартаУровней[0];
    КонецЕсли;

    Возврат СтрокаУровня;

КонецФункции

Функция КартаУровнейПоУмолчанию()
    
    КартаСтатусовИУровней = Новый Соответствие;
    КартаСтатусовИУровней.Вставить(УровниЛога.Отладка, 			"DEBUG");//  ОТЛАДКА
    КартаСтатусовИУровней.Вставить(УровниЛога.Информация, 		"INFO");//     ИНФО
    КартаСтатусовИУровней.Вставить(УровниЛога.Предупреждение,  	"WARN");// ВНИМАНИЕ 
    КартаСтатусовИУровней.Вставить(УровниЛога.Ошибка, 		   	"ERROR");//   ОШИБКА
    КартаСтатусовИУровней.Вставить(УровниЛога.КритичнаяОшибка, 	"FATAL");// КРИТИЧНА

    Возврат КартаСтатусовИУровней;

КонецФункции

Процедура ПриСозданииОбъекта()

    УстановитьФорматДатыСобытия("yyyy-MM-ddTHH:mm:ss.%1Z");
    КартаУровней = КартаУровнейПоУмолчанию();
    ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет);
КонецПроцедуры