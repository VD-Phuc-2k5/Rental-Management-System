import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({super.key});

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.blue700, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: "Public Sans",
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColors.blue700,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Public Sans",
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: AppColors.slate700,
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: "Public Sans",
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.slate400,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColors.slate300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColors.blue700, width: 1.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.info_outline, "Thông tin cơ bản"),
          const SizedBox(height: 16),
          _buildLabel("Tên nhà trọ"),
          _buildTextField(hintText: "VD: Landmark A"),
          const SizedBox(height: 16),
          _buildLabel("Địa chỉ chi tiết"),
          _buildTextField(
            hintText: "Số nhà, tên đường, phường, quận, thành phố...",
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildLabel("Loại hình"),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: "Chọn loại hình",
              hintStyle: const TextStyle(
                fontFamily: "Public Sans",
                color: AppColors.slate900,
                fontSize: 16,
              ),
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.slate500,
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: AppColors.slate300,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
