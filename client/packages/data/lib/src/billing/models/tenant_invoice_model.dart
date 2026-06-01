import 'package:domain/billing.dart';

class TenantInvoiceModel extends TenantInvoiceEntity {
  const TenantInvoiceModel({
    required super.id,
    required super.roomId,
    required super.month,
    required super.status,
    required super.total,
    super.dueDate,
    super.paidAt,
  });

  factory TenantInvoiceModel.fromJson(Map<String, dynamic> json) {
    return TenantInvoiceModel(
      id: _readString(json, 'id'),
      roomId: _readString(json, 'roomId', snake: 'room_id'),
      month: _readString(json, 'month'),
      status: _readString(json, 'status'),
      total: _readInt(json, 'total'),
      dueDate: _readNullableString(json, 'dueDate', snake: 'due_date'),
      paidAt: _readDateTime(json, 'paidAt', snake: 'paid_at'),
    );
  }
}

class TenantInvoiceItemModel extends TenantInvoiceItemEntity {
  const TenantInvoiceItemModel({
    required super.type,
    required super.amount,
    super.description,
    super.quantity,
    super.unitPrice,
  });

  factory TenantInvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return TenantInvoiceItemModel(
      type: _readString(json, 'type'),
      amount: _readInt(json, 'amount'),
      description: _readNullableString(json, 'description'),
      quantity: _readDouble(json, 'quantity'),
      unitPrice: _readDouble(json, 'unitPrice', snake: 'unit_price'),
    );
  }
}

class TenantInvoiceDetailModel extends TenantInvoiceDetailEntity {
  const TenantInvoiceDetailModel({
    required super.id,
    required super.roomId,
    required super.month,
    required super.status,
    required super.total,
    super.dueDate,
    super.paidAt,
    required super.items,
    required super.landlordId,
  });

  factory TenantInvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map(
              (e) => TenantInvoiceItemModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList()
        : <TenantInvoiceItemModel>[];

    return TenantInvoiceDetailModel(
      id: _readString(json, 'id'),
      roomId: _readString(json, 'roomId', snake: 'room_id'),
      month: _readString(json, 'month'),
      status: _readString(json, 'status'),
      total: _readInt(json, 'total'),
      dueDate: _readNullableString(json, 'dueDate', snake: 'due_date'),
      paidAt: _readDateTime(json, 'paidAt', snake: 'paid_at'),
      landlordId: _readString(json, 'landlordId', snake: 'landlord_id'),
      items: items,
    );
  }
}

String _readString(
  Map<String, dynamic> json,
  String key, {
  String? snake,
}) {
  final v = json[key] ?? (snake != null ? json[snake] : null);
  return v?.toString() ?? '';
}

String? _readNullableString(
  Map<String, dynamic> json,
  String key, {
  String? snake,
}) {
  final v = json[key] ?? (snake != null ? json[snake] : null);
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

int _readInt(Map<String, dynamic> json, String key) {
  final v = json[key];
  if (v is int) return v;
  if (v is num) return v.round();
  if (v is String) return double.tryParse(v)?.round() ?? 0;
  return 0;
}

double? _readDouble(
  Map<String, dynamic> json,
  String key, {
  String? snake,
}) {
  final v = json[key] ?? (snake != null ? json[snake] : null);
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

DateTime? _readDateTime(
  Map<String, dynamic> json,
  String key, {
  String? snake,
}) {
  final v = json[key] ?? (snake != null ? json[snake] : null);
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}
