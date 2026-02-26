import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/utils/constants.dart';

class PaymentHeading extends StatelessWidget {
  const PaymentHeading({super.key, required this.price, required this.roomId});
  final int price;
  final String roomId;
  String formatVND(int price) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(price);
  }

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
            spacing: 8,
            children: [
              const Icon(Icons.apartment, size: 20, color: AppColors.blue700),
              Text(
                roomId,
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
      ],
    );
  }
}
