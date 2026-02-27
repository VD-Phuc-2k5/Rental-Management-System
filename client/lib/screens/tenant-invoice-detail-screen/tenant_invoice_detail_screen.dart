import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/tenant-invoice-detail-screen/components/body.dart';
import 'package:app/screens/tenant-invoice-detail-screen/components/invoice_detail_models.dart';
import 'package:flutter/material.dart';

class TenantInvoiceDetailScreen extends StatelessWidget {
  final InvoiceDetailData? invoice;

  const TenantInvoiceDetailScreen({super.key, this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Chi tiết hóa đơn"),
      body: invoice != null
          ? Body(
              invoice: invoice!,
              onPayNow: () {
                // TODO: Navigate to payment screen
              },
              onDownloadPDF: () {
                // TODO: Download PDF
              },
            )
          : const Body(),
    );
  }
}
