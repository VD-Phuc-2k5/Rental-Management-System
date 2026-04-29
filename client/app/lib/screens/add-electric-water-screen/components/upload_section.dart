import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class UploadSection extends StatelessWidget {
  /// Callback khi người dùng nhấn "Chọn file".
  /// Nhận path file được chọn (null nếu huỷ).
  final ValueChanged<String?>? onFilePicked;

  /// Tên file đã chọn (hiển thị khi đã pick xong)
  final String? selectedFileName;

  /// Đang upload / xử lý
  final bool isLoading;

  const UploadSection({
    super.key,
    this.onFilePicked,
    this.selectedFileName,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue300,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          // Icon upload
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.blue100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              color: AppColors.blue700,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),

          // Mô tả
          Text(
            selectedFileName != null
                ? selectedFileName!
                : 'Upload file Excel vào đây',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:
                  selectedFileName != null
                      ? AppColors.blue700
                      : AppColors.slate700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),

          // Nút chọn file
          OutlinedButton(
            onPressed: isLoading ? null : () => onFilePicked?.call(null),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.blue700,
              side: const BorderSide(color: AppColors.blue700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child:
                isLoading
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text(
                      'Chọn file',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
