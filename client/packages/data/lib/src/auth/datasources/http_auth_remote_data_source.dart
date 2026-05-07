import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:http/http.dart' as http;

import '../models/auth_model.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class HttpAuthRemoteDataSource implements AuthRemoteDataSource {
  HttpAuthRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;
  final _authStateController = StreamController<AuthModel?>.broadcast();

  void _checkInitialAuthState() {
    // TO DO: Implement token/session check logic here
    Future.microtask(() {
      _authStateController.add(null);
    });
  }

  @override
  Stream<AuthModel?> get onAuthStateChanged {
    _checkInitialAuthState();
    return _authStateController.stream;
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    required bool acceptedTerms,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          'phone': phone,
          'accepted_terms': acceptedTerms,
        }),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return UserModel.fromJson(json['data']);
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

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        final authData = AuthModel.fromJson(json['data']);
        _authStateController.add(authData);
        return authData;
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

  @override
  Future<void> logout() async {
    try {
      _authStateController.add(null);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }
}
