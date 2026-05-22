import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:domain/rental_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'landlord_request_list_event.dart';
part 'landlord_request_list_state.dart';

@injectable
class LandlordRequestListBloc
    extends Bloc<LandlordRequestListEvent, LandlordRequestListState> {
  LandlordRequestListBloc({
    required GetIncomingRequestsUsecase getIncomingRequestsUsecase,
    required RejectRentalRequestUsecase rejectRentalRequestUsecase,
  })  : _getUsecase = getIncomingRequestsUsecase,
        _rejectUsecase = rejectRentalRequestUsecase,
        super(const LandlordRequestListInitial()) {
    on<LandlordRequestListFetched>(_onFetched);
    on<LandlordRequestListRejected>(_onRejected);
  }

  final GetIncomingRequestsUsecase _getUsecase;
  final RejectRentalRequestUsecase _rejectUsecase;

  Future<void> _onFetched(
    LandlordRequestListFetched event,
    Emitter<LandlordRequestListState> emit,
  ) async {
    final prevData = state.currentOrPreviousData;
    emit(LandlordRequestListLoadInProgress(prevData: prevData));
    final result = await _getUsecase(const NoParams());
    result.fold(
      (failure) => emit(
          LandlordRequestListLoadFailure(failure: failure, prevData: prevData)),
      (data) => emit(LandlordRequestListLoadSuccess(data: data)),
    );
  }

  Future<void> _onRejected(
    LandlordRequestListRejected event,
    Emitter<LandlordRequestListState> emit,
  ) async {
    final prevData = state.currentOrPreviousData;
    emit(LandlordRequestListLoadInProgress(prevData: prevData));
    final result =
        await _rejectUsecase(RejectRentalRequestParams(id: event.id));
    result.fold(
      (failure) => emit(LandlordRequestListLoadFailure(
          failure: failure, prevData: prevData)),
      (_) => add(LandlordRequestListFetched()),
    );
  }
}
