import 'package:flutter/material.dart';

class CalendarDayHeader extends StatelessWidget {
  const CalendarDayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: days
          .map(
            (d) => Center(
              child: Text(
                d,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}