import 'package:core/constants.dart';
import 'package:domain/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../blocs/update_profile/update_profile_bloc.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key, required this.profile});

  final UserProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UpdateProfileBloc>(),
      child: _EditProfileView(profile: profile),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView({required this.profile});

  final UserProfileEntity profile;

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _dobCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.fullName);
    _phoneCtrl = TextEditingController(text: widget.profile.phone);
    _dobCtrl = TextEditingController(text: widget.profile.dateOfBirth ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<UpdateProfileBloc>().add(
          UpdateProfileSubmitted(
            fullName: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            dateOfBirth:
                _dobCtrl.text.trim().isEmpty ? null : _dobCtrl.text.trim(),
          ),
        );
  }

  Future<void> _pickDate() async {
    DateTime initial = DateTime.now();
    final parts = _dobCtrl.text.split('-');
    if (parts.length == 3) {
      initial = DateTime(
        int.tryParse(parts[0]) ?? initial.year,
        int.tryParse(parts[1]) ?? initial.month,
        int.tryParse(parts[2]) ?? initial.day,
      );
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobCtrl.text =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileLoadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật thành công')),
          );
          Navigator.of(context).pop(state.data);
        } else if (state is UpdateProfileLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.gray25,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.slate900),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Chỉnh sửa hồ sơ',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.slate900,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.slate200, height: 1),
          ),
        ),
        body: BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
          builder: (context, state) {
            final loading = state is UpdateProfileLoadInProgress;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _nameCtrl,
                      label: 'Họ và tên',
                      icon: Icons.person_outline,
                      enabled: !loading,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Vui lòng nhập họ tên'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _phoneCtrl,
                      label: 'Số điện thoại',
                      icon: Icons.phone_iphone,
                      keyboardType: TextInputType.phone,
                      enabled: !loading,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _dobCtrl,
                      label: 'Ngày sinh',
                      icon: Icons.cake_outlined,
                      enabled: !loading,
                      readOnly: true,
                      onTap: loading ? null : _pickDate,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Lưu thay đổi',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.blue700),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.blue700, width: 1.5),
        ),
      ),
    );
  }
}
