import 'package:flutter/material.dart';
import 'screens/register-rent-screen/register_rent_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RegisterRentScreen(),
    );
  }
}