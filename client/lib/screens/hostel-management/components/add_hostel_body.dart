import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class AddHostelBody extends StatelessWidget {
  const AddHostelBody({super.key});

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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _buildUtilityChip(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.blue700.withAlpha(26) : AppColors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: isActive ? AppColors.blue700 : AppColors.slate300,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isActive ? AppColors.blue700 : AppColors.slate600),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: "Public Sans",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isActive ? AppColors.blue700 : AppColors.slate600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadBox() {
    return Expanded(
      child: Container(
        height: 128,
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: AppColors.slate300, width: 2.0, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.image_outlined, color: AppColors.slate400, size: 24),
            SizedBox(height: 4),
            Text(
              "Tải ảnh lên",
              style: TextStyle(
                fontFamily: "Public Sans",
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: AppColors.slate400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
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
                _buildTextField(hintText: "Số nhà, tên đường, phường, quận, thành phố...", maxLines: 3),
                const SizedBox(height: 16),
                _buildLabel("Loại hình"),

                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Chọn loại hình",
                    hintStyle: const TextStyle(fontFamily: "Public Sans", color: AppColors.slate900, fontSize: 16),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down, color: AppColors.slate500),
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: AppColors.slate300, width: 1.0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(height: 8, color: AppColors.slate100),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(Icons.grid_view, "Tiện ích chung"),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    _buildUtilityChip(Icons.wifi, "Wifi miễn phí", true),
                    _buildUtilityChip(Icons.local_parking, "Giữ xe", false),
                    _buildUtilityChip(Icons.security, "An ninh 24/7", false),
                    _buildUtilityChip(Icons.videocam_outlined, "Camera", false),
                    _buildUtilityChip(Icons.access_time, "Giờ giấc tự do", false),
                    _buildUtilityChip(Icons.elevator_outlined, "Thang máy", false),
                  ],
                ),
              ],
            ),
          ),

          Container(height: 8, color: AppColors.slate100),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(Icons.photo_library_outlined, "Hình ảnh nhà trọ"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildImageUploadBox(),
                    const SizedBox(width: 20),
                    _buildImageUploadBox(),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.slate200, width: 1.0)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue700,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                    },
                    child: const Text(
                      "Thêm nhà trọ",
                      style: TextStyle(fontFamily: "Public Sans", fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: AppColors.slate200, width: 2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Hủy",
                      style: TextStyle(fontFamily: "Public Sans", fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.slate600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}