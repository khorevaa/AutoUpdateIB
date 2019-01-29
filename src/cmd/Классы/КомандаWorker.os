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

Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("d worker-dir", "", "рабочий каталог процесса агента")
				.ПоУмолчанию(ПараметрыПриложения.КаталогДанныхПриложения()); 

	Команда.Аргумент("MESSAGE", "", "Файл сообщения на рабочий процесс агента");
	
	Команда.Аргумент("UID", Строка(Новый УникальныйИдентификатор), "идентификатор запущенного рабочего процесса агента")
				.Обязательный(Ложь);

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт
		
	РабочийКаталогПроцесса = Команда.ЗначениеОпции("worker-dir");
	СообщениеНаРабочийПроцесс = Команда.ЗначениеАргумента("MESSAGE");
	ИдентификаторРабочегоПроцесса = Команда.ЗначениеАргумента("UID");
	
	Агент = Новый РабочийПроцессАгента(ИдентификаторРабочегоПроцесса);
	Агент.РабочийКаталог(РабочийКаталогПроцесса);
	Агент.УстановитьКаталогКешаФайлов(ПараметрыПриложения.КаталогКешаДанныхПриложения());
	Агент.Запустить(СообщениеНаРабочийПроцесс);

КонецПроцедуры

