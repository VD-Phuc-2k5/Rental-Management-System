import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../../viewing_appointment.dart';

abstract interface class ViewingAppointmentRepository {
  Future<Either<Failure, ViewingAppointmentEntity>> createViewingAppointment({
    required String roomId,
    required String scheduledAt,
    String? note,
  });

  Future<Either<Failure, List<ViewingAppointmentEntity>>> getMyViewingAppointments();

  Future<Either<Failure, List<ViewingAppointmentEntity>>> getLandlordViewingAppointments();

  Future<Either<Failure, ViewingAppointmentEntity>> approveViewingAppointment({
    required String id,
  });

  Future<Either<Failure, ViewingAppointmentEntity>> rejectViewingAppointment({
    required String id,
  });

  Future<Either<Failure, void>> cancelViewingAppointment({required String id});
}
