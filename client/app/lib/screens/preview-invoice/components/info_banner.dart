import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class InfoBanner extends StatelessWidget {
  final String message;

  const InfoBanner({
    super.key,
    this.message =
        'Hệ thống đã tự động tính toán dựa theo hợp đồng từng phòng. Kiểm tra và gửi khi sẵn sàng.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.blue700.withAlpha(10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blue100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: AppColors.blue700, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.slate700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
