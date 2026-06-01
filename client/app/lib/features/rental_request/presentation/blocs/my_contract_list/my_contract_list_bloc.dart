import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:domain/rental_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'my_contract_list_event.dart';
part 'my_contract_list_state.dart';

@injectable
class MyContractListBloc
    extends Bloc<MyContractListEvent, MyContractListState> {
  MyContractListBloc({required GetMyContractsUsecase getMyContractsUsecase})
      : _usecase = getMyContractsUsecase,
        super(const MyContractListInitial()) {
    on<MyContractListFetched>(_onFetched);
  }

  final GetMyContractsUsecase _usecase;

  Future<void> _onFetched(
    MyContractListFetched event,
    Emitter<MyContractListState> emit,
  ) async {
    emit(const MyContractListLoadInProgress());
    final result = await _usecase(const NoParams());
    result.fold(
      (failure) => emit(MyContractListLoadFailure(failure: failure)),
      (data) => emit(MyContractListLoadSuccess(data: data)),
    );
  }
}
