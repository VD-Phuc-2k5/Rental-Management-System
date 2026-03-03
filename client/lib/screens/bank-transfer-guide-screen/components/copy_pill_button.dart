import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class CopyPillButton extends StatelessWidget {
  const CopyPillButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blue700.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.copy_rounded, size: 16, color: AppColors.blue700),
          SizedBox(width: 6),
          Text(
            'Sao chép',
            style: TextStyle(
              color: AppColors.blue700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}