import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class WarningBox extends StatelessWidget {
  const WarningBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.red50,
        border: Border.all(color: AppColors.red100),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        "Lưu ý: Hủy hợp đồng trước thời hạn có thể ảnh hưởng đến tiền cọc theo điều khoản đã ký.",
        style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.62,
          color: AppColors.red500,
        ),
      ),
    );
  }
}
