import 'package:flutter/material.dart';

class HostelManagementWrapper extends StatefulWidget {
  const HostelManagementWrapper({super.key});

  static HostelManagementWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<HostelManagementWrapperState>();
  }

  @override
  State<HostelManagementWrapper> createState() =>
      HostelManagementWrapperState();
}

class HostelManagementWrapperState extends State<HostelManagementWrapper> {
  static bool isEmpty = true;

  void updateState(bool emptyStatus) {
    setState(() {
      isEmpty = emptyStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Text("");
  }
}
