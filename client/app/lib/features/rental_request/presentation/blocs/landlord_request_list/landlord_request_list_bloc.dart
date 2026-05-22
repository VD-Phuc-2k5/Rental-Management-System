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
  LandlordRequestListBloc(
      {required GetIncomingRequestsUsecase getIncomingRequestsUsecase})
      : _usecase = getIncomingRequestsUsecase,
        super(const LandlordRequestListInitial()) {
    on<LandlordRequestListFetched>(_onFetched);
  }

  final GetIncomingRequestsUsecase _usecase;

  Future<void> _onFetched(
    LandlordRequestListFetched event,
    Emitter<LandlordRequestListState> emit,
  ) async {
    emit(const LandlordRequestListLoadInProgress());
    final result = await _usecase(const NoParams());
    result.fold(
      (failure) => emit(LandlordRequestListLoadFailure(failure: failure)),
      (data) => emit(LandlordRequestListLoadSuccess(data: data)),
    );
  }
}
