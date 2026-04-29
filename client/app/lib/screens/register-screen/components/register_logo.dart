import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class RegisterLogo extends StatelessWidget {
  const RegisterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.blue700.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.apartment,
        size: 40,
        color: AppColors.blue700,
      ),
    );
  }
}
