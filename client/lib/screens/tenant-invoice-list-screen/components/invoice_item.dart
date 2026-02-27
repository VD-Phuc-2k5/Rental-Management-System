import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:flutter/material.dart';

class InvoiceItem extends StatelessWidget {
  final String billingMonth;
  final String paidAt;
  final int amount;
  final String statusLabel;
  final bool isPaid;
  final VoidCallback? onTap;

  const InvoiceItem({
    super.key,
    required this.billingMonth,
    required this.paidAt,
    required this.amount,
    required this.statusLabel,
    required this.isPaid,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const invoiceLabelStyle = TextStyle(
      color: AppColors.blue950,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );

    const invoiceInfoStyle = TextStyle(
      color: AppColors.slate500,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    final Color statusBackground = isPaid ? AppColors.green50 : AppColors.red50;
    final Color statusColor = isPaid ? AppColors.green600 : AppColors.red600;
    final IconData statusIcon = isPaid
        ? Icons.check_circle_outline
        : Icons.error_outline;

    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(width: 1.0, color: AppColors.slate100),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha(13),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.slate50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tháng $billingMonth', style: invoiceLabelStyle),
                    Text(paidAt, style: invoiceInfoStyle),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatVND(amount), style: invoiceLabelStyle),
                Container(
                  color: statusBackground,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  child: Row(
                    spacing: 4.0,
                    children: [
                      Icon(statusIcon, size: 10, color: statusColor),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
