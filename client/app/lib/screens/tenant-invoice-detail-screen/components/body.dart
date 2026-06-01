import 'invoice_actions.dart';
import 'invoice_detail_models.dart';
import 'invoice_general_info.dart';
import 'invoice_line_items.dart';
import 'invoice_payment_info.dart';
import 'invoice_status_header.dart';
import 'invoice_total_summary.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {

  const Body({
    super.key,
    this.invoice = const InvoiceDetailData(
      id: '',
      status: InvoiceStatus.pending,
      generalInfo: InvoiceGeneralInfoData(
        roomName: 'Phòng 302 - Nhà Trọ Xanh',
        landlordName: 'Nguyễn văn A',
        billingMonth: '10/2023',
      ),
      lineItems: [
        InvoiceLineItemData(
          name: 'Tiền phòng',
          description: 'Cố định hàng tháng',
          amount: 3500000,
        ),
        InvoiceLineItemData(
          name: 'Tiền điện',
          description: '230 số (1240 - 1470) x 3.500đ',
          amount: 805000,
        ),
        InvoiceLineItemData(
          name: 'Tiền nước',
          description: '5m³ x 20.000đ',
          amount: 100000,
        ),
        InvoiceLineItemData(
          name: 'Phí dịch vụ',
          description: 'Internet, vệ sinh',
          amount: 150000,
        ),
      ],
      totalAmount: 4555000,
      paymentInfo: InvoicePaymentInfoData(
        paymentMethod: 'Chuyển khoản ngân hàng',
        createdDate: '28/10/2023',
        transactionId: 'INV-202310-302',
      ),
    ),
    this.onPayNow,
    this.onDownloadPDF,
  });
  final InvoiceDetailData invoice;
  final VoidCallback? onPayNow;
  final VoidCallback? onDownloadPDF;

  @override
  Widget build(BuildContext context) {
    final bool isPaid = invoice.status == InvoiceStatus.paid;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 24.0,
          children: [
            InvoiceStatusHeader(status: invoice.status),
            InvoiceGeneralInfo(info: invoice.generalInfo),
            InvoiceLineItems(items: invoice.lineItems),
            InvoiceTotalSummary(totalAmount: invoice.totalAmount),
            if (isPaid && invoice.paymentInfo != null)
              InvoicePaymentInfo(paymentInfo: invoice.paymentInfo!),
            InvoiceActions(
              status: invoice.status,
              onPayNow: onPayNow,
              onDownloadPDF: onDownloadPDF,
            ),
          ],
        ),
      ),
    );
  }
}
