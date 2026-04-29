import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class HeadingIcon extends StatelessWidget {
  const HeadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blue700.withAlpha(26),
      ),
      child: const Icon(
        Icons.check_circle_outline_outlined,
        size: 54.0,
        color: AppColors.blue700,
      ),
    );
  }
}
