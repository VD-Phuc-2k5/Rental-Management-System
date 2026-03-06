import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class ComplaintReasonField extends StatelessWidget {
  const ComplaintReasonField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lý do khiếu nại',
          style: TextStyle(
            color: AppColors.gray800,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.white),
          ),
          child: TextField(
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Mô tả chi tiết lý do bạn không hài lòng với kết quả sửa chữa...',
              hintStyle: const TextStyle(color: Color(0xFF6B7280), height: 1.25),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ),
      ],
    );
  }
}