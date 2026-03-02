import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class UpdateRoomBody extends StatelessWidget {
  const UpdateRoomBody({super.key});

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: AppColors.slate700,
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? initialValue,
    String? suffixText,
    bool isDropdown = false,
  }) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: isDropdown,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: AppColors.slate900,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.slate50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColors.blue700),
        ),
        suffixIcon: isDropdown
            ? const Icon(Icons.keyboard_arrow_down, color: AppColors.slate500)
            : null,
        suffixText: suffixText,
        suffixStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: AppColors.slate400,
        ),
      ),
    );
  }

  Widget _buildUtilityChip(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.blue700.withAlpha(25) : AppColors.slate50,
        border: Border.all(
          color: isSelected ? AppColors.blue700 : AppColors.slate200,
        ),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            Icon(Icons.check, size: 12, color: AppColors.blue700),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: isSelected ? AppColors.blue700 : AppColors.slate600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String imagePath) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.black.withAlpha(128),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 12, color: AppColors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: AppColors.slate100),
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
          children: [
            _buildLabel("Chọn khu trọ"),
            _buildTextField(
              initialValue: "Khu A - 123 Nguyễn Trãi, Q5",
              isDropdown: true,
            ),
            const SizedBox(height: 16),

            _buildLabel("Số phòng"),
            _buildTextField(initialValue: "101"),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Tầng"),
                      _buildTextField(initialValue: "1"),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Diện tích (m2)"),
                      _buildTextField(initialValue: "25"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.slate100),
            const SizedBox(height: 16),

            _buildLabel("Giá thuê"),
            _buildTextField(initialValue: "3.500.000"),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Giá điện"),
                      _buildTextField(
                        initialValue: "3.500",
                        suffixText: "đ/kWh",
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Giá nước"),
                      _buildTextField(
                        initialValue: "15.000",
                        suffixText: "đ/m3",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.slate100),
            const SizedBox(height: 16),

            _buildLabel("Tiện ích"),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildUtilityChip("Máy lạnh", Icons.ac_unit, true),
                _buildUtilityChip("Giường", Icons.bed, true),
                _buildUtilityChip("WC riêng", Icons.bathtub, true),
                _buildUtilityChip("Tủ lạnh", Icons.kitchen, false),
                _buildUtilityChip("Ban công", Icons.balcony, false),
              ],
            ),
            const SizedBox(height: 24),

            _buildLabel("Hình ảnh phòng"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildImagePreview(
                    'assets/images/add-room-screen/room_img1.jpg',
                  ),
                  const SizedBox(width: 8),
                  _buildImagePreview(
                    'assets/images/add-room-screen/room_img2.jpg',
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.blue50.withAlpha(128),
                      border: Border.all(
                        color: AppColors.blue700.withAlpha(102),
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),

                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppColors.blue700,
                          size: 18,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Thêm ảnh",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: AppColors.blue700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue700,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Lưu thay đổi",
                  style: TextStyle(
                    fontFamily: "Public Sans",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.slate200, width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Hủy",
                  style: TextStyle(
                    fontFamily: "Public Sans",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.slate600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
