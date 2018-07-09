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

#Использовать cli
#Использовать tempfiles
#Использовать "../core"
#Использовать "."

Перем Лог;

///////////////////////////////////////////////////////////////////////////////

Процедура ВыполнитьПриложение()

	Приложение = Новый КонсольноеПриложение(ПараметрыПриложения.ИмяПриложения(),
											"Приложение для пакетного обновления информационных баз 1С");
	Приложение.Версия("version", ПараметрыПриложения.Версия());

	Приложение.Опция("v verbose", Ложь, "вывод отладочной информация в процессе выполнении")
					.Флаговый()
					.ВОкружении("AUTOUPDATEIB_VERSOBE");

	Приложение.Опция("с config-file", "", "файл с настройкой приложения")
			   .ПоУмолчанию(ПараметрыПриложения.ПутьКФайлуКонфигурацииПриложения());

	Приложение.ДобавитьКоманду("update u", "Выполняет одиночное обновление информационной базы 1С",
								Новый КомандаUpdate);
	Приложение.ДобавитьКоманду("agent a", "Выполняет запуск в режиме агента обновления",
								Новый КомандаAgent);
	Приложение.ДобавитьКоманду("worker w", "Выполняет запуск рабочего процесса агента",
								Новый КомандаWorker);
	
	Приложение.Запустить(АргументыКоманднойСтроки);

КонецПроцедуры // ВыполнениеКоманды()

///////////////////////////////////////////////////////

Лог = ПараметрыПриложения.Лог();

Попытка

	ВыполнитьПриложение();

Исключение

	Лог.КритичнаяОшибка(ОписаниеОшибки());
	ВременныеФайлы.Удалить();

	ЗавершитьРаботу(1);

КонецПопытки;