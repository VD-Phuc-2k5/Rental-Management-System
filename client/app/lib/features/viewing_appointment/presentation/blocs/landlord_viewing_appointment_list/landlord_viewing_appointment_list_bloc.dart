import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:domain/viewing_appointment.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'landlord_viewing_appointment_list_event.dart';
part 'landlord_viewing_appointment_list_state.dart';

@injectable
class LandlordViewingAppointmentListBloc
    extends Bloc<LandlordViewingAppointmentListEvent,
        LandlordViewingAppointmentListState> {
  LandlordViewingAppointmentListBloc({
    required GetLandlordViewingAppointmentsUsecase
        getLandlordViewingAppointmentsUsecase,
    required ApproveViewingAppointmentUsecase approveViewingAppointmentUsecase,
    required RejectViewingAppointmentUsecase rejectViewingAppointmentUsecase,
  })  : _getUsecase = getLandlordViewingAppointmentsUsecase,
        _approveUsecase = approveViewingAppointmentUsecase,
        _rejectUsecase = rejectViewingAppointmentUsecase,
        super(const LandlordViewingAppointmentListInitial()) {
    on<LandlordViewingAppointmentListFetched>(_onFetched);
    on<LandlordViewingAppointmentApproved>(_onApproved);
    on<LandlordViewingAppointmentRejected>(_onRejected);
  }

  final GetLandlordViewingAppointmentsUsecase _getUsecase;
  final ApproveViewingAppointmentUsecase _approveUsecase;
  final RejectViewingAppointmentUsecase _rejectUsecase;

  Future<void> _onFetched(
    LandlordViewingAppointmentListFetched event,
    Emitter<LandlordViewingAppointmentListState> emit,
  ) async {
    emit(const LandlordViewingAppointmentListLoadInProgress());
    final result = await _getUsecase(const NoParams());
    result.fold(
      (failure) =>
          emit(LandlordViewingAppointmentListLoadFailure(failure: failure)),
      (data) => emit(LandlordViewingAppointmentListLoadSuccess(data: data)),
    );
  }

  Future<void> _onApproved(
    LandlordViewingAppointmentApproved event,
    Emitter<LandlordViewingAppointmentListState> emit,
  ) async {
    final prevData = state.currentOrPreviousData;
    emit(LandlordViewingAppointmentListLoadInProgress(prevData: prevData));
    final result = await _approveUsecase(
      ApproveViewingAppointmentParams(id: event.id),
    );
    result.fold(
      (failure) => emit(LandlordViewingAppointmentListLoadFailure(
          failure: failure, prevData: prevData)),
      (_) => add(LandlordViewingAppointmentListFetched()),
    );
  }

  Future<void> _onRejected(
    LandlordViewingAppointmentRejected event,
    Emitter<LandlordViewingAppointmentListState> emit,
  ) async {
    final prevData = state.currentOrPreviousData;
    emit(LandlordViewingAppointmentListLoadInProgress(prevData: prevData));
    final result = await _rejectUsecase(
      RejectViewingAppointmentParams(id: event.id),
    );
    result.fold(
      (failure) => emit(LandlordViewingAppointmentListLoadFailure(
          failure: failure, prevData: prevData)),
      (_) => add(LandlordViewingAppointmentListFetched()),
    );
  }
}
