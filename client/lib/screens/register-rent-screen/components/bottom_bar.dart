import 'package:flutter/material.dart';

class RegisterRentBottomBar extends StatelessWidget {
  final VoidCallback onRegister;

  const RegisterRentBottomBar({super.key, required this.onRegister});

  @override
Widget build(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(
          color: Color(0xFFDCE0E5),
          width: 1,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 8,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onRegister,
          style: const ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Color(0xFF1A5FAD)),
            foregroundColor:
                WidgetStatePropertyAll(Color(0xFFFFFFFF)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Đăng ký thuê phòng ngay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    ),
  );
}
}