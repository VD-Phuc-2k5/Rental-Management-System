part of 'register_landlord_bloc.dart';

sealed class RegisterLandlordEvent extends Equatable {
  const RegisterLandlordEvent();

  @override
  List<Object> get props => [];
}

final class RegisterLandlordRequested extends RegisterLandlordEvent {
  const RegisterLandlordRequested({
    required this.identityNumber,
    required this.fullName,
    required this.password,
    required this.confirmPassword,
    required this.email,
    required this.phone,
    required this.acceptedTerms,
  });

  final String identityNumber;
  final String fullName;
  final String password;
  final String confirmPassword;
  final String email;
  final String phone;
  final bool acceptedTerms;

  @override
  List<Object> get props => [identityNumber, fullName, password, email, phone];
}
