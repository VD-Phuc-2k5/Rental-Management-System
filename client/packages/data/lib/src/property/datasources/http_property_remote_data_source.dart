import 'dart:convert';
import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import '../../../property.dart';
import 'package:http/http.dart' as http;


class HttpPropertyRemoteDataSource implements PropertyRemoteDataSource {
  HttpPropertyRemoteDataSource({required http.Client client}) : _client = client;
  final http.Client _client;

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  @override
  Future<List<PropertyModel>> getProperties({required String token}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/properties'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final list = json['data'] as List<dynamic>;
        return list.map((e) => PropertyModel.fromJson(e as Map<String, dynamic>)).toList();
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
  Future<PropertyModel> getPropertyById({required String id, required String token}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/properties/$id'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) return PropertyModel.fromJson(json['data'] as Map<String, dynamic>);
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
  Future<PropertyModel> createProperty({
    required String token,
    required String name,
    required String address,
    required String ward,
    required String district,
    required String city,
    required String description,
    required List<String> amenityCodes,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/properties'),
        headers: _headers(token),
        body: jsonEncode({
          'name': name, 'address': address, 'ward': ward,
          'district': district, 'city': city, 'description': description,
          'amenityCodes': amenityCodes,
        }),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) return PropertyModel.fromJson(json['data'] as Map<String, dynamic>);
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
  Future<PropertyModel> updateProperty({
    required String id,
    required String token,
    String? name,
    String? address,
    String? ward,
    String? district,
    String? city,
    String? description,
    List<String>? amenityCodes,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (address != null) body['address'] = address;
      if (ward != null) body['ward'] = ward;
      if (district != null) body['district'] = district;
      if (city != null) body['city'] = city;
      if (description != null) body['description'] = description;
      if (amenityCodes != null) body['amenityCodes'] = amenityCodes;

      final response = await _client.patch(
        Uri.parse('$baseUrl/properties/$id'),
        headers: _headers(token),
        body: jsonEncode(body),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) return PropertyModel.fromJson(json['data'] as Map<String, dynamic>);
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
  Future<void> deleteProperty({required String id, required String token}) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/properties/$id'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
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
