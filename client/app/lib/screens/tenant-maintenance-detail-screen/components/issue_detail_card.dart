import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/models/maintenance_request.dart';

class IssueDetailCard extends StatelessWidget {
  const IssueDetailCard({super.key, required this.request});

  final MaintenanceRequest request;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: title + location
            const Text(
              'Sự cố',
              style: TextStyle(
                color: AppColors.blue950,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            if (request.location.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.slate400,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.location,
                      style: const TextStyle(
                        color: AppColors.slate400,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Photos
            Row(
              children: [
                Expanded(
                  child: _PhotoTile(
                    imagePath: request.imageUrls.isNotEmpty
                        ? request.imageUrls.first
                        : 'assets/images/empty-image.jpg',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PhotoTile(
                    imagePath: request.imageUrls.length > 1
                        ? request.imageUrls[1]
                        : 'assets/images/empty-image.jpg',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mô tả chi tiết sự cố',
                    style: TextStyle(
                      color: AppColors.blue950,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    request.description.isNotEmpty
                        ? request.description
                        : 'Chưa có mô tả chi tiết',
                    style: const TextStyle(
                      color: AppColors.slate600,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      fontSize: 13,
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
  const _PhotoTile({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final imageWidget = imagePath.startsWith('http')
        ? Image.network(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.slate500,
              ),
            ),
          )
        : Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.slate500,
              ),
            ),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 114,
        color: AppColors.slate100,
        child: imageWidget,
      ),
    );
  }
}
