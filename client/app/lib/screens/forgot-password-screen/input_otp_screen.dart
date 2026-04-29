import 'package:app/core/constants.dart';
import 'package:app/screens/forgot-password-screen/components/progress_indicator_bar.dart';
import 'package:app/screens/forgot-password-screen/components/input-otp/body.dart';
import 'package:flutter/material.dart';

class InputOtpScreen extends StatelessWidget {
  final String contact;

  const InputOtpScreen({super.key, required this.contact});

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
          icon: const Icon(Icons.arrow_back, color: AppColors.slate700),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: ProgressIndicatorBar(currentStep: 2, totalSteps: 3),
          ),
        ),
      ),
      body: InputOtpBody(contact: contact),
    );
  }
}