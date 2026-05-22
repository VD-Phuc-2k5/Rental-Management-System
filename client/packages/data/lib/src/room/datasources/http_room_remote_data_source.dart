import 'dart:convert';
import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import '../../../room.dart';
import 'package:domain/room.dart';
import 'package:http/http.dart' as http;


class HttpRoomRemoteDataSource implements RoomRemoteDataSource {
  HttpRoomRemoteDataSource({required http.Client client}) : _client = client;
  final http.Client _client;

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  @override
  Future<List<RoomModel>> getRooms({required String propertyId, required String token}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/properties/$propertyId/rooms'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return (json['data'] as List).map((e) => RoomModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw ServerException(message: json['message'] as String? ?? 'Error');
    } on SocketException { throw const NetworkException();
    } on FormatException { throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<RoomModel> getRoomById({required String id, required String token}) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/rooms/$id'), headers: _headers(token));
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) return RoomModel.fromJson(json['data'] as Map<String, dynamic>);
      throw ServerException(message: json['message'] as String? ?? 'Error');
    } on SocketException { throw const NetworkException();
    } on FormatException { throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<RoomModel> createRoom({
    required String propertyId, required String token, required String title,
    required double areaSqm, required double monthlyRent, required double depositAmount,
    required double electricityRatePerKwh, required double waterRatePerM3,
    required List<String> includedAmenityCodes,
    required List<RoomAddonAmenity> addonAmenities,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title, 'area_sqm': areaSqm, 'monthly_rent': monthlyRent,
        'deposit_amount': depositAmount, 'electricity_rate_per_kwh': electricityRatePerKwh,
        'water_rate_per_m3': waterRatePerM3,
        'included_amenity_codes': includedAmenityCodes,
        'addon_amenities': addonAmenities
            .map((a) => {'code': a.code, 'monthly_price': a.monthlyPrice})
            .toList(),
        'description': ?description,
      };
      final response = await _client.post(
        Uri.parse('$baseUrl/properties/$propertyId/rooms'),
        headers: _headers(token), body: jsonEncode(body),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) return RoomModel.fromJson(json['data'] as Map<String, dynamic>);
      throw ServerException(message: json['message'] as String? ?? 'Error');
    } on SocketException { throw const NetworkException();
    } on FormatException { throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<RoomModel> updateRoom({
    required String id, required String token, String? title, String? status,
    double? areaSqm, double? monthlyRent, double? depositAmount,
    double? electricityRatePerKwh, double? waterRatePerM3,
    List<String>? includedAmenityCodes,
    List<RoomAddonAmenity>? addonAmenities,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': ?title, 'status': ?status,
        'area_sqm': ?areaSqm, 'monthly_rent': ?monthlyRent,
        'deposit_amount': ?depositAmount,
        'electricity_rate_per_kwh': ?electricityRatePerKwh,
        'water_rate_per_m3': ?waterRatePerM3,
        'included_amenity_codes': ?includedAmenityCodes,
        if (addonAmenities != null)
          'addon_amenities': addonAmenities
              .map((a) => {'code': a.code, 'monthly_price': a.monthlyPrice})
              .toList(),
        'description': ?description,
      };
      final response = await _client.patch(
        Uri.parse('$baseUrl/rooms/$id'), headers: _headers(token), body: jsonEncode(body),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) return RoomModel.fromJson(json['data'] as Map<String, dynamic>);
      throw ServerException(message: json['message'] as String? ?? 'Error');
    } on SocketException { throw const NetworkException();
    } on FormatException { throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> deleteRoom({required String id, required String token}) async {
    try {
      final response = await _client.delete(Uri.parse('$baseUrl/rooms/$id'), headers: _headers(token));
      if (response.statusCode == 200) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw ServerException(message: json['message'] as String? ?? 'Error');
    } on SocketException { throw const NetworkException();
    } on FormatException { throw const UnknownException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnknownException) rethrow;
      throw UnknownException(message: e.toString());
    }
  }
}
