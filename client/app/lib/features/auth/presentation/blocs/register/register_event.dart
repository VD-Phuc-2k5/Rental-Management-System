part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

final class RegisterRequested extends RegisterEvent {
  const RegisterRequested({
    required this.fullName,
    required this.password,
    required this.confirmPassword,
    required this.email,
    required this.phone,
    required this.acceptedTerms,
  });

  final String fullName;
  final String password;
  final String confirmPassword;
  final String email;
  final String phone;
  final bool acceptedTerms;

  @override
  List<Object> get props => [fullName, password, email, phone];
}
