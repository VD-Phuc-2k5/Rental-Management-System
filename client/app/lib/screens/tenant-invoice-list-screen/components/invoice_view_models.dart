class InvoiceSummaryData {

  const InvoiceSummaryData({
    required this.dueDate,
    required this.amountDue,
    this.badgeText,
  });
  final String dueDate;
  final int amountDue;
  final String? badgeText;
}

class InvoiceHistoryItemData {

  const InvoiceHistoryItemData({
    required this.billingMonth,
    required this.paidAt,
    required this.amount,
    required this.statusLabel,
    required this.isPaid,
  });
  final String billingMonth;
  final String paidAt;
  final int amount;
  final String statusLabel;
  final bool isPaid;
}

enum InvoiceHistoryState { loading, data, empty, error }
