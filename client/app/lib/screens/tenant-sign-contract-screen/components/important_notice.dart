import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class ImportantNoticeCard extends StatelessWidget {
  const ImportantNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blue700.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.blue700.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue700.withValues(alpha: 0.2),
            ),
            child: const Icon(Icons.notifications_none_rounded, color: AppColors.blue700),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông báo quan trọng',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.blue950,fontSize: 16),
                ),
                SizedBox(height: 2),
                Text(
                  'Bạn có một hợp đồng thuê nhà mới cần\nxem xét và ký tên.',
                  style: TextStyle(color: AppColors.slate600, fontSize: 14,fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}