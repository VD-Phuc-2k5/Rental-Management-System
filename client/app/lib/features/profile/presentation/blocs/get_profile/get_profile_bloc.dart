import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:domain/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'get_profile_event.dart';
part 'get_profile_state.dart';

@injectable
class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  GetProfileBloc({required GetProfileUsecase getProfileUsecase})
      : _getProfileUsecase = getProfileUsecase,
        super(const GetProfileInitial()) {
    on<GetProfileFetched>(_onFetched);
  }

  final GetProfileUsecase _getProfileUsecase;

  Future<void> _onFetched(
    GetProfileFetched event,
    Emitter<GetProfileState> emit,
  ) async {
    emit(const GetProfileLoadInProgress());
    final result = await _getProfileUsecase(const NoParams());
    result.fold(
      (failure) => emit(GetProfileLoadFailure(failure: failure)),
      (data) => emit(GetProfileLoadSuccess(data: data)),
    );
  }
}
