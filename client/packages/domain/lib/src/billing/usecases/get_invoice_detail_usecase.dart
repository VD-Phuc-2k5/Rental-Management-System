import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/tenant_invoice_entity.dart';
import '../repositories/billing_repository.dart';

class GetInvoiceDetailParams extends Equatable {
  const GetInvoiceDetailParams({required this.invoiceId});

  final String invoiceId;

  @override
  List<Object?> get props => [invoiceId];
}

class GetInvoiceDetailUsecase
    implements UseCase<TenantInvoiceDetailEntity, GetInvoiceDetailParams> {
  GetInvoiceDetailUsecase({required BillingRepository billingRepository})
    : _repository = billingRepository;

  final BillingRepository _repository;

  @override
  Future<Either<Failure, TenantInvoiceDetailEntity>> call(
    GetInvoiceDetailParams params,
  ) {
    return _repository.getInvoiceDetail(invoiceId: params.invoiceId);
  }
}
