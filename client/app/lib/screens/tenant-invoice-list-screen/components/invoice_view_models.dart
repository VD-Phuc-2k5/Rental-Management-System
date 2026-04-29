class InvoiceSummaryData {
  final String dueDate;
  final int amountDue;
  final String? badgeText;

  const InvoiceSummaryData({
    required this.dueDate,
    required this.amountDue,
    this.badgeText,
  });
}

class InvoiceHistoryItemData {
  final String billingMonth;
  final String paidAt;
  final int amount;
  final String statusLabel;
  final bool isPaid;

  const InvoiceHistoryItemData({
    required this.billingMonth,
    required this.paidAt,
    required this.amount,
    required this.statusLabel,
    required this.isPaid,
  });
}

enum InvoiceHistoryState { loading, data, empty, error }
