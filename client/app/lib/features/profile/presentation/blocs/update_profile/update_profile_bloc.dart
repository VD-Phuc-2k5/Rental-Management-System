import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

@injectable
class UpdateProfileBloc
    extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc({required UpdateProfileUsecase updateProfileUsecase})
      : _updateProfileUsecase = updateProfileUsecase,
        super(const UpdateProfileInitial()) {
    on<UpdateProfileSubmitted>(_onSubmitted);
  }

  final UpdateProfileUsecase _updateProfileUsecase;

  Future<void> _onSubmitted(
    UpdateProfileSubmitted event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(const UpdateProfileLoadInProgress());
    final result = await _updateProfileUsecase(
      UpdateProfileParams(
        fullName: event.fullName,
        phone: event.phone,
        dateOfBirth: event.dateOfBirth,
        avatarUrl: event.avatarUrl,
      ),
    );
    result.fold(
      (failure) => emit(UpdateProfileLoadFailure(failure: failure)),
      (data) => emit(UpdateProfileLoadSuccess(data: data)),
    );
  }
}
