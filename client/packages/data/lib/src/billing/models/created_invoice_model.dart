import 'package:domain/billing.dart';

class CreatedInvoiceModel extends CreatedInvoiceEntity {
  const CreatedInvoiceModel({
    required super.id,
    required super.roomId,
  });

  factory CreatedInvoiceModel.fromJson(Map<String, dynamic> json) {
    return CreatedInvoiceModel(
      id: json['id'] as String? ?? '',
      roomId: json['roomId'] as String? ?? '',
    );
  }
}
