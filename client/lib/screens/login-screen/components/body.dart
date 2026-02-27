import 'package:flutter/material.dart';
import 'package:app/screens/login-screen/components/login_background.dart';
import 'package:app/screens/login-screen/components/login_logo.dart';
import 'package:app/screens/login-screen/components/login_header.dart';
import 'package:app/screens/login-screen/components/login_form.dart';
import 'package:app/screens/login-screen/components/login_footer.dart';
import 'package:app/core/constants.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  void _handleLogin() {
    // TODO: Implement login logic
  }

  void _handleForgotPassword() {
    // TODO: Navigate to forgot password screen
  }

  void _handleSignUp() {
    // TODO: Navigate to sign up screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      body: Stack(
        children: [
          const LoginBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoginLogo(),
                    const SizedBox(height: 12),
                    const LoginHeader(),
                    const SizedBox(height: 24),
                    LoginForm(
                      onSubmit: _handleLogin,
                      onForgotPassword: _handleForgotPassword,
                    ),
                    const SizedBox(height: 24),
                    LoginFooter(onSignUpPressed: _handleSignUp),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}