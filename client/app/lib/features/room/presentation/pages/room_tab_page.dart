import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/router/route_constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/landlord_navigation_bottom.dart';
import '../../../property/presentation/blocs/property_list/property_list_bloc.dart';

class RoomTabPage extends StatelessWidget {
  const RoomTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PropertyListBloc>()..add(const PropertyListFetched()),
      child: const _RoomTabView(),
    );
  }
}

class _RoomTabView extends StatelessWidget {
  const _RoomTabView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleSpacing: 16.0,
        title: const Text(
          'Quản lý phòng trọ',
          style: TextStyle(
            color: AppColors.slate900,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate200, height: 1.0),
        ),
      ),
      body: BlocBuilder<PropertyListBloc, PropertyListState>(
        builder: (context, state) {
          if (state is PropertyListLoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blue700),
            );
          }
          if (state is PropertyListLoadFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.failure.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<PropertyListBloc>().add(
                      const PropertyListFetched(),
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          if (state is PropertyListLoadSuccess) {
            final properties = state.data;
            if (properties.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.home_outlined,
                      size: 64,
                      color: AppColors.slate300,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Chưa có khu trọ nào',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Hãy tạo khu trọ trước khi thêm phòng',
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 13,
                        color: AppColors.slate500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await context.push(RoutePaths.createProperty);
                        if (context.mounted) {
                          context.read<PropertyListBloc>().add(
                            const PropertyListFetched(),
                          );
                        }
                      },
                      icon: const Icon(Icons.add, color: AppColors.white),
                      label: const Text(
                        'Tạo khu trọ ngay',
                        style: TextStyle(color: AppColors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue700,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<PropertyListBloc>().add(
                const PropertyListFetched(),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: properties.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = properties[index];
                  return _PropertyRoomCard(
                    title: p.name,
                    address:
                        '${p.address}, ${p.ward}, ${p.district}, ${p.city}',
                    onTap: () => context.push(
                      RoutePaths.roomList,
                      extra: {
                        'propertyId': p.id,
                        'propertyName': p.name,
                      },
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const LandlordNavigationBottom(currentIndex: 1),
    );
  }
}

class _PropertyRoomCard extends StatelessWidget {
  const _PropertyRoomCard({
    required this.title,
    required this.address,
    required this.onTap,
  });

  final String title;
  final String address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.slate200),
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha(13),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 13,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.slate400,
            ),
          ],
        ),
      ),
    );
  }
}
