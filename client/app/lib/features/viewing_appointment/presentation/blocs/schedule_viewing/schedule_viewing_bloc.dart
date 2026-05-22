import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/viewing_appointment.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'schedule_viewing_event.dart';
part 'schedule_viewing_state.dart';

@injectable
class ScheduleViewingBloc
    extends Bloc<ScheduleViewingEvent, ScheduleViewingState> {
  ScheduleViewingBloc(
      {required CreateViewingAppointmentUsecase createViewingAppointmentUsecase})
      : _usecase = createViewingAppointmentUsecase,
        super(const ScheduleViewingInitial()) {
    on<ScheduleViewingSubmitted>(_onSubmitted);
  }

  final CreateViewingAppointmentUsecase _usecase;

  Future<void> _onSubmitted(
    ScheduleViewingSubmitted event,
    Emitter<ScheduleViewingState> emit,
  ) async {
    emit(const ScheduleViewingLoadInProgress());
    final result = await _usecase(
      CreateViewingAppointmentParams(
        roomId: event.roomId,
        scheduledAt: event.scheduledAt,
        note: event.note,
      ),
    );
    result.fold(
      (failure) => emit(ScheduleViewingLoadFailure(failure: failure)),
      (data) => emit(ScheduleViewingLoadSuccess(data: data)),
    );
  }
}
