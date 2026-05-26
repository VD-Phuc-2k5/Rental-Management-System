import 'package:equatable/equatable.dart';

import 'created_invoice_entity.dart';

class CreateInvoicesResultEntity extends Equatable {
  const CreateInvoicesResultEntity({
    required this.created,
    required this.invoices,
  });

  final int created;
  final List<CreatedInvoiceEntity> invoices;

  @override
  List<Object?> get props => [created, invoices];
}
