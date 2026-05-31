abstract class TenantInvoiceEntity {
  const TenantInvoiceEntity({
    required this.id,
    required this.roomId,
    required this.month,
    required this.status,
    required this.total,
    this.dueDate,
    this.paidAt,
  });

  final String id;
  final String roomId;
  /// YYYY-MM
  final String month;
  final String status;
  final int total;
  final String? dueDate;
  final DateTime? paidAt;
}

abstract class TenantInvoiceItemEntity {
  const TenantInvoiceItemEntity({
    required this.type,
    required this.amount,
    this.description,
    this.quantity,
    this.unitPrice,
  });

  final String type;
  final int amount;
  final String? description;
  final double? quantity;
  final double? unitPrice;
}

abstract class TenantInvoiceDetailEntity extends TenantInvoiceEntity {
  const TenantInvoiceDetailEntity({
    required super.id,
    required super.roomId,
    required super.month,
    required super.status,
    required super.total,
    super.dueDate,
    super.paidAt,
    required this.items,
    required this.landlordId,
  });

  final List<TenantInvoiceItemEntity> items;
  final String landlordId;
}
