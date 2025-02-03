// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_stream/feature/calendar/widget/horizontal_split_view_widget.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomCalendarPageV2();
  }
}

class ScrollableCalendarPage extends StatefulWidget {
  const ScrollableCalendarPage({super.key});

  @override
  _ScrollableCalendarPageState createState() => _ScrollableCalendarPageState();
}

class _ScrollableCalendarPageState extends State<ScrollableCalendarPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  List<DateTime> _months = [];
  final ScrollController _scrollController = ScrollController();

  final List<CalendarEvent> _events = []; // Список событий

  @override
  void initState() {
    super.initState();
    _initializeMonths();
    _initializeEvents(); // Инициализация событий
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeMonths() {
    final now = DateTime.now();
    _months = List.generate(
      (3 + 2 + 1) * 12, // 5 лет, включая текущий год
      (index) => DateTime(now.year - 2, now.month + index, 1),
    );
  }

  void _initializeEvents() {
    // Пример добавления событий
    _events.addAll([
      CalendarEvent(
          id: 1,
          name: "Событие 1",
          startDate: DateTime.now(),
          color: "#FF0000", // Красный
          description: "Описание события 1",
          type: CalendarEventType.event),
      CalendarEvent(
          id: 2,
          name: "Курс 1",
          startDate: DateTime.now().add(const Duration(days: 2)),
          color: "#0000FF", // Синий
          description: "Описание курса 1",
          type: CalendarEventType.courses),
    ]);
  }

  List<CalendarEvent> _getEventsForDate(DateTime date) {
    return _events.where((event) {
      return event.startDate.year == date.year &&
          event.startDate.month == date.month &&
          event.startDate.day == date.day;
    }).toList();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadNextMonth();
    } else if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 4) {
      _loadPreviousMonth();
    }
  }

  void _loadNextMonth() {
    setState(() {
      final lastMonth = _months.last;
      _months.add(DateTime(lastMonth.year, lastMonth.month + 1, 1));
    });
  }

  void _loadPreviousMonth() {
    setState(() {
      final firstMonth = _months.first;
      _months.insert(0, DateTime(firstMonth.year, firstMonth.month - 1, 1));
    });
  }

  List<DateTime?> _generateDaysInMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    // Определяем, с какого дня недели начинается месяц
    final startDayOffset = firstDayOfMonth.weekday - 1; // 0 = Понедельник

    // Заполняем пустыми ячейками дни до начала месяца
    final daysBeforeMonth = List<DateTime?>.filled(startDayOffset, null);

    // Генерируем дни месяца
    final daysInMonth = List.generate(
      lastDayOfMonth.day,
      (index) => DateTime(date.year, date.month, index + 1),
    );

    // Объединяем пустые дни и дни месяца
    return [...daysBeforeMonth, ...daysInMonth];
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return Scaffold(
      appBar: AppBar(title: const Text("Календарь")),
      body: HorizontalSplitView(
        top: ListView.builder(
          controller: _scrollController,
          itemCount: _months.length,
          itemBuilder: (context, index) {
            final currentMonth = _months[index];
            final daysInMonth = _generateDaysInMonth(currentMonth);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat.yMMMM().format(currentMonth),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Добавляем дни недели
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: daysOfWeek.map((day) {
                      return Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: daysInMonth.length,
                  itemBuilder: (context, index) {
                    final day = daysInMonth[index];

                    if (day == null) {
                      // Пустая ячейка для дней до начала месяца
                      return const SizedBox.shrink();
                    }

                    final isSelected = _selectedDate == day;
                    final eventsForDay = _events.where((event) {
                      return event.startDate.year == day.year &&
                          event.startDate.month == day.month &&
                          event.startDate.day == day.day;
                    }).toList();

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = day;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            if (eventsForDay.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: eventsForDay.map((event) {
                                  final color =
                                      event.type == CalendarEventType.event
                                          ? Colors.red
                                          : Colors.blue;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        bottom: WeekWidget(
          events: const [],
          selectedDay: _selectedDate,
          focusedDay: _focusedDate,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
              _focusedDate = focusedDay;
            });
          },
        ),
        ratio: 0.7,
      ),
    );
  }
}

class ScrollableCalendarPageOld extends StatefulWidget {
  const ScrollableCalendarPageOld({super.key});

  @override
  _ScrollableCalendarPageOldState createState() =>
      _ScrollableCalendarPageOldState();
}

class _ScrollableCalendarPageOldState extends State<ScrollableCalendarPageOld> {
  bool _isExpanded = true;
  DateTime _selectedDate = DateTime.now();
  final DateTime _focusedDate = DateTime.now();
  List<DateTime> _months = []; // Хранит список начальных дат каждого месяца
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerForHorizontal = ScrollController();

  @override
  void initState() {
    super.initState();
    // Добавляем начальный диапазон месяцев
    _initializeMonths();
    // Слушатель для обработки скролла
    _scrollController.addListener(_onScroll);
    // Горизонтальный скролл слушатель
    _scrollControllerForHorizontal.addListener(_onHorizontalScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Инициализация первых 12 месяцев
  void _initializeMonths() {
    final now = DateTime.now();
    _months = List.generate(
      12,
      (index) => DateTime(now.year, now.month + index, 1),
    );
  }

  // Обработка скролла
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadNextMonth();
    } else if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 4) {
      _loadPreviousMonth();
    }
  }

  void _onHorizontalScroll() {
    if (_scrollControllerForHorizontal.position.pixels >=
        _scrollControllerForHorizontal.position.maxScrollExtent - 40) {
      // Достигнут конец, переход на следующую неделю
      setState(() {
        _selectedDate = _selectedDate.add(const Duration(days: 7));
      });
    } else if (_scrollControllerForHorizontal.position.pixels <=
        _scrollControllerForHorizontal.position.minScrollExtent + 40) {
      // Достигнут начало, переход на предыдущую неделю
      setState(() {
        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      });
    }
  }

  // Добавляет следующий месяц
  void _loadNextMonth() {
    setState(() {
      final lastMonth = _months.last;
      _months.add(DateTime(lastMonth.year, lastMonth.month + 1, 1));
    });
  }

  // Добавляет предыдущий месяц
  void _loadPreviousMonth() {
    setState(() {
      final firstMonth = _months.first;
      _months.insert(0, DateTime(firstMonth.year, firstMonth.month - 1, 1));
    });
  }

  // Генерация дней в месяце
  List<DateTime> _generateDaysInMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    return List.generate(
      lastDayOfMonth.day,
      (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Календарь")),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? MediaQuery.of(context).size.height * 0.6 : 80,
            child: _isExpanded
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: _months.length,
                    itemBuilder: (context, index) {
                      final currentMonth = _months[index];
                      final daysInMonth = _generateDaysInMonth(currentMonth);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat.yMMMM().format(currentMonth),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                            ),
                            itemCount: daysInMonth.length,
                            itemBuilder: (context, index) {
                              final day = daysInMonth[index];
                              final isSelected = _selectedDate == day;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = day;
                                    _isExpanded = false;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  )
                : _buildCompactWeekView(),
          ),
          Expanded(
            child: _selectedDate == null
                ? const Center(
                    child: Text('Выберите дату для просмотра событий'),
                  )
                : ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Событие ${index + 1}"),
                        subtitle: Text(
                          "Описание события для ${DateFormat.yMMMd().format(_selectedDate)}",
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactWeekView() {
    // Определяем начало текущей недели
    final startOfWeek =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));

    // Создаем список из 3 недель: предыдущая, текущая, следующая
    final daysOfWeeks = [
      ...List.generate(7, (i) => startOfWeek.subtract(Duration(days: 7 - i))),
      ...List.generate(7, (i) => startOfWeek.add(Duration(days: i))),
      ...List.generate(7, (i) => startOfWeek.add(Duration(days: 7 + i))),
    ];

    // Программная установка начальной позиции на середину списка
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollControllerForHorizontal.hasClients) {
        final middlePosition =
            MediaQuery.of(context).size.width; // центрируем список
        _scrollControllerForHorizontal.jumpTo(middlePosition);
      }
    });

    return Column(
      children: [
        // Заголовок с названием месяца
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(_selectedDate),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // Горизонтальный ListView с днями недели
        Expanded(
          child: ListView.builder(
            controller: _scrollControllerForHorizontal,
            scrollDirection: Axis.horizontal,
            itemCount: daysOfWeeks.length,
            itemBuilder: (context, index) {
              final day = daysOfWeeks[index];
              final isSelected = _selectedDate.day == day.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day; // Обновляем только выбранный день
                  });
                },
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E')
                            .format(day), // День недели (пн, вт, ср...)
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        '${day.day}', // Число
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CustomCalendarPage extends StatefulWidget {
  const CustomCalendarPage({super.key});

  @override
  _CustomCalendarPageState createState() => _CustomCalendarPageState();
}

class _CustomCalendarPageState extends State<CustomCalendarPage> {
  final _isExpanded =
      ValueNotifier<bool>(true); // Состояние календаря (развернут/сжат)
  DateTime _selectedDate = DateTime.now();

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];
  var _scrollController = ScrollController();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 1000) {
        // ignore: avoid_print
        print('scrolling distance: ${_scrollController.offset}');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Календарь')),
      body: Stack(children: [
        AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ValueListenableBuilder<bool>(
              valueListenable: _isExpanded,
              builder: (context, value, _) => value
                  ? _buildScrollSingleDatePickerWithValue()
                  : buildWeekWidget(),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            onPressed: () {
              if (_isExpanded.value) {
                _scrollController = ScrollController();
              }
              _isExpanded.value = !_isExpanded.value;
            },
          ),
        )
      ]),
    );
  }

  Widget buildWeekWidget() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 1, 1),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.week,
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {},
        ),
        //Раздел с событиями
        ValueListenableBuilder(
          valueListenable: _isExpanded,
          builder: (context, value, _) => value
              ? const SizedBox.shrink()
              : Expanded(
                  child: _buildEvents(),
                ),
        )
      ],
    );
  }

  Widget _buildScrollSingleDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      calendarViewMode: CalendarDatePicker2Mode.scroll,
      selectedDayHighlightColor: Colors.amber[900],
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),
      centerAlignModePicker: true,
      useAbbrLabelForMonthModePicker: true,
      firstDate: DateTime(DateTime.now().year - 2, DateTime.now().month - 1,
          DateTime.now().day - 5),
      lastDate: DateTime(DateTime.now().year + 3, DateTime.now().month + 2,
          DateTime.now().day + 10),
      selectableDayPredicate: (day) => !day
          .difference(DateTime.now().subtract(const Duration(days: 3)))
          .isNegative,
    );
    return SizedBox(
      width: 375,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text('Scroll Single Date Picker'),
          SizedBox(
            width: 250,
            height: 600,
            child: CalendarDatePicker2(
              config: config.copyWith(
                scrollViewController: _scrollController,
                dayMaxWidth: 32,
                controlsHeight: 40,
                hideScrollViewTopHeader: true,
              ),
              value: _singleDatePickerValueWithDefaultValue,
              onValueChanged: (dates) => setState(
                () {
                  _singleDatePickerValueWithDefaultValue = dates;

                  _selectedDate = dates.first;
                  // _isExpanded = false; // Переход в компактный режим
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Список событий
  Widget _buildEvents() {
    return ListView.builder(
      itemCount: 5, // Количество событий
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Событие ${index + 1}"),
          subtitle: Text(
            "Описание события для ${DateFormat.yMMMd().format(_singleDatePickerValueWithDefaultValue.first!)}",
          ),
        );
      },
    );
  }
}

class CalendarEvent {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? color;
  final String? address;
  final String? description;
  final String? previewImageLink;
  final CalendarEventType type;

  CalendarEvent({
    required this.id,
    required this.name,
    required this.startDate,
    required this.type,
    this.endDate,
    this.startTime,
    this.endTime,
    this.color,
    this.address,
    this.description,
    this.previewImageLink,
  });
}

enum CalendarEventType {
  event,
  courses,
}

class CustomCalendarPageV2 extends StatefulWidget {
  const CustomCalendarPageV2({super.key});

  @override
  _CustomCalendarPageV2State createState() => _CustomCalendarPageV2State();
}

class _CustomCalendarPageV2State extends State<CustomCalendarPageV2> {
  DateTime _selectedDate = DateTime.now();

  final ScrollController _scrollController = ScrollController();
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];

  final List<CalendarEvent> _events = [
    CalendarEvent(
      id: 1,
      name: "Событие 1",
      startDate: DateTime.now(),
      type: CalendarEventType.event,
    ),
    CalendarEvent(
      id: 2,
      name: "Курс 1",
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 4)),
      type: CalendarEventType.courses,
    ),
    CalendarEvent(
      id: 3,
      name: "Событие 2",
      startDate: DateTime.now(),
      type: CalendarEventType.event,
    ),
    CalendarEvent(
      id: 4,
      name: "Курс 2",
      startDate: DateTime.now().add(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 6)),
      type: CalendarEventType.courses,
    ),
    CalendarEvent(
      id: 2,
      name: "Курс 1",
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 4)),
      type: CalendarEventType.courses,
    ),
  ];

  final dayTextStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
  final weekendTextStyle =
      TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Календарь')),
      body: HorizontalSplitView(
        top: ScrollSingleDatePicker(
          onValueChanged: (dates) => setState(() {
            _singleDatePickerValueWithDefaultValue = dates;
            _selectedDate = dates.first;
          }),
          config: CalendarDatePicker2Config(
            animateToDisplayedMonthDate: true,
            monthViewController: _scrollController,
            currentDate: _singleDatePickerValueWithDefaultValue.first,
            calendarViewMode: CalendarDatePicker2Mode.scroll,
            selectedDayHighlightColor: const Color.fromARGB(255, 21, 106, 234),
            weekdayLabelTextStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            firstDayOfWeek: 1,
            controlsHeight: 50,
            controlsTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            dayTextStyle: dayTextStyle,
            disabledDayTextStyle: const TextStyle(
              color: Colors.grey,
            ),
            firstDate: DateTime(DateTime.now().year - 1,
                DateTime.now().month - 1, DateTime.now().day - 5),
            lastDate: DateTime(DateTime.now().year + 2,
                DateTime.now().month + 2, DateTime.now().day + 10),
            selectableDayPredicate: (day) => !day
                .difference(DateTime.now().subtract(const Duration(days: 3)))
                .isNegative,
            dayBuilder: _dayBuilder,
          ),
          singleDatePickerValueWithDefaultValue:
              _singleDatePickerValueWithDefaultValue,
        ),
        bottom: WeekWidget(
          events: _events,
          selectedDay: _singleDatePickerValueWithDefaultValue.first!,
          focusedDay: _selectedDate,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _singleDatePickerValueWithDefaultValue.clear();
              _singleDatePickerValueWithDefaultValue.add(selectedDay);
              _selectedDate = selectedDay;
            });
          },
        ),
        ratio: 1.0,
      ),
    );
  }

  /// Кастомный билдер для дня
  Widget _dayBuilder({
    required DateTime date,
    BoxDecoration? decoration,
    bool? isDisabled,
    bool? isSelected = false,
    bool? isToday = false,
    TextStyle? textStyle,
  }) {
    // Фильтруем события для выбранного дня
    final selectedDayEvents = _events.where((event) {
      if (event.type == CalendarEventType.courses) {
        // Проверяем, попадает ли selectedDay в диапазон дат курса
        return date
                .isAfter(event.startDate.subtract(const Duration(days: 1))) &&
            date.isBefore(event.endDate!.add(const Duration(days: 1)));
      }
      return isSameDay(date, event.startDate);
    }).toList();

    return Container(
      decoration: decoration,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            MaterialLocalizations.of(context).formatDecimal(date.day),
            style: textStyle,
          ),
          if (selectedDayEvents.isNotEmpty)
            Positioned(
              bottom: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  selectedDayEvents.length > 4 ? 4 : selectedDayEvents.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: selectedDayEvents[index].type ==
                              CalendarEventType.event
                          ? Colors.blue
                          : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// {@template calendar_screen}
/// ScrollSingleDatePicker widget.
/// {@endtemplate}
class ScrollSingleDatePicker extends StatelessWidget {
  /// {@macro calendar_screen}
  const ScrollSingleDatePicker({
    super.key,
    required this.config,
    required this.singleDatePickerValueWithDefaultValue,
    this.onValueChanged,
  });

  final CalendarDatePicker2Config config;
  final List<DateTime?> singleDatePickerValueWithDefaultValue;

  final void Function(List<DateTime>)? onValueChanged;
  @override
  Widget build(BuildContext context) => CalendarDatePicker2(
        config: config.copyWith(
            dayMaxWidth: 32, controlsHeight: 40, hideScrollViewTopHeader: true),
        value: singleDatePickerValueWithDefaultValue,
        onValueChanged: onValueChanged,
      );
}

class WeekWidget extends StatelessWidget {
  const WeekWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.events,
    this.onDaySelected,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<CalendarEvent> events; // Список всех событий
  final void Function(DateTime, DateTime)? onDaySelected;

  @override
  Widget build(BuildContext context) {
    // Фильтруем события для выбранного дня
    final selectedDayEvents = events.where((event) {
      if (event.type == CalendarEventType.courses) {
        // Проверяем, попадает ли selectedDay в диапазон дат курса
        return selectedDay
                .isAfter(event.startDate.subtract(const Duration(days: 1))) &&
            selectedDay.isBefore(event.endDate!.add(const Duration(days: 1)));
      }
      return isSameDay(selectedDay, event.startDate);
    }).toList();

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 1, 1),
          focusedDay: focusedDay,
          calendarFormat: CalendarFormat.week,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          onDaySelected: onDaySelected,
          eventLoader: (day) {
            // Возвращаем события для конкретного дня, включая диапазон для курсов
            return events.where((event) {
              if (event.type == CalendarEventType.courses) {
                return day.isAfter(
                        event.startDate.subtract(const Duration(days: 1))) &&
                    day.isBefore(event.endDate!.add(const Duration(days: 1)));
              }
              return isSameDay(day, event.startDate);
            }).toList();
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, dayEvents) {
              // Отображаем до 4 кружков для событий
              final displayedEvents = dayEvents.cast<CalendarEvent>();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: displayedEvents.take(4).map((event) {
                  final color = event.type == CalendarEventType.event
                      ? Colors.blue
                      : Colors.red;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: selectedDayEvents.length,
            itemBuilder: (context, index) {
              final event = selectedDayEvents[index];
              return ListTile(
                title: Text(event.name),
                subtitle: Text(
                  event.description ?? "Описание отсутствует",
                ),
                leading: Icon(
                  event.type == CalendarEventType.event
                      ? Icons.event
                      : Icons.school,
                  color: event.type == CalendarEventType.event
                      ? Colors.blue
                      : Colors.red,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


// class WeekWidget extends StatelessWidget {
//   const WeekWidget({
//     super.key,
//     required this.focusedDay,
//     required this.selectedDay,
//     this.onDaySelected,
//   });
//   final DateTime focusedDay;
//   final DateTime selectedDay;
//   final void Function(DateTime, DateTime)? onDaySelected;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TableCalendar(
//           firstDay: DateTime.utc(2000, 1, 1),
//           lastDay: DateTime.utc(2100, 1, 1),
//           focusedDay: focusedDay,
//           calendarFormat: CalendarFormat.week,
//           selectedDayPredicate: (day) => isSameDay(selectedDay, day),
//           onDaySelected: onDaySelected,
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: 5, // Количество событий
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text("Событие ${index + 1}"),
//                 subtitle: Text(
//                   "Описание события для ${DateFormat.yMMMd().format(selectedDay)}",
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
