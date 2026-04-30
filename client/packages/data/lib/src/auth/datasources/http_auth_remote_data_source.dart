import 'dart:convert';
import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class HttpAuthRemoteDataSource implements AuthRemoteDataSource {
  HttpAuthRemoteDataSource({required this.client});

  final http.Client client;

  @override
  Future<UserModel> register({
    required String fullName,
    required String password,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await client.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return UserModel.fromJson(json);
      }

      throw AuthenticationException(message: json['message'] as String);
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const UnknownException(
        message: 'Invalid response format',
      );
    } catch (e) {
      throw UnknownException(
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }
}
