import 'package:core/constants.dart';
import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../screens/login-screen/login_screen.dart';
import '../blocs/register/register_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // obsecures
  bool _obscurePassword = true;

  // TextEditing Controllers
  final _fullnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<RegisterBloc>().add(
      RegisterRequested(
        fullName: _fullnameController.text.trim(),
        password: _passwordController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoadFailure) {
          showToast(message: state.failure.message, type: ToastType.error);
        }

        if (state is RegisterLoadSuccess) {
          showToast(message: "Đăng ký thành công", type: ToastType.success);
          Navigator.of(
            context,
          ).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoadInProgress;
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                // Username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Họ và tên",
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
                      controller: _fullnameController,
                      style: const TextStyle(
                        color: AppColors.slate400,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.slate400,
                        ),
                        hintText: "Nhập họ và tên",
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
                          return 'Họ và tên không được để trống.';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                  ],
                ),

                // Phone
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Số điện thoại",
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
                      controller: _phoneController,
                      style: const TextStyle(
                        color: AppColors.slate400,
                      ),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: AppColors.slate400,
                        ),
                        hintText: "Nhập số điện thoại",
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
                          return 'Số điện thoại không được để trống.';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                  ],
                ),

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

                // Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mật khẩu",
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
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        color: AppColors.slate400,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.key_outlined,
                          color: AppColors.slate400,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.slate400,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hintText: "Nhập mật khẩu",
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
                          return 'Mật khẩu không được để trống.';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                  ],
                ),

                // Submit button
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue700,
                    disabledBackgroundColor: AppColors.blue700.withValues(
                      alpha: 0.6,
                    ),
                    foregroundColor: AppColors.white,
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
                          'Đăng ký',
                        ),
                ),

                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // context.goNamed(RouteNames.login);
                        },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đã có tài khoản? ',
                        style: TextStyle(color: AppColors.slate500),
                      ),
                      Text(
                        'Đăng nhập!',
                        style: TextStyle(color: AppColors.blue700),
                      ),
                    ],
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
