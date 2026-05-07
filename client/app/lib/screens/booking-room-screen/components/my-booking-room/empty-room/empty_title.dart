import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class EmptyTitle extends StatelessWidget {
  const EmptyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Bạn chưa có lịch hẹn nào",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: AppColors.slate900,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Hãy tìm kiếm và đặt lịch xem phòng ngay để tìm được nơi ở ưng ý nhất.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.slate500,
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}