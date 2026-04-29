import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class BottomActionBar extends StatelessWidget {
  final VoidCallback? onNext;
  final bool isLoading;
  final bool hasErrors;

  const BottomActionBar({
    super.key,
    this.onNext,
    this.isLoading = false,
    this.hasErrors = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool canProceed = !hasErrors && !isLoading && onNext != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.slate200)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: canProceed ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canProceed ? AppColors.blue700 : AppColors.blue300,
                disabledBackgroundColor: AppColors.blue300,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.white,
                        ),
                      )
                      : const Text(
                        'Tiếp theo',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
            ),
          ),
          if (hasErrors) ...[
            const SizedBox(height: 6),
            const Text(
              'Vui lòng sửa lỗi để tiếp tục',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.slate500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
