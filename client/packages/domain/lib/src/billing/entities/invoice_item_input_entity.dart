import 'package:equatable/equatable.dart';

class InvoiceItemInputEntity extends Equatable {
  const InvoiceItemInputEntity({
    required this.type,
    this.description,
    this.quantity,
    this.unitPrice,
    this.amount,
  });

  final String type;
  final String? description;
  final double? quantity;
  final double? unitPrice;
  final double? amount;

  @override
  List<Object?> get props => [type, description, quantity, unitPrice, amount];
}
