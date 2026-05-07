import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:flutter/material.dart';

enum TransactionStatus { paid, pending }

class TransactionListItem extends StatelessWidget {
  final String roomName;
  final String tenantName;
  final String paymentMethod;
  final String timeOrDeadline;
  final int amount;
  final TransactionStatus status;

  const TransactionListItem({
    super.key,
    required this.roomName,
    required this.tenantName,
    required this.paymentMethod,
    required this.timeOrDeadline,
    required this.amount,
    required this.status,
  });

  bool get _isPaid => status == TransactionStatus.paid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _LeadingIcon(isPaid: _isPaid),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$roomName - $tenantName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate900,
                    fontFamily: "Inter",
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _isPaid
                      ? '$paymentMethod \u2022 $timeOrDeadline'
                      : 'Hạn: $timeOrDeadline',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                    fontFamily: "Inter",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatVND(amount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900,
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _isPaid ? AppColors.green100 : AppColors.orange100,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle_rounded,
                      size: 6,
                      color: _isPaid ? AppColors.green600 : AppColors.orange500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isPaid ? 'Đã thanh toán' : 'Chờ thanh toán',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color:
                            _isPaid ? AppColors.green600 : AppColors.orange500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final bool isPaid;

  const _LeadingIcon({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    if (isPaid) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.blue50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.qr_code_2_rounded,
          color: AppColors.blue500,
          size: 24,
        ),
      );
    }
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.orange100,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.pending_outlined,
        color: AppColors.orange500,
        size: 24,
      ),
    );
  }
}
