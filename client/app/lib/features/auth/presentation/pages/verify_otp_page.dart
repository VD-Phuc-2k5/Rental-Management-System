import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/common_appbar.dart';
import '../blocs/verify_otp/verify_otp_bloc.dart';
import '../widgets/otp_instruction_text.dart';
import '../widgets/progress_indicator_bar.dart';
import '../widgets/verify_otp_form.dart';

class VerifyOtpPage extends StatelessWidget {
  const VerifyOtpPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VerifyOtpBloc>()..add(AddEmail(email: email)),
      child: const VerifyOtpView(),
    );
  }
}

class VerifyOtpView extends StatelessWidget {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final String email = context.read<VerifyOtpBloc>().email;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.grayBackground,
        appBar: const CommonAppBar(
          title: "Quên mật khẩu",
          prevRouteName: RouteNames.forgotPassword,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 16),
                const ProgressIndicatorBar(
                  currentStep: 2,
                  totalSteps: 3,
                ),
                const SizedBox(height: 250),
                OtpInstructionText(email: email),
                const SizedBox(height: 20),
                const VerifyOtpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
