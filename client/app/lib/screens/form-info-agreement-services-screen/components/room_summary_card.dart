import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class RoomSummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const RoomSummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blue700.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue700.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF6B7280),fontWeight: FontWeight.w400, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE5E7EB),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/room_tick.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}