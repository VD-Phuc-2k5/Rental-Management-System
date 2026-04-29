import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';
import 'confirmation_section.dart';
import 'member_selection_list.dart';
import 'models.dart';
import 'password_input_section.dart';
import 'warning_message.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedMemberId;
  bool _isConfirmed = true;

  final List<RoomMember> _members = const [
    RoomMember(id: '1', name: 'Trần Minh Hiếu', role: 'Thành viên'),
    RoomMember(id: '2', name: 'Lê Thùy Dung', role: 'Thành viên'),
    RoomMember(id: '3', name: 'Phạm Văn Nam', role: 'Thành viên'),
  ];

  bool get _isFormValid {
    return _selectedMemberId != null &&
        _passwordController.text.isNotEmpty &&
        _isConfirmed;
  }

  void _handleSubmit() {
    if (!_isFormValid) return;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Xác nhận chuyển quyền',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.slate900,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn chuyển quyền trưởng phòng cho ${_members.firstWhere((m) => m.id == _selectedMemberId).name}?',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.slate700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.slate600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TO DO: Implement API call to transfer leadership
              Navigator.pop(context);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chuyển quyền thành công'),
                  backgroundColor: AppColors.green600,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue700,
              elevation: 0,
            ),
            child: const Text(
              'Xác nhận',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WarningMessage(),
          const SizedBox(height: 24),
          MemberSelectionList(
            members: _members,
            selectedMemberId: _selectedMemberId,
            onMemberSelected: (memberId) {
              setState(() {
                _selectedMemberId = memberId;
              });
            },
          ),
          const SizedBox(height: 24),
          PasswordInputSection(controller: _passwordController),
          const SizedBox(height: 24),
          ConfirmationSection(
            isConfirmed: _isConfirmed,
            onChanged: (value) {
              setState(() {
                _isConfirmed = value;
              });
            },
            onSubmit: _handleSubmit,
            isValid: _isFormValid,
          ),
        ],
      ),
    );
  }
}
