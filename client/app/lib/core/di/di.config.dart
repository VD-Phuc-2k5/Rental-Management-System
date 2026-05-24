// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/auth.dart' as _i41;
import 'package:data/profile.dart' as _i366;
import 'package:data/property.dart' as _i83;
import 'package:data/rental_request.dart' as _i411;
import 'package:data/room.dart' as _i586;
import 'package:data/viewing_appointment.dart' as _i1022;
import 'package:domain/auth.dart' as _i378;
import 'package:domain/profile.dart' as _i503;
import 'package:domain/property.dart' as _i369;
import 'package:domain/rental_request.dart' as _i284;
import 'package:domain/room.dart' as _i142;
import 'package:domain/viewing_appointment.dart' as _i278;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart'
    as _i652;
import '../../features/auth/presentation/blocs/forgot_password/forgot_password_bloc.dart'
    as _i1047;
import '../../features/auth/presentation/blocs/login/login_bloc.dart' as _i1018;
import '../../features/auth/presentation/blocs/register/register_bloc.dart'
    as _i517;
import '../../features/auth/presentation/blocs/register_landlord/register_landlord_bloc.dart'
    as _i165;
import '../../features/auth/presentation/blocs/verify_otp/verify_otp_bloc.dart'
    as _i452;
import '../../features/home/presentation/blocs/available_room_list/available_room_list_bloc.dart'
    as _i779;
import '../../features/home/presentation/blocs/browse_room_detail/browse_room_detail_bloc.dart'
    as _i511;
import '../../features/profile/presentation/blocs/get_profile/get_profile_bloc.dart'
    as _i373;
import '../../features/profile/presentation/blocs/update_profile/update_profile_bloc.dart'
    as _i275;
import '../../features/property/presentation/blocs/create_property/create_property_bloc.dart'
    as _i509;
import '../../features/property/presentation/blocs/delete_property/delete_property_bloc.dart'
    as _i634;
import '../../features/property/presentation/blocs/property_list/property_list_bloc.dart'
    as _i327;
import '../../features/property/presentation/blocs/update_property/update_property_bloc.dart'
    as _i1054;
import '../../features/rental_request/presentation/blocs/contract_detail/contract_detail_bloc.dart'
    as _i269;
import '../../features/rental_request/presentation/blocs/create_rental_request/create_rental_request_bloc.dart'
    as _i715;
import '../../features/rental_request/presentation/blocs/deposit_payment/deposit_payment_cubit.dart'
    as _i260;
import '../../features/rental_request/presentation/blocs/landlord_contract_list/landlord_contract_list_bloc.dart'
    as _i116;
import '../../features/rental_request/presentation/blocs/landlord_request_list/landlord_request_list_bloc.dart'
    as _i598;
import '../../features/rental_request/presentation/blocs/my_contract_list/my_contract_list_bloc.dart'
    as _i267;
import '../../features/rental_request/presentation/blocs/my_rental_request_list/my_rental_request_list_bloc.dart'
    as _i507;
import '../../features/room/presentation/blocs/create_room/create_room_bloc.dart'
    as _i621;
import '../../features/room/presentation/blocs/delete_room/delete_room_bloc.dart'
    as _i171;
import '../../features/room/presentation/blocs/room_list/room_list_bloc.dart'
    as _i187;
import '../../features/room/presentation/blocs/update_room/update_room_bloc.dart'
    as _i746;
import '../../features/viewing_appointment/presentation/blocs/create_viewing_appointment/create_viewing_appointment_bloc.dart'
    as _i619;
import '../../features/viewing_appointment/presentation/blocs/landlord_viewing_appointment_list/landlord_viewing_appointment_list_bloc.dart'
    as _i445;
import '../../features/viewing_appointment/presentation/blocs/my_viewing_appointment_list/my_viewing_appointment_list_bloc.dart'
    as _i500;
import '../../features/viewing_appointment/presentation/blocs/schedule_viewing/schedule_viewing_bloc.dart'
    as _i324;
