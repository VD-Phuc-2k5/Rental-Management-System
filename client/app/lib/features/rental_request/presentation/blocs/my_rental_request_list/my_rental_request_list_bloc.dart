import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:domain/rental_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'my_rental_request_list_event.dart';
part 'my_rental_request_list_state.dart';

@injectable
class MyRentalRequestListBloc
    extends Bloc<MyRentalRequestListEvent, MyRentalRequestListState> {
  MyRentalRequestListBloc(
      {required GetMyRentalRequestsUsecase getMyRentalRequestsUsecase})
      : _usecase = getMyRentalRequestsUsecase,
        super(const MyRentalRequestListInitial()) {
    on<MyRentalRequestListFetched>(_onFetched);
  }

  final GetMyRentalRequestsUsecase _usecase;

  Future<void> _onFetched(
    MyRentalRequestListFetched event,
    Emitter<MyRentalRequestListState> emit,
  ) async {
    emit(const MyRentalRequestListLoadInProgress());
    final result = await _usecase(const NoParams());
    result.fold(
      (failure) => emit(MyRentalRequestListLoadFailure(failure: failure)),
      (data) => emit(MyRentalRequestListLoadSuccess(data: data)),
    );
  }
}
