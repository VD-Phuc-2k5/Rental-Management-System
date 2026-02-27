import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/core/widgets/tenant_navigation_bottom.dart';
import 'package:app/screens/tenant-invoice-detail-screen/components/invoice_detail_examples.dart';
import 'package:app/screens/tenant-invoice-detail-screen/tenant_invoice_detail_screen.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/body.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/invoice_view_models.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Hóa đơn của tôi"),
      body: Body(
        onHistoryItemTap: (item) => _navigateToInvoiceDetail(context, item),
      ),
      bottomNavigationBar: TenantNavigationBottom(currentIndex: 3),
    );
  }
}
