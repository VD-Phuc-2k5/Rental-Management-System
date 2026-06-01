import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../auth.dart';

class RegisterLandlordParams extends RegisterParams {
  const RegisterLandlordParams({
    required super.fullName,
    required super.password,
    required super.confirmPassword,
    required super.email,
    required super.phone,
    required super.acceptedTerms,
    required this.identityNumber,
  });

  final String identityNumber;

  @override
  List<Object> get props => [super.props, identityNumber];
}

class RegisterLandlordUsecase implements UseCase<void, RegisterLandlordParams> {
  RegisterLandlordUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(RegisterLandlordParams params) async {
    return _authRepository.registerLandlord(
      identityNumber: params.identityNumber,
      fullName: params.fullName,
      password: params.password,
      confirmPassword: params.confirmPassword,
      email: params.email,
      phone: params.phone,
      acceptedTerms: params.acceptedTerms,
    );
  }
}
