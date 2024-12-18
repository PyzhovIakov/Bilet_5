Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ДополнительныеНачисления.Записывать = Истина;
	Для Каждого ТекСтрокаДополнительныеНачисления Из ДополнительныеНачисления Цикл
		Движение = Движения.ДополнительныеНачисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ТекСтрокаДополнительныеНачисления.ВидРасчета;
		Движение.ПериодРегистрации = Дата;
		Движение.Сотрудник = ТекСтрокаДополнительныеНачисления.Сотрудник;
		Движение.Подразделение = ТекСтрокаДополнительныеНачисления.Подразделение;
		Движение.Процент = ТекСтрокаДополнительныеНачисления.Процент;
	КонецЦикла;

	// регистр ОсновныеНачисления
	Движения.ОсновныеНачисления.Записывать = Истина;
	Для Каждого ТекСтрокаОсновныеНачисления Из ОсновныеНачисления Цикл
		Движение = Движения.ОсновныеНачисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ТекСтрокаОсновныеНачисления.ВидРасчета;
		Движение.ПериодРегистрации = Дата;
		Движение.ПериодДействияНачало = ТекСтрокаОсновныеНачисления.ДатаНачала;
		Движение.ПериодДействияКонец = ТекСтрокаОсновныеНачисления.ДатаОкончания;
		Движение.Сотрудник = ТекСтрокаОсновныеНачисления.Сотрудник;
		Движение.Подразделение = ТекСтрокаОсновныеНачисления.Подразделение;
		Движение.Размер = ТекСтрокаОсновныеНачисления.Размер;
	КонецЦикла;
	Движения.Записать();

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОсновныеНачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки,
	|	ОсновныеНачисленияДанныеГрафика.Подразделение КАК Подразделение,
	|	ОсновныеНачисленияДанныеГрафика.ЗначениеЧасовПериодДействия КАК Норма,
	|	ОсновныеНачисленияДанныеГрафика.ЗначениеЧасовФактическийПериодДействия КАК Отработано
	|ПОМЕСТИТЬ ВремТ
	|ИЗ
	|	РегистрРасчета.ОсновныеНачисления.ДанныеГрафика(ВидРасчета = &Оклад
	|	И Регистратор = &Ссылка) КАК ОсновныеНачисленияДанныеГрафика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СведенияОСотрудникахСрезПоследних.Подразделение КАК Подразделение,
	|	СведенияОСотрудникахСрезПоследних.ВерхняяГраница КАК ВерхняяГраница,
	|	СведенияОСотрудникахСрезПоследних.Оклад КАК Оклад
	|ПОМЕСТИТЬ ВремТ2
	|ИЗ
	|	РегистрСведений.СведенияОСотрудниках.СрезПоследних(&Дата, Подразделение В
	|		(ВЫБРАТЬ
	|			ВремТ.Подразделение КАК Подразделение
	|		ИЗ
	|			ВремТ КАК ВремТ)) КАК СведенияОСотрудникахСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВремТ2.Подразделение КАК Подразделение,
	|	ВремТ2.ВерхняяГраница КАК ВерхняяГраница,
	|	ЕСТЬNULL(ВремТ21.ВерхняяГраница, 0) КАК НижняяГраница,
	|	МАКСИМУМ(ВремТ2.Оклад) КАК Оклад
	|ПОМЕСТИТЬ ВремТ3
	|ИЗ
	|	ВремТ2 КАК ВремТ2
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВремТ2 КАК ВремТ21
	|		ПО ВремТ2.Подразделение = ВремТ21.Подразделение
	|		И ВремТ2.ВерхняяГраница > ВремТ21.ВерхняяГраница
	|СГРУППИРОВАТЬ ПО
	|	ВремТ2.Подразделение,
	|	ВремТ2.ВерхняяГраница,
	|	ЕСТЬNULL(ВремТ21.ВерхняяГраница, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВремТ.НомерСтроки КАК НомерСтроки,
	|	ЕСТЬNULL(ВремТ.Норма, 0) КАК Норма,
	|	ЕСТЬNULL(ВремТ.Отработано, 0) КАК Отработано,
	|	ЕСТЬNULL(МАКСИМУМ(ВремТ3.Оклад), 0) КАК Оклад
	|ИЗ
	|	ВремТ КАК ВремТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВремТ3 КАК ВремТ3
	|		ПО ВремТ.Подразделение = ВремТ3.Подразделение
	|		И ВремТ.Отработано МЕЖДУ ВремТ3.НижняяГраница И ВремТ3.ВерхняяГраница
	|СГРУППИРОВАТЬ ПО
	|	ВремТ.НомерСтроки,
	|	ВремТ.Норма,
	|	ВремТ.Отработано,
	|	ЕСТЬNULL(ВремТ.Норма, 0),
	|	ЕСТЬNULL(ВремТ.Отработано, 0)";

	Запрос.УстановитьПараметр("Оклад", ПланыВидовРасчета.ОсновныеНачисления.Оклад);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка= РезультатЗапроса.Выбрать();
	
	Для Каждого СтрокаДвижения из Движения.ОсновныеНачисления Цикл
		Если СтрокаДвижения.ВидРасчета <> 	ПланыВидовРасчета.ОсновныеНачисления.Оклад тогда
			продолжить;
		КонецЕсли;
		Выборка.Сбросить();
		Выборка.НайтиСледующий(СтрокаДвижения.НомерСтроки,"НомерСтроки");
		СтрокаДвижения.Результат = Выборка.Оклад/ Выборка.Норма* Выборка.Отработано;	
		СтрокаДвижения.Размер = Выборка.Оклад;
	КонецЦикла;
	Движения.ОсновныеНачисления.Записать();
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОсновныеНачисленияДанныеГрафика.НомерСтроки,
		|	ОсновныеНачисленияДанныеГрафика.Значение15МинФактическийПериодДействия
		|ИЗ
		|	РегистрРасчета.ОсновныеНачисления.ДанныеГрафика(Регистратор = &Ссылка
		|	И ВидРасчета = &Штраф) КАК ОсновныеНачисленияДанныеГрафика";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Штраф", ПланыВидовРасчета.ОсновныеНачисления.Штраф);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка= РезультатЗапроса.Выбрать();
	
	Для Каждого СтрокаДвижения из Движения.ОсновныеНачисления Цикл
		Если СтрокаДвижения.ВидРасчета <> 	ПланыВидовРасчета.ОсновныеНачисления.Штраф тогда
			продолжить;
		КонецЕсли;
		Выборка.Сбросить();
		Выборка.НайтиСледующий(СтрокаДвижения.НомерСтроки,"НомерСтроки");
		СтрокаДвижения.Результат = Выборка.Значение15МинФактическийПериодДействия*СтрокаДвижения.Размер;	
	КонецЦикла;
	Движения.ОсновныеНачисления.Записать();
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДополнительныеНачисления.Подразделение,
		|	ДополнительныеНачисления.НомерСтроки
		|ПОМЕСТИТЬ ВремТ
		|ИЗ
		|	РегистрРасчета.ДополнительныеНачисления КАК ДополнительныеНачисления
		|ГДЕ
		|	ДополнительныеНачисления.Регистратор = &Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(УправленческийОборотыДтКт.СумамаОборотДт) КАК СумамаОборотДт,
		|	УправленческийОборотыДтКт.СубконтоКт3
		|ПОМЕСТИТЬ ВремТ1
		|ИЗ
		|	РегистрБухгалтерии.Управленческий.ОборотыДтКт(&НМ, &КМ,, СчетДт = &Покупатели,, СчетКт = &ПрибылиУбытки, &СубконтоУ,
		|		СубконтоКт3 В
		|		(ВЫБРАТЬ
		|			ВремТ.Подразделение
		|		ИЗ
		|			ВремТ КАК ВремТ)) КАК УправленческийОборотыДтКт
		|СГРУППИРОВАТЬ ПО
		|	УправленческийОборотыДтКт.СубконтоКт3
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВремТ.НомерСтроки,
		|	ЕстьNull(ВремТ1.СумамаОборотДт,0) как СумамаОборотДт
		|ИЗ
		|	ВремТ КАК ВремТ
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВремТ1 КАК ВремТ1
		|		ПО ВремТ.Подразделение = ВремТ1.СубконтоКт3";
	СубконтоУ = новый Массив;
	СубконтоУ.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	СубконтоУ.Добавить(ПланыВидовХарактеристик.ВидыСубконто.ИнвНомер);
	СубконтоУ.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Подразделение);
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("СубконтоУ", СубконтоУ);
	Запрос.УстановитьПараметр("КМ", КонецМесяца(ДобавитьМесяц(Дата,-1)));
	Запрос.УстановитьПараметр("ПрибылиУбытки", ПланыСчетов.Управленческий.ПрибылиУбытки);
	Запрос.УстановитьПараметр("Покупатели", ПланыСчетов.Управленческий.Покупатели);
	Запрос.УстановитьПараметр("НМ", НачалоМесяца(ДобавитьМесяц(Дата,-1)));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка= РезультатЗапроса.Выбрать();
	
	Для Каждого СтрокаДвижения из Движения.ДополнительныеНачисления Цикл	
		Выборка.Сбросить();
		Выборка.НайтиСледующий(СтрокаДвижения.НомерСтроки,"НомерСтроки");
		СтрокаДвижения.Результат = ?(Выборка.СумамаОборотДт=0,0,Выборка.СумамаОборотДт*СтрокаДвижения.Процент/100);	
	КонецЦикла;
	Движения.ДополнительныеНачисления.Записать();
	
КонецПроцедуры