import 'package:equatable/equatable.dart';

class BillingImportResultEntity extends Equatable {
  const BillingImportResultEntity({required this.imported});

  final int imported;

  @override
  List<Object?> get props => [imported];
}
