import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  Widget _buildSummaryBox(String number, String label) {
    return Expanded(
      child: Container(
        height: 61.5,
        decoration: BoxDecoration(
          color: const Color(0xFFEBF3FB),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.25,
                color: AppColors.blue700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w600,
                fontSize: 10,
                height: 1.5,
                color: AppColors.slate500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildSummaryBox("11", "PHÒNG TỔNG"),
        const SizedBox(width: 12),
        _buildSummaryBox("8", "ĐANG THUÊ"),
        const SizedBox(width: 12),
        _buildSummaryBox("3", "CÒN TRỐNG"),
      ],
    );
  }
}