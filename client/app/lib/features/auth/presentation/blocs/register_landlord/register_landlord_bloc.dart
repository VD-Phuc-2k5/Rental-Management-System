import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'register_landlord_event.dart';
part 'register_landlord_state.dart';

@Injectable()
class RegisterLandlordBloc
    extends Bloc<RegisterLandlordEvent, RegisterLandlordState> {
  RegisterLandlordBloc({
    required RegisterLandlordUsecase registerLandlordUsecase,
  }) : _registerLandlordUsecase = registerLandlordUsecase,
       super(const RegisterLandlordInitial()) {
    on<RegisterLandlordRequested>(_onRegisterRequested);
  }

  final RegisterLandlordUsecase _registerLandlordUsecase;

  Future<void> _onRegisterRequested(
    RegisterLandlordRequested event,
    Emitter<RegisterLandlordState> emit,
  ) async {
    emit(const RegisterLandlordLoadInProgress());

    final result = await _registerLandlordUsecase(
      RegisterLandlordParams(
        identityNumber: event.identityNumber,
        fullName: event.fullName,
        password: event.password,
        confirmPassword: event.confirmPassword,
        email: event.email,
        phone: event.phone,
        acceptedTerms: event.acceptedTerms,
      ),
    );

    result.fold(
      (failure) => emit(RegisterLandlordLoadFailure(failure: failure)),
      (_) => emit(const RegisterLandlordLoadSuccess(data: null)),
    );
  }
}
