part of 'deposit_payment_cubit.dart';

sealed class DepositPaymentState extends Equatable {
  const DepositPaymentState();
}

class DepositPaymentInitial extends DepositPaymentState {
  const DepositPaymentInitial();

  @override
  List<Object?> get props => [];
}

class DepositPaymentLoading extends DepositPaymentState {
  const DepositPaymentLoading();

  @override
  List<Object?> get props => [];
}

class DepositPaymentSuccess extends DepositPaymentState {
  const DepositPaymentSuccess({required this.payUrl, required this.deeplink});

  final String payUrl;
  final String deeplink;

  @override
  List<Object?> get props => [payUrl, deeplink];
}

class DepositPaymentFailure extends DepositPaymentState {
  const DepositPaymentFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class DepositPaymentRejecting extends DepositPaymentState {
  const DepositPaymentRejecting();

  @override
  List<Object?> get props => [];
}

class DepositPaymentRejected extends DepositPaymentState {
  const DepositPaymentRejected();

  @override
  List<Object?> get props => [];
}
