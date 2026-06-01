import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/rental_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'contract_detail_event.dart';
part 'contract_detail_state.dart';

@injectable
class ContractDetailBloc
    extends Bloc<ContractDetailEvent, ContractDetailState> {
  ContractDetailBloc(
      {required GetContractDetailUsecase getContractDetailUsecase})
      : _usecase = getContractDetailUsecase,
        super(const ContractDetailInitial()) {
    on<ContractDetailFetched>(_onFetched);
  }

  final GetContractDetailUsecase _usecase;

  Future<void> _onFetched(
    ContractDetailFetched event,
    Emitter<ContractDetailState> emit,
  ) async {
    emit(const ContractDetailLoadInProgress());
    final result =
        await _usecase(GetContractDetailParams(id: event.contractId));
    result.fold(
      (failure) => emit(ContractDetailLoadFailure(failure: failure)),
      (data) => emit(ContractDetailLoadSuccess(data: data)),
    );
  }
}
