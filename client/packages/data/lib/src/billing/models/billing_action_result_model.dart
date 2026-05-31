import 'package:domain/billing.dart';

class BillingActionResultModel extends BillingActionResultEntity {
  const BillingActionResultModel({required super.success});

  factory BillingActionResultModel.success() {
    return const BillingActionResultModel(success: true);
  }
}
