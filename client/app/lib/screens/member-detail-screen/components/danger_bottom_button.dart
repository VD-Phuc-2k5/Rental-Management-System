import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class DangerBottomButton extends StatelessWidget {
  const DangerBottomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false, // Mặc định là không xoay
  });

  final String text;
  final VoidCallback? onPressed; // Thêm tham số nhận sự kiện
  final bool isLoading; // Thêm tham số trạng thái loading

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grayBackground,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton.icon(
            // Nếu đang loading thì khóa nút (trả về null), ngược lại thì gọi onPressed
            onPressed: isLoading ? null : onPressed,

            // Nếu đang loading thì hiện vòng xoay, ngược lại hiện Icon thùng rác/xóa
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.person_remove_alt_1_outlined,
                    color: AppColors.white,
                  ),

            label: Text(
              isLoading ? 'Đang xử lý...' : text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red500,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              // Tùy chỉnh màu khi nút bị khóa (lúc đang loading)
              disabledBackgroundColor: AppColors.red500.withValues(alpha: 0.6),
              disabledForegroundColor: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
