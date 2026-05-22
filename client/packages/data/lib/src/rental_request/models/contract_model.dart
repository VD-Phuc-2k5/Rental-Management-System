import 'package:domain/rental_request.dart';

class ContractModel extends ContractEntity {
  ContractModel({
    required super.id,
    required super.roomId,
    required super.tenantId,
    required super.landlordId,
    required super.startDate,
    required super.endDate,
    required super.monthlyRent,
    required super.deposit,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.rentalRequestId,
    super.terms,
    super.sentAt,
    super.signedAt,
    super.cancelledAt,
    super.finishedAt,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
        id: json['id'] as String,
        rentalRequestId: json['rentalRequestId'] as String?,
        roomId: json['roomId'] as String,
        tenantId: json['tenantId'] as String,
        landlordId: json['landlordId'] as String,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
        monthlyRent: _parseDouble(json['monthlyRent']),
        deposit: _parseDouble(json['deposit']),
        status: _statusFromJson(json['status'] as String),
        terms: json['terms'] as String?,
        sentAt: json['sentAt'] as String?,
        signedAt: json['signedAt'] as String?,
        cancelledAt: json['cancelledAt'] as String?,
        finishedAt: json['finishedAt'] as String?,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
      );
}

double _parseDouble(dynamic v) =>
    v is num ? v.toDouble() : double.parse(v.toString());

ContractStatus _statusFromJson(String v) => ContractStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == v.toUpperCase(),
      orElse: () => ContractStatus.draft,
    );
