import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isPast;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isPast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isPast ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.blue700
              : Colors.transparent,
        ),
        child: Text(
          "${date.day}",
          style: TextStyle(
            color: isPast
                ? AppColors.slate300
                : isSelected
                    ? AppColors.white
                    : AppColors.black,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}