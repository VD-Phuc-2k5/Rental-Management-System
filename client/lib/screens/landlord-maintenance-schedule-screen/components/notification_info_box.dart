import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class NotificationInfoBox extends StatelessWidget {
  final String roomNumber;

  const NotificationInfoBox({super.key, required this.roomNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: AppColors.blue200.withAlpha(102), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          const Icon(Icons.info_outline, color: AppColors.blue700, size: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.0,
              children: [
                const Text(
                  "Thông báo cho khách thuê",
                  style: TextStyle(
                    color: AppColors.blue950,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Hệ thống sẽ tự động gửi thông báo xác nhận lịch sửa chữa đến khách thuê $roomNumber qua ứng dụng ngay khi bạn lưu.",
                  style: const TextStyle(
                    color: AppColors.slate600,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.5,
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
