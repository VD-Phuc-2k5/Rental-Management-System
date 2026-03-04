import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

import 'section_header.dart';

class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({super.key});

  Widget _buildTextField(
    String label, {
    String? hintText,
    String? initialValue,
    String? suffixText,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.slate700,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: " *",
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextField(
            controller: initialValue != null
                ? TextEditingController(text: initialValue)
                : null,
            style: const TextStyle(
              fontFamily: "Noto Sans",
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.slate700,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: "Noto Sans",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.slate400,
              ),
              suffixIcon: suffixText != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            suffixText,
                            style: const TextStyle(
                              fontFamily: "Noto Sans",
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.blue700),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: "Thông tin cơ bản",
          icon: Icons.info_outline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          "Tiêu đề bài đăng",
          hintText: "Ví dụ: Phòng trọ cao cấp Q.1",
          isRequired: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                "Diện tích",
                initialValue: "25",
                suffixText: "m²",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                "Giá thuê",
                initialValue: "3.500.000",
                suffixText: "VNĐ",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                "Giá điện",
                initialValue: "3.500",
                suffixText: "đ/KWh",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                "Giá nước",
                initialValue: "15.000",
                suffixText: "đ/m3",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
