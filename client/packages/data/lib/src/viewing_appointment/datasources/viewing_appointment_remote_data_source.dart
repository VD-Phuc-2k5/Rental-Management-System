import '../models/viewing_appointment_model.dart';

abstract interface class ViewingAppointmentRemoteDataSource {
  Future<ViewingAppointmentModel> createViewingAppointment({
    required String token,
    required String roomId,
    required String scheduledAt,
    String? note,
  });

  Future<List<ViewingAppointmentModel>> getMyViewingAppointments({
    required String token,
  });

  Future<List<ViewingAppointmentModel>> getLandlordViewingAppointments({
    required String token,
  });

  Future<ViewingAppointmentModel> approveViewingAppointment({
    required String token,
    required String id,
  });

  Future<ViewingAppointmentModel> rejectViewingAppointment({
    required String token,
    required String id,
  });

  Future<void> cancelViewingAppointment({
    required String token,
    required String id,
  });
}
