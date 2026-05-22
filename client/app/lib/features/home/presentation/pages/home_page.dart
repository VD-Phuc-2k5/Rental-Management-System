import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/format_currency.dart';
import '../../../../core/widgets/tenant_navigation_bottom.dart';
import '../blocs/available_room_list/available_room_list_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<AvailableRoomListBloc>()..add(AvailableRoomListFetched()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _selectedFilterIndex = 0;

  void _onFilterTap(int index) {
    setState(() => _selectedFilterIndex = index);
    double? minRent;
    double? maxRent;
    switch (index) {
      case 1:
        maxRent = 2000000;
      case 2:
        minRent = 2000000;
        maxRent = 4000000;
      case 3:
        minRent = 4000000;
    }
    context.read<AvailableRoomListBloc>().add(
      AvailableRoomListFetched(minRent: minRent, maxRent: maxRent),
    );
  }

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
              'NhàTrọ+',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'Inter',
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const _SearchBar(),
              _FilterPriceRow(
                currentIndex: _selectedFilterIndex,
                onTap: _onFilterTap,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phòng nổi bật',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const _RoomList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TenantNavigationBottom(currentIndex: 0),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          const BoxShadow(
            color: AppColors.gray300,
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm phòng trọ...',
          hintStyle: const TextStyle(color: AppColors.gray400),
          prefixIcon: const Icon(Icons.search, color: AppColors.gray500),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: AppColors.gray500),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _FilterPriceRow extends StatelessWidget {
  const _FilterPriceRow({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _labels = ['Tất cả', 'Dưới 2tr', '2 - 4tr', 'Trên 4tr'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < _labels.length; i++)
            _FilterChip(
              label: _labels[i],
              isSelected: currentIndex == i,
              onTap: () => onTap(i),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue700 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomList extends StatelessWidget {
  const _RoomList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailableRoomListBloc, AvailableRoomListState>(
      builder: (context, state) {
        return switch (state) {
          AvailableRoomListLoadInProgress() => const Center(
            child: CircularProgressIndicator(),
          ),
          AvailableRoomListLoadSuccess(:final data) when data.isEmpty =>
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'Không có phòng trống nào.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          AvailableRoomListLoadSuccess(:final data) => Column(
            children: [
              for (final room in data)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RoomCard(
                    title: room.title,
                    address: room.fullAddress,
                    monthlyRent: room.monthlyRent,
                    imageUrl: room.firstImageUrl,
                    onTap: () => context.push(
                      RoutePaths.roomDetail,
                      extra: {'roomId': room.id, 'isLandlord': false},
                    ),
                  ),
                ),
            ],
          ),
          AvailableRoomListLoadFailure() => Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Có lỗi xảy ra khi tải danh sách phòng.'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<AvailableRoomListBloc>().add(
                    AvailableRoomListFetched(),
                  ),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.title,
    required this.address,
    required this.monthlyRent,
    required this.onTap,
    this.imageUrl,
  });

  final String title;
  final String address;
  final double monthlyRent;
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.grey.withValues(alpha: 0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: AppColors.gray200,
                            child: const Icon(
                              Icons.broken_image,
                              color: AppColors.gray500,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: AppColors.gray500,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  address,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: AppColors.gray600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: formatCurrency(monthlyRent),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blue700,
                              ),
                            ),
                            const TextSpan(
                              text: '/tháng',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
