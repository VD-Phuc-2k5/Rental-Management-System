import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class TechnicianInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController notesController;

  const TechnicianInfoSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.notesController,
  });

  Widget _buildSectionHeader() {
    return const Text(
      "Thông tin thợ sửa chữa",
      style: TextStyle(
        color: AppColors.blue950,
        fontFamily: "Inter",
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.slate700,
            ),
            children: [
              TextSpan(text: label),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.red500),
                ),
            ],
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 16, color: AppColors.slate900),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 16, color: AppColors.slate400),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.slate300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.slate300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.blue700, width: 2),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1.0, color: AppColors.slate200),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          _buildSectionHeader(),
          _buildTextField(
            label: "Tên thợ sửa chữa",
            hint: "VD: Anh Nam Thợ Điện",
            controller: nameController,
            isRequired: true,
          ),
          _buildTextField(
            label: "Số điện thoại thợ",
            hint: "09xx xxx xxx",
            controller: phoneController,
            isRequired: true,
            keyboardType: TextInputType.phone,
            suffixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.slate400,
            ),
          ),
          _buildTextField(
            label: "Ghi chú thêm",
            hint: "Mạng theo tháng gần...",
            controller: notesController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
