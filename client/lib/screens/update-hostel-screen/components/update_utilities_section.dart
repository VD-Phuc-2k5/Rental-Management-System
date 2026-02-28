import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class UpdateUtilitiesSection extends StatelessWidget {
  const UpdateUtilitiesSection({super.key});

  Widget _buildUtilityChip(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.blue700.withAlpha(26) : AppColors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: isActive ? AppColors.blue700 : AppColors.slate300, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isActive ? AppColors.blue700 : AppColors.slate600),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontFamily: "Public Sans", fontWeight: FontWeight.w500, fontSize: 14, color: isActive ? AppColors.blue700 : AppColors.slate600)),
        ],
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
              Icon(Icons.grid_view, color: AppColors.blue700, size: 16),
              SizedBox(width: 8),
              Text("Tiện ích chung", style: TextStyle(fontFamily: "Public Sans", fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.blue700)),
            ],
          ),
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
    );
  }
}