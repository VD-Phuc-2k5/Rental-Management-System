import 'package:domain/billing.dart';

class BillingInvoicePreviewModel extends BillingInvoicePreviewEntity {
  const BillingInvoicePreviewModel({
    required super.id,
    required super.hostelName,
    required super.roomNumber,
    required super.rentFee,
    required super.electricKwh,
    required super.electricFee,
    required super.waterM3,
    required super.waterFee,
    required super.serviceFee,
    required super.total,
  });

  factory BillingInvoicePreviewModel.fromJson(Map<String, dynamic> json) {
    return BillingInvoicePreviewModel(
      id: json['roomId'] as String? ?? '',
      hostelName: json['propertyName'] as String? ?? '',
      roomNumber: json['roomTitle'] as String? ?? '',
      rentFee: (json['rentFee'] as num?)?.toInt() ?? 0,
      electricKwh: (json['electricKwh'] as num?)?.toInt() ?? 0,
      electricFee: (json['electricFee'] as num?)?.toInt() ?? 0,
      waterM3: (json['waterM3'] as num?)?.toInt() ?? 0,
      waterFee: (json['waterFee'] as num?)?.toInt() ?? 0,
      serviceFee: (json['serviceFee'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}
