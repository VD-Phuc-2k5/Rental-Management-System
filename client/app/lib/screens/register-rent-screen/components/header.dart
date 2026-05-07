import 'package:flutter/material.dart';

class RegisterRentHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const RegisterRentHeader({super.key, required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
      centerTitle: true,
      title: const Text(
        'Đăng ký thuê phòng',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
    );
  }
}