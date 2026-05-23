import 'package:domain/viewing_appointment.dart';

class ViewingAppointmentModel extends ViewingAppointmentEntity {
  ViewingAppointmentModel({
    required super.id,
    required super.tenantId,
    required super.roomId,
    required super.scheduledAt,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.note,
    super.roomTitle,
    super.roomAddress,
    super.roomMonthlyRent,
  });

  factory ViewingAppointmentModel.fromJson(Map<String, dynamic> json) =>
      ViewingAppointmentModel(
        id: json['id'] as String,
        tenantId: json['tenantId'] as String,
        roomId: json['roomId'] as String,
        scheduledAt: json['scheduledAt'] as String,
        status: _statusFromJson(json['status'] as String),
        note: json['note'] as String?,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
        roomTitle: json['roomTitle'] as String?,
        roomAddress: json['roomAddress'] as String?,
        roomMonthlyRent: json['roomMonthlyRent'] as String?,
      );
}

ViewingAppointmentStatus _statusFromJson(String v) =>
    ViewingAppointmentStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == v.toUpperCase(),
      orElse: () => ViewingAppointmentStatus.pending,
    );
