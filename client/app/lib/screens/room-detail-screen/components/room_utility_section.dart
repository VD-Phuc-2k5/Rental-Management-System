import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class UtilityItem {
  final IconData icon;
  final String label;

  const UtilityItem({
    required this.icon,
    required this.label,
  });
}

final List<UtilityItem> utilities = [
  UtilityItem(icon: Icons.wifi, label: 'Wi-Fi'),
  UtilityItem(icon: Icons.ac_unit, label: 'Điều hòa'),
  UtilityItem(icon: Icons.local_parking, label: 'Bãi đỗ xe'),
  UtilityItem(icon: Icons.hot_tub, label: 'Bình nóng lạnh'),
];

class RoomUtilitySection extends StatelessWidget {
  const RoomUtilitySection({ super.key });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiện ích',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: utilities.map((utility) {
            return Expanded(
              child: _buildUtilityItem(utility.icon, utility.label),
            );
          }).toList(),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: 1,
          color: AppColors.slate200,
        ),
      ],
    );
  }

  Widget _buildUtilityItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.slate100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 24,
            color: AppColors.blue700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.slate500,
          ),
        ),
      ],
    );
  }
}