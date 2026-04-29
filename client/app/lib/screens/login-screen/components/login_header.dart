import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "NhàTrọ+",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: AppColors.blue700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Quản lý nhà trọ thông minh",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.slate500,
          ),
        ),
      ],
    );
  }
}
