enum PaymentMethodType { payos, bankTransfer }

class PaymentLineItemData {
  const PaymentLineItemData({
    required this.name,
    this.description,
    required this.amount,
  });
  final String name;
  final String? description;
  final int amount;
}

class PaymentData {
  const PaymentData({
    required this.invoiceId,
    required this.roomName,
    required this.lineItems,
    required this.totalAmount,
  });
  final String invoiceId;
  final String roomName;
  final List<PaymentLineItemData> lineItems;
  final int totalAmount;
}

class PaymentMethodOption {
  const PaymentMethodOption({
    required this.type,
    required this.name,
    required this.description,
    required this.iconName,
    required this.isSelected,
  });
  final PaymentMethodType type;
  final String name;
  final String description;
  final String iconName;
  final bool isSelected;

  PaymentMethodOption copyWith({
    PaymentMethodType? type,
    String? name,
    String? description,
    String? iconName,
    bool? isSelected,
  }) {
    return PaymentMethodOption(
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
