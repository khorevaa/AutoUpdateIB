Перем ТекущийЭлемент Экспорт; // Соответствие из очереди
Перем ПровайдерОчереди;

Функция Следующий() Экспорт

	ТекущийЭлемент = ПровайдерОчереди.ПолучитьИзОчереди();

	Возврат НЕ ТекущийЭлемент = Неопределено;

КонецФункции

Процедура УстановитьПровайдер(НовыйПровайдерОчереди) Экспорт

	ПровайдерОчереди = НовыйПровайдерОчереди;

КонецПроцедуры