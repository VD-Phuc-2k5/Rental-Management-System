import 'package:app/screens/home-screen/components/filter_price.dart';
import 'package:app/screens/home-screen/components/search_filter.dart';
import 'package:flutter/material.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SearchFilter(),
          FilterPrice(
            currentIndex: _selectedFilterIndex,
            onTap: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
              // TODO: handle lọc theo giá
            },
          ),
        ]
      )
    );
  }
}