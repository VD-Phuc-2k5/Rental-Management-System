import 'dart:convert';
import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:http/http.dart' as http;

import '../models/user_profile_model.dart';
import 'profile_remote_data_source.dart';

class HttpProfileRemoteDataSource implements ProfileRemoteDataSource {
  HttpProfileRemoteDataSource({required http.Client client}) : _client = client;
  final http.Client _client;

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  @override
  Future<UserProfileModel> getProfile({required String token}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/profile'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(json['data'] as Map<String, dynamic>);
      }
      throw ServerException(message: json['message'] as String? ?? 'Error');
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
  Future<UserProfileModel> updateProfile({
    required String token,
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? avatarUrl,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (fullName != null) body['fullName'] = fullName;
      if (phone != null) body['phone'] = phone;
      if (dateOfBirth != null) body['dateOfBirth'] = dateOfBirth;
      if (avatarUrl != null) body['avatarUrl'] = avatarUrl;

      final response = await _client.patch(
        Uri.parse('$baseUrl/profile'),
        headers: _headers(token),
        body: jsonEncode(body),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(json['data'] as Map<String, dynamic>);
      }
      throw ServerException(message: json['message'] as String? ?? 'Error');
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
