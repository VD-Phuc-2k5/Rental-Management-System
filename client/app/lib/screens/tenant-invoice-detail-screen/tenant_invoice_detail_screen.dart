import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import 'components/invoice_detail_models.dart';
import '../tenant-invoice-payment-screen/components/payment_models.dart';
import '../tenant-invoice-payment-screen/tenant_invoice_payment_screen.dart';
import 'package:flutter/material.dart';

class TenantInvoiceDetailScreen extends StatelessWidget {

  const TenantInvoiceDetailScreen({super.key, this.invoice});
  final InvoiceDetailData? invoice;

  void _handlePayNow(BuildContext context) {
    if (invoice == null) return;

    // Convert invoice line items to payment line items
    final paymentLineItems = invoice!.lineItems
        .map(
          (item) => PaymentLineItemData(
            name: item.name,
            description: item.description,
            amount: item.amount,
          ),
        )
        .toList();

    final paymentData = PaymentData(
      invoiceId: invoice!.generalInfo.billingMonth,
      roomName: invoice!.generalInfo.roomName,
      lineItems: paymentLineItems,
      totalAmount: invoice!.totalAmount,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TenantInvoicePaymentScreen(
          appbarTitle: "Thanh toán hóa đơn",
          paymentData: paymentData,
        ),
      ),
    );
  }

  void _handleDownloadPDF() {
    // TO DO: Implement PDF download logic
    // This will be integrated with API later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Chi tiết hóa đơn"),
      body: invoice != null
          ? Body(
              invoice: invoice!,
              onPayNow: () => _handlePayNow(context),
              onDownloadPDF: _handleDownloadPDF,
            )
          : const Body(),
    );
  }
}
