import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required LoginUsecase loginUsecase,
  }) : _loginUsecase = loginUsecase,
       super(const LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  final LoginUsecase _loginUsecase;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoadInProgress());

    final result = await _loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(LoginLoadFailure(failure: failure)),
      (data) => emit(LoginLoadSuccess(data: data)),
    );
  }
}
