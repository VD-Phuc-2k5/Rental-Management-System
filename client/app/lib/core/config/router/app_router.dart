import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/register_page.dart';
import '../../../features/auth/presentation/pages/verify_otp_page.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';
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
      final isForgotPassword =
          location.startsWith(RoutePaths.forgotPassword) ||
          location.startsWith(RoutePaths.verifyForgotPasswordOtpPrefix);

      if (authStatus == AuthenticationStatus.unknown) {
        return isSplash ? null : RoutePaths.splash;
      }

      if (authStatus == AuthenticationStatus.authenticated) {
        if (isSplash || isAuthRoute) return RoutePaths.home;
      } else {
        if (!isAuthRoute && !isForgotPassword) return RoutePaths.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
        path: RoutePaths.verifyForgotPasswordOtp,
        name: RouteNames.verifyForgotPasswordOtp,
        builder: (BuildContext context, GoRouterState state) {
          final String email = state.pathParameters["email"] ?? "";
          return VerifyOtpPage(email: email);
        },
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return ErrorPage(error: state.error);
    },
  );
}
