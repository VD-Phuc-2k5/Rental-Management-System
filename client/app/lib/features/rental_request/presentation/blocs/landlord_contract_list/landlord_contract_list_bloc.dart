import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:domain/rental_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'landlord_contract_list_event.dart';
part 'landlord_contract_list_state.dart';

@injectable
class LandlordContractListBloc
    extends Bloc<LandlordContractListEvent, LandlordContractListState> {
  LandlordContractListBloc(
      {required GetLandlordContractsUsecase getLandlordContractsUsecase})
      : _usecase = getLandlordContractsUsecase,
        super(const LandlordContractListInitial()) {
    on<LandlordContractListFetched>(_onFetched);
  }

  final GetLandlordContractsUsecase _usecase;

  Future<void> _onFetched(
    LandlordContractListFetched event,
    Emitter<LandlordContractListState> emit,
  ) async {
    final prevData = state.currentOrPreviousData;
    emit(LandlordContractListLoadInProgress(prevData: prevData));
    final result = await _usecase(const NoParams());
    result.fold(
      (failure) => emit(LandlordContractListLoadFailure(
          failure: failure, prevData: prevData)),
      (data) => emit(LandlordContractListLoadSuccess(data: data)),
    );
  }
}
