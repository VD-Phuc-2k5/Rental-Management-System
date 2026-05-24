import 'package:equatable/equatable.dart';

class VnpayPaymentEntity extends Equatable {
  const VnpayPaymentEntity({
    required this.payUrl,
    required this.deeplink,
    this.qrCodeUrl,
  });

  final String payUrl;
  final String deeplink;
  final String? qrCodeUrl;

  @override
  List<Object?> get props => [payUrl, deeplink, qrCodeUrl];
}
