import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/room.dart'; // Import để dùng RoomEntity

import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';
import '../../core/di/di.dart';
import '../../core/blocs/room_contract/room_contract_cubit.dart';
import '../../core/blocs/room_contract/room_contract_state.dart';

import '../room-details-empty-screen/components/room_info_card.dart';
import 'components/tenant_list_section.dart';

// ĐÃ ẨN ĐI THEO YÊU CẦU CỦA DEMO:
// import 'components/contract_info_section.dart';
// import 'components/pending_requests_section.dart';
// import 'components/rented_room_bottom_bar.dart';

class RoomDetailsRentedScreen extends StatelessWidget {
  const RoomDetailsRentedScreen({
    super.key,
    required this.room,
    required this.propertyName,
  });

  final RoomEntity room;
  final String propertyName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Vẫn lấy ID phòng để tìm hợp đồng
      create: (context) => getIt<RoomContractCubit>()..fetchActiveContract(room.id),
      child: Scaffold(
        backgroundColor: AppColors.gray25,
        appBar: CommonAppBar(title: "Chi tiết phòng ${room.title}"),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // THẺ TỔNG QUAN PHÒNG (Truyền dữ liệu thật)
                    RoomInfoCard(room: room, propertyName: propertyName),
                    const SizedBox(height: 24),

                    // DANH SÁCH THÀNH VIÊN ĐƯỢC QUẢN LÝ BỞI CUBIT
                    BlocBuilder<RoomContractCubit, RoomContractState>(
                      builder: (context, state) {
                        if (state is RoomContractLoading || state is RoomContractInitial) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.blue700));
                        }
                        if (state is RoomContractFailure) {
                          return Center(child: Text('Lỗi: ${state.message}', style: const TextStyle(color: Colors.red)));
                        }
                        if (state is RoomContractEmpty) {
                          return const Center(child: Text('Phòng này hiện chưa có hợp đồng đang hiệu lực.', style: TextStyle(color: AppColors.slate500)));
                        }
                        if (state is RoomContractSuccess) {
                          return TenantListSection(contractId: state.contractId);
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // CÁC THÀNH PHẦN ĐÃ BỊ ẨN
                    // const SizedBox(height: 24),
                    // const PendingRequestsSection(),
                    // const SizedBox(height: 24),
                    // const ContractInfoSection(),
                  ],
                ),
              ),
            ),
            // ĐÃ ẨN NÚT HỦY HỢP ĐỒNG Ở DƯỚI ĐÁY
            // const RentedRoomBottomBar(),
          ],
        ),
      ),
    );
  }
}