import 'dart:typed_data';

import '../models/billing_import_result_model.dart';
import '../models/billing_invoice_preview_model.dart';
import '../models/billing_action_result_model.dart';
import '../models/create_invoices_result_model.dart';
import '../models/tenant_invoice_model.dart';

abstract interface class BillingRemoteDataSource {
  Future<BillingImportResultModel> importMeterReadings({
    required String token,
    required Uint8List fileBytes,
    required String fileName,
    String? month,
    String? propertyId,
    String? source,
  });

  Future<List<BillingInvoicePreviewModel>> previewInvoices({
    required String token,
    required String month,
    String? propertyId,
    List<String>? roomIds,
  });

  Future<CreateInvoicesResultModel> createInvoices({
    required String token,
    required String month,
    String? propertyId,
    List<String>? roomIds,
    String? dueDate,
    bool? isDraft,
  });

  Future<BillingActionResultModel> updateInvoice({
    required String token,
    required String invoiceId,
    required List<Map<String, dynamic>> items,
    String? dueDate,
  });

  Future<BillingActionResultModel> finalizeInvoice({
    required String token,
    required String invoiceId,
    String? dueDate,
  });

  Future<List<TenantInvoiceModel>> getTenantInvoices({
    required String token,
    String? month,
  });

  Future<List<TenantInvoiceModel>> getLandlordInvoices({
    required String token,
    String? month,
    String? status,
  });

  Future<TenantInvoiceDetailModel> getInvoiceDetail({
    required String token,
    required String invoiceId,
  });
}
