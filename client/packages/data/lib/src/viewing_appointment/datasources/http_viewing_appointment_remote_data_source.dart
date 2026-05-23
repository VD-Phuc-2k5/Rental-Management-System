import 'dart:convert';
import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:http/http.dart' as http;

import '../models/viewing_appointment_model.dart';
import 'viewing_appointment_remote_data_source.dart';

class HttpViewingAppointmentRemoteDataSource
    implements ViewingAppointmentRemoteDataSource {
  HttpViewingAppointmentRemoteDataSource({required http.Client client})
    : _client = client;

  final http.Client _client;

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Never _handleError(int statusCode, Map<String, dynamic> json) {
    throw ServerException(
      message: json['message'] as String? ?? 'Error',
    );
  }

  @override
  Future<ViewingAppointmentModel> createViewingAppointment({
    required String token,
    required String roomId,
    required String scheduledAt,
    String? note,
  }) async {
    try {
      final body = <String, dynamic>{
        'roomId': roomId,
        'scheduledAt': scheduledAt,
        'note': ?note,
      };
      final response = await _client.post(
        Uri.parse('$baseUrl/viewing-appointments'),
        headers: _headers(token),
        body: jsonEncode(body),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        return ViewingAppointmentModel.fromJson(
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
  Future<List<ViewingAppointmentModel>> getMyViewingAppointments({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/viewing-appointments/mine'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return (json['data'] as List)
            .map(
              (e) =>
                  ViewingAppointmentModel.fromJson(e as Map<String, dynamic>),
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
  Future<List<ViewingAppointmentModel>> getLandlordViewingAppointments({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/landlord/viewing-appointments'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return (json['data'] as List)
            .map(
              (e) =>
                  ViewingAppointmentModel.fromJson(e as Map<String, dynamic>),
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
  Future<ViewingAppointmentModel> approveViewingAppointment({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/landlord/viewing-appointments/$id/approve'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ViewingAppointmentModel.fromJson(
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
  Future<ViewingAppointmentModel> rejectViewingAppointment({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/landlord/viewing-appointments/$id/reject'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ViewingAppointmentModel.fromJson(
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
  Future<void> cancelViewingAppointment({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/viewing-appointments/$id'),
        headers: _headers(token),
      );
      if (response.statusCode == 204 || response.statusCode == 200) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
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
