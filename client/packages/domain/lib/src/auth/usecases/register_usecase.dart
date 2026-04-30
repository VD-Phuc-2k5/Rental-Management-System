import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.fullName,
    required this.password,
    required this.email,
    required this.phone,
  });

  final String fullName;
  final String password;
  final String email;
  final String phone;

  @override
  List<Object> get props => [fullName, password, email, phone];
}

class RegisterUsecase implements UseCase<void, RegisterParams> {
  RegisterUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(RegisterParams params) async {
    return await _authRepository.register(
      fullName: params.fullName,
      password: params.password,
      email: params.email,
      phone: params.phone,
    );
  }
}
