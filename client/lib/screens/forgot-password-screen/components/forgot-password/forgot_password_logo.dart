import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class ForgotPasswordLogo extends StatelessWidget {
  const ForgotPasswordLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.blue700.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Icon(
        Icons.lock_reset,
        size: 40,
        color: AppColors.blue700,
      ),
    );
  }
}
