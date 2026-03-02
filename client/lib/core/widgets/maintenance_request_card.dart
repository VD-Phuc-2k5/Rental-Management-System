import "package:app/core/collapse_text.dart";
import "package:app/core/constants.dart";
import "package:app/core/models/maintenance_request.dart";
import "package:app/screens/tenant-maintenance-request-screen/components/priority_selector.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class MaintenanceRequestCard extends StatelessWidget {
  final MaintenanceRequest request;
  final VoidCallback? onTap;
  final Widget? actionButton;

  const MaintenanceRequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.slate200),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 2,
              color: AppColors.black.withAlpha(13),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.0,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.0,
                    children: [
                      _buildPriorityBadge(),
                      Text(
                        request.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate900,
                        ),
                      ),
                      Text(
                        request.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.blue700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CollapsibleText(
                        text: request.description,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (request.imageUrl != null) ...[
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      request.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.slate200,
                            borderRadius: BorderRadius.circular(8),
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.slate400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimeAgo(request.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.slate400,
                      ),
                    ),
                  ],
                ),
                if (actionButton != null)
                  actionButton!
                else
                  _buildStatusBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge() {
    Color badgeColor;
    String label;

    switch (request.priority) {
      case Priority.low:
        badgeColor = AppColors.blue700;
        label = "THẤP";
        break;
      case Priority.medium:
        badgeColor = AppColors.yellow600;
        label = "TRUNG BÌNH";
        break;
      case Priority.high:
        badgeColor = AppColors.red500;
        label = "KHẨN CẤP";
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: badgeColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: badgeColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color textColor;
    Color backgroundColor;
    String label;

    switch (request.status) {
      case RequestStatus.pending:
        textColor = AppColors.orange600;
        backgroundColor = AppColors.orange100;
        label = "Chờ xử lý";
        break;
      case RequestStatus.processing:
        textColor = AppColors.blue700;
        backgroundColor = AppColors.blue100;
        label = "Đang xử lý";
        break;
      case RequestStatus.completed:
        textColor = AppColors.green600;
        backgroundColor = AppColors.green100;
        label = "Hoàn thành";
        break;
      case RequestStatus.rejected:
        textColor = AppColors.red500;
        backgroundColor = AppColors.red100;
        label = "Từ chối";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Vừa xong";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} phút trước";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} giờ trước";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} ngày trước";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} tuần trước";
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }
}
