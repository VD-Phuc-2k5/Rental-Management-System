import 'package:core/constants.dart';
import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/router/route_constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/landlord_navigation_bottom.dart';
import '../blocs/property_list/property_list_bloc.dart';
import '../blocs/delete_property/delete_property_bloc.dart';

class PropertyListPage extends StatelessWidget {
  const PropertyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<PropertyListBloc>()..add(const PropertyListFetched()),
        ),
        BlocProvider(create: (_) => getIt<DeletePropertyBloc>()),
      ],
      child: const _PropertyListView(),
    );
  }
}

class _PropertyListView extends StatelessWidget {
  const _PropertyListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleSpacing: 16.0,
        title: const Text(
          "Nhà trọ của tôi",
          style: TextStyle(
            color: AppColors.slate900,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
              top: 11.0,
              bottom: 11.0,
            ),
            child: ElevatedButton.icon(
              onPressed: () async {
                await context.push(RoutePaths.createProperty);
                if (context.mounted) {
                  context
                      .read<PropertyListBloc>()
                      .add(const PropertyListFetched());
                }
              },
              icon: const Icon(Icons.add, size: 16, color: AppColors.white),
              label: const Text(
                "Thêm nhà trọ",
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue700,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate200, height: 1.0),
        ),
      ),
      body: BlocConsumer<DeletePropertyBloc, DeletePropertyState>(
        listener: (context, deleteState) {
          if (deleteState is DeletePropertyLoadSuccess) {
            context.read<PropertyListBloc>().add(const PropertyListFetched());
          } else if (deleteState is DeletePropertyLoadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(deleteState.failure.message),
              ),
            );
          }
        },
        builder: (context, deleteState) {
          return Stack(
            children: [
              BlocBuilder<PropertyListBloc, PropertyListState>(
                builder: (context, state) {
                  if (state is PropertyListLoadInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.blue700,
                      ),
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
                            onPressed: () =>
                                context.read<PropertyListBloc>().add(
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
                              'Chưa có nhà trọ nào',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                color: AppColors.slate500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await context.push(RoutePaths.createProperty);
                                if (context.mounted) {
                                  context
                                      .read<PropertyListBloc>()
                                      .add(const PropertyListFetched());
                                }
                              },
                              icon: const Icon(
                                Icons.add,
                                color: AppColors.white,
                              ),
                              label: const Text(
                                'Thêm nhà trọ',
                                style: TextStyle(color: AppColors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async =>
                          context.read<PropertyListBloc>().add(
                            const PropertyListFetched(),
                          ),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: properties.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final p = properties[index];
                          return _PropertyCard(
                            id: p.id,
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
                            onUpdate: () async {
                              await context.push(
                                RoutePaths.updateProperty,
                                extra: p,
                              );
                              if (context.mounted) {
                                context
                                    .read<PropertyListBloc>()
                                    .add(const PropertyListFetched());
                              }
                            },
                            onDelete: () =>
                                context.read<DeletePropertyBloc>().add(
                                  DeletePropertySubmitted(id: p.id),
                                ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              if (deleteState is DeletePropertyLoadInProgress)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: const LandlordNavigationBottom(currentIndex: 0),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.id,
    required this.title,
    required this.address,
    required this.onTap,
    required this.onUpdate,
    required this.onDelete,
  });

  final String id;
  final String title;
  final String address;
  final VoidCallback onTap;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

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
            const SizedBox(height: 16),
            const Divider(color: AppColors.slate100, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: onUpdate,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.blue700),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Cập nhật",
                          style: TextStyle(
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: AppColors.blue700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.edit_square,
                          size: 12,
                          color: AppColors.blue700,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    showDeleteDialog(context).then((confirm) {
                      if (confirm == true) {
                        onDelete();
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.red500),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Xóa",
                          style: TextStyle(
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: AppColors.red500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.delete_outline,
                          size: 12,
                          color: AppColors.red500,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