import '../blocs/new_requests/new_requests_cubit.dart' as _i773;
import '../blocs/pending_contract/pending_contract_cubit.dart' as _i958;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule(this);
    gh.singleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i1022.ViewingAppointmentRemoteDataSource>(
      () => registerModule.viewingAppointmentRemoteDataSource,
    );
    gh.lazySingleton<_i41.AuthRemoteDataSource>(
      () => registerModule.authRemoteDataSource,
    );
    gh.lazySingleton<_i378.AuthRepository>(() => registerModule.authRepository);
    gh.lazySingleton<_i83.PropertyRemoteDataSource>(
      () => registerModule.propertyRemoteDataSource,
    );
    gh.lazySingleton<_i586.BrowseRoomRemoteDataSource>(
      () => registerModule.browseRoomRemoteDataSource,
    );
    gh.lazySingleton<_i411.RentalRequestRemoteDataSource>(
      () => registerModule.rentalRequestRemoteDataSource,
    );
    gh.lazySingleton<_i586.RoomRemoteDataSource>(
      () => registerModule.roomRemoteDataSource,
    );
    gh.lazySingleton<_i366.ProfileRemoteDataSource>(
      () => registerModule.profileRemoteDataSource,
    );
    gh.factory<_i378.RegisterUsecase>(() => registerModule.registerUseCase);
    gh.factory<_i378.RegisterLandlordUsecase>(
      () => registerModule.registerLandlordUsecase,
    );
    gh.factory<_i378.LoginUsecase>(() => registerModule.loginUsecase);
    gh.factory<_i378.LogoutUsecase>(() => registerModule.logoutUsecase);
    gh.factory<_i378.ForgotPasswordUsecase>(
      () => registerModule.forgotPasswordUsecase,
    );
    gh.factory<_i378.VerifyOtpUsecase>(() => registerModule.verifyOtpUsecase);
    gh.factory<_i378.ResetPasswordUsecase>(
      () => registerModule.resetPasswordUsecase,
    );
    gh.factory<_i1047.ForgotPasswordBloc>(
      () => _i1047.ForgotPasswordBloc(
        forgotPasswordUsecase: gh<_i378.ForgotPasswordUsecase>(),
      ),
    );
    gh.factory<_i165.RegisterLandlordBloc>(
      () => _i165.RegisterLandlordBloc(
        registerLandlordUsecase: gh<_i378.RegisterLandlordUsecase>(),
      ),
    );
    gh.factory<_i452.VerifyOtpBloc>(
      () => _i452.VerifyOtpBloc(
        verifyOtpUsecase: gh<_i378.VerifyOtpUsecase>(),
        forgotPasswordUsecase: gh<_i378.ForgotPasswordUsecase>(),
      ),
    );
    gh.singleton<_i652.AuthenticationBloc>(
      () => _i652.AuthenticationBloc(
        authRepository: gh<_i378.AuthRepository>(),
        logoutUseCase: gh<_i378.LogoutUsecase>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i503.ProfileRepository>(
      () => registerModule.profileRepository(
        gh<_i366.ProfileRemoteDataSource>(),
        gh<_i652.AuthenticationBloc>(),
      ),
    );
    gh.lazySingleton<_i142.RoomRepository>(
      () => registerModule.roomRepository(
        gh<_i586.RoomRemoteDataSource>(),
        gh<_i652.AuthenticationBloc>(),
      ),
    );
    gh.factory<_i503.GetProfileUsecase>(() => registerModule.getProfileUsecase);
    gh.factory<_i503.UpdateProfileUsecase>(
      () => registerModule.updateProfileUsecase,
    );
    gh.factory<_i275.UpdateProfileBloc>(
      () => _i275.UpdateProfileBloc(
        updateProfileUsecase: gh<_i503.UpdateProfileUsecase>(),
      ),
    );
    gh.lazySingleton<_i142.BrowseRoomRepository>(
      () => registerModule.browseRoomRepository(
        gh<_i586.BrowseRoomRemoteDataSource>(),
        gh<_i652.AuthenticationBloc>(),
      ),
    );
    gh.factory<_i373.GetProfileBloc>(
      () => _i373.GetProfileBloc(
        getProfileUsecase: gh<_i503.GetProfileUsecase>(),
      ),
    );
    gh.lazySingleton<_i278.ViewingAppointmentRepository>(
      () => registerModule.viewingAppointmentRepository(
        gh<_i1022.ViewingAppointmentRemoteDataSource>(),
        gh<_i652.AuthenticationBloc>(),
      ),
    );
    gh.singleton<_i583.GoRouter>(
      () => registerModule.router(gh<_i652.AuthenticationBloc>()),
    );
    gh.factory<_i278.CreateViewingAppointmentUsecase>(
      () => registerModule.createViewingAppointmentUsecase,
    );
    gh.factory<_i278.GetMyViewingAppointmentsUsecase>(
      () => registerModule.getMyViewingAppointmentsUsecase,
    );
    gh.factory<_i278.GetLandlordViewingAppointmentsUsecase>(
      () => registerModule.getLandlordViewingAppointmentsUsecase,
    );
    gh.factory<_i278.ApproveViewingAppointmentUsecase>(
      () => registerModule.approveViewingAppointmentUsecase,
    );
    gh.factory<_i278.RejectViewingAppointmentUsecase>(
      () => registerModule.rejectViewingAppointmentUsecase,
    );
    gh.factory<_i278.CancelViewingAppointmentUsecase>(
      () => registerModule.cancelViewingAppointmentUsecase,
    );
    gh.factory<_i517.RegisterBloc>(
      () => _i517.RegisterBloc(registerUsecase: gh<_i378.RegisterUsecase>()),
    );
    gh.factory<_i1018.LoginBloc>(
      () => _i1018.LoginBloc(loginUsecase: gh<_i378.LoginUsecase>()),
    );
    gh.factory<_i500.MyViewingAppointmentListBloc>(
      () => _i500.MyViewingAppointmentListBloc(
        getMyViewingAppointmentsUsecase:
            gh<_i278.GetMyViewingAppointmentsUsecase>(),
        cancelViewingAppointmentUsecase:
            gh<_i278.CancelViewingAppointmentUsecase>(),
      ),
    );
    gh.lazySingleton<_i284.RentalRequestRepository>(
      () => registerModule.rentalRequestRepository(
        gh<_i411.RentalRequestRemoteDataSource>(),
        gh<_i652.AuthenticationBloc>(),
      ),
    );
    gh.factory<_i142.GetRoomsUsecase>(() => registerModule.getRoomsUsecase);
    gh.factory<_i142.GetRoomByIdUsecase>(
      () => registerModule.getRoomByIdUsecase,
    );
    gh.factory<_i142.CreateRoomUsecase>(() => registerModule.createRoomUsecase);
    gh.factory<_i142.UpdateRoomUsecase>(() => registerModule.updateRoomUsecase);
    gh.factory<_i142.DeleteRoomUsecase>(() => registerModule.deleteRoomUsecase);
    gh.factory<_i445.LandlordViewingAppointmentListBloc>(
      () => _i445.LandlordViewingAppointmentListBloc(
        getLandlordViewingAppointmentsUsecase:
            gh<_i278.GetLandlordViewingAppointmentsUsecase>(),
        approveViewingAppointmentUsecase:
            gh<_i278.ApproveViewingAppointmentUsecase>(),
        rejectViewingAppointmentUsecase:
            gh<_i278.RejectViewingAppointmentUsecase>(),
      ),
    );
    gh.factory<_i746.UpdateRoomBloc>(
      () => _i746.UpdateRoomBloc(
        updateRoomUsecase: gh<_i142.UpdateRoomUsecase>(),
      ),
    );
    gh.singleton<_i773.NewRequestsCubit>(
      () => _i773.NewRequestsCubit(gh<_i652.AuthenticationBloc>()),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i369.PropertyRepository>(
      () => registerModule.propertyRepository(
        gh<_i83.PropertyRemoteDataSource>(),
        gh<_i652.AuthenticationBloc>(),
      ),
    );
    gh.factory<_i284.CreateRentalRequestUsecase>(
      () => registerModule.createRentalRequestUsecase,
    );
    gh.factory<_i284.GetMyRentalRequestsUsecase>(
      () => registerModule.getMyRentalRequestsUsecase,
    );
    gh.factory<_i284.CancelRentalRequestUsecase>(
      () => registerModule.cancelRentalRequestUsecase,
    );
    gh.factory<_i284.GetIncomingRequestsUsecase>(
      () => registerModule.getIncomingRequestsUsecase,
    );
    gh.factory<_i284.RejectRentalRequestUsecase>(
      () => registerModule.rejectRentalRequestUsecase,
    );
    gh.factory<_i284.GetMyContractsUsecase>(
      () => registerModule.getMyContractsUsecase,
    );
    gh.factory<_i284.GetLandlordContractsUsecase>(
      () => registerModule.getLandlordContractsUsecase,
    );
    gh.factory<_i284.GetContractDetailUsecase>(
      () => registerModule.getContractDetailUsecase,
    );
    gh.factory<_i284.UpdateContractUsecase>(
      () => registerModule.updateContractUsecase,
    );
    gh.factory<_i284.SendContractUsecase>(
      () => registerModule.sendContractUsecase,
    );
    gh.factory<_i284.SignContractUsecase>(
      () => registerModule.signContractUsecase,
    );
    gh.factory<_i284.CancelContractUsecase>(
      () => registerModule.cancelContractUsecase,
    );
    gh.factory<_i284.FinishContractUsecase>(
      () => registerModule.finishContractUsecase,
    );
    gh.factory<_i284.GetContractMembersUsecase>(
      () => registerModule.getContractMembersUsecase,
    );
    gh.factory<_i284.RemoveContractMemberUsecase>(
      () => registerModule.removeContractMemberUsecase,
    );
    gh.factory<_i284.CreateVnpayPaymentUsecase>(
      () => registerModule.createVnpayPaymentUsecase,
    );
    gh.factory<_i284.GetRentalRequestByIdUsecase>(
      () => registerModule.getRentalRequestByIdUsecase,
    );
    gh.factory<_i284.GetContractByRentalRequestIdUsecase>(
      () => registerModule.getContractByRentalRequestIdUsecase,
    );
    gh.factory<_i269.ContractDetailBloc>(
      () => _i269.ContractDetailBloc(
        getContractDetailUsecase: gh<_i284.GetContractDetailUsecase>(),
      ),
    );
    gh.factory<_i142.GetAvailableRoomsUsecase>(
      () => registerModule.getAvailableRoomsUsecase,
    );
    gh.factory<_i142.GetBrowseRoomDetailUsecase>(
      () => registerModule.getBrowseRoomDetailUsecase,
    );
    gh.factory<_i619.CreateViewingAppointmentBloc>(
      () => _i619.CreateViewingAppointmentBloc(
        createViewingAppointmentUsecase:
            gh<_i278.CreateViewingAppointmentUsecase>(),
      ),
    );
    gh.factory<_i324.ScheduleViewingBloc>(
      () => _i324.ScheduleViewingBloc(
        createViewingAppointmentUsecase:
            gh<_i278.CreateViewingAppointmentUsecase>(),
      ),
    );
    gh.factory<_i267.MyContractListBloc>(
      () => _i267.MyContractListBloc(
        getMyContractsUsecase: gh<_i284.GetMyContractsUsecase>(),
      ),
    );
    gh.singleton<_i958.PendingContractCubit>(
      () => _i958.PendingContractCubit(
        gh<_i284.GetMyContractsUsecase>(),
        gh<_i652.AuthenticationBloc>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.factory<_i187.RoomListBloc>(
      () => _i187.RoomListBloc(getRoomsUsecase: gh<_i142.GetRoomsUsecase>()),
    );
    gh.factory<_i715.CreateRentalRequestBloc>(
      () => _i715.CreateRentalRequestBloc(
        createRentalRequestUsecase: gh<_i284.CreateRentalRequestUsecase>(),
      ),
    );
    gh.factory<_i598.LandlordRequestListBloc>(
      () => _i598.LandlordRequestListBloc(
        getIncomingRequestsUsecase: gh<_i284.GetIncomingRequestsUsecase>(),
        rejectRentalRequestUsecase: gh<_i284.RejectRentalRequestUsecase>(),
      ),
    );
    gh.factory<_i260.DepositPaymentCubit>(
      () => _i260.DepositPaymentCubit(
        createVnpayPaymentUsecase: gh<_i284.CreateVnpayPaymentUsecase>(),
        cancelContractUsecase: gh<_i284.CancelContractUsecase>(),
      ),
    );
    gh.factory<_i171.DeleteRoomBloc>(
      () => _i171.DeleteRoomBloc(
        deleteRoomUsecase: gh<_i142.DeleteRoomUsecase>(),
      ),
    );
    gh.factory<_i621.CreateRoomBloc>(
      () => _i621.CreateRoomBloc(
        createRoomUsecase: gh<_i142.CreateRoomUsecase>(),
      ),
    );
    gh.factory<_i116.LandlordContractListBloc>(
      () => _i116.LandlordContractListBloc(
        getLandlordContractsUsecase: gh<_i284.GetLandlordContractsUsecase>(),
      ),
    );
    gh.factory<_i507.MyRentalRequestListBloc>(
      () => _i507.MyRentalRequestListBloc(
        getMyRentalRequestsUsecase: gh<_i284.GetMyRentalRequestsUsecase>(),
      ),
    );
    gh.factory<_i369.GetPropertiesUsecase>(
      () => registerModule.getPropertiesUsecase,
    );
    gh.factory<_i369.GetPropertyByIdUsecase>(
      () => registerModule.getPropertyByIdUsecase,
    );
    gh.factory<_i369.CreatePropertyUsecase>(
      () => registerModule.createPropertyUsecase,
    );
    gh.factory<_i369.UpdatePropertyUsecase>(
      () => registerModule.updatePropertyUsecase,
    );
    gh.factory<_i369.DeletePropertyUsecase>(
      () => registerModule.deletePropertyUsecase,
    );
    gh.factory<_i779.AvailableRoomListBloc>(
      () => _i779.AvailableRoomListBloc(
        getAvailableRoomsUsecase: gh<_i142.GetAvailableRoomsUsecase>(),
      ),
    );
    gh.factory<_i511.BrowseRoomDetailBloc>(
      () => _i511.BrowseRoomDetailBloc(
        getBrowseRoomDetailUsecase: gh<_i142.GetBrowseRoomDetailUsecase>(),
      ),
    );
    gh.factory<_i1054.UpdatePropertyBloc>(
      () => _i1054.UpdatePropertyBloc(
        updatePropertyUsecase: gh<_i369.UpdatePropertyUsecase>(),
      ),
    );
    gh.factory<_i634.DeletePropertyBloc>(
      () => _i634.DeletePropertyBloc(
        deletePropertyUsecase: gh<_i369.DeletePropertyUsecase>(),
      ),
    );
    gh.factory<_i327.PropertyListBloc>(
      () => _i327.PropertyListBloc(
        getPropertiesUsecase: gh<_i369.GetPropertiesUsecase>(),
      ),
    );
    gh.factory<_i509.CreatePropertyBloc>(
      () => _i509.CreatePropertyBloc(
        createPropertyUsecase: gh<_i369.CreatePropertyUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {
  _$RegisterModule(this._getIt);

  final _i174.GetIt _getIt;

  @override
  _i1022.HttpViewingAppointmentRemoteDataSource
  get viewingAppointmentRemoteDataSource =>
      _i1022.HttpViewingAppointmentRemoteDataSource(
        client: _getIt<_i519.Client>(),
      );

  @override
  _i41.HttpAuthRemoteDataSource get authRemoteDataSource =>
      _i41.HttpAuthRemoteDataSource(client: _getIt<_i519.Client>());

  @override
  _i41.AuthRepositoryImpl get authRepository => _i41.AuthRepositoryImpl(
    authRemoteDataSource: _getIt<_i41.AuthRemoteDataSource>(),
  );

  @override
  _i83.HttpPropertyRemoteDataSource get propertyRemoteDataSource =>
      _i83.HttpPropertyRemoteDataSource(client: _getIt<_i519.Client>());

  @override
  _i586.HttpBrowseRoomRemoteDataSource get browseRoomRemoteDataSource =>
      _i586.HttpBrowseRoomRemoteDataSource(client: _getIt<_i519.Client>());

  @override
  _i411.HttpRentalRequestRemoteDataSource get rentalRequestRemoteDataSource =>
      _i411.HttpRentalRequestRemoteDataSource(client: _getIt<_i519.Client>());

  @override
  _i586.HttpRoomRemoteDataSource get roomRemoteDataSource =>
      _i586.HttpRoomRemoteDataSource(client: _getIt<_i519.Client>());

  @override
  _i366.HttpProfileRemoteDataSource get profileRemoteDataSource =>
      _i366.HttpProfileRemoteDataSource(client: _getIt<_i519.Client>());

  @override
  _i378.RegisterUsecase get registerUseCase =>
      _i378.RegisterUsecase(authRepository: _getIt<_i378.AuthRepository>());

  @override
  _i378.RegisterLandlordUsecase get registerLandlordUsecase =>
      _i378.RegisterLandlordUsecase(
        authRepository: _getIt<_i378.AuthRepository>(),
      );

  @override
  _i378.LoginUsecase get loginUsecase =>
      _i378.LoginUsecase(authRepository: _getIt<_i378.AuthRepository>());

  @override
  _i378.LogoutUsecase get logoutUsecase =>
      _i378.LogoutUsecase(authRepository: _getIt<_i378.AuthRepository>());

  @override
  _i378.ForgotPasswordUsecase get forgotPasswordUsecase =>
      _i378.ForgotPasswordUsecase(
        authRepository: _getIt<_i378.AuthRepository>(),
      );

  @override
  _i378.VerifyOtpUsecase get verifyOtpUsecase =>
      _i378.VerifyOtpUsecase(authRepository: _getIt<_i378.AuthRepository>());

  @override
  _i378.ResetPasswordUsecase get resetPasswordUsecase =>
      _i378.ResetPasswordUsecase(
        authRepository: _getIt<_i378.AuthRepository>(),
      );

  @override
  _i503.GetProfileUsecase get getProfileUsecase => _i503.GetProfileUsecase(
    profileRepository: _getIt<_i503.ProfileRepository>(),
  );

  @override
  _i503.UpdateProfileUsecase get updateProfileUsecase =>
      _i503.UpdateProfileUsecase(
        profileRepository: _getIt<_i503.ProfileRepository>(),
      );

  @override
  _i278.CreateViewingAppointmentUsecase get createViewingAppointmentUsecase =>
      _i278.CreateViewingAppointmentUsecase(
        repo: _getIt<_i278.ViewingAppointmentRepository>(),
      );

  @override
  _i278.GetMyViewingAppointmentsUsecase get getMyViewingAppointmentsUsecase =>
      _i278.GetMyViewingAppointmentsUsecase(
        repo: _getIt<_i278.ViewingAppointmentRepository>(),
      );

  @override
  _i278.GetLandlordViewingAppointmentsUsecase
  get getLandlordViewingAppointmentsUsecase =>
      _i278.GetLandlordViewingAppointmentsUsecase(
        repo: _getIt<_i278.ViewingAppointmentRepository>(),
      );

  @override
  _i278.ApproveViewingAppointmentUsecase get approveViewingAppointmentUsecase =>
      _i278.ApproveViewingAppointmentUsecase(
        repo: _getIt<_i278.ViewingAppointmentRepository>(),
      );

  @override
  _i278.RejectViewingAppointmentUsecase get rejectViewingAppointmentUsecase =>
      _i278.RejectViewingAppointmentUsecase(
        repo: _getIt<_i278.ViewingAppointmentRepository>(),
      );

  @override
  _i278.CancelViewingAppointmentUsecase get cancelViewingAppointmentUsecase =>
      _i278.CancelViewingAppointmentUsecase(
        repo: _getIt<_i278.ViewingAppointmentRepository>(),
      );

  @override
  _i142.GetRoomsUsecase get getRoomsUsecase =>
      _i142.GetRoomsUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i142.GetRoomByIdUsecase get getRoomByIdUsecase =>
      _i142.GetRoomByIdUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i142.CreateRoomUsecase get createRoomUsecase =>
      _i142.CreateRoomUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i142.UpdateRoomUsecase get updateRoomUsecase =>
      _i142.UpdateRoomUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i142.DeleteRoomUsecase get deleteRoomUsecase =>
      _i142.DeleteRoomUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i284.CreateRentalRequestUsecase get createRentalRequestUsecase =>
      _i284.CreateRentalRequestUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.GetMyRentalRequestsUsecase get getMyRentalRequestsUsecase =>
      _i284.GetMyRentalRequestsUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.CancelRentalRequestUsecase get cancelRentalRequestUsecase =>
      _i284.CancelRentalRequestUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.GetIncomingRequestsUsecase get getIncomingRequestsUsecase =>
      _i284.GetIncomingRequestsUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.RejectRentalRequestUsecase get rejectRentalRequestUsecase =>
      _i284.RejectRentalRequestUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.GetMyContractsUsecase get getMyContractsUsecase =>
      _i284.GetMyContractsUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.GetLandlordContractsUsecase get getLandlordContractsUsecase =>
      _i284.GetLandlordContractsUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.GetContractDetailUsecase get getContractDetailUsecase =>
      _i284.GetContractDetailUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.UpdateContractUsecase get updateContractUsecase =>
      _i284.UpdateContractUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.SendContractUsecase get sendContractUsecase =>
      _i284.SendContractUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.SignContractUsecase get signContractUsecase =>
      _i284.SignContractUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.CancelContractUsecase get cancelContractUsecase =>
      _i284.CancelContractUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.FinishContractUsecase get finishContractUsecase =>
      _i284.FinishContractUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.GetContractMembersUsecase get getContractMembersUsecase =>
      _i284.GetContractMembersUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.RemoveContractMemberUsecase get removeContractMemberUsecase =>
      _i284.RemoveContractMemberUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.CreateVnpayPaymentUsecase get createVnpayPaymentUsecase =>
      _i284.CreateVnpayPaymentUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.GetRentalRequestByIdUsecase get getRentalRequestByIdUsecase =>
      _i284.GetRentalRequestByIdUsecase(
        rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
      );

  @override
  _i284.GetContractByRentalRequestIdUsecase
      get getContractByRentalRequestIdUsecase =>
          _i284.GetContractByRentalRequestIdUsecase(
            rentalRequestRepository: _getIt<_i284.RentalRequestRepository>(),
          );

  @override
  _i142.GetAvailableRoomsUsecase get getAvailableRoomsUsecase =>
      _i142.GetAvailableRoomsUsecase(
        browseRoomRepository: _getIt<_i142.BrowseRoomRepository>(),
      );

  @override
  _i142.GetBrowseRoomDetailUsecase get getBrowseRoomDetailUsecase =>
      _i142.GetBrowseRoomDetailUsecase(
        browseRoomRepository: _getIt<_i142.BrowseRoomRepository>(),
      );

  @override
  _i369.GetPropertiesUsecase get getPropertiesUsecase =>
      _i369.GetPropertiesUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );

  @override
  _i369.GetPropertyByIdUsecase get getPropertyByIdUsecase =>
      _i369.GetPropertyByIdUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );

  @override
  _i369.CreatePropertyUsecase get createPropertyUsecase =>
      _i369.CreatePropertyUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );

  @override
  _i369.UpdatePropertyUsecase get updatePropertyUsecase =>
      _i369.UpdatePropertyUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );

  @override
  _i369.DeletePropertyUsecase get deletePropertyUsecase =>
      _i369.DeletePropertyUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );
}
