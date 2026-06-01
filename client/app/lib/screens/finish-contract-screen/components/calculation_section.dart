import '../../../core/constants.dart';
import 'package:flutter/material.dart';

class CalculationSection extends StatelessWidget {
  const CalculationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.slate100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate_outlined,
                color: AppColors.blue700,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "Tính khấu trừ",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.blue700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tiền đặt cọc",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  color: AppColors.slate500,
                ),
              ),
              Text(
                "4.000.000đ",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.slate900,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "- Sửa tường",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  color: AppColors.red500,
                ),
              ),
              Text(
                "- 300.000đ",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.red500,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: AppColors.slate100, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Tổng hoàn trả",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.slate900,
                ),
              ),
              Text(
                "3.700.000đ",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: AppColors.blue700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
