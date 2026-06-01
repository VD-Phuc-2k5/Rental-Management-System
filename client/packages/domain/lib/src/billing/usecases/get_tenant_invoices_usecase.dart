import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/tenant_invoice_entity.dart';
import '../repositories/billing_repository.dart';

class GetTenantInvoicesParams extends Equatable {
  const GetTenantInvoicesParams({this.month});

  final String? month;

  @override
  List<Object?> get props => [month];
}

class GetTenantInvoicesUsecase
    implements UseCase<List<TenantInvoiceEntity>, GetTenantInvoicesParams> {
  GetTenantInvoicesUsecase({required BillingRepository billingRepository})
    : _repository = billingRepository;

  final BillingRepository _repository;

  @override
  Future<Either<Failure, List<TenantInvoiceEntity>>> call(
    GetTenantInvoicesParams params,
  ) {
    return _repository.getTenantInvoices(month: params.month);
  }
}
