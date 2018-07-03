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
	
	Команда.Опция("rmq-user ru", "", "пользователь сервера RabbitMQ")
				.ВОкружении("RMQ_USER");

	Команда.Опция("rmq-pwd rp", "", "пароль пользователя сервера RabbitMQ")
				.ВОкружении("RMQ_PWD RMQ_PASSWORD");

	Команда.Опция("rmq-queue rq", "", "имя очереди получения на сервере RabbitMQ")
				.ВОкружении("RMQ_QUEUE");

	Команда.Опция("rmq-exchange-name re", "", "имя точки ответа сервера RabbitMQ")
				.ВОкружении("RMQ_EXCHANGE_NAME");

	Команда.Опция("rmq-routing-key rr", "", "ключ маршрутизации сервера RabbitMQ")
				.ВОкружении("RMQ_ROUTING_KEY");
	
	Команда.Опция("rmq-virtual-host rmq-vhost rv", "/", "виртуальный хост на сервере RabbitMQ")
				.ВОкружении("RMQ_VHOST");

	Команда.Опция("l agent-log-file", "", "путь к файлу лога агента");
	Команда.Опция("t agent-timer", 3600, "таймер опроса сервера очереди");
	
	Команда.Опция("S swarm", Ложь, "режим многопоточности (роя агентов)");
	Команда.Опция("C swarm-agent-count", 0, "количество процессов (0 - автоматический расчет)");
	Команда.Опция("swarm-agent-timeuot", 0, "таймаут перезапуска процесса агента при зависании");

	Команда.Опция("P provider", "json", "провайдер очереди обновления").ТПеречисление()
				.Перечисление("json", "json", "файл json для чтения и получения очереди")
				.Перечисление("rmq", "rmq" , "сервер RabbitMQ");
			
	Команда.Аргумент("PATH", "", "Путь к провайдеру очереди")
				.ВОкружении("AGENT_PATH");

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	

КонецПроцедуры