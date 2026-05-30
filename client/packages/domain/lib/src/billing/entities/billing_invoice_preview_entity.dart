import 'package:equatable/equatable.dart';

class BillingInvoicePreviewEntity extends Equatable {
  const BillingInvoicePreviewEntity({
    required this.id,
    required this.hostelName,
    required this.roomNumber,
    required this.rentFee,
    required this.electricKwh,
    required this.electricFee,
    required this.waterM3,
    required this.waterFee,
    required this.serviceFee,
    required this.total,
  });

  final String id;
  final String hostelName;
  final String roomNumber;
  final int rentFee;
  final int electricKwh;
  final int electricFee;
  final int waterM3;
  final int waterFee;
  final int serviceFee;
  final int total;

  @override
  List<Object?> get props => [
        id,
        hostelName,
        roomNumber,
        rentFee,
        electricKwh,
        electricFee,
        waterM3,
        waterFee,
        serviceFee,
        total,
      ];
}
