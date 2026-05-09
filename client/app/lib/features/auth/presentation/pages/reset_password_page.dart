import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/common_appbar.dart';
import '../blocs/reset_password/reset_password_bloc.dart';
import '../widgets/progress_indicator_bar.dart';
import '../widgets/reset_password_form.dart';
import '../widgets/reset_password_intruction.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(
        resetPasswordUsecase: getIt(),
        email: email,
        otp: otp,
      ),
      child: const ResetPasswordView(),
    );
  }
}

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: const Scaffold(
        backgroundColor: AppColors.grayBackground,
        appBar: CommonAppBar(
          title: "Quên mật khẩu",
          prevRouteName: RouteNames.forgotPassword,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 16),
                ProgressIndicatorBar(
                  currentStep: 3,
                  totalSteps: 3,
                ),
                SizedBox(height: 220),
                ResetPasswordIntruction(),
                SizedBox(height: 32),
                ResetPasswordForm(),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
