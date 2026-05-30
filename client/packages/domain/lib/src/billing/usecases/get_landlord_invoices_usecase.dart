import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/tenant_invoice_entity.dart';
import '../repositories/billing_repository.dart';

class GetLandlordInvoicesParams extends Equatable {
  const GetLandlordInvoicesParams({this.month, this.status});

  final String? month;
  final String? status;

  @override
  List<Object?> get props => [month, status];
}

class GetLandlordInvoicesUsecase
    implements UseCase<List<TenantInvoiceEntity>, GetLandlordInvoicesParams> {
  GetLandlordInvoicesUsecase({required BillingRepository billingRepository})
    : _repository = billingRepository;

  final BillingRepository _repository;

  @override
  Future<Either<Failure, List<TenantInvoiceEntity>>> call(
    GetLandlordInvoicesParams params,
  ) {
    return _repository.getLandlordInvoices(
      month: params.month,
      status: params.status,
    );
  }
}
