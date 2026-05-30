import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';

import '../../core/di/di.dart';
import '../../core/blocs/room_contract/room_contract_cubit.dart';
import '../../core/blocs/room_contract/room_contract_state.dart';

import '../room-details-empty-screen/components/room_info_card.dart';
import 'components/contract_info_section.dart';
import 'components/pending_requests_section.dart';
import 'components/rented_room_bottom_bar.dart';
import 'components/tenant_list_section.dart';

class RoomDetailsRentedScreen extends StatelessWidget {
  const RoomDetailsRentedScreen({
    super.key,
    required this.roomNumber,
    required this.roomId,
  });

  final String roomNumber;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RoomContractCubit>()..fetchActiveContract(roomId),
      child: Scaffold(
        backgroundColor: AppColors.gray25,
        appBar: CommonAppBar(title: "Chi tiết phòng $roomNumber"),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    BlocBuilder<RoomContractCubit, RoomContractState>(
                      builder: (context, state) {
                        if (state is RoomContractLoading || state is RoomContractInitial) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.blue700),
                            ),
                          );
                        }

                        if (state is RoomContractFailure) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text('Lỗi: ${state.message}',
                                  style: const TextStyle(color: Colors.red)),
                            ),
                          );
                        }

                        if (state is RoomContractEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text('Phòng này hiện chưa có hợp đồng nào đang hiệu lực.',
                                  style: TextStyle(color: AppColors.slate500)),
                            ),
                          );
                        }

                        if (state is RoomContractSuccess) {
                          return TenantListSection(contractId: state.contractId); // TRUYỀN ID THẬT
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),

                    RoomInfoCard(roomNumber: roomNumber),
                    const SizedBox(height: 24),
                    const PendingRequestsSection(),
                    const SizedBox(height: 24),
                    const ContractInfoSection(),
                  ],
                ),
              ),
            ),
            const RentedRoomBottomBar(),
          ],
        ),
      ),
    );
  }
}