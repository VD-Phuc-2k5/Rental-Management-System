import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class PaymentBottomBar extends StatelessWidget {
  const PaymentBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFDCE0E5), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {}, // UI-only
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue700,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: const Text(
                  'Thanh toán ngay',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock_outline, size: 16, color: Color(0xFF94A3B8)),
                SizedBox(width: 6),
                Text(
                  'Giao dịch được bảo mật bởi hệ thống NhàTrọ+',
                  style: TextStyle(color: AppColors.gray500, fontWeight: FontWeight.w400,fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}