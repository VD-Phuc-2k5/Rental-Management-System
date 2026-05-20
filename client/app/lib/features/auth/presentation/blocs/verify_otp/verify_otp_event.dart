part of 'verify_otp_bloc.dart';

sealed class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

final class VerifyOtpRequested extends VerifyOtpEvent {
  const VerifyOtpRequested({required this.otp});

  final String otp;

  @override
  List<Object> get props => [otp];
}

final class AddEmail extends VerifyOtpEvent {
  const AddEmail({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

final class ResendOtpRequested extends VerifyOtpEvent {
  const ResendOtpRequested();

  @override
  List<Object> get props => [];
}
