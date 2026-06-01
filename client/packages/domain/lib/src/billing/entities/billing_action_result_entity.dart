import 'package:equatable/equatable.dart';

class BillingActionResultEntity extends Equatable {
  const BillingActionResultEntity({required this.success});

  final bool success;

  @override
  List<Object?> get props => [success];
}
