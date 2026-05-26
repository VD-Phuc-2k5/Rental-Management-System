import 'package:core/errors.dart';
import 'package:domain/billing.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/billing_remote_data_source.dart';

class BillingRepositoryImpl implements BillingRepository {
  BillingRepositoryImpl({
    required BillingRemoteDataSource billingRemoteDataSource,
    required String Function() getToken,
  }) : _dataSource = billingRemoteDataSource,
       _getToken = getToken;

  final BillingRemoteDataSource _dataSource;
  final String Function() _getToken;

  @override
  Future<Either<Failure, BillingImportResultEntity>> importMeterReadings({
    required String filePath,
    String? month,
    String? propertyId,
    String? source,
  }) async {
    try {
      final data = await _dataSource.importMeterReadings(
        token: _getToken(),
        filePath: filePath,
        month: month,
        propertyId: propertyId,
        source: source,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<BillingInvoicePreviewEntity>>> previewInvoices({
    required String month,
    String? propertyId,
    List<String>? roomIds,
  }) async {
    try {
      final data = await _dataSource.previewInvoices(
        token: _getToken(),
        month: month,
        propertyId: propertyId,
        roomIds: roomIds,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, CreateInvoicesResultEntity>> createInvoices({
    required String month,
    String? propertyId,
    List<String>? roomIds,
    String? dueDate,
    bool? isDraft,
  }) async {
    try {
      final data = await _dataSource.createInvoices(
        token: _getToken(),
        month: month,
        propertyId: propertyId,
        roomIds: roomIds,
        dueDate: dueDate,
        isDraft: isDraft,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BillingActionResultEntity>> updateInvoice({
    required String invoiceId,
    required List<InvoiceItemInputEntity> items,
  }) async {
    try {
      final payload = items
          .map(
            (item) => {
              'type': item.type,
              if (item.description != null) 'description': item.description,
              if (item.quantity != null) 'quantity': item.quantity,
              if (item.unitPrice != null) 'unitPrice': item.unitPrice,
              if (item.amount != null) 'amount': item.amount,
            },
          )
          .toList();

      final data = await _dataSource.updateInvoice(
        token: _getToken(),
        invoiceId: invoiceId,
        items: payload,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BillingActionResultEntity>> finalizeInvoice({
    required String invoiceId,
    String? dueDate,
  }) async {
    try {
      final data = await _dataSource.finalizeInvoice(
        token: _getToken(),
        invoiceId: invoiceId,
        dueDate: dueDate,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }
}
