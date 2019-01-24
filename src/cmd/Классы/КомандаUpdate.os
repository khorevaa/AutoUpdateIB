#Использовать "../../core"
//    Copyright 2018 khorevaa
// 
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
Перем Лог;

Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("u db-user", "", "пользователь информационной базы")
				.ВОкружении("DB_USER IB_USER");
	
	Команда.Опция("p db-pwd", "", "пароль пользователя информационной базы")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("U uc-code", "", "ключ разрешения запуска")
				.ВОкружении("DB_UC_CODE IB_UC_CODE");

	Команда.Опция("v v8version", "", "версия платформы для запуска")
				.ВОкружении("V8VERSION");

	Команда.Опция("d work-dir", ТекущийКаталог(), "рабочий каталог")
				.ПоУмолчанию(ПараметрыПриложения.КаталогДанныхПриложения()); 

	Команда.Аргумент("FILE", "", "Путь к файлу с настройками обновления");
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ПутьКФайлуНастройки = Команда.ЗначениеАргумента("FILE");
	
	КлючРазрешенияЗапуска = Команда.ЗначениеОпции("uc-code");
	
	ПользовательИБ	= Команда.ЗначениеОпции("db-user");
	ПарольИБ	= Команда.ЗначениеОпции("db-pwd");
	ВерсияПлатформы = Команда.ЗначениеОпции("v8version");
	КаталогКешаФайлов = Команда.ЗначениеОпции("work-dir");
	
	ФайлЧтения = Новый Файл(ПутьКФайлуНастройки);
	Если Не ФайлЧтения.Существует() Тогда
		ВызватьИсключение "Не найден файл настройки обновления";
	КонецЕсли;

	НастройкиОбновления = ПрочитатьВСоответствие(ФайлЧтения.ПолноеИмя, ФайлЧтения.Расширение);

	Если ТипЗнч(НастройкиОбновления) = Тип("Массив") Тогда
		
		МассивНастроекОбновления = НастройкиОбновления
	
	Иначе
		МассивНастроекОбновления = Новый Массив;
		МассивНастроекОбновления.Добавить(НастройкиОбновления);

	КонецЕсли;

	ПользовательскимиПараметры = СформироватьПользовательскиеНастройки(ПользовательИБ, ПарольИБ, ВерсияПлатформы, КлючРазрешенияЗапуска);

	Для каждого НастройкаОбновления Из МассивНастроекОбновления Цикл
		
		ВыполнитьОбновлениеПоНастройке(НастройкаОбновления, КаталогКешаФайлов, ПользовательскимиПараметры);

	КонецЦикла;

	Лог.Информация("Работа по обновлению завершена");

КонецПроцедуры

Функция ПрочитатьФайл(Знач ПутьКФайлу)

	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу, "utf-8");
	ТекстФайла = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	Возврат ТекстФайла;

КонецФункции

Процедура ДополнитьПользовательскимиПараметрами(НастройкаОбновления, ПользовательскимиПараметры)
		
	ПараметрыПодключения = ПользовательскимиПараметры.ПараметрыПодключения;

	Для каждого ПараметрПодключения Из ПараметрыПодключения Цикл
		
		НастройкаОбновления.ПараметрыПодключения.Вставить(ПараметрПодключения.Ключ, ПараметрПодключения.Значение);

	КонецЦикла;

КонецПроцедуры

Функция СформироватьПользовательскиеНастройки(ПользовательИБ, ПарольИБ, ВерсияПлатформы, КлючРазрешенияЗапуска)
	
	ПользовательскиеПараметры = Новый Структура();
	ПараметрыПодключения = Новый Структура();

	Если Не ПустаяСтрока(ПользовательИБ) Тогда
		ПараметрыПодключения.Вставить("Пользователь", ПользовательИБ);
	КонецЕсли;
	Если Не ПустаяСтрока(ПарольИБ) Тогда
		ПараметрыПодключения.Вставить("Пароль", ПарольИБ);
	КонецЕсли;
	
	Если Не ПустаяСтрока(ВерсияПлатформы) Тогда
		ПараметрыПодключения.Вставить("ВерсияПлатформы", ВерсияПлатформы);
	КонецЕсли;

	Если Не ПустаяСтрока(ВерсияПлатформы) Тогда
		ПараметрыПодключения.Вставить("КлючРазрешенияЗапуска", КлючРазрешенияЗапуска);
	КонецЕсли;

	ПользовательскиеПараметры.Вставить("ПараметрыПодключения", ПараметрыПодключения);
	
	Возврат ПользовательскиеПараметры;

КонецФункции

Функция ПрочитатьВСоответствие(Знач ПутьКФайлу, Знач РасширениеФайла)
	
	Результат = НОвый Соответствие();

	Если НРег(РасширениеФайла) = ".yaml" Тогда
		
		ТекстФайла = ПрочитатьФайл(ПутьКФайлу);
		Процессор = Новый ПарсерYAML;
		Результат = Процессор.ПрочитатьYaml(ТекстФайла);
	ИначеЕсли НРег(РасширениеФайла) = ".json" Тогда

		ТекстФайла = ПрочитатьФайл(ПутьКФайлу);
		Парсер = Новый ПарсерJSON;
		Результат = Парсер.ПрочитатьJSON(ТекстФайла);
	Иначе
		ВызватьИсключение СтрШаблон("Неизвестный формат файла настроек обновления. Текущий формат <%1>", РасширениеФайла);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Процедура ВыполнитьОбновлениеПоНастройке(НастройкаОбновленияБазы, КаталогКешаФайлов, ПользовательскимиПараметры)
	
	НастройкиОбновления = Новый НастройкаОбновления();
	НастройкиОбновления.УстановитьКешФайлов(КаталогКешаФайлов);
	НастройкиОбновления.Заполнить(НастройкаОбновленияБазы);
	
	ДополнитьПользовательскимиПараметрами(НастройкиОбновления, ПользовательскимиПараметры);
		
	ПроцессорОбновления = Новый МенеджерОбновления();
	РезультатВыполнения = ПроцессорОбновления.ВыполнитьОбновление(НастройкиОбновления);

	Если РезультатВыполнения.Выполнено Тогда
		Лог.Информация("Обновление выполнено");
	Иначе
		Лог.КритичнаяОшибка("Обновление не выполнено по причине:
		|<%1>", РезультатВыполнения.ОписаниеОшибки );
	КонецЕсли;

КонецПроцедуры

Лог = ПараметрыПриложения.Лог();