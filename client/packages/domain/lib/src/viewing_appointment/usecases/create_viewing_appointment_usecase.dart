import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../viewing_appointment.dart';

class CreateViewingAppointmentParams extends Equatable {
  const CreateViewingAppointmentParams({
    required this.roomId,
    required this.scheduledAt,
    this.note,
  });

  final String roomId;
  final String scheduledAt;
  final String? note;

  @override
  List<Object?> get props => [roomId, scheduledAt, note];
}

class CreateViewingAppointmentUsecase
    implements UseCase<ViewingAppointmentEntity, CreateViewingAppointmentParams> {
  CreateViewingAppointmentUsecase({required ViewingAppointmentRepository repo})
      : _repo = repo;

  final ViewingAppointmentRepository _repo;

  @override
  Future<Either<Failure, ViewingAppointmentEntity>> call(
    CreateViewingAppointmentParams params,
  ) {
    return _repo.createViewingAppointment(
      roomId: params.roomId,
      scheduledAt: params.scheduledAt,
      note: params.note,
    );
  }
}
