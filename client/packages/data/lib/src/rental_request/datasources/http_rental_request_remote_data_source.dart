import 'dart:convert';
import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:domain/rental_request.dart';
import 'package:http/http.dart' as http;

import '../models/contract_member_model.dart';
import '../models/contract_model.dart';
import '../models/rental_request_model.dart';
import 'rental_request_remote_data_source.dart';

class HttpRentalRequestRemoteDataSource
    implements RentalRequestRemoteDataSource {
  HttpRentalRequestRemoteDataSource({required http.Client client})
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
  Future<RentalRequestModel> createRentalRequest({
    required String token,
    required String roomId,
    String? note,
    List<MemberInfo> memberInfo = const [],
    List<VehicleInfo> parkingInfo = const [],
  }) async {
    try {
      final body = <String, dynamic>{
        'roomId': roomId,
        'note': ?note,
        if (memberInfo.isNotEmpty)
          'memberInfo': memberInfo.map((m) => m.toJson()).toList(),
        if (parkingInfo.isNotEmpty)
          'parkingInfo': parkingInfo.map((v) => v.toJson()).toList(),
      };
      final response = await _client.post(
        Uri.parse('$baseUrl/rental-requests'),
        headers: _headers(token),
        body: jsonEncode(body),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        return RentalRequestModel.fromJson(json['data'] as Map<String, dynamic>);
      }
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<List<RentalRequestModel>> getMyRentalRequests({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/rental-requests/mine'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return (json['data'] as List)
            .map((e) => RentalRequestModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> cancelRentalRequest({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/rental-requests/$id'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<List<RentalRequestModel>> getIncomingRequests({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/landlord/rental-requests'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return (json['data'] as List)
            .map((e) => RentalRequestModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> rejectRentalRequest({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _client.patch(
        Uri.parse('$baseUrl/landlord/rental-requests/$id/reject'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<List<ContractModel>> getMyContracts({required String token}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/contracts/mine'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return (json['data'] as List)
            .map((e) => ContractModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<List<ContractModel>> getLandlordContracts({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/landlord/contracts'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return (json['data'] as List)
            .map((e) => ContractModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<ContractModel> getContractDetail({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/contracts/$id'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return ContractModel.fromJson(json['data'] as Map<String, dynamic>);
      }
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<ContractModel> updateContract({
    required String token,
    required String id,
    String? startDate,
    String? endDate,
    double? monthlyRent,
    double? deposit,
    String? terms,
  }) async {
    try {
      final body = <String, dynamic>{
        'startDate': ?startDate,
        'endDate': ?endDate,
        'monthlyRent': ?monthlyRent,
        'deposit': ?deposit,
        'terms': ?terms,
      };
      final response = await _client.patch(
        Uri.parse('$baseUrl/landlord/contracts/$id'),
        headers: _headers(token),
        body: jsonEncode(body),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return ContractModel.fromJson(json['data'] as Map<String, dynamic>);
      }
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> sendContract({required String token, required String id}) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/landlord/contracts/$id/send'),
        headers: _headers(token),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> signContract({required String token, required String id}) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/contracts/$id/sign'),
        headers: _headers(token),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> cancelContract({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/contracts/$id/cancel'),
        headers: _headers(token),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> finishContract({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/landlord/contracts/$id/finish'),
        headers: _headers(token),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<List<ContractMemberModel>> getContractMembers({
    required String token,
    required String contractId,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/contracts/$contractId/members'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return (json['data'] as List)
            .map((e) => ContractMemberModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> removeContractMember({
    required String token,
    required String contractId,
    required String memberId,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/contracts/$contractId/members/$memberId'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _handleError(response.statusCode, json);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }
}
