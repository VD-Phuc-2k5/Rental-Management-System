import 'package:flutter/material.dart';
import 'calendar_header.dart';
import 'calendar_day_header.dart';
import 'calendar_day_cell.dart';

class CustomCalendarPicker extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;

  const CustomCalendarPicker({
    super.key,
    this.initialDate,
    this.onDateSelected,
  });

  @override
  State<CustomCalendarPicker> createState() =>
      _CustomCalendarPickerState();
}

class _CustomCalendarPickerState
    extends State<CustomCalendarPicker> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _currentMonth =
        DateTime(_selectedDate!.year, _selectedDate!.month);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  List<Widget> _buildDays() {
    final firstDay =
        DateTime(_currentMonth.year, _currentMonth.month, 1);

    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0)
            .day;

    final startingWeekday = firstDay.weekday % 7;

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    List<Widget> items = [];

    for (int i = 0; i < startingWeekday; i++) {
      items.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date =
          DateTime(_currentMonth.year, _currentMonth.month, day);

      final isSelected =
          _selectedDate?.year == date.year &&
              _selectedDate?.month == date.month &&
              _selectedDate?.day == date.day;

      final isPast = date.isBefore(todayOnly);

      items.add(
        CalendarDayCell(
          date: date,
          isSelected: isSelected,
          isPast: isPast,
          onTap: () {
            setState(() => _selectedDate = date);
            widget.onDateSelected?.call(date);
          },
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: 0.05),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarHeader(
            currentMonth: _currentMonth,
            onPrevious: _previousMonth,
            onNext: _nextMonth,
          ),
          const SizedBox(height: 12),
          const CalendarDayHeader(),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            children: _buildDays(),
          ),
        ],
      ),
    );
  }
}