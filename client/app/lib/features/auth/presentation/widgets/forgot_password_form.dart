import 'package:core/constants.dart';
import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/router/route_constants.dart';
import '../blocs/forgot_password/forgot_password_bloc.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordForm();
}

class _ForgotPasswordForm extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // TextEditing Controllers
  final _emailController = TextEditingController();

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<ForgotPasswordBloc>().add(
      ForgotPasswordRequested(
        email: _emailController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordLoadFailure) {
          showToast(message: state.failure.message, type: ToastType.error);
        }

        if (state is ForgotPasswordLoadSuccess) {
          showToast(
            message: "Mã OTP đã gửi đến email của bạn!",
            type: ToastType.success,
          );

          context.goNamed(
            RouteNames.forgotPassword,
            extra: {
              'step': '2',
              'email': _emailController.text.trim(),
            },
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoadInProgress;
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                // Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                        color: AppColors.slate500,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(
                        color: AppColors.slate400,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.slate400,
                        ),
                        hintText: "Nhập email",
                        hintStyle: const TextStyle(
                          color: AppColors.slate400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          borderSide: const BorderSide(
                            color: AppColors.slate500,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          borderSide: const BorderSide(
                            color: AppColors.blue500,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email không được để trống.';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                  ],
                ),

                // Submit button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue700,
                      disabledBackgroundColor: AppColors.blue700.withValues(
                        alpha: 0.6,
                      ),
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withValues(alpha: 1),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Text(
                            'Gửi mã OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
