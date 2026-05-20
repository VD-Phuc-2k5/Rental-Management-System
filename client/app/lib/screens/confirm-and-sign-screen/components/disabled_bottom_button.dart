import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class DisabledBottomButton extends StatelessWidget {
  final String text;
  const DisabledBottomButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.gray25,
        border: Border(
          top: BorderSide(
            color: AppColors.slate200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.slate200,
              disabledBackgroundColor: AppColors.slate200,
              disabledForegroundColor: AppColors.slate400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              elevation: 0,
            ),
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}