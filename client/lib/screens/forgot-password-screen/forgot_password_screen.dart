import 'package:app/core/constants.dart';
import 'package:app/screens/forgot-password-screen/components/forgot-password/body.dart';
import 'package:app/screens/forgot-password-screen/components/progress_indicator_bar.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: AppBar(
        backgroundColor: AppColors.grayBackground,
        title: const Text(
          'Quên mật khẩu',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.slate700
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: ProgressIndicatorBar(currentStep: 1, totalSteps: 3),
              ),
            ],
          ),
        ),
      ),
      body: const ForgotPasswordBody(),
    );
  }
}
