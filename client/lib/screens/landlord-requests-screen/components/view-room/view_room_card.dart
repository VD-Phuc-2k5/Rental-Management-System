import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ViewRoomCard extends StatelessWidget {
  final String tenantName;
  final String phoneNumber;
  final String roomInfo;
  final String scheduledDate;
  final String? note;
  final String status;
  final VoidCallback onTap;

  const ViewRoomCard({
    super.key,
    required this.tenantName,
    required this.phoneNumber,
    required this.roomInfo,
    required this.scheduledDate,
    required this.onTap,
    this.note,
    this.status = 'Chờ xử lý',
  });

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    final parts = trimmed
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return '?';
    }
    if (parts.length >= 2) {
      final secondLast = parts[parts.length - 2];
      final last = parts[parts.length - 1];
      if (secondLast.isEmpty || last.isEmpty) {
        return '?';
      }
      return '${secondLast[0]}${last[0]}'.toUpperCase();
    }
    final firstPart = parts[0];
    return firstPart.isNotEmpty ? firstPart[0].toUpperCase() : '?';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ xử lý':
        return AppColors.amber500;
      case 'Đã xác nhận':
        return AppColors.green600;
      case 'Đã huỷ':
        return AppColors.red600;
      default:
        return AppColors.slate500;
    }
  }

  Color _getStatusBackground(String status) {
    switch (status) {
      case 'Chờ xử lý':
        return AppColors.yellow100;
      case 'Đã xác nhận':
        return AppColors.green100;
      case 'Đã huỷ':
        return AppColors.red100;
      default:
        return AppColors.slate100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blue50,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _getInitials(tenantName),
                  style: const TextStyle(
                    color: AppColors.blue700,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenantName,
                      style: const TextStyle(
                        color: AppColors.slate900,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      phoneNumber,
                      style: const TextStyle(
                        color: AppColors.slate500,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusBackground(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.meeting_room_outlined,
            text: roomInfo,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.calendar_month_outlined,
            text: scheduledDate,
          ),
          if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.description_outlined,
              text: note!,
              textColor: AppColors.slate500,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;

  const _InfoRow({required this.icon, required this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.slate500,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '"$text"',
            style: TextStyle(
              color: textColor ?? AppColors.black,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
