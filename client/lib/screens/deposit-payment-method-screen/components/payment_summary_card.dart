import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
        child: Column(
          children: [
            const Text(
              'TỔNG TIỀN THANH TOÁN',
              style: TextStyle(
                color: AppColors.gray500,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '5.000.000đ',
              style: TextStyle(
                color: AppColors.blue700,
                fontWeight: FontWeight.w800,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.apartment_rounded, color: Color(0xFF647487)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Phòng 301 - Tòa Landmark',
                    style: TextStyle(
                      color: Color(0xFF1A202C),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}