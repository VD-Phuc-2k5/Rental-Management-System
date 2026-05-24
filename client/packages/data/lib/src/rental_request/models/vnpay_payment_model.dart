import 'package:domain/rental_request.dart';

class VnpayPaymentModel extends VnpayPaymentEntity {
  const VnpayPaymentModel({
    required super.payUrl,
    required super.deeplink,
    super.qrCodeUrl,
  });

  factory VnpayPaymentModel.fromJson(Map<String, dynamic> json) =>
      VnpayPaymentModel(
        payUrl: json['payUrl'] as String,
        deeplink: json['deeplink'] as String,
        qrCodeUrl: json['qrCodeUrl'] as String?,
      );
}
