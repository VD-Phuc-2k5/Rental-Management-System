import 'package:app/core/constants.dart';
import 'package:app/screens/tenant-invoice-detail-screen/components/invoice_detail_models.dart';
import 'package:flutter/material.dart';

class InvoicePaymentInfo extends StatelessWidget {
  final InvoicePaymentInfoData paymentInfo;

  const InvoicePaymentInfo({super.key, required this.paymentInfo});

  @override
  Widget build(BuildContext context) {
    const invoiceDetailLabelStyle = TextStyle(
      color: AppColors.blue950,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );

    const invoiceDetailInfoLabelStyle = TextStyle(
      color: AppColors.slate500,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );

    const invoiceDetailInfoStyle = TextStyle(
      color: AppColors.blue950,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        const Text('Thông tin thanh toán', style: invoiceDetailLabelStyle),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: AppColors.blue700),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            spacing: 32.0,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16.0,
                children: [
                  const Text('Phương thức', style: invoiceDetailInfoLabelStyle),
                  Text(
                    paymentInfo.paymentMethod,
                    style: invoiceDetailInfoStyle,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16.0,
                children: [
                  const Text(
                    'Ngày tạo hóa đơn',
                    style: invoiceDetailInfoLabelStyle,
                  ),
                  Text(paymentInfo.createdDate, style: invoiceDetailInfoStyle),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16.0,
                children: [
                  const Text(
                    'Mã giao dịch',
                    style: invoiceDetailInfoLabelStyle,
                  ),
                  Text(
                    paymentInfo.transactionId,
                    style: invoiceDetailInfoStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
