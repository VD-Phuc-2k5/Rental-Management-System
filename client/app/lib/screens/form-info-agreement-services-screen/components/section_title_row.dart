import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class SectionTitleRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionTitleRow({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.blue700),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }
}