import 'package:domain/billing.dart';

class BillingImportResultModel extends BillingImportResultEntity {
  const BillingImportResultModel({required super.imported});

  factory BillingImportResultModel.fromJson(Map<String, dynamic> json) {
    return BillingImportResultModel(
      imported: (json['imported'] as num?)?.toInt() ?? 0,
    );
  }
}
