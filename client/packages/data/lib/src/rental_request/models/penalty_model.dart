import 'package:domain/rental_request.dart';

class PenaltyModel extends PenaltyEntity {
  PenaltyModel({
    required super.id,
    required super.contractId,
    required super.tenantId,
    required super.roomId,
    required super.amount,
    required super.reason,
    required super.status,
    required super.createdAt,
  });

  factory PenaltyModel.fromJson(Map<String, dynamic> json) => PenaltyModel(
    id: json['id'] as String,
    contractId: (json['contractId'] ?? json['contract_id'] ?? '') as String,
    tenantId: (json['tenantId'] ?? json['tenant_id'] ?? '') as String,
    roomId: (json['roomId'] ?? json['room_id'] ?? '') as String,
    amount: json['amount'] is num
        ? (json['amount'] as num).toDouble()
        : double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
    reason: (json['reason'] ?? '') as String,
    status: (json['status'] ?? 'pending') as String,
    createdAt: (json['createdAt'] ?? json['created_at'] ?? '') as String,
  );
}
