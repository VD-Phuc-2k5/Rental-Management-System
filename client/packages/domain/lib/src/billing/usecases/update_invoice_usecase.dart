import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/billing_action_result_entity.dart';
import '../entities/invoice_item_input_entity.dart';
import '../repositories/billing_repository.dart';

class UpdateInvoiceParams extends Equatable {
  const UpdateInvoiceParams({
    required this.invoiceId,
    required this.items,
    this.dueDate,
  });

  final String invoiceId;
  final List<InvoiceItemInputEntity> items;
  final String? dueDate;

  @override
  List<Object?> get props => [invoiceId, items, dueDate];
}

class UpdateInvoiceUsecase
    implements UseCase<BillingActionResultEntity, UpdateInvoiceParams> {
  UpdateInvoiceUsecase({required BillingRepository billingRepository})
    : _repository = billingRepository;

  final BillingRepository _repository;

  @override
  Future<Either<Failure, BillingActionResultEntity>> call(
    UpdateInvoiceParams params,
  ) {
    return _repository.updateInvoice(
      invoiceId: params.invoiceId,
      items: params.items,
      dueDate: params.dueDate,
    );
  }
}
