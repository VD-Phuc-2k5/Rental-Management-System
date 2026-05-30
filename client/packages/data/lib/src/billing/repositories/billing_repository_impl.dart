import 'dart:typed_data';

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
    required Uint8List fileBytes,
    required String fileName,
    String? month,
    String? propertyId,
    String? source,
  }) async {
    try {
      final data = await _dataSource.importMeterReadings(
        token: _getToken(),
        fileBytes: fileBytes,
        fileName: fileName,
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
    String? dueDate,
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

  @override
  Future<Either<Failure, List<TenantInvoiceEntity>>> getLandlordInvoices({
    String? month,
    String? status,
  }) async {
    try {
      final data = await _dataSource.getLandlordInvoices(
        token: _getToken(),
        month: month,
        status: status,
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

  @override
  Future<Either<Failure, List<TenantInvoiceEntity>>> getTenantInvoices({
    String? month,
  }) async {
    try {
      final data = await _dataSource.getTenantInvoices(
        token: _getToken(),
        month: month,
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
  Future<Either<Failure, TenantInvoiceDetailEntity>> getInvoiceDetail({
    required String invoiceId,
  }) async {
    try {
      final data = await _dataSource.getInvoiceDetail(
        token: _getToken(),
        invoiceId: invoiceId,
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
