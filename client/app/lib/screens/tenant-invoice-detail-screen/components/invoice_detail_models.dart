enum InvoiceStatus { pending, paid }

class InvoiceGeneralInfoData {
  final String roomName;
  final String landlordName;
  final String billingMonth;

  const InvoiceGeneralInfoData({
    required this.roomName,
    required this.landlordName,
    required this.billingMonth,
  });
}

class InvoiceLineItemData {
  final String name;
  final String? description;
  final int amount;

  const InvoiceLineItemData({
    required this.name,
    this.description,
    required this.amount,
  });
}

class InvoicePaymentInfoData {
  final String paymentMethod;
  final String createdDate;
  final String transactionId;

  const InvoicePaymentInfoData({
    required this.paymentMethod,
    required this.createdDate,
    required this.transactionId,
  });
}

class InvoiceDetailData {
  final InvoiceStatus status;
  final InvoiceGeneralInfoData generalInfo;
  final List<InvoiceLineItemData> lineItems;
  final int totalAmount;
  final InvoicePaymentInfoData? paymentInfo;

  const InvoiceDetailData({
    required this.status,
    required this.generalInfo,
    required this.lineItems,
    required this.totalAmount,
    this.paymentInfo,
  });
}
