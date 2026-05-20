import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class LandlordPaymentHistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LandlordPaymentHistoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      title: const Text(
        'Lịch sử thanh toán',
        style: TextStyle(
          color: AppColors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.slate100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: 'Tháng 02/2026',
                isDense: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.slate700,
                  size: 14,
                ),
                style: const TextStyle(
                  color: AppColors.slate700,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                dropdownColor: AppColors.white,
                items: <String>[
                  'Tháng 01/2026',
                  'Tháng 02/2026',
                  'Tháng 03/2026',
                  'Tháng 04/2026',
                  'Tháng 05/2026',
                  'Tháng 06/2026',
                  'Tháng 07/2026',
                  'Tháng 08/2026',
                  'Tháng 09/2026',
                  'Tháng 10/2026',
                  'Tháng 11/2026',
                  'Tháng 12/2026',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle month selection change
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}