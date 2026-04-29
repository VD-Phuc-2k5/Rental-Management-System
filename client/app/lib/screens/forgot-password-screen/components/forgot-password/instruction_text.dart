import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class InstructionText extends StatelessWidget {

  const InstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          'Quên mật khẩu?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
            color: AppColors.black
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Đừng lo lắng! Vui lòng nhập số điện thoại hoặc email đã đăng ký để nhận mã OTP xác thực.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.slate500,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}