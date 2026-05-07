import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class CountdownWidget extends StatelessWidget {
  final int daysRemaining;

  const CountdownWidget({super.key, required this.daysRemaining});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.amber500, width: 6),
            color: AppColors.amber100.withAlpha(51),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                daysRemaining.toString(),
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w800,
                  fontSize: 48,
                  height: 1.0,
                  color: AppColors.amber500,
                ),
              ),
              const Text(
                "NGÀY",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                  color: AppColors.amber500,
                ),
              ),
            ],
          ),
        ),
        const Text(
          "Thời gian còn lại",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.slate500,
          ),
        ),
      ],
    );
  }
}
