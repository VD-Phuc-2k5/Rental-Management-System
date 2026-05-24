import 'package:bloc/bloc.dart';
import 'package:domain/rental_request.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'deposit_payment_state.dart';

@injectable
class DepositPaymentCubit extends Cubit<DepositPaymentState> {
  DepositPaymentCubit({
    required CreateVnpayPaymentUsecase createVnpayPaymentUsecase,
    required CancelContractUsecase cancelContractUsecase,
  }) : _createVnpayPayment = createVnpayPaymentUsecase,
       _cancelContract = cancelContractUsecase,
       super(const DepositPaymentInitial());

  final CreateVnpayPaymentUsecase _createVnpayPayment;
  final CancelContractUsecase _cancelContract;

  Future<void> pay(String contractId) async {
    emit(const DepositPaymentLoading());
    final result = await _createVnpayPayment(
      CreateVnpayPaymentParams(contractId: contractId),
    );
    result.fold(
      (failure) => emit(DepositPaymentFailure(failure.toString())),
      (payment) => emit(
        DepositPaymentSuccess(
          payUrl: payment.payUrl,
          deeplink: payment.deeplink,
        ),
      ),
    );
  }

  Future<void> reject(String contractId) async {
    emit(const DepositPaymentRejecting());
    final result = await _cancelContract(
      CancelContractParams(id: contractId),
    );
    result.fold(
      (failure) => emit(DepositPaymentFailure(failure.toString())),
      (_) => emit(const DepositPaymentRejected()),
    );
  }
}
