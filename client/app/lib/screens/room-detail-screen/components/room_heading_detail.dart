import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:flutter/material.dart';

class RoomHeadingDetail extends StatelessWidget {
  final String title;
  final double price;

  const RoomHeadingDetail({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.black
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                formatVND(price.toInt()),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue700
                ),
              ),
              const Text(
                "/tháng",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.slate500
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}