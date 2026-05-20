import 'package:app/core/constants.dart';
import 'package:app/core/widgets/tenant_navigation_bottom.dart';
import 'package:flutter/material.dart';

import 'components/profile_action_card.dart';
import 'components/profile_header.dart';
import 'components/profile_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.gray25,
      bottomNavigationBar: const TenantNavigationBottom(currentIndex: 4),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: topPadding + 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.blue700, Color(0xFF2E86DE)],
                ),
              ),
            ),

            Column(
              children: [
                SizedBox(height: topPadding + 10),

                const ProfileHeader(),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: const [
                      SizedBox(height: 32),
                      ProfileInfoCard(),
                      SizedBox(height: 20),
                      ProfileActionCard(),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
