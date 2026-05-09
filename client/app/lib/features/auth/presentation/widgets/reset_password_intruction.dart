import 'package:core/constants.dart';
import 'package:flutter/material.dart';

class ResetPasswordIntruction extends StatelessWidget {
  const ResetPasswordIntruction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Tạo mật khẩu mới',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Vui lòng thiết lập mật khẩu an toàn',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Liberation Sans',
            color: AppColors.slate500,
          ),
        ),
      ],
    );
  }
}
