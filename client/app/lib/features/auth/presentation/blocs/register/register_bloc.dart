import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'register_event.dart';
part 'register_state.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required RegisterUsecase registerUsecase})
    : _registerUsecase = registerUsecase,
      super(const RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  final RegisterUsecase _registerUsecase;

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoadInProgress());

    final result = await _registerUsecase(
      RegisterParams(
        fullName: event.fullName,
        password: event.password,
        email: event.email,
        phone: event.phone,
      ),
    );

    result.fold(
      (failure) => emit(RegisterLoadFailure(failure: failure)),
      (_) => emit(const RegisterLoadSuccess(data: null)),
    );
  }
}
