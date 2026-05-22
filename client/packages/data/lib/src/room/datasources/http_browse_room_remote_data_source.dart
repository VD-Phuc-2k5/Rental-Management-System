import 'dart:convert';
import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:http/http.dart' as http;

import '../models/available_room_model.dart';
import '../models/browse_room_detail_model.dart';
import 'browse_room_remote_data_source.dart';

class HttpBrowseRoomRemoteDataSource implements BrowseRoomRemoteDataSource {
  HttpBrowseRoomRemoteDataSource({required http.Client client})
      : _client = client;

  final http.Client _client;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  @override
  Future<List<AvailableRoomModel>> getAvailableRooms({
    required String token,
    double? minRent,
    double? maxRent,
  }) async {
    try {
      final queryParams = <String, String>{
        if (minRent != null) 'minRent': minRent.toString(),
        if (maxRent != null) 'maxRent': maxRent.toString(),
      };
      final uri = Uri.parse('$baseUrl/browse/rooms').replace(
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );
      final response = await _client.get(uri, headers: _headers(token));
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return (json['data'] as List)
            .map((e) => AvailableRoomModel.fromJson(e as Map<String, dynamic>))
            .toList();
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
  Future<BrowseRoomDetailModel> getRoomDetail({
    required String id,
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/browse/rooms/$id'),
        headers: _headers(token),
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return BrowseRoomDetailModel.fromJson(
            json['data'] as Map<String, dynamic>);
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
