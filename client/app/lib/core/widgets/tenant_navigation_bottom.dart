import '../constants.dart';
import '../../screens/tenant-invoice-list-screen/tenant_invoice_list_screen.dart';
import '../../screens/tenant-maintenance-request-screen/tenant_maintenance_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/pending_contract/pending_contract_cubit.dart';
import '../config/router/route_constants.dart';

class TenantNavigationBottom extends StatelessWidget {

  const TenantNavigationBottom({super.key, this.currentIndex = 0, this.onTap});
  final int currentIndex;
  final Function(int)? onTap;


  void _navigateByIndex(BuildContext context, int index) {
    if (index == currentIndex) {
      return;
    }

    switch (index) {
      case 0:
        context.go(RoutePaths.home);
        break;
      case 1:
        context.go(RoutePaths.myAppointments);
        break;
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
      case 4:
        context.go(RoutePaths.profile);
        break;
      default:
        context.go(RoutePaths.home);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingContractCubit, PendingContractState>(
      builder: (context, pendingState) {
        final hasPending = pendingState is PendingContractFound;
        final items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Lịch hẹn",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            label: "Sự cố",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            label: "Hóa đơn",
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: hasPending,
              backgroundColor: AppColors.red500,
              child: const Icon(Icons.perm_identity),
            ),
            label: "Tài khoản",
          ),
        ];

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray300,
                blurRadius: 10,
                offset: Offset(0, -2),
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
              items: items,
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
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              iconSize: 28,
            ),
          ),
        );
      },
    );
  }
}
