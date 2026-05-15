part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

final class ResetPasswordRequested extends ResetPasswordEvent {
  const ResetPasswordRequested({
    required this.newPassword,
    required this.confirmPassword,
  });

  final String newPassword;
  final String confirmPassword;

  @override
  List<Object> get props => [newPassword, confirmPassword];
}


