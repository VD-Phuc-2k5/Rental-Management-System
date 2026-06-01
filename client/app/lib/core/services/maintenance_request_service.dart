import 'dart:convert';
import 'dart:io';

import 'package:core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/maintenance_request.dart';
import '../models/priority.dart';

class MaintenanceRequestService {
  MaintenanceRequestService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  String _errorMessage(http.Response response) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['message']?.toString() ?? 'Có lỗi xảy ra';
    } catch (_) {
      return 'Có lỗi xảy ra';
    }
  }

  Future<List<MaintenanceRequest>> fetchLandlordRequests({
  required String token,
}) async {
  try {
    final response = await _client.get(
      Uri.parse('$baseUrl/landlord/maintenance-requests'),
      headers: _headers(token),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      final data = json['data'] as List;

      return data
          .map(
            (item) => MaintenanceRequest.fromMap(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    }

    throw Exception(_errorMessage(response));
  } on SocketException {
    throw Exception('Không có kết nối mạng');
  } catch (e) {
    throw Exception(e.toString());
  }
}

  Future<void> scheduleMaintenanceRequest({
  required String token,
  required String requestId,
  required String technicianName,
  required String technicianPhone,
  required DateTime scheduledAt,
  String? landlordNote,
}) async {
  try {
    final response = await _client.patch(
      Uri.parse('$baseUrl/landlord/maintenance-requests/$requestId/schedule'),
      headers: _headers(token),
      body: jsonEncode({
        'technicianName': technicianName.trim(),
        'technicianPhone': technicianPhone.trim(),
        'scheduledAt': scheduledAt.toIso8601String(),
        'landlordNote': landlordNote?.trim(),
      }),
    );

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(_errorMessage(response));
  } on SocketException {
    throw Exception('Không có kết nối mạng');
  } catch (e) {
    throw Exception(e.toString());
  }
}

  Future<List<MaintenanceRequest>> fetchMyRequests({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/maintenance-requests/mine'),
        headers: _headers(token),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'] as List;

        return data
            .map(
              (item) => MaintenanceRequest.fromMap(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
      }

      throw Exception(_errorMessage(response));
    } on SocketException {
      throw Exception('Không có kết nối mạng');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> createRequest({
    required String token,
    required String title,
    required String description,
    required String location,
    required Priority priority,
    List<XFile> images = const [],
  }) async {
    try {
      final imageUrls = await _uploadImages(
        token: token,
        images: images,
      );

      final body = {
        'title': title.trim(),
        'description': description.trim(),
        'location': location.trim(),
        'priority': priority.name,
        if (imageUrls.isNotEmpty) 'imageUrls': imageUrls,
      };

      final response = await _client.post(
        Uri.parse('$baseUrl/maintenance-requests'),
        headers: _headers(token),
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      }

      throw Exception(_errorMessage(response));
    } on SocketException {
      throw Exception('Không có kết nối mạng');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<String>> _uploadImages({
    required String token,
    required List<XFile> images,
    String bucket = 'maintenance-requests',
  }) async {
    if (images.isEmpty) return const [];

    final urls = <String>[];

    for (final image in images) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/image?bucket=$bucket'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      final bytes = await image.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: image.name,
        ),
      );

      final streamedResponse = await _client.send(request);
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 201 ||
          streamedResponse.statusCode == 200) {
        final json = jsonDecode(responseBody) as Map<String, dynamic>;

        final data = json['data'];

        if (data is Map && data['url'] != null) {
          urls.add(data['url'].toString());
        } else if (json['url'] != null) {
          urls.add(json['url'].toString());
        }

        continue;
      }

      throw Exception(
  'Upload ảnh thất bại: ${streamedResponse.statusCode} - $responseBody',
);
    }

    return urls;
  }

  Future<MaintenanceRequest> completeRequest({
      required String token,
      required String requestId,
    }) async {
      try {
        final response = await _client.patch(
          Uri.parse('$baseUrl/maintenance-requests/$requestId/complete'),
          headers: _headers(token),
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);

          final data = json is Map<String, dynamic> && json['data'] != null
              ? json['data']
              : json;

          return MaintenanceRequest.fromMap(
            Map<String, dynamic>.from(data as Map),
          );
        }

        throw Exception(_errorMessage(response));
      } on SocketException {
        throw Exception('Không có kết nối mạng');
      } catch (e) {
        throw Exception(e.toString());
      }
    }
    
    Future<MaintenanceRequest> fetchRequestDetail({
      required String token,
      required String requestId,
    }) async {
      try {
        final response = await _client.get(
          Uri.parse('$baseUrl/maintenance-requests/$requestId'),
          headers: _headers(token),
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);

          final data = json is Map<String, dynamic> && json['data'] != null
              ? json['data']
              : json;

          return MaintenanceRequest.fromMap(
            Map<String, dynamic>.from(data as Map),
          );
        }

        throw Exception(_errorMessage(response));
      } on SocketException {
        throw Exception('Không có kết nối mạng');
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    Future<MaintenanceRequest> submitComplaint({
      required String token,
      required String requestId,
      required String complaintDescription,
      List<XFile> images = const [],
    }) async {
      try {
        final complaintImageUrls = await _uploadImages(
          token: token,
          images: images,
          bucket: 'maintenance-requests',
        );

        final response = await _client.patch(
          Uri.parse('$baseUrl/maintenance-requests/$requestId/complaint'),
          headers: _headers(token),
          body: jsonEncode({
            'complaintDescription': complaintDescription.trim(),
            if (complaintImageUrls.isNotEmpty)
              'complaintImageUrls': complaintImageUrls,
          }),
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);

          final data = json is Map<String, dynamic> && json['data'] != null
              ? json['data']
              : json;

          return MaintenanceRequest.fromMap(
            Map<String, dynamic>.from(data as Map),
          );
        }

        throw Exception(_errorMessage(response));
      } on SocketException {
        throw Exception('Không có kết nối mạng');
      } catch (e) {
        throw Exception(e.toString());
      }
    }
}