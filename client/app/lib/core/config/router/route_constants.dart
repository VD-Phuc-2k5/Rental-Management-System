abstract class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyForgotPasswordOtp =
      '/verify-forgot-password-otp/:email';
  static const String verifyForgotPasswordOtpPrefix =
      '/verify-forgot-password-otp/';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
}

abstract class RouteNames {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String verifyForgotPasswordOtp = 'verify-forgot-password-otp';
  static const String resetPassword = 'reset-password';
  static const String home = 'home';
}
