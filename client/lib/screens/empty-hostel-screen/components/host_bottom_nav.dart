import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class HostBottomNav extends StatelessWidget {
  const HostBottomNav({super.key});

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    final color = isActive ? AppColors.blue700 : AppColors.slate500;

    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isActive)
            Positioned(
              top: 0,
              child: Container(
                width: 48,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.blue700,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: "Noto Sans",
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 10,
                  height: 1.5,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.slate200, width: 1.0)),
      ),
      child: Row(
        children: [
          _buildNavItem(
            icon: Icons.grid_view,
            label: "Nhà trọ",
            isActive: true,
          ),
          _buildNavItem(
            icon: Icons.door_front_door_outlined,
            label: "Phòng",
            isActive: false,
          ),
          _buildNavItem(
            icon: Icons.check_circle_outline,
            label: "Yêu cầu",
            isActive: false,
          ),
          _buildNavItem(
            icon: Icons.receipt_long_outlined,
            label: "Hóa đơn",
            isActive: false,
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            label: "Hồ sơ",
            isActive: false,
          ),
        ],
      ),
    );
  }
}
