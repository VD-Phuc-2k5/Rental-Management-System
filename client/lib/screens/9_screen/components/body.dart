import 'package:flutter/material.dart';

import '../../10_1_screen/components/tenant_info_screen.dart'; 
import '../../9_screen/components/apartment_card.dart';
import '../../9_screen/components/appointment_info_card.dart';
import '../../9_screen/components/primary_button.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          'Đăng ký thuê phòng',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Column(
          children: [
            ApartmentCard(),
            SizedBox(height: 12),
            AppointmentInfoCard(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: PrimaryButton(
          text: 'Đăng ký thuê phòng ngay',
          trailingIcon: Icons.arrow_forward,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TenantInfoScreen()),
            );
          },
        ),
      ),
    );
  }
}