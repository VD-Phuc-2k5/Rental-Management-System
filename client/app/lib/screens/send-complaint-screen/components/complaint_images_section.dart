import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class ComplaintImagesSection extends StatelessWidget {
  const ComplaintImagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hình ảnh minh chứng',
          style: TextStyle(
            color: AppColors.gray800,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _UploadBox(onPressed: null)),
            SizedBox(width: 12),
            Expanded(child: _UploadBox(onPressed: null)),
            SizedBox(width: 12),
            Expanded(child: _UploadBox(onPressed: null)),
          ],
        ),
        SizedBox(height: 10),
        Padding(
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
  const _UploadBox({this.onPressed});
  final VoidCallback? onPressed;

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