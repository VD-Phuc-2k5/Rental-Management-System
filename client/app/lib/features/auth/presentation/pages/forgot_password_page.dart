import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/common_appbar.dart';
import '../blocs/forgot_password/forgot_password_bloc.dart';
import '../widgets/forgot_password_form.dart';
import '../widgets/forgot_password_instruction_text.dart';
import '../widgets/forgot_password_logo.dart';
import '../widgets/progress_indicator_bar.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordBloc>(),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: const Scaffold(
        backgroundColor: AppColors.grayBackground,
        appBar: CommonAppBar(
          title: "Quên mật khẩu",
          prevRouteName: RouteNames.login,
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
                  currentStep: 1,
                  totalSteps: 3,
                ),
                SizedBox(height: 100),
                ForgotPasswordLogo(),
                SizedBox(height: 32),
                ForgotPasswordInstructionText(),
                SizedBox(height: 32),
                ForgotPasswordForm(),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
