import 'package:app/screens/home-screen/home_screen.dart';
import 'package:app/screens/landlord-maintenance-requests-screen/landlord_maintenance_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.white),
      home: LandlordMaintenanceRequestsScreen(),
    );
  }
}
