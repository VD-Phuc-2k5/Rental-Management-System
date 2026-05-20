import 'package:app/core/constants.dart';
import 'package:app/screens/tenant-invoice-detail-screen/components/invoice_detail_models.dart';
import 'package:flutter/material.dart';

class InvoiceGeneralInfo extends StatelessWidget {
  final InvoiceGeneralInfoData info;

  const InvoiceGeneralInfo({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    const invoiceDetailLabelStyle = TextStyle(
      color: AppColors.blue950,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );

    const invoiceDetailHelpTextStyle = TextStyle(
      color: Color.fromRGBO(148, 163, 184, 1),
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        const Text('Thông tin chung', style: invoiceDetailLabelStyle),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.slate50,
            border: Border.all(width: 1.0, color: AppColors.blue700),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            spacing: 16.0,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColors.blue700.withAlpha(13),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.apartment,
                  color: AppColors.blue700,
                  size: 30,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.roomName, style: invoiceDetailLabelStyle),
                  Text(
                    'Chủ trọ: ${info.landlordName}',
                    style: invoiceDetailHelpTextStyle,
                  ),
                  Text(
                    '• Tháng ${info.billingMonth}',
                    style: invoiceDetailHelpTextStyle,
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
