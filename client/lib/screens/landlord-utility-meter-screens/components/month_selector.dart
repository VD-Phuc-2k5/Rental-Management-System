import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final String currentMonth;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;

  const MonthSelector({
    super.key,
    required this.currentMonth,
    this.onPreviousMonth,
    this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.blue700.withAlpha(26),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        "THÁNG $currentMonth",
        style: const TextStyle(
          color: AppColors.blue700,
          fontFamily: "Inter",
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
