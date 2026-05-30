import 'package:core/constants.dart';
import 'package:core/utils.dart';
import 'package:domain/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/router/route_constants.dart';
import '../../../../core/di/di.dart';
import '../../../../screens/room-details-rented-screen/room_details_rented_screen.dart';
import '../../../../screens/add-electric-water-screen/add_electric_water_screen.dart';
import '../blocs/room_list/room_list_bloc.dart';
import '../blocs/delete_room/delete_room_bloc.dart';

class RoomListPage extends StatelessWidget {
  const RoomListPage({
    super.key,
    required this.propertyId,
    required this.propertyName,
  });
  final String propertyId;
  final String propertyName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          getIt<RoomListBloc>()
            ..add(RoomListFetched(propertyId: propertyId)),
        ),
        BlocProvider(create: (_) => getIt<DeleteRoomBloc>()),
      ],
      child: _RoomListView(propertyId: propertyId, propertyName: propertyName),
    );
  }
}

class _RoomListView extends StatelessWidget {
  const _RoomListView({required this.propertyId, required this.propertyName});
  final String propertyId;
  final String propertyName;

  String _formatPrice(double price) {
    final n = price.toInt();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '$bufđ';
  }

  String _amenityLabel(String code) => const {
    'AC': 'Điều hòa',
    'AIR_CONDITIONER': 'Điều hòa',
    'BED': 'Giường',
    'WASHING_MACHINE': 'Máy giặt',
    'BALCONY': 'Ban công',
    'WATER_HEATER': 'Nóng lạnh',
    'FRIDGE': 'Tủ lạnh',
    'TABLE_CHAIR': 'Bàn ghế',
    'TV': 'TV',
    'WARDROBE': 'Tủ quần áo',
    'KITCHEN': 'Bếp',
    'WIFI': 'Wifi',
    'PRIVATE_BATHROOM': 'WC riêng',
  }[code] ?? code;

  Color _statusColor(RoomStatus s) => switch (s) {
    RoomStatus.available => AppColors.green700,
    RoomStatus.occupied => AppColors.blue700,
    RoomStatus.maintenance => AppColors.amber500,
  };

  Color _statusBg(RoomStatus s) => switch (s) {
    RoomStatus.available => AppColors.green100,
    RoomStatus.occupied => AppColors.blue100,
    RoomStatus.maintenance => AppColors.amber100,
  };

  String _statusLabel(RoomStatus s) => switch (s) {
    RoomStatus.available => 'Còn trống',
    RoomStatus.occupied => 'Đang thuê',
    RoomStatus.maintenance => 'Bảo trì',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate900),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Text(
          propertyName,
          style: const TextStyle(
            color: AppColors.slate900,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4, top: 11, bottom: 11),
            child: SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddElectricWaterScreen(
                        initialPropertyId: propertyId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.receipt_long_outlined),
                tooltip: 'Tạo hóa đơn',
                color: AppColors.blue700,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.blue50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 11, bottom: 11),
            child: ElevatedButton.icon(
              onPressed: () async {
                await context.push(
                  RoutePaths.createRoom,
                  extra: {'propertyId': propertyId},
                );
                if (context.mounted) {
                  context.read<RoomListBloc>().add(
                    RoomListFetched(propertyId: propertyId),
                  );
                }
              },
              icon: const Icon(Icons.add, size: 16, color: AppColors.white),
              label: const Text(
                "Thêm phòng",
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
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.slate200, height: 1),
        ),
      ),
      body: BlocConsumer<DeleteRoomBloc, DeleteRoomState>(
        listener: (context, state) {
          if (state is DeleteRoomLoadSuccess) {
            context.read<RoomListBloc>().add(
              RoomListFetched(propertyId: propertyId),
            );
            showToast(message: 'Đã xóa phòng thành công', type: ToastType.success);
          } else if (state is DeleteRoomLoadFailure) {
            showToast(message: state.failure.message, type: ToastType.error);
          }
        },
        builder: (context, _) {
          return BlocBuilder<RoomListBloc, RoomListState>(
            builder: (context, state) {
              if (state is RoomListLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RoomListLoadFailure) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.failure.message),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<RoomListBloc>().add(
                          RoomListFetched(propertyId: propertyId),
                        ),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }
              if (state is RoomListLoadSuccess) {
                final rooms = state.data;
                if (rooms.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.door_front_door_outlined,
                          size: 64,
                          color: AppColors.slate300,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Chưa có phòng nào',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            color: AppColors.slate500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await context.push(
                              RoutePaths.createRoom,
                              extra: {'propertyId': propertyId},
                            );
                            if (context.mounted) {
                              context.read<RoomListBloc>().add(
                                RoomListFetched(propertyId: propertyId),
                              );
                            }
                          },
                          icon: const Icon(Icons.add, color: AppColors.white),
                          label: const Text(
                            'Thêm phòng',
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
                  onRefresh: () async => context.read<RoomListBloc>().add(
                    RoomListFetched(propertyId: propertyId),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: rooms.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final r = rooms[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomDetailsRentedScreen(
                                roomNumber: r.title,
                                roomId: r.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.slate100),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withAlpha(13),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.blue700,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "P.${r.title}",
                                      style: const TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusBg(r.status),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Text(
                                      _statusLabel(r.status),
                                      style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: _statusColor(r.status),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${r.areaSqm} m² · ${_formatPrice(r.monthlyRent)}/tháng',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppColors.blue700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 13,
                                    color: AppColors.slate400,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Đặt cọc: ${_formatPrice(r.depositAmount)}',
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 12,
                                      color: AppColors.slate500,
                                    ),
                                  ),
                                ],
                              ),
                              if (r.includedAmenityCodes.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: r.includedAmenityCodes
                                      .map(
                                        (code) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.blue700.withAlpha(20),
                                        borderRadius: BorderRadius.circular(9999),
                                        border: Border.all(
                                          color: AppColors.blue700.withAlpha(60),
                                        ),
                                      ),
                                      child: Text(
                                        _amenityLabel(code),
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 11,
                                          color: AppColors.blue700,
                                        ),
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ),
                              ],
                              if (r.description != null &&
                                  r.description!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  r.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    color: AppColors.slate400,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              const Divider(color: AppColors.slate100, height: 1),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: AppColors.blue700,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 30),
                                      ),
                                      onPressed: () async {
                                        await context.push(
                                          RoutePaths.updateRoom,
                                          extra: r,
                                        );
                                        if (context.mounted) {
                                          context.read<RoomListBloc>().add(
                                            RoomListFetched(
                                              propertyId: propertyId,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "Cập nhật",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: AppColors.blue700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: AppColors.red500,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 30),
                                      ),
                                      onPressed: () =>
                                          showDeleteDialog(context).then((confirmed) {
                                            if (confirmed == true &&
                                                context.mounted) {
                                              context.read<DeleteRoomBloc>().add(
                                                DeleteRoomSubmitted(id: r.id),
                                              );
                                            }
                                          }),
                                      child: const Text(
                                        "Xóa",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: AppColors.red500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}