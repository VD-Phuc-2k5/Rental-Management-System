import 'package:bloc/bloc.dart';
// Import gói domain để xài Usecase
import 'package:domain/src/rental_request/rental_request.dart';
import 'penalty_state.dart';

class PenaltyCubit extends Cubit<PenaltyState> {
  PenaltyCubit(this._createPenalty, this._getContractDetail) : super(PenaltyInitial());

  final CreatePenaltyUsecase _createPenalty;
  final GetContractDetailUsecase _getContractDetail;

  Future<void> submitPenalty({
    required String contractId,
    required double amount,
    required String reason,
  }) async {
    emit(PenaltyLoading());

    final contractRes = await _getContractDetail.call(GetContractDetailParams(id: contractId));

    await contractRes.fold(
          (failure) async => emit(PenaltyFailure(failure.message)),
          (contract) async {
        final penaltyRes = await _createPenalty.call(CreatePenaltyParams(
          contractId: contractId,
          tenantId: contract.tenantId,
          roomId: contract.roomId,
          amount: amount,
          reason: reason,
        ));

        penaltyRes.fold(
              (failure) => emit(PenaltyFailure(failure.message)),
              (_) => emit(PenaltySuccess()),
        );
      },
    );
  }
}