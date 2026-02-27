import 'package:app/screens/home-screen/components/body.dart';
import 'package:app/screens/home-screen/components/navigation_bottom.dart';
import "package:flutter/material.dart";
import 'package:app/core/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              "NhàTrọ+", 
              style: TextStyle(
                fontSize: 32, 
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                color: AppColors.blue700
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
                BoxShadow(
                  color: AppColors.gray300,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle_outlined, size: 32, color: AppColors.blue700),
            ),  
          )
        ],
      ),
      body: Container(
        color: AppColors.gray25,
        width: double.infinity,
        height: double.infinity,
        child: const Center(
          child: HomeScreenBody()
        ),
      ),
      bottomNavigationBar: NavigationBottom(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}