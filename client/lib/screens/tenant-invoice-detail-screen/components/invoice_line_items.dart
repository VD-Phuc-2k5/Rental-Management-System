import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:app/screens/tenant-invoice-detail-screen/components/invoice_detail_models.dart';
import 'package:flutter/material.dart';

class InvoiceLineItems extends StatelessWidget {
  final List<InvoiceLineItemData> items;

  const InvoiceLineItems({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const invoiceDetailLabelStyle = TextStyle(
      color: AppColors.blue950,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );

    const invoiceDetailTextStyle = TextStyle(
      color: AppColors.blue950,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
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
        const Text('Chi tiết các khoản phí', style: invoiceDetailLabelStyle),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.slate50,
            border: Border.all(width: 1.0, color: AppColors.blue700),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            spacing: 32.0,
            children: items.map((item) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16.0,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: invoiceDetailTextStyle),
                        if (item.description != null)
                          Text(
                            item.description!,
                            style: invoiceDetailHelpTextStyle,
                          ),
                      ],
                    ),
                  ),
                  Text(formatVND(item.amount), style: invoiceDetailLabelStyle),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
