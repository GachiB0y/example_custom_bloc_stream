// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_stream/feature/calendar/widget/horizontal_split_view_widget.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomCalendarPageV2();
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
