import 'package:domain/profile.dart';
import 'package:domain/property.dart';
import 'package:domain/room.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/register_landlord_page.dart';
import '../../../features/auth/presentation/pages/register_page.dart';
import '../../../features/auth/presentation/pages/reset_password_page.dart';
import '../../../features/auth/presentation/pages/verify_otp_page.dart';
import '../../../features/property/presentation/pages/property_list_page.dart';
import '../../../features/property/presentation/pages/create_property_page.dart';
import '../../../features/property/presentation/pages/update_property_page.dart';
import '../../../features/room/presentation/pages/room_list_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../../features/room/presentation/pages/room_tab_page.dart';
import '../../../features/room/presentation/pages/create_room_page.dart';
import '../../../features/room/presentation/pages/update_room_page.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';
import '../../../screens/landlord-requests-screen/landlord_requests_screen.dart';
import '../../../screens/landlord-payment-history/landlord_payment_history_screen.dart';
import '../../widgets/error_page.dart';
import 'go_router_refresh_stream.dart';
import 'route_constants.dart';

GoRouter createRouter(AuthenticationBloc authBloc) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authStatus = authBloc.state.status;
      final String location = state.matchedLocation;

      final isSplash = location == RoutePaths.splash;
      final isAuthRoute =
          location == RoutePaths.login || location == RoutePaths.register;
      final isForgotPassword = location == RoutePaths.forgotPassword;

      if (authStatus == AuthenticationStatus.unknown) {
        return isSplash ? null : RoutePaths.splash;
      }

      if (authStatus == AuthenticationStatus.authenticated) {
        if (isSplash || isAuthRoute) return RoutePaths.propertyList;
      } else {
        if (!isAuthRoute && !isForgotPassword) return RoutePaths.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, String>;
          final role = extra["role"] ?? "";
          switch (role) {
            case 'user':
              return const RegisterPage();
            case 'landlord':
              return const RegisterLandlordPage();
            default:
              return const SplashPage();
          }
        },
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (_, _) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, String>;
          final step = extra["step"] ?? "";
          switch (step) {
            case "1":
              return const ForgotPasswordPage();
            case "2":
              return VerifyOtpPage(email: extra["email"] ?? "");
            case "3":
              return ResetPasswordPage(
                email: extra["email"] ?? "",
                otp: extra["otp"] ?? "",
              );
            default:
              return const SplashPage();
          }
        },
      ),
      GoRoute(
        path: RoutePaths.propertyList,
        name: RouteNames.propertyList,
        builder: (_, _) => const PropertyListPage(),
      ),
      GoRoute(
        path: RoutePaths.createProperty,
        name: RouteNames.createProperty,
        builder: (_, _) => const CreatePropertyPage(),
      ),
      GoRoute(
        path: RoutePaths.updateProperty,
        name: RouteNames.updateProperty,
        builder: (BuildContext context, GoRouterState state) {
          final property = state.extra as PropertyEntity;
          return UpdatePropertyPage(property: property);
        },
      ),
      GoRoute(
        path: RoutePaths.roomTab,
        name: RouteNames.roomTab,
        builder: (_, _) => const RoomTabPage(),
      ),
      GoRoute(
        path: RoutePaths.roomList,
        name: RouteNames.roomList,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, String>;
          return RoomListPage(
            propertyId: extra['propertyId'] ?? '',
            propertyName: extra['propertyName'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RoutePaths.createRoom,
        name: RouteNames.createRoom,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, String>;
          return CreateRoomPage(propertyId: extra['propertyId'] ?? '');
        },
      ),
      GoRoute(
        path: RoutePaths.updateRoom,
        name: RouteNames.updateRoom,
        builder: (BuildContext context, GoRouterState state) {
          final room = state.extra as RoomEntity;
          return UpdateRoomPage(room: room);
        },
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        builder: (_, _) => const ProfilePage(),
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        name: RouteNames.editProfile,
        builder: (context, state) {
          final profile = state.extra as UserProfileEntity;
          return EditProfilePage(profile: profile);
        },
      ),
      GoRoute(
        path: RoutePaths.landlordRequests,
        name: RouteNames.landlordRequests,
        builder: (context, _) => const LandlordRequestsScreen(),
      ),
      GoRoute(
        path: RoutePaths.landlordPayments,
        name: RouteNames.landlordPayments,
        builder: (context, _) => const LandlordPaymentHistoryScreen(),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        ErrorPage(error: state.error),
  );
}
