import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class UpdateReasonSection extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const UpdateReasonSection({
    super.key,
    required this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lý do cập nhật",
          style: TextStyle(
            color: AppColors.blue900,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText:
                'Vui lòng nhập lý do thay đổi để thông báo cho người thuê...',
            hintStyle: const TextStyle(
              color: AppColors.slate400,
              fontFamily: "Inter",
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.slate50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.slate200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.slate200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.blue700,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red500),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red500, width: 1.5),
            ),
            errorText: errorText,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
