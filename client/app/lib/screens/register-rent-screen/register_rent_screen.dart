import 'package:flutter/material.dart';

import 'package:app/screens/form-info-rent-screen/tenant_info_screen.dart';
import 'package:app/screens/register-rent-screen/components/header.dart';
import 'package:app/screens/register-rent-screen/components/apartment_section.dart';
import 'package:app/screens/register-rent-screen/components/appointment_section.dart';
import 'package:app/screens/register-rent-screen/components/bottom_bar.dart';
import 'package:app/core/constants.dart';
class RegisterRentScreen extends StatelessWidget {
  const RegisterRentScreen({super.key});

  void _goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TenantInfoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate100,
      appBar: RegisterRentHeader(
        onBack: () => Navigator.pop(context),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Column(
          children: [
            RegisterRentApartmentSection(),
            SizedBox(height: 12),
            RegisterRentAppointmentSection(),
          ],
        ),
      ),
      bottomNavigationBar: RegisterRentBottomBar(
        onRegister: () => _goNext(context),
      ),
    );
  }
}