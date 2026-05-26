import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/billing_import_result_entity.dart';
import '../repositories/billing_repository.dart';

class ImportMeterReadingsParams extends Equatable {
  const ImportMeterReadingsParams({
    required this.filePath,
    this.month,
    this.propertyId,
    this.source,
  });

  final String filePath;
  final String? month;
  final String? propertyId;
  final String? source;

  @override
  List<Object?> get props => [filePath, month, propertyId, source];
}

class ImportMeterReadingsUsecase
    implements UseCase<BillingImportResultEntity, ImportMeterReadingsParams> {
  ImportMeterReadingsUsecase({required BillingRepository billingRepository})
    : _repository = billingRepository;

  final BillingRepository _repository;

  @override
  Future<Either<Failure, BillingImportResultEntity>> call(
    ImportMeterReadingsParams params,
  ) {
    return _repository.importMeterReadings(
      filePath: params.filePath,
      month: params.month,
      propertyId: params.propertyId,
      source: params.source,
    );
  }
}
