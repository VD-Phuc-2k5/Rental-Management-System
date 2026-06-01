import 'package:bloc/bloc.dart';
import 'package:domain/rental_request.dart';
import 'package:injectable/injectable.dart';

// Import từ các package bên ngoài
import 'package:core/usecase.dart';

import 'room_contract_state.dart';

@injectable
class RoomContractCubit extends Cubit<RoomContractState> {
  RoomContractCubit(this._getLandlordContracts) : super(RoomContractInitial());

  final GetLandlordContractsUsecase _getLandlordContracts;

  Future<void> fetchActiveContract(String roomId) async {
    emit(RoomContractLoading());

    // Gọi Usecase lấy danh sách hợp đồng
    final result = await _getLandlordContracts.call(const NoParams());

    result.fold(
      (failure) => emit(RoomContractFailure(failure.message)),
      (contracts) {
        try {
          // Lọc tìm hợp đồng của đúng phòng này và đang ở trạng thái đã ký (signed)
          final activeContract = contracts.firstWhere(
            (c) => c.roomId == roomId && c.status == ContractStatus.signed,
          );
          emit(RoomContractSuccess(activeContract.id));
        } catch (e) {
          // firstWhere quăng lỗi nếu không tìm thấy
          emit(RoomContractEmpty());
        }
      },
    );
  }
}
