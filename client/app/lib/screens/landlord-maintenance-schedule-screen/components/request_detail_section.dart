import '../../../core/collapse_text.dart';
import '../../../core/constants.dart';
import '../../../core/models/maintenance_request.dart';
import 'package:flutter/material.dart';

class RequestDetailSection extends StatelessWidget {
  const RequestDetailSection({super.key, required this.request});
  final MaintenanceRequest request;

  bool get _isComplaint => request.status == RequestStatus.complaint;

  /// Tách nội dung khiếu nại ra khỏi description tổng hợp.
  /// Backend ghép: "{original}\n\n--- Khiếu nại ---\n\n{complaint}"
  ({String original, String? complaint}) get _parsedDescription {
    const separator = '--- Khiếu nại ---';
    final parts = request.description.split(separator);
    if (parts.length >= 2) {
      return (
        original: parts[0].trim(),
        complaint: parts.sublist(1).join(separator).trim(),
      );
    }
    return (original: request.description.trim(), complaint: null);
  }

  Widget _buildImage(String? path, {double? width, double? height}) {
    final placeholder = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.slate200,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: const Icon(Icons.image_not_supported, color: AppColors.slate500),
    );

    if (path == null) return placeholder;

    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      );
    }

    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }

  Widget _buildRequestHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          width: 1.0,
          color: _isComplaint ? AppColors.red100 : AppColors.slate200,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6.0,
              children: [
                if (_isComplaint)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.report_gmailerrorred_outlined,
                          size: 13,
                          color: AppColors.red500,
                        ),
                        Text(
                          'Đang có khiếu nại',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.red500,
                          ),
                        ),
                      ],
                    ),
                  ),
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
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: _buildImage(
              request.imageUrls.isNotEmpty ? request.imageUrls.first : null,
              width: 88,
              height: 88,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentSection() {
    final parsed = _parsedDescription;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1.0, color: AppColors.slate200),
        borderRadius: BorderRadius.circular(8.0),
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
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: _buildImage(
                    request.imageUrls[index],
                    width: 120,
                    height: 120,
                  ),
                ),
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
                text: parsed.original.isNotEmpty
                    ? parsed.original
                    : 'Chưa có mô tả',
                maxLines: 3,
                style: const TextStyle(fontSize: 14, color: AppColors.slate500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintSection() {
    final parsed = _parsedDescription;
    final complaintText = parsed.complaint ?? '';
    final hasImages = request.complaintImageUrls.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        border: Border.all(width: 1.0, color: AppColors.red100),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(10),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          const Row(
            spacing: 6,
            children: [
              Icon(
                Icons.report_gmailerrorred_outlined,
                size: 18,
                color: AppColors.red500,
              ),
              Text(
                "Khiếu nại từ khách thuê",
                style: TextStyle(
                  color: AppColors.red500,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (hasImages)
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: request.complaintImageUrls.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: _buildImage(
                    request.complaintImageUrls[index],
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
            ),
          if (complaintText.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                const Text(
                  "Nội dung khiếu nại",
                  style: TextStyle(
                    color: AppColors.red500,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                CollapsibleText(
                  text: complaintText,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.slate600,
                    height: 1.4,
                  ),
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
      children: [
        _buildRequestHeader(),
        _buildIncidentSection(),
        if (_isComplaint) _buildComplaintSection(),
      ],
    );
  }
}
