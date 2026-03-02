import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class PhoneEmailInput extends StatelessWidget {
  final TextEditingController? controller;

  const PhoneEmailInput({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Số điện thoại / Email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.slate700,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
          decoration: InputDecoration(
            hintText: 'Nhập thông tin của bạn',
            hintStyle: TextStyle(
              color: AppColors.slate400,
              fontSize: 16,
              fontFamily: 'Inter',
            ),
            suffixIcon: const Icon(
              Icons.contact_page_outlined,
              color: AppColors.slate400,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9999),
              borderSide: const BorderSide(color: AppColors.slate200, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9999),
              borderSide: const BorderSide(
                color: AppColors.blue700,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ví dụ: 0912345678 hoặc abc@gmail.com',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.slate400,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
