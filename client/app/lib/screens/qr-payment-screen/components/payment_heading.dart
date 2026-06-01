import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/format_currency.dart';

class PaymentHeading extends StatelessWidget {
  const PaymentHeading({
    super.key,
    required this.price,
    required this.roomName,
    this.payerName,
  });
  final int price;
  final String roomName;
  final String? payerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        const Text(
          "Tổng thanh toán",
          style: TextStyle(
            color: AppColors.slate500,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          formatVND(price),
          style: const TextStyle(
            color: AppColors.blue700,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 30,
            letterSpacing: -0.75,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.blue700.withAlpha(26),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.apartment, size: 20, color: AppColors.blue700),
              Text(
                roomName,
                style: const TextStyle(
                  color: AppColors.slate700,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        if (payerName != null && payerName!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 18, color: AppColors.blue700),
              const SizedBox(width: 6),
              Text(
                payerName!,
                style: const TextStyle(
                  color: AppColors.slate700,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
