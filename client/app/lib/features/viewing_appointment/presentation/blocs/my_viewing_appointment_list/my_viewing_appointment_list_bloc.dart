import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:domain/viewing_appointment.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'my_viewing_appointment_list_event.dart';
part 'my_viewing_appointment_list_state.dart';

@injectable
class MyViewingAppointmentListBloc extends Bloc<MyViewingAppointmentListEvent,
    MyViewingAppointmentListState> {
  MyViewingAppointmentListBloc({
    required GetMyViewingAppointmentsUsecase getMyViewingAppointmentsUsecase,
    required CancelViewingAppointmentUsecase cancelViewingAppointmentUsecase,
  })  : _getUsecase = getMyViewingAppointmentsUsecase,
        _cancelUsecase = cancelViewingAppointmentUsecase,
        super(const MyViewingAppointmentListInitial()) {
    on<MyViewingAppointmentListFetched>(_onFetched);
    on<MyViewingAppointmentCancelled>(_onCancelled);
  }

  final GetMyViewingAppointmentsUsecase _getUsecase;
  final CancelViewingAppointmentUsecase _cancelUsecase;

  Future<void> _onFetched(
    MyViewingAppointmentListFetched event,
    Emitter<MyViewingAppointmentListState> emit,
  ) async {
    emit(const MyViewingAppointmentListLoadInProgress());
    final result = await _getUsecase(const NoParams());
    result.fold(
      (failure) => emit(MyViewingAppointmentListLoadFailure(failure: failure)),
      (data) => emit(MyViewingAppointmentListLoadSuccess(data: data)),
    );
  }

  Future<void> _onCancelled(
    MyViewingAppointmentCancelled event,
    Emitter<MyViewingAppointmentListState> emit,
  ) async {
    final prevData = state.currentOrPreviousData;
    emit(MyViewingAppointmentListLoadInProgress(prevData: prevData));
    final result = await _cancelUsecase(
      CancelViewingAppointmentParams(id: event.id),
    );
    result.fold(
      (failure) => emit(
        MyViewingAppointmentListLoadFailure(failure: failure, prevData: prevData),
      ),
      (_) => add(MyViewingAppointmentListFetched()),
    );
  }
}
