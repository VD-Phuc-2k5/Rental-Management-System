import 'package:app/screens/tenant-maintenance-request-screen/tenant_maintenance_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/screens/home-screen/home_screen.dart';
import 'package:app/screens/tenant-invoice-list-screen/tenant_invoice_list_screen.dart';

class TenantNavigationBottom extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const TenantNavigationBottom({super.key, this.currentIndex = 0, this.onTap});

  final _items = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month),
      label: "Lịch hẹn",
    ),
    BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: "Sự cố"),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_outlined),
      label: "Hóa đơn",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.perm_identity),
      label: "Tài khoản",
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
            builder: (_) => const TenantMaintenanceRequestScreen(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TenantInvoiceListScreen()),
        );
        break;
      default:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const HomeScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray300,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
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
      ),
    );
  }
}
