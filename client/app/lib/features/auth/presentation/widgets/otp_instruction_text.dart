import 'package:core/constants.dart';
import 'package:flutter/material.dart';

class OtpInstructionText extends StatelessWidget {
  const OtpInstructionText({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Nhập mã OTP',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito',
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.slate500,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w400,
              ),
              children: [
                const TextSpan(text: 'Mã đã gửi đến '),
                TextSpan(
                  text: email,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue700,
                    fontFamily: 'Noto Sans',
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
