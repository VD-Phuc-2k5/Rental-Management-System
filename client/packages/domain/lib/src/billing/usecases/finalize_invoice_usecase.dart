import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/billing_action_result_entity.dart';
import '../repositories/billing_repository.dart';

class FinalizeInvoiceParams extends Equatable {
  const FinalizeInvoiceParams({
    required this.invoiceId,
    this.dueDate,
  });

  final String invoiceId;
  final String? dueDate;

  @override
  List<Object?> get props => [invoiceId, dueDate];
}

class FinalizeInvoiceUsecase
    implements UseCase<BillingActionResultEntity, FinalizeInvoiceParams> {
  FinalizeInvoiceUsecase({required BillingRepository billingRepository})
    : _repository = billingRepository;

  final BillingRepository _repository;

  @override
  Future<Either<Failure, BillingActionResultEntity>> call(
    FinalizeInvoiceParams params,
  ) {
    return _repository.finalizeInvoice(
      invoiceId: params.invoiceId,
      dueDate: params.dueDate,
    );
  }
}
