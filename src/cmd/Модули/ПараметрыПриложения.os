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
#Использовать fs
#Использовать logos

Перем КаталогЛокальныхДанныхПриложения;

Функция ИмяПриложения() Экспорт
	Возврат "AutoUpdateIB";
КонецФункции

Функция ИмяЛога() Экспорт
	Возврат "oscript.app.AutoUpdateIB";
КонецФункции

Функция Версия() Экспорт
	Возврат "0.0.1";
КонецФункции

Функция КаталогДанныхПриложения() Экспорт
	Возврат ПолучитьЛокальныйКаталогДанныхПриложения();
КонецФункции

Функция Лог() Экспорт
	Возврат Логирование.ПолучитьЛог(ИмяЛога());
КонецФункции

Функция ПутьКФайлуКонфигурацииПриложения() Экспорт
	Возврат ОбъединитьПути(ПолучитьЛокальныйКаталогДанныхПриложения(), ".config.json");
КонецФункции

Функция ПолучитьЛокальныйКаталогДанныхПриложения()

	Если ЗначениеЗаполнено(КаталогЛокальныхДанныхПриложения) Тогда
		Возврат КаталогЛокальныхДанныхПриложения;
	КонецЕсли;

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ОбщийКаталогДанныхПриложений = СистемнаяИнформация.ПолучитьПутьПапки(СпециальнаяПапка.ЛокальныйКаталогДанныхПриложений);

	КаталогЛокальныхДанныхПриложения = ОбъединитьПути(ОбщийКаталогДанныхПриложений, ИмяПриложения());

	ФС.ОбеспечитьКаталог(КаталогЛокальныхДанныхПриложения);

	Возврат КаталогЛокальныхДанныхПриложения;

КонецФункции
