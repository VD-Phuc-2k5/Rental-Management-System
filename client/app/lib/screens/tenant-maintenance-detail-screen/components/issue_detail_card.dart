import 'package:flutter/material.dart';
import '../../../core/constants.dart';

import '../../../core/models/maintenance_request.dart';
class IssueDetailCard extends StatelessWidget {
  const IssueDetailCard({
    super.key,
    required this.request,
  });

  final MaintenanceRequest request;

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
            Container(
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
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Vị trí sự cố',
                    style: TextStyle(
                      color: AppColors.blue950,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    request.location.isNotEmpty ? request.location : 'Chưa xác định',
                    style: const TextStyle(
                      color: AppColors.slate600,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: AppColors.gray50,
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: AppColors.gray100),
            //   ),
            //   child:  Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Mô tả chi tiết sự cố',
            //         style: TextStyle(
            //           color: AppColors.blue950,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       SizedBox(height: 6),
            //       Text(
            //         request.description.isNotEmpty
            //             ? request.description
            //             : 'Chưa có mô tả chi tiết',
            //         style: const TextStyle(
            //           color: AppColors.slate600,
            //           fontWeight: FontWeight.w400,
            //           height: 1.25,
            //         ),
            //       ),
            //       const SizedBox(height: 10),
            //       const Text(
            //         'Vị trí sự cố',
            //         style: TextStyle(
            //           color: AppColors.blue950,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       const SizedBox(height: 6),
            //       Text(
            //         request.location.isNotEmpty ? request.location : 'Chưa xác định',
            //         style: const TextStyle(
            //           color: AppColors.slate600,
            //           fontWeight: FontWeight.w400,
            //           height: 1.25,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

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
        width: 52,
        height: 114,
        color: AppColors.slate100,
        child: imageWidget,
      ),
    );
  }
}