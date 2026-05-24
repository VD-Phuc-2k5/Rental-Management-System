import 'package:data/auth.dart';
import 'package:data/profile.dart';
import 'package:data/property.dart';
import 'package:data/rental_request.dart';
import 'package:data/room.dart';
import 'package:data/viewing_appointment.dart';
import 'package:domain/auth.dart';
import 'package:domain/profile.dart';
import 'package:domain/property.dart';
import 'package:domain/rental_request.dart';
import 'package:domain/room.dart';
import 'package:domain/viewing_appointment.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../config/router/app_router.dart';

@module
abstract class RegisterModule {
  @singleton
  http.Client get httpClient => http.Client();

  @singleton
  GoRouter router(AuthenticationBloc authBloc) => createRouter(authBloc);

  // --- Data Layer ---
  // auth
  @LazySingleton(as: AuthRemoteDataSource)
  HttpAuthRemoteDataSource get authRemoteDataSource;

  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository;

  // property datasource
  @LazySingleton(as: PropertyRemoteDataSource)
  HttpPropertyRemoteDataSource get propertyRemoteDataSource;

  // property repository — needs getToken callback wired to AuthenticationBloc
  @LazySingleton(as: PropertyRepository)
  PropertyRepositoryImpl propertyRepository(
    PropertyRemoteDataSource dataSource,
    AuthenticationBloc authBloc,
  ) => PropertyRepositoryImpl(
    propertyRemoteDataSource: dataSource,
    getToken: () => authBloc.state.user?.token ?? '',
  );

  // room datasource
  @LazySingleton(as: RoomRemoteDataSource)
  HttpRoomRemoteDataSource get roomRemoteDataSource;

  // room repository — needs getToken callback wired to AuthenticationBloc
  @LazySingleton(as: RoomRepository)
  RoomRepositoryImpl roomRepository(
    RoomRemoteDataSource dataSource,
    AuthenticationBloc authBloc,
  ) => RoomRepositoryImpl(
    roomRemoteDataSource: dataSource,
    getToken: () => authBloc.state.user?.token ?? '',
  );

  // browse room datasource
  @LazySingleton(as: BrowseRoomRemoteDataSource)
  HttpBrowseRoomRemoteDataSource get browseRoomRemoteDataSource;

  // browse room repository
  @LazySingleton(as: BrowseRoomRepository)
  BrowseRoomRepositoryImpl browseRoomRepository(
    BrowseRoomRemoteDataSource dataSource,
    AuthenticationBloc authBloc,
  ) => BrowseRoomRepositoryImpl(
    browseRoomRemoteDataSource: dataSource,
    getToken: () => authBloc.state.user?.token ?? '',
  );

  // profile datasource
  @LazySingleton(as: ProfileRemoteDataSource)
  HttpProfileRemoteDataSource get profileRemoteDataSource;

  // profile repository — needs getToken callback wired to AuthenticationBloc
  @LazySingleton(as: ProfileRepository)
  ProfileRepositoryImpl profileRepository(
    ProfileRemoteDataSource dataSource,
    AuthenticationBloc authBloc,
  ) => ProfileRepositoryImpl(
    profileRemoteDataSource: dataSource,
    getToken: () => authBloc.state.user?.token ?? '',
  );

  // rental request datasource
  @LazySingleton(as: RentalRequestRemoteDataSource)
  HttpRentalRequestRemoteDataSource get rentalRequestRemoteDataSource;

  // rental request repository — needs getToken callback wired to AuthenticationBloc
  @LazySingleton(as: RentalRequestRepository)
  RentalRequestRepositoryImpl rentalRequestRepository(
    RentalRequestRemoteDataSource dataSource,
    AuthenticationBloc authBloc,
  ) => RentalRequestRepositoryImpl(
    rentalRequestRemoteDataSource: dataSource,
    getToken: () => authBloc.state.user?.token ?? '',
  );

  // viewing appointment datasource
  @LazySingleton(as: ViewingAppointmentRemoteDataSource)
  HttpViewingAppointmentRemoteDataSource get viewingAppointmentRemoteDataSource;

  // viewing appointment repository
  @LazySingleton(as: ViewingAppointmentRepository)
  ViewingAppointmentRepositoryImpl viewingAppointmentRepository(
    ViewingAppointmentRemoteDataSource dataSource,
    AuthenticationBloc authBloc,
  ) => ViewingAppointmentRepositoryImpl(
    viewingAppointmentRemoteDataSource: dataSource,
    getToken: () => authBloc.state.user?.token ?? '',
  );

  // --- Domain (UseCases) ---
  // auth
  @injectable
  RegisterUsecase get registerUseCase;

  @injectable
  RegisterLandlordUsecase get registerLandlordUsecase;

  @injectable
  LoginUsecase get loginUsecase;

  @injectable
  LogoutUsecase get logoutUsecase;

  @injectable
  ForgotPasswordUsecase get forgotPasswordUsecase;

  @injectable
  VerifyOtpUsecase get verifyOtpUsecase;

  @injectable
  ResetPasswordUsecase get resetPasswordUsecase;

  // property
  @injectable
  GetPropertiesUsecase get getPropertiesUsecase;

  @injectable
  GetPropertyByIdUsecase get getPropertyByIdUsecase;

  @injectable
  CreatePropertyUsecase get createPropertyUsecase;

  @injectable
  UpdatePropertyUsecase get updatePropertyUsecase;

  @injectable
  DeletePropertyUsecase get deletePropertyUsecase;

  // profile
  @injectable
  GetProfileUsecase get getProfileUsecase;

  @injectable
  UpdateProfileUsecase get updateProfileUsecase;

  // browse room
  @injectable
  GetAvailableRoomsUsecase get getAvailableRoomsUsecase;

  @injectable
  GetBrowseRoomDetailUsecase get getBrowseRoomDetailUsecase;

  // room
  @injectable
  GetRoomsUsecase get getRoomsUsecase;

  @injectable
  GetRoomByIdUsecase get getRoomByIdUsecase;

  @injectable
  CreateRoomUsecase get createRoomUsecase;

  @injectable
  UpdateRoomUsecase get updateRoomUsecase;

  @injectable
  DeleteRoomUsecase get deleteRoomUsecase;

  // rental request
  @injectable
  CreateRentalRequestUsecase get createRentalRequestUsecase;

  @injectable
  GetMyRentalRequestsUsecase get getMyRentalRequestsUsecase;

  @injectable
  CancelRentalRequestUsecase get cancelRentalRequestUsecase;

  @injectable
  GetIncomingRequestsUsecase get getIncomingRequestsUsecase;

  @injectable
  RejectRentalRequestUsecase get rejectRentalRequestUsecase;

  @injectable
  GetMyContractsUsecase get getMyContractsUsecase;

  @injectable
  GetLandlordContractsUsecase get getLandlordContractsUsecase;

  @injectable
  GetContractDetailUsecase get getContractDetailUsecase;

  @injectable
  UpdateContractUsecase get updateContractUsecase;

  @injectable
  SendContractUsecase get sendContractUsecase;

  @injectable
  SignContractUsecase get signContractUsecase;

  @injectable
  CancelContractUsecase get cancelContractUsecase;

  @injectable
  FinishContractUsecase get finishContractUsecase;

  @injectable
  GetContractMembersUsecase get getContractMembersUsecase;

  @injectable
  RemoveContractMemberUsecase get removeContractMemberUsecase;

  @injectable
  CreateVnpayPaymentUsecase get createVnpayPaymentUsecase;

  @injectable
  GetRentalRequestByIdUsecase get getRentalRequestByIdUsecase;

  @injectable
  GetContractByRentalRequestIdUsecase get getContractByRentalRequestIdUsecase;

  // viewing appointment
  @injectable
  CreateViewingAppointmentUsecase get createViewingAppointmentUsecase;

  @injectable
  GetMyViewingAppointmentsUsecase get getMyViewingAppointmentsUsecase;

  @injectable
  GetLandlordViewingAppointmentsUsecase
  get getLandlordViewingAppointmentsUsecase;

  @injectable
  ApproveViewingAppointmentUsecase get approveViewingAppointmentUsecase;

  @injectable
  RejectViewingAppointmentUsecase get rejectViewingAppointmentUsecase;

  @injectable
  CancelViewingAppointmentUsecase get cancelViewingAppointmentUsecase;
}
