import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ImageUploadSection extends StatelessWidget {
  const ImageUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.slate300, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.blue50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.blue700,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Thêm hình ảnh",
            style: TextStyle(
              fontFamily: "Noto Sans",
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.slate700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "(Tối đa 5 ảnh)",
            style: TextStyle(
              fontFamily: "Noto Sans",
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.slate500,
            ),
          ),
        ],
      ),
    );
  }
}
