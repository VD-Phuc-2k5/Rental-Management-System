import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/viewing_appointment.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'create_viewing_appointment_event.dart';
part 'create_viewing_appointment_state.dart';

@injectable
class CreateViewingAppointmentBloc
    extends Bloc<CreateViewingAppointmentEvent, CreateViewingAppointmentState> {
  CreateViewingAppointmentBloc(
      {required CreateViewingAppointmentUsecase createViewingAppointmentUsecase})
      : _usecase = createViewingAppointmentUsecase,
        super(const CreateViewingAppointmentInitial()) {
    on<CreateViewingAppointmentSubmitted>(_onSubmitted);
  }

  final CreateViewingAppointmentUsecase _usecase;

  Future<void> _onSubmitted(
    CreateViewingAppointmentSubmitted event,
    Emitter<CreateViewingAppointmentState> emit,
  ) async {
    emit(const CreateViewingAppointmentLoadInProgress());
    final result = await _usecase(
      CreateViewingAppointmentParams(
        roomId: event.roomId,
        scheduledAt: event.scheduledAt,
        note: event.note,
      ),
    );
    result.fold(
      (failure) => emit(CreateViewingAppointmentLoadFailure(failure: failure)),
      (data) => emit(CreateViewingAppointmentLoadSuccess(data: data)),
    );
  }
}
