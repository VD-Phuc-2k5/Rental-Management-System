import '../../../core/constants.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
  });
  final VoidCallback onPressed;
  final String label;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue600,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          disabledBackgroundColor: AppColors.slate300,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
