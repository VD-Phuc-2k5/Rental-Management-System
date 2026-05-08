part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

final class ForgotPasswordRequested extends ForgotPasswordEvent {
  const ForgotPasswordRequested({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}
