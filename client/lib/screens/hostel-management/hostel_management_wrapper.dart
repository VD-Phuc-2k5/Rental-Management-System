import 'package:flutter/material.dart';
import 'empty_hostel_screen.dart';
import 'hostel_list_screen.dart';

class HostelManagementWrapper extends StatefulWidget {
  const HostelManagementWrapper({super.key});

  @override
  State<HostelManagementWrapper> createState() => _HostelManagementWrapperState();
}

class _HostelManagementWrapperState extends State<HostelManagementWrapper> {
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return const EmptyHostelScreen();
    } else {
      return const HostelListScreen();
    }
  }
}