import 'package:app/core/constants.dart';
import 'package:app/screens/tenant-invoice-detail-screen/components/invoice_detail_models.dart';
import 'package:flutter/material.dart';

class InvoiceActions extends StatelessWidget {
  final InvoiceStatus status;
  final VoidCallback? onPayNow;
  final VoidCallback? onDownloadPDF;

  const InvoiceActions({
    super.key,
    required this.status,
    this.onPayNow,
    this.onDownloadPDF,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPaid = status == InvoiceStatus.paid;

    if (isPaid) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(width: 1.0, color: AppColors.slate700),
          ),
        ),
        onPressed: onDownloadPDF,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            Icon(Icons.picture_as_pdf, color: AppColors.slate700),
            Text(
              'Tải PDF',
              style: TextStyle(
                color: AppColors.slate700,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(width: 1.0, color: AppColors.slate700),
        ),
      ),
      onPressed: onPayNow,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.0,
        children: [
          Icon(Icons.picture_as_pdf, color: AppColors.slate700),
          Text(
            'Thanh toán ngay',
            style: TextStyle(
              color: AppColors.slate700,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
