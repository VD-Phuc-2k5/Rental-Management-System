enum InvoiceStatus { pending, paid }

class InvoiceGeneralInfoData {

  const InvoiceGeneralInfoData({
    required this.roomName,
    required this.landlordName,
    required this.billingMonth,
  });
  final String roomName;
  final String landlordName;
  final String billingMonth;
}

class InvoiceLineItemData {

  const InvoiceLineItemData({
    required this.name,
    this.description,
    required this.amount,
  });
  final String name;
  final String? description;
  final int amount;
}

class InvoicePaymentInfoData {

  const InvoicePaymentInfoData({
    required this.paymentMethod,
    required this.createdDate,
    required this.transactionId,
  });
  final String paymentMethod;
  final String createdDate;
  final String transactionId;
}

class InvoiceDetailData {

  const InvoiceDetailData({
    required this.status,
    required this.generalInfo,
    required this.lineItems,
    required this.totalAmount,
    this.paymentInfo,
  });
  final InvoiceStatus status;
  final InvoiceGeneralInfoData generalInfo;
  final List<InvoiceLineItemData> lineItems;
  final int totalAmount;
  final InvoicePaymentInfoData? paymentInfo;
}
