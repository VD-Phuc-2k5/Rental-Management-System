import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class OtpInstructionText extends StatelessWidget {
  final String contact;

  const OtpInstructionText({super.key, required this.contact});

  String get _maskedContact {
    if (contact.length < 2) return contact;
    final prefix = contact.substring(0, 2);
    final remaining = contact.length - 2;
    if (remaining <= 0) return prefix;
    if (contact.length == 10) return '${prefix}xx-xxx-xxx';
    return prefix + 'x' * remaining;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                text: _maskedContact,
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
    );
  }
}
