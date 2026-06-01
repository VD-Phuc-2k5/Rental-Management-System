import 'package:flutter/material.dart';

import '../../../core/constants.dart';

class LandlordPaymentHistoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const LandlordPaymentHistoryAppBar({
    super.key,
    required this.selectedMonth,
    required this.monthOptions,
    required this.onMonthChanged,
  });

  final String? selectedMonth;
  final List<String> monthOptions;
  final ValueChanged<String?> onMonthChanged;

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
                value: selectedMonth ?? '',
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
                items: <String>['', ...monthOptions].map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.isEmpty ? 'Tất cả' : _monthLabel(value)),
                  );
                }).toList(),
                onChanged: (value) {
                  onMonthChanged(value == null || value.isEmpty ? null : value);
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

  String _monthLabel(String value) {
    final parts = value.split('-');
    if (parts.length != 2) return value;
    return 'Tháng ${parts[1]}/${parts[0]}';
  }
}
