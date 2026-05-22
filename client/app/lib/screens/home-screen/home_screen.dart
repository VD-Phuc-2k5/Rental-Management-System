import 'components/body.dart';
import '../../core/widgets/tenant_navigation_bottom.dart';
import "package:flutter/material.dart";
import '../../core/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: AppBar(
        backgroundColor: AppColors.gray25,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 200,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "NhàTrọ+",
              style: TextStyle(
                fontSize: 32,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                color: AppColors.blue700,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                const BoxShadow(
                  color: AppColors.gray300,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.account_circle_outlined,
                size: 32,
                color: AppColors.blue700,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const HomeScreenBody(),
      ),
      bottomNavigationBar: const TenantNavigationBottom(currentIndex: 0),
    );
  }
}
