import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class ContractPreviewFileCard extends StatelessWidget {
  final ImageProvider previewImage;
  const ContractPreviewFileCard({super.key, required this.previewImage});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderRow(),
            SizedBox(height: 12),
            _PreviewArea(image: previewImage),
            SizedBox(height: 10),
            _FileMetaRow(),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Bản xem trước hợp đồng',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A202C),
              fontSize: 16,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.slate100,
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Chưa ký',
            style: TextStyle(
              color: AppColors.slate600,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _PreviewArea extends StatelessWidget {
  final ImageProvider image;
  const _PreviewArea({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
            const Center(child: _EyeButton()),
          ],
        ),
      ),
    );
  }
}

class _EyeButton extends StatelessWidget {
  const _EyeButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF195AA4)),
    );
  }
}


class _FileMetaRow extends StatelessWidget {
  const _FileMetaRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Text(
            'HD-2026-0301-A301.pdf',
            style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400,fontSize: 12),
          ),
        ),
        Text(
          '2.4 MB',
          style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400,fontSize: 12),
        ),
      ],
    );
  }
}