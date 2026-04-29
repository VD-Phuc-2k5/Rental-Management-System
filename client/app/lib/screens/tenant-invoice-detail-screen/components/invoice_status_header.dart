import 'package:app/core/constants.dart';
import 'package:app/screens/tenant-invoice-detail-screen/components/invoice_detail_models.dart';
import 'package:flutter/material.dart';

class InvoiceStatusHeader extends StatelessWidget {
  final InvoiceStatus status;

  const InvoiceStatusHeader({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isPaid = status == InvoiceStatus.paid;
    final Color backgroundColor = isPaid
        ? AppColors.green50
        : AppColors.yellow50;
    final Color borderColor = isPaid ? AppColors.green200 : AppColors.orange100;
    final Color iconColor = isPaid ? AppColors.green600 : AppColors.yellow600;
    final Color textColor = isPaid ? AppColors.green600 : AppColors.yellow600;
    final IconData icon = isPaid ? Icons.check_circle : Icons.schedule;
    final String statusText = isPaid ? 'Đã thanh toán' : 'Chờ thanh toán';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(width: 1.0, color: borderColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(icon, size: 40, color: AppColors.white),
          ),
          Text(
            statusText,
            style: TextStyle(
              color: textColor,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
