import 'package:app/core/constants.dart';
import 'package:app/screens/home-screen/components/filter_price.dart';
import 'package:app/screens/home-screen/components/intro_room_section.dart';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SearchFilter(),
          FilterPrice(
            currentIndex: _selectedFilterIndex,
            onTap: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
              // TODO: handle lọc theo giá
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phòng nổi bật",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Xem thêm",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.blue600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const IntroRoomSection(),
        ],
      ),
    );
  }
}
