import 'package:app/screens/empty-hostel-screen/empty_hostel_screen.dart';
import 'package:app/screens/landlord-maintenance-requests-screen/landlord_maintenance_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class LandlordNavigationBottom extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const LandlordNavigationBottom({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  final _items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      label: "Tổng quan",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.door_front_door_outlined),
      label: "Phòng",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.check_circle_outline),
      label: "Yêu cầu",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      label: "Hóa đơn",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: "Hồ sơ",
    ),
  ];

  void _navigateByIndex(BuildContext context, int index) {
    if (index == currentIndex) {
      return;
    }

    switch (index) {
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LandlordMaintenanceRequestsScreen(),
          ),
        );
        break;
      default:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const EmptyHostelScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray300,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        items: _items,
        currentIndex: currentIndex,
        onTap: (index) {
          if (onTap != null) {
            onTap!(index);
            return;
          }
          _navigateByIndex(context, index);
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: AppColors.blue700,
        unselectedItemColor: AppColors.gray500,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        iconSize: 28,
      ),
    );
  }
}
