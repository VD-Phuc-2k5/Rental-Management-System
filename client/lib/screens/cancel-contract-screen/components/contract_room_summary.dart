import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ContractRoomSummary extends StatelessWidget {
  const ContractRoomSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Đang thuê",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColors.slate500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Phòng 305 - Nhà trọ Hạnh Phúc",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF1A202C),
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.slate100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.domain,
              color: AppColors.slate500,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
