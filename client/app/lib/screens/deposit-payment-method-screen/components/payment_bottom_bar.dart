import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/screens/bank-transfer-guide-screen/bank_transfer_guide_screen.dart';
class PaymentBottomBar extends StatelessWidget {
  const PaymentBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
      void _goNext(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BankTransferGuideScreen()),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.gray100, width: 1)),
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
                onPressed: () => _goNext(context),
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
                Icon(Icons.lock_outline, size: 16, color: AppColors.gray500),
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