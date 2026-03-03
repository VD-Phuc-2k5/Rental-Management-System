import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class InfoNoticeBanner extends StatelessWidget {
  const InfoNoticeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.blue700.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blue700.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline_rounded, color: AppColors.blue700),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Vui lòng chuyển đúng số tiền và nội dung\nđể hệ thống xác nhận tự động nhanh nhất.',
              style: TextStyle(
                color: AppColors.slate700,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}