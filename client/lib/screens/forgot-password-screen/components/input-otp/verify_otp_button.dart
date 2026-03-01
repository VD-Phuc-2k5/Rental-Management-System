import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class VerifyOtpButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const VerifyOtpButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColors.blue700 : AppColors.slate300,
          foregroundColor: Colors.white,
          elevation: isEnabled ? 6 : 0,
          shadowColor: Colors.black.withValues(alpha: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Xác nhận',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
