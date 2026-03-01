import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class TenantCccdUploadSection extends StatelessWidget {
  const TenantCccdUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF647487),
            ),
            children: [
              TextSpan(text: 'Ảnh CCCD '),
              TextSpan(
                text: '*',
                style: TextStyle(color: Color(0xFFE53935)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Expanded(child: _UploadBox(title: 'Mặt trước')),
            SizedBox(width: 12),
            Expanded(child: _UploadBox(title: 'Mặt sau')),
          ],
        ),
      ],
    );
  }
}

class _UploadBox extends StatelessWidget {
  final String title;
  const _UploadBox({required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.slate300),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x19195AA4),
              ),
              child: const Icon(Icons.add, color: Color(0xFF195AA4)),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Color(0xFF647487))),
          ],
        ),
      ),
    );
  }
}