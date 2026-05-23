import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/new_requests/new_requests_cubit.dart';
import '../config/router/route_constants.dart';

class LandlordNavigationBottom extends StatelessWidget {
  const LandlordNavigationBottom({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });
  final int currentIndex;
  final Function(int)? onTap;

  void _navigateByIndex(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go(RoutePaths.propertyList);
        break;
      case 1:
        context.go(RoutePaths.roomTab);
        break;
      case 2:
        context.go(RoutePaths.landlordViewingAppointments);
        break;
      case 3:
        context.go(RoutePaths.landlordPayments);
        break;
      case 4:
        context.go(RoutePaths.profile);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray300,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BlocBuilder<NewRequestsCubit, NewRequestsState>(
        builder: (context, requestsState) => BottomNavigationBar(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: "Tổng quan",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.door_front_door_outlined),
              label: "Phòng",
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.check_circle_outline),
                  if (requestsState.count > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '${requestsState.count}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: "Yêu cầu",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: "Hóa đơn",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: "Hồ sơ",
            ),
          ],
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
