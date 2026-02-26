import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';

class PaymentQr extends StatelessWidget {
  const PaymentQr({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(width: 1.0, color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        spacing: 16.0,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: AppColors.blue700.withAlpha(26),
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset("assets/images/qr-payment.png"),
            ),
          ),
          const Text(
            "Quét mã để thanh toán",
            style: TextStyle(
              fontFamily: "Inter",
              color: AppColors.blue950,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
