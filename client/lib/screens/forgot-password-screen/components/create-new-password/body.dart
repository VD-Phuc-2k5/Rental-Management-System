import 'package:app/core/widgets/primary_button.dart';
import 'package:app/screens/forgot-password-screen/components/create-new-password/create_new_pass_form.dart';
import 'package:app/screens/forgot-password-screen/components/create-new-password/create_new_pass_intruction.dart';
import 'package:app/screens/home-screen/home_screen.dart';
import 'package:flutter/material.dart';

class CreateNewPasswordBody extends StatefulWidget {
  final Future<void> Function(String password, String confirmPassword) onSubmit;

  const CreateNewPasswordBody({
    super.key,
    required this.onSubmit,
  });

  @override
  State<CreateNewPasswordBody> createState() => _CreateNewPasswordBodyState();
}

class _CreateNewPasswordBodyState extends State<CreateNewPasswordBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await widget.onSubmit(_passwordController.text, _confirmPasswordController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mật khẩu đã được cập nhật thành công!')),
        );
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật mật khẩu thất bại: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CreateNewPassIntruction(),
                        const SizedBox(height: 16),
                        NewPassInputForm(
                          formKey: _formKey,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                        ),
                      ],
                    ),
                  ),
                ),
                PrimaryButton(
                  label: "Hoàn tất",
                  onPressed: submit,
                  isLoading: _isLoading,
                  fontSize: 20,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}