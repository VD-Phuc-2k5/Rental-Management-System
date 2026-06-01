import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/create_invoices_result_entity.dart';
import '../repositories/billing_repository.dart';

class CreateInvoicesParams extends Equatable {
  const CreateInvoicesParams({
    required this.month,
    this.propertyId,
    this.roomIds,
    this.dueDate,
    this.isDraft,
  });

  final String month;
  final String? propertyId;
  final List<String>? roomIds;
  final String? dueDate;
  final bool? isDraft;

  @override
  List<Object?> get props => [month, propertyId, roomIds, dueDate, isDraft];
}

class CreateInvoicesUsecase
    implements UseCase<CreateInvoicesResultEntity, CreateInvoicesParams> {
  CreateInvoicesUsecase({required BillingRepository billingRepository})
    : _repository = billingRepository;

  final BillingRepository _repository;

  @override
  Future<Either<Failure, CreateInvoicesResultEntity>> call(
    CreateInvoicesParams params,
  ) {
    return _repository.createInvoices(
      month: params.month,
      propertyId: params.propertyId,
      roomIds: params.roomIds,
      dueDate: params.dueDate,
      isDraft: params.isDraft,
    );
  }
}
