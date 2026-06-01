import 'dart:typed_data';

import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/billing_import_result_entity.dart';
import '../entities/billing_invoice_preview_entity.dart';
import '../entities/billing_action_result_entity.dart';
import '../entities/create_invoices_result_entity.dart';
import '../entities/invoice_item_input_entity.dart';
import '../entities/tenant_invoice_entity.dart';

abstract interface class BillingRepository {
  Future<Either<Failure, BillingImportResultEntity>> importMeterReadings({
    required Uint8List fileBytes,
    required String fileName,
    String? month,
    String? propertyId,
    String? source,
  });

  Future<Either<Failure, List<BillingInvoicePreviewEntity>>> previewInvoices({
    required String month,
    String? propertyId,
    List<String>? roomIds,
  });

  Future<Either<Failure, CreateInvoicesResultEntity>> createInvoices({
    required String month,
    String? propertyId,
    List<String>? roomIds,
    String? dueDate,
    bool? isDraft,
  });

  Future<Either<Failure, BillingActionResultEntity>> updateInvoice({
    required String invoiceId,
    required List<InvoiceItemInputEntity> items,
    String? dueDate,
  });

  Future<Either<Failure, BillingActionResultEntity>> finalizeInvoice({
    required String invoiceId,
    String? dueDate,
  });

  Future<Either<Failure, List<TenantInvoiceEntity>>> getTenantInvoices({
    String? month,
  });

  Future<Either<Failure, List<TenantInvoiceEntity>>> getLandlordInvoices({
    String? month,
    String? status,
  });

  Future<Either<Failure, TenantInvoiceDetailEntity>> getInvoiceDetail({
    required String invoiceId,
  });
}
