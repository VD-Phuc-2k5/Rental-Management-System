import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class UpdateImagesSection extends StatelessWidget {
  const UpdateImagesSection({super.key});

  Widget _buildImageUploadBox() {
    return Expanded(
      child: Container(
        height: 128,
        decoration: BoxDecoration(color: AppColors.slate50, borderRadius: BorderRadius.circular(5.0), border: Border.all(color: AppColors.slate300, width: 2.0, style: BorderStyle.solid)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.image_outlined, color: AppColors.slate400, size: 24),
            SizedBox(height: 4),
            Text("Tải ảnh lên", style: TextStyle(fontFamily: "Public Sans", fontWeight: FontWeight.w500, fontSize: 10, color: AppColors.slate400)),
          ],
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
          Row(
            children: const [
              Icon(Icons.photo_library_outlined, color: AppColors.blue700, size: 16),
              SizedBox(width: 8),
              Text("Hình ảnh khu trọ", style: TextStyle(fontFamily: "Public Sans", fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.blue700)),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [_buildImageUploadBox(), const SizedBox(width: 20), _buildImageUploadBox()]),
        ],
      ),
    );
  }
}