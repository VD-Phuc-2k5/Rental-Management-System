import 'package:app/core/collapse_text.dart';
import 'package:app/core/constants.dart';
import 'package:app/core/models/maintenance_request.dart';
import 'package:flutter/material.dart';

class RequestDetailSection extends StatelessWidget {
  final MaintenanceRequest request;
  const RequestDetailSection({super.key, required this.request});

  Widget _buildRequestHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1.0, color: AppColors.slate200),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              spacing: 4.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.title,
                  style: const TextStyle(
                    color: AppColors.blue950,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  request.location,
                  style: const TextStyle(
                    color: AppColors.slate400,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(
              request.imageUrls.isNotEmpty
                  ? request.imageUrls.first
                  : "assets/images/empty-image.jpg",
              width: 96,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 96,
                  decoration: BoxDecoration(
                    color: AppColors.slate200,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppColors.slate500,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1.0, color: AppColors.slate200),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          const Text(
            "Sự cố",
            style: TextStyle(
              color: AppColors.blue950,
              fontFamily: "Inter",
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          if (request.imageUrls.isNotEmpty)
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: request.imageUrls.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      request.imageUrls[index],
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: AppColors.slate200,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.slate500,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              const Text(
                "Mô tả chi tiết sự cố",
                style: TextStyle(
                  color: AppColors.blue950,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              CollapsibleText(
                text: request.description,
                maxLines: 3,
                style: const TextStyle(fontSize: 14, color: AppColors.slate500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      children: [_buildRequestHeader(), _buildIncidentSection()],
    );
  }
}
