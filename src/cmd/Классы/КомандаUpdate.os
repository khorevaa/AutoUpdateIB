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
	
	Команда.Опция("u db-user", "Администратор", "пользователь информационной базы")
				.ВОкружении("DB_USER");
	
	Команда.Опция("p db-pwd", "", "пароль пользователя информационной базы")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("U uc-code", "", "ключ разрешения запуска")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("v v8version", "8.3", "версия платформы для запуска")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("L load-cf", Ложь, "загрузка конфигурации вместо обновления")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("D update-dynamic", Ложь, "использовать динамическое обновление")
				.ВОкружении("DB_PASSWORD IB_PWD");
	
	Команда.Опция("W update-warnings-as-errors update-wae", Ложь, "при обновлении предупреждения как ошибки")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("S update-server", Истина, "использовать обновление на сервере")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("E update-extension", "", "обновление расширения")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("B block-db", Ложь, "заблокировать информационную базу перед обновлением")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("cluster-user", Ложь, "пользователь для подключения к кластеру сервера 1С")
				.ВОкружении("DB_PASSWORD IB_PWD");
	
	Команда.Опция("cluster-pwd", Ложь, "пароль пользователя для подключения к кластеру сервера 1С")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Опция("cluster-port", 1545, "порт для подключения кластеру сервера 1С")
				.ВОкружении("DB_PASSWORD IB_PWD");

	Команда.Аргумент("DBCONNECTION", "", "Строка подключения к информационной базе")
				.ТСтрока()
				.ВОкружении("DB_CONNECTION");

	Команда.Аргумент("PATh", "", "Путь к файлу или каталогу обновления")
				.ВОкружении("")
				.ПоУмолчанию(ТекущийКаталог());

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт


КонецПроцедуры