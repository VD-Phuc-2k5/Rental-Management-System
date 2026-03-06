import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class ComplaintImagesSection extends StatelessWidget {
  const ComplaintImagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hình ảnh minh chứng',
          style: TextStyle(
            color: AppColors.gray800,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: _UploadBox(onPressed: null)),
            SizedBox(width: 12),
            const Expanded(child: _UploadBox(onPressed: null)),
            SizedBox(width: 12),
            const Expanded(child: _UploadBox(onPressed: null)),
          ],
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 10),
          child: Text(
            '* Tải lên tối đa 3 ảnh minh chứng tình trạng hiện tại.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadBox extends StatelessWidget {
  final VoidCallback? onPressed;
  const _UploadBox({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.white),
          ),
          child: const Center(
            child: Icon(Icons.add, size: 30, color: AppColors.gray400),
          ),
        ),
      ),
    );
  }
}