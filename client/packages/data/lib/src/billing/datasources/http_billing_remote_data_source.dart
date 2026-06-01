import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:http/http.dart' as http;

import '../models/billing_import_result_model.dart';
import '../models/billing_invoice_preview_model.dart';
import '../models/billing_action_result_model.dart';
import '../models/create_invoices_result_model.dart';
import '../models/tenant_invoice_model.dart';
import 'billing_remote_data_source.dart';

class HttpBillingRemoteDataSource implements BillingRemoteDataSource {
  HttpBillingRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Map<String, String> _headers(String token) => {
    'Authorization': 'Bearer $token',
  };

  Never _handleError(int statusCode, Map<String, dynamic> json) {
    final message = json['message'] as String? ?? 'Error';
    final details = json['details'];
    if (details is Map && details['errors'] is List) {
      final errors = (details['errors'] as List)
          .map((e) => e.toString())
          .toList();
      throw ServerException(message: '$message\n${errors.join('\n')}');
    }
    throw ServerException(message: message);
  }

  @override
  Future<BillingImportResultModel> importMeterReadings({
    required String token,
    required Uint8List fileBytes,
    required String fileName,
    String? month,
    String? propertyId,
    String? source,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/billing/meter-readings/import');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(_headers(token));

      if (month != null && month.isNotEmpty) request.fields['month'] = month;
      if (propertyId != null && propertyId.isNotEmpty) {
        request.fields['propertyId'] = propertyId;
      }
      if (source != null && source.isNotEmpty) {
        request.fields['source'] = source;
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );

      final streamed = await _client.send(request);
      final response = await http.Response.fromStream(streamed);
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return BillingImportResultModel.fromJson(
          json['data'] as Map<String, dynamic>,
        );
      }

      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is UnknownException) {
        rethrow;
      }
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<List<BillingInvoicePreviewModel>> previewInvoices({
    required String token,
    required String month,
    String? propertyId,
    List<String>? roomIds,
  }) async {
    try {
      final body = <String, dynamic>{
        'month': month,
        'propertyId': ?propertyId,
        if (roomIds != null && roomIds.isNotEmpty) 'roomIds': roomIds,
      };

      final response = await _client.post(
        Uri.parse('$baseUrl/billing/invoices/preview'),
        headers: {
          ..._headers(token),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        return (json['data'] as List)
            .map(
              (e) => BillingInvoicePreviewModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();
      }
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is UnknownException) {
        rethrow;
      }
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<CreateInvoicesResultModel> createInvoices({
    required String token,
    required String month,
    String? propertyId,
    List<String>? roomIds,
    String? dueDate,
    bool? isDraft,
  }) async {
    try {
      final body = <String, dynamic>{
        'month': month,
        'propertyId': ?propertyId,
        if (roomIds != null && roomIds.isNotEmpty) 'roomIds': roomIds,
        'dueDate': ?dueDate,
        'isDraft': ?isDraft,
      };

      final response = await _client.post(
        Uri.parse('$baseUrl/billing/invoices'),
        headers: {
          ..._headers(token),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        return CreateInvoicesResultModel.fromJson(
          json['data'] as Map<String, dynamic>,
        );
      }

      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is UnknownException) {
        rethrow;
      }
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<BillingActionResultModel> updateInvoice({
    required String token,
    required String invoiceId,
    required List<Map<String, dynamic>> items,
    String? dueDate,
  }) async {
    try {
      final response = await _client.patch(
        Uri.parse('$baseUrl/billing/invoices/$invoiceId'),
        headers: {
          ..._headers(token),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'items': items,
          if (dueDate != null && dueDate.isNotEmpty) 'dueDate': dueDate,
        }),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return BillingActionResultModel.success();
      }

      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is UnknownException) {
        rethrow;
      }
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<BillingActionResultModel> finalizeInvoice({
    required String token,
    required String invoiceId,
    String? dueDate,
  }) async {
    try {
      final body = <String, dynamic>{
        'dueDate': ?dueDate,
      };

      final response = await _client.post(
        Uri.parse('$baseUrl/billing/invoices/$invoiceId/finalize'),
        headers: {
          ..._headers(token),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return BillingActionResultModel.success();
      }

      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is UnknownException) {
        rethrow;
      }
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<List<TenantInvoiceModel>> getTenantInvoices({
    required String token,
    String? month,
  }) async {
    try {
      final query = month != null && month.isNotEmpty ? '?month=$month' : '';
      final response = await _client.get(
        Uri.parse('$baseUrl/billing/invoices/tenant$query'),
        headers: _headers(token),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final list = json['data'] as List? ?? [];
        return list
            .whereType<Map>()
            .map(
              (e) => TenantInvoiceModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      }

      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is UnknownException) {
        rethrow;
      }
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<List<TenantInvoiceModel>> getLandlordInvoices({
    required String token,
    String? month,
    String? status,
  }) async {
    try {
      final query = <String, String>{
        if (month != null && month.isNotEmpty) 'month': month,
        if (status != null && status.isNotEmpty) 'status': status,
      };
      final uri = Uri.parse(
        '$baseUrl/billing/invoices/landlord',
      ).replace(queryParameters: query.isEmpty ? null : query);
      final response = await _client.get(uri, headers: _headers(token));

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final list = json['data'] as List? ?? [];
        return list
            .whereType<Map>()
            .map(
              (e) => TenantInvoiceModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();
      }

      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is UnknownException) {
        rethrow;
      }
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<TenantInvoiceDetailModel> getInvoiceDetail({
    required String token,
    required String invoiceId,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/billing/invoices/$invoiceId'),
        headers: _headers(token),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json['data'] as Map<String, dynamic>? ?? json;
        return TenantInvoiceDetailModel.fromJson(data);
      }

      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is UnknownException) {
        rethrow;
      }
      throw UnknownException(message: e.toString());
    }
  }
}
