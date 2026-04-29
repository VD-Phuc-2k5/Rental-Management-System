import 'package:app/screens/tenant-invoice-list-screen/components/invoice_history_section.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/invoice_summary_card.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/invoice_view_models.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final InvoiceSummaryData latestInvoice;
  final InvoiceHistoryState historyState;
  final List<InvoiceHistoryItemData> historyItems;
  final VoidCallback? onPayNow;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<InvoiceHistoryItemData>? onHistoryItemTap;
  final Widget? historyErrorWidget;

  const Body({
    super.key,
    this.latestInvoice = const InvoiceSummaryData(
      dueDate: '10/06/2026',
      amountDue: 2750000,
      badgeText: 'Mới nhất',
    ),
    this.historyState = InvoiceHistoryState.data,
    this.historyItems = const [
      InvoiceHistoryItemData(
        billingMonth: '02/2026',
        paidAt: 'Hạn: 10/03/2026',
        amount: 2750000,
        statusLabel: 'Chờ thanh toán',
        isPaid: false,
      ),
      InvoiceHistoryItemData(
        billingMonth: '01/2026',
        paidAt: '10/02/2026 • 14:30',
        amount: 3500000,
        statusLabel: 'Đã thanh toán',
        isPaid: true,
      ),
      InvoiceHistoryItemData(
        billingMonth: '12/2025',
        paidAt: '10/01/2026 • 10:15',
        amount: 3200000,
        statusLabel: 'Đã thanh toán',
        isPaid: true,
      ),
    ],
    this.onPayNow,
    this.onSearchChanged,
    this.onHistoryItemTap,
    this.historyErrorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 4.0,
          children: [
            InvoiceSummaryCard(invoice: latestInvoice, onPayNow: onPayNow),
            InvoiceHistorySection(
              state: historyState,
              items: historyItems,
              onSearchChanged: onSearchChanged,
              onItemTap: onHistoryItemTap,
              errorWidget: historyErrorWidget,
            ),
          ],
        ),
      ),
    );
  }
}
