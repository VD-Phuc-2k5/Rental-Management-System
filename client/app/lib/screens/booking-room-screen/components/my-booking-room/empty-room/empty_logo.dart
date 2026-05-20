import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class EmptyLogo extends StatelessWidget {
  const EmptyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final Color iconColor = AppColors.blue700.withValues(alpha: 0.4);

    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.blue700.withValues(alpha: 0.05),
                  AppColors.blue700.withValues(alpha: 0.20),
                ],
              ),
            ),
          ),
          Icon(
            Icons.calendar_month_outlined,
            size: 80,
            color: iconColor,
          ),
          Positioned(
            top: 32,
            right: 26,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.blue700.withValues(alpha: 0.30),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 38,
            left: 18,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.blue700.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}