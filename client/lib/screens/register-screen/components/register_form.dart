import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class RegisterForm extends StatefulWidget {
  final Future<void> Function(
    String username, 
    String password,
    String email,
    String confirmPassword
  )? onSubmit;
  final VoidCallback? onLoginPressed;

  const RegisterForm({
    super.key,
    this.onSubmit,
    this.onLoginPressed,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeTerms = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get username => _usernameController.text;
  String get password => _passwordController.text;
  String get email => _emailController.text;
  String get confirmPassword => _confirmPasswordController.text;

  Future<void> _handleSubmit() async {
    if (username.isEmpty || password.isEmpty || email.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin'),
          backgroundColor: AppColors.red600,
        ),
      );
      return;
    }

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bạn phải đồng ý với điều khoản sử dụng'),
          backgroundColor: AppColors.red600,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mật khẩu và xác nhận mật khẩu không khớp'),
          backgroundColor: AppColors.red600,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSubmit?.call(username, password, email, confirmPassword);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thất bại: $e'),
            backgroundColor: AppColors.red600,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          "Họ và tên", 
          "Nhập họ và tên", 
          _usernameController, 
          Icons.person_outline_rounded, false, null, null),
        const SizedBox(height: 6),
        _buildTextField(
          "Số điện thoại / Email", 
          "Nhập số điện thoại hoặc email", _emailController, Icons.email_outlined, false, null, null),
        const SizedBox(height: 6),
        _buildTextField(
          "Mật khẩu",
          "Nhập mật khẩu",
          _passwordController,
          Icons.lock_outline_rounded,
          _obscurePassword,
          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        const SizedBox(height: 6),
        _buildTextField(
          "Xác nhận mật khẩu",
          "Nhập lại mật khẩu",
          _confirmPasswordController,
          Icons.lock_outline_rounded,
          _obscureConfirmPassword,
          _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreeTerms,
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _agreeTerms = value ?? false;
                        });
                      },
                shape: const CircleBorder(),
                side: BorderSide(
                  color: AppColors.slate200,
                  width: 1.5,
                ),
                checkColor: Colors.transparent, 
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.blue700;
                  }
                  return Colors.white;
                }),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 2,
                  children: [
                    Text(
                      "Tôi đồng ý với",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray600,
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        "Điều khoản sử dụng",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blue700,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.blue700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue700,
              foregroundColor: Colors.white,
              elevation: 0,
              disabledBackgroundColor: AppColors.gray300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Đăng ký",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.slate200,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Hoặc",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.slate400,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.slate200,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Đã có tài khoản?",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.slate600,
              ),
            ),
            TextButton(
              onPressed: widget.onLoginPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                " Đăng nhập",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue700,
                  decorationColor: AppColors.blue700,
                ),
              ),
            ), 
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hintText,
    TextEditingController controller,
    IconData prefixIcon,
    bool obscureText,
    IconData? suffixIcon,
    void Function()? onSuffixIconPressed,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(height: 6),
        Container(

          decoration: BoxDecoration(
            border: Border.all(color: AppColors.slate200),
            borderRadius: BorderRadius.circular(32),
          ),
          child: TextField(
            controller: controller,
            enabled: !_isLoading,
            obscureText: obscureText,
            enableSuggestions: !obscureText,
            autocorrect: !obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: "Noto Sans",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.slate400,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: AppColors.gray500,
                size: 20,
              ),
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(
                        suffixIcon,
                        color: _isLoading ? AppColors.gray300 : AppColors.gray500,
                        size: 20,
                      ),
                      onPressed: onSuffixIconPressed,
                    )
                  : null,
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
