import 'package:bloc/bloc.dart';
import 'package:domain/rental_request.dart'; // Import UseCase của team bạn
import 'remove_member_state.dart';

class RemoveMemberCubit extends Cubit<RemoveMemberState> {
  RemoveMemberCubit(this._removeUsecase) : super(RemoveMemberInitial());

  final RemoveContractMemberUsecase _removeUsecase;

  Future<void> removeMember({
    required String contractId,
    required String memberId,
  }) async {
    emit(RemoveMemberLoading()); // Báo UI hiện vòng xoay

    // Gọi API từ UseCase
    final result = await _removeUsecase.call(
      RemoveContractMemberParams(contractId: contractId, memberId: memberId),
    );

    // Xử lý kết quả trả về
    result.fold(
          (failure) => emit(RemoveMemberFailure(failure.message)), // Thất bại
          (_) => emit(RemoveMemberSuccess()),                      // Thành công
    );
  }
}