import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/billing_invoice_preview_entity.dart';
import '../repositories/billing_repository.dart';

class PreviewInvoicesParams extends Equatable {
  const PreviewInvoicesParams({
    required this.month,
    this.propertyId,
    this.roomIds,
  });

  final String month;
  final String? propertyId;
  final List<String>? roomIds;

  @override
  List<Object?> get props => [month, propertyId, roomIds];
}

class PreviewInvoicesUsecase
    implements UseCase<List<BillingInvoicePreviewEntity>, PreviewInvoicesParams> {
  PreviewInvoicesUsecase({required BillingRepository billingRepository})
    : _repository = billingRepository;

  final BillingRepository _repository;

  @override
  Future<Either<Failure, List<BillingInvoicePreviewEntity>>> call(
    PreviewInvoicesParams params,
  ) {
    return _repository.previewInvoices(
      month: params.month,
      propertyId: params.propertyId,
      roomIds: params.roomIds,
    );
  }
}
