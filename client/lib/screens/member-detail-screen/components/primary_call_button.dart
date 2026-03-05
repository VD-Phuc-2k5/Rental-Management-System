import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class PrimaryCallButton extends StatelessWidget {
  const PrimaryCallButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.call, color: AppColors.white),
        label: const Text(
          'Liên hệ ngay',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue700,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
          elevation: 0,
        ),
      ),
    );
  }
}