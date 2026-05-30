class InvoiceSummaryData {

  const InvoiceSummaryData({
    required this.dueDate,
    required this.amountDue,
    this.billingMonth,
    this.badgeText,
  });
  final String dueDate;
  final int amountDue;
  final String? billingMonth;
  final String? badgeText;
}

class InvoiceHistoryItemData {

  const InvoiceHistoryItemData({
    required this.id,
    required this.billingMonth,
    required this.paidAt,
    required this.amount,
    required this.statusLabel,
    required this.isPaid,
  });
  final String id;
  final String billingMonth;
  final String paidAt;
  final int amount;
  final String statusLabel;
  final bool isPaid;
}

enum InvoiceHistoryState { loading, data, empty, error }
