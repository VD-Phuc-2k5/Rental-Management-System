import 'package:app/screens/forgot-password-screen/forgot_password_screen.dart';
import 'package:app/screens/register-screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/login-screen/components/login_background.dart';
import 'package:app/screens/login-screen/components/login_logo.dart';
import 'package:app/screens/login-screen/components/login_header.dart';
import 'package:app/screens/login-screen/components/login_form.dart';
import 'package:app/screens/login-screen/components/login_footer.dart';
import 'package:app/core/constants.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  Future<void> _handleLogin(String email, String password) async {
    // TODO: Implement login logic
  }

  void _handleForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  void _handleSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
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
                      onForgotPassword: () => _handleForgotPassword(context),
                    ),
                    const SizedBox(height: 24),
                    LoginFooter(onSignUpPressed: () => _handleSignUp(context)),
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