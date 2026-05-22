import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../viewing_appointment.dart';

class CancelViewingAppointmentParams extends Equatable {
  const CancelViewingAppointmentParams({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

class CancelViewingAppointmentUsecase
    implements UseCase<void, CancelViewingAppointmentParams> {
  CancelViewingAppointmentUsecase({required ViewingAppointmentRepository repo})
      : _repo = repo;

  final ViewingAppointmentRepository _repo;

  @override
  Future<Either<Failure, void>> call(CancelViewingAppointmentParams params) {
    return _repo.cancelViewingAppointment(id: params.id);
  }
}
