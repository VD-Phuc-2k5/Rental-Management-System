import 'priority.dart';

enum RequestStatus { pending, processing, completed, rejected }

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
    }
  }
}
