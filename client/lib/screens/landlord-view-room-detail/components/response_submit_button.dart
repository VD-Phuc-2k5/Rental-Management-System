import 'package:app/core/constants.dart';
import 'package:app/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ResponseSubmitButton extends StatelessWidget {
  final VoidCallback? onReject;
  final VoidCallback? onConfirm;
  final bool isLoading;

  const ResponseSubmitButton({
    super.key,
    this.onReject,
    this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: isLoading ? null : onReject,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.red500, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                backgroundColor: AppColors.white,
              ),
              child: const Text(
                'Từ chối',
                style: TextStyle(
                  color: AppColors.red500,
                  fontSize: 16,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButton(
            label: 'Xác nhận',
            onPressed: onConfirm,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}