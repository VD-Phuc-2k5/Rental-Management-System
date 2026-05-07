import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class VerifyingIndicator extends StatelessWidget {
  const VerifyingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 96,
          height: 96,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: 96,
                height: 96,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation(AppColors.blue100),
                ),
              ),
               Transform.rotate(
                angle: -math.pi / 2,
                child: const SizedBox(
                  width: 96,
                  height: 96,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation(AppColors.blue700),
                  ),
                ),
              ),
              const Icon(Icons.hourglass_empty_rounded, color: AppColors.blue700, size: 28),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Đang xác nhận giao dịch...',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF1A202C),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Hệ thống đang kiểm tra giao dịch của bạn. Quá\ntrình này có thể mất từ 1-3 phút. Vui lòng không\nthoát màn hình.',
          style: TextStyle(
            color: AppColors.slate500,
            height: 1.25,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}