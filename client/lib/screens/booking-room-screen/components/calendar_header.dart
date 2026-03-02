import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          DateFormat('MMMM yyyy', 'vi')
              .format(currentMonth),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}