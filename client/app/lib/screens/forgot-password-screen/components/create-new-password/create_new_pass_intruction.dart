import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class CreateNewPassIntruction extends StatelessWidget {

  const CreateNewPassIntruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Tạo mật khẩu mới',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Vui lòng thiết lập mật khẩu an toàn',
          style: const TextStyle(
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
