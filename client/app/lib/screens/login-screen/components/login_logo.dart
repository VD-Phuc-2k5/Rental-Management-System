import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.blue700.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Icon(
        Icons.home_work_rounded,
        size: 40,
        color: AppColors.blue700,
      ),
    );
  }
}
