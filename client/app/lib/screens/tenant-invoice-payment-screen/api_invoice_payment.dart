import 'dart:async';
import 'dart:convert';

import 'package:core/constants.dart';
import 'package:http/http.dart' as http;

bool _isUuid(String value) {
  final v = value.trim();
  final uuid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );
  return uuid.hasMatch(v);
}

class InvoicePaymentResult {
  const InvoicePaymentResult({
    required this.payUrl,
    this.qrCodeUrl,
  });

  final String payUrl;
  final String? qrCodeUrl;
}

Future<InvoicePaymentResult> createInvoicePaymentUrl({
  required String token,
  required String invoiceId,
}) async {
  if (!_isUuid(invoiceId)) {
    throw Exception('InvoiceId không hợp lệ (cần UUID).');
  }

  final uri = Uri.parse('$baseUrl/payments/payos/create-invoice');
  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'invoiceId': invoiceId}),
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'] as String?;
        if (message != null && message.isNotEmpty) {
          throw Exception(message);
        }
      }
    } catch (_) {
      // ignore json parse errors
    }
    throw Exception('Failed to create invoice payment: ${response.statusCode}');
  }

  final decoded = jsonDecode(response.body);
  if (decoded is! Map<String, dynamic>) {
    throw Exception('Invalid response format');
  }

  final data =
      decoded['data'] is Map<String, dynamic> ? decoded['data'] : decoded;
  if (data is! Map<String, dynamic>) {
    throw Exception('Invalid response data');
  }

  final payUrl = (data['payUrl'] as String?) ?? '';
  if (payUrl.isEmpty) throw Exception('Missing payUrl');
  final qrCodeUrl = data['qrCodeUrl'] as String?;
  return InvoicePaymentResult(payUrl: payUrl, qrCodeUrl: qrCodeUrl);
}

Future<void> devConfirmPayment({
  required String token,
  required String contractId,
}) async {
  final uri = Uri.parse('$baseUrl/payments/dev/confirm-payment');
  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'contractId': contractId}),
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Dev confirm failed: ${response.statusCode}');
  }
}

Future<void> devConfirmInvoicePayment({
  required String token,
  required String invoiceId,
}) async {
  final uri = Uri.parse('$baseUrl/payments/dev/confirm-invoice-payment');
  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'invoiceId': invoiceId}),
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Dev confirm invoice failed: ${response.statusCode}');
  }
}

Future<bool> isContractSigned({
  required String token,
  required String contractId,
}) async {
  if (!_isUuid(contractId)) return false;

  final uri = Uri.parse('$baseUrl/contracts/$contractId');
  final response = await http.get(
    uri,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode < 200 || response.statusCode >= 300) return false;

  final decoded = jsonDecode(response.body);
  if (decoded is! Map<String, dynamic>) return false;

  final data =
      decoded['data'] is Map<String, dynamic> ? decoded['data'] : decoded;
  if (data is! Map<String, dynamic>) return false;

  final status = (data['status'] as String?)?.toLowerCase();
  return status == 'signed';
}

Future<bool> isInvoicePaid({
  required String token,
  required String invoiceId,
}) async {
  if (!_isUuid(invoiceId)) return false;

  final uri = Uri.parse('$baseUrl/billing/invoices/$invoiceId');
  final response = await http.get(
    uri,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to fetch invoice: ${response.statusCode}');
  }

  final decoded = jsonDecode(response.body);
  if (decoded is! Map<String, dynamic>) return false;

  final data =
      decoded['data'] is Map<String, dynamic> ? decoded['data'] : decoded;
  if (data is! Map<String, dynamic>) return false;

  final status = (data['status'] as String?)?.toLowerCase();
  return status == 'paid';
}
