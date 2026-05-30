import 'package:bloc/bloc.dart';
import 'package:domain/rental_request.dart';
import 'contract_members_state.dart';

class ContractMembersCubit extends Cubit<ContractMembersState> {
  ContractMembersCubit(this._usecase) : super(ContractMembersInitial());

  final GetContractMembersUsecase _usecase;

  Future<void> fetchMembers(String contractId) async {
    emit(ContractMembersLoading());

    // Gọi API thông qua UseCase của team
    final result = await _usecase.call(
      GetContractMembersParams(contractId: contractId),
    );

    result.fold(
          (failure) => emit(ContractMembersFailure(failure.message)),
          (members) => emit(ContractMembersSuccess(members)),
    );
  }
}