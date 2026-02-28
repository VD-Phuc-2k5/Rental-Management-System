import 'package:flutter/material.dart';

import '../form-info-rent-screen/tenant_info_screen.dart';
import 'components/header.dart';
import 'components/apartment_section.dart';
import 'components/appointment_section.dart';
import 'components/bottom_bar.dart';

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
      backgroundColor: const Color(0xFFF3F5F7),
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