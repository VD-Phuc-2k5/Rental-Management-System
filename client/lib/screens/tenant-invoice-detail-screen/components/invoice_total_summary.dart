import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:flutter/material.dart';

class InvoiceTotalSummary extends StatelessWidget {
  final int totalAmount;

  const InvoiceTotalSummary({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.blue700.withAlpha(13),
        border: Border.all(width: 1.0, color: AppColors.blue700.withAlpha(26)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 16.0,
        children: [
          const Text(
            'Tổng cộng',
            style: TextStyle(
              color: AppColors.slate600,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Text(
            formatVND(totalAmount),
            style: const TextStyle(
              color: AppColors.blue700,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
