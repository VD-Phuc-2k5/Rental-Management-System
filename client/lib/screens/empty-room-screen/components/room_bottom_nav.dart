import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class RoomBottomNav extends StatelessWidget {
  const RoomBottomNav({super.key});

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? AppColors.blue700 : AppColors.slate500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10,
              color: isActive ? AppColors.blue700 : AppColors.slate500,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 48,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.blue700,
                borderRadius: BorderRadius.circular(9999),
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.slate200, width: 1.0)),
      ),
      child: Row(
        children: [
          _buildNavItem(Icons.grid_view, "Nhà trọ", false),
          _buildNavItem(Icons.door_front_door_outlined, "Phòng", true),
          _buildNavItem(Icons.check_circle_outline, "Yêu cầu", false),
          _buildNavItem(Icons.receipt_long_outlined, "Hóa đơn", false),
          _buildNavItem(Icons.account_circle_outlined, "Hồ sơ", false),
        ],
      ),
    );
  }
}