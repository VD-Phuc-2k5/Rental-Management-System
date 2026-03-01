import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/core/widgets/tenant_navigation_bottom.dart';
import 'package:app/screens/tenant-invoice-detail-screen/components/invoice_detail_examples.dart';
import 'package:app/screens/tenant-invoice-detail-screen/tenant_invoice_detail_screen.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/body.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/invoice_view_models.dart';
import 'package:app/screens/tenant-invoice-payment-screen/components/payment_models.dart';
import 'package:app/screens/tenant-invoice-payment-screen/tenant_invoice_payment_screen.dart';
import 'package:flutter/material.dart';

class TenantInvoiceListScreen extends StatelessWidget {
  const TenantInvoiceListScreen({super.key});

  void _navigateToInvoiceDetail(
    BuildContext context,
    InvoiceHistoryItemData item,
  ) {
    // Navigate to detail screen with appropriate invoice data based on status
    final invoice = item.isPaid
        ? InvoiceDetailExamples.paidInvoice
        : InvoiceDetailExamples.pendingInvoice;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TenantInvoiceDetailScreen(invoice: invoice),
      ),
    );
  }

  void _navigateToPayment(BuildContext context) {
    // TODO: Replace with actual invoice data from API
    const paymentData = PaymentData(
      invoiceId: 'INV-2026-03',
      roomName: 'Phòng 202 - Nhà Trọ Xanh',
      lineItems: [
        PaymentLineItemData(name: 'Tiền phòng', amount: 2000000),
        PaymentLineItemData(
          name: 'Điện',
          description: '125kWh x 4,000đ',
          amount: 500000,
        ),
        PaymentLineItemData(name: 'Nước', amount: 200000),
        PaymentLineItemData(
          name: 'Dịch vụ (Wifi, rác, vệ sinh)',
          amount: 50000,
        ),
      ],
      totalAmount: 2750000,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TenantInvoicePaymentScreen(
          appbarTitle: "Thanh toán hóa đơn",
          paymentData: paymentData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Hóa đơn của tôi"),
      body: Body(
        onHistoryItemTap: (item) => _navigateToInvoiceDetail(context, item),
        onPayNow: () => _navigateToPayment(context),
      ),
      bottomNavigationBar: TenantNavigationBottom(currentIndex: 3),
    );
  }
}
