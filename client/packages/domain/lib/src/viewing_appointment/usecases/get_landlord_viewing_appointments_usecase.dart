import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../viewing_appointment.dart';

class GetLandlordViewingAppointmentsUsecase
    implements UseCase<List<ViewingAppointmentEntity>, NoParams> {
  GetLandlordViewingAppointmentsUsecase({
    required ViewingAppointmentRepository repo,
  }) : _repo = repo;

  final ViewingAppointmentRepository _repo;

  @override
  Future<Either<Failure, List<ViewingAppointmentEntity>>> call(NoParams params) {
    return _repo.getLandlordViewingAppointments();
  }
}
