import 'priority.dart';

enum RequestStatus { pending, processing, completed, rejected, complaint  }

class MaintenanceRequest {
  MaintenanceRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.imageUrls = const [],
    this.tenantName,

    this.technicianName,
    this.technicianPhone,
    this.scheduledAt,
    this.landlordNote,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final Priority priority;
  final RequestStatus status;
  final DateTime createdAt;
  final List<String> imageUrls;
  final String? tenantName;
  
  final String? technicianName;
  final String? technicianPhone;
  final DateTime? scheduledAt;
  final String? landlordNote;
  factory MaintenanceRequest.fromMap(Map<String, dynamic> map) {
  return MaintenanceRequest(
    id: map['id']?.toString() ?? '',
    title: map['title']?.toString() ?? '',
    description: map['description']?.toString() ?? '',
    location: map['location']?.toString() ?? '',
    priority: _parsePriority(map['priority']),
    status: _parseStatus(map['status']),
    createdAt: DateTime.tryParse(
          map['createdAt']?.toString() ??
              map['created_at']?.toString() ??
              '',
        )?.toLocal() ??
        DateTime.now(),
    imageUrls: _parseImageUrls(
      map['imageUrls'] ?? map['image_urls'],
    ),
    tenantName: map['tenantName']?.toString() ??
        map['tenant_name']?.toString(),
    
    technicianName: map['technicianName']?.toString() ??
        map['technician_name']?.toString(),
    technicianPhone: map['technicianPhone']?.toString() ??
        map['technician_phone']?.toString(),
    scheduledAt: DateTime.tryParse(
      map['scheduledAt']?.toString() ??
          map['scheduled_at']?.toString() ??
          '',
    )?.toLocal(),
    landlordNote: map['landlordNote']?.toString() ??
        map['landlord_note']?.toString(),
  );
}

  static Priority _parsePriority(dynamic value) {
    return Priority.values.firstWhere(
      (e) => e.name == value?.toString(),
      orElse: () => Priority.low,
    );
  }

  static RequestStatus _parseStatus(dynamic value) {
    return RequestStatus.values.firstWhere(
      (e) => e.name == value?.toString(),
      orElse: () => RequestStatus.pending,
    );
  }

  static List<String> _parseImageUrls(dynamic value) {
    if (value == null) return const [];

    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    return const [];
  }
}

extension RequestStatusExtension on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.pending:
        return "Chờ xử lý";
      case RequestStatus.processing:
        return "Đang xử lý";
      case RequestStatus.completed:
        return "Hoàn thành";
      case RequestStatus.rejected:
        return "Từ chối";
      case RequestStatus.complaint:
        return "Khiếu nại";
    }
  }
}