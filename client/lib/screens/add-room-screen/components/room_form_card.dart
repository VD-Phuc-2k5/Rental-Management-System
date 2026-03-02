import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class RoomFormCard extends StatelessWidget {
  const RoomFormCard({super.key});

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.slate700,
        ),
      ),
    );
  }

  Widget _buildTextField(String initialValue, {String? suffixText}) {
    return TextFormField(
      initialValue: initialValue,
      style: const TextStyle(
        fontFamily: "Nunito",
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
          borderSide: const BorderSide(color: AppColors.slate200, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColors.blue700, width: 1.0),
        ),
        suffixText: suffixText,
        suffixStyle: const TextStyle(
          fontFamily: "Nunito",
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: AppColors.slate400,
        ),
      ),
    );
  }

  Widget _buildUtilityChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.blue700.withAlpha(26) : AppColors.slate50,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: isActive ? AppColors.blue700 : AppColors.slate200,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            const Icon(Icons.check, size: 12, color: AppColors.blue700),
          if (isActive) const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: isActive ? AppColors.blue700 : AppColors.slate600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String imagePath) {
    return Container(
      width: 104,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: AppColors.black.withAlpha(128),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 12, color: AppColors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          TextFormField(
            initialValue: "Khu A - 123 Nguyễn Trãi, Q5",
            readOnly: true,
            style: const TextStyle(
              fontFamily: "Nunito",
              color: AppColors.slate900,
              fontSize: 16,
            ),
            decoration: InputDecoration(
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
                  color: AppColors.slate200,
                  width: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLabel("Số phòng"),
          _buildTextField("101"),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildLabel("Tầng"), _buildTextField("1")],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Diện tích (m2)"),
                    _buildTextField("25"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.slate100, thickness: 1),
          const SizedBox(height: 16),
          _buildLabel("Giá thuê"),
          _buildTextField("3.500.000"),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Giá điện"),
                    _buildTextField("3.500", suffixText: "đ/kWh"),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Giá nước"),
                    _buildTextField("15.000", suffixText: "đ/m3"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.slate100, thickness: 1),
          const SizedBox(height: 16),
          _buildLabel("Tiện ích"),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _buildUtilityChip("Máy lạnh", true),
              _buildUtilityChip("Giường", true),
              _buildUtilityChip("WC riêng", true),
              _buildUtilityChip("Tủ lạnh", false),
              _buildUtilityChip("Ban công", false),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabel("Hình ảnh phòng"),
          Row(
            children: [
              _buildImagePreview('assets/images/add-room-screen/room_img1.jpg'),
              const SizedBox(width: 8),
              _buildImagePreview('assets/images/add-room-screen/room_img2.jpg'),
              const SizedBox(width: 8),

              Expanded(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF).withAlpha(128),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
