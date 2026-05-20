import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class IssueDetailCard extends StatelessWidget {
  final String issueImage1;
  final String issueImage2;
  const IssueDetailCard({
    super.key,
    required this.issueImage1,
    required this.issueImage2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sự cố',
              style: TextStyle(
                color: AppColors.blue950,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _PhotoTile(assetPath: issueImage1),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _PhotoTile(assetPath: issueImage2),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray100),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mô tả chi tiết sự cố',
                    style: TextStyle(
                      color: AppColors.blue950,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '"Nước bị rò rỉ. Nước chảy liên tục ở bồn rửa\nmặt"',
                    style: TextStyle(
                      color: AppColors.slate600,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String assetPath;
  const _PhotoTile({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 52,
        height: 114,
        color: AppColors.slate100,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.image_not_supported_outlined, color: AppColors.slate500),
          ),
        ),
      ),
    );
  }
}