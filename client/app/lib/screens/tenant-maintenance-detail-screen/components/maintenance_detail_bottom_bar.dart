import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class MaintenanceDetailBottomBar extends StatelessWidget {
  const MaintenanceDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.report_gmailerrorred_outlined, color: AppColors.red500),
                label: const Text(
                  'Gửi khiếu nại',
                  style: TextStyle(color: AppColors.red500, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.red500, width: 1),
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 11,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline, color: AppColors.white),
                label: const Text(
                  'Xác nhận hoàn thành',
                  style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}