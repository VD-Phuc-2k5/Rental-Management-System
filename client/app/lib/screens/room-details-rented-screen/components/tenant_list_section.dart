import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/rental_request.dart';

import '../../../core/blocs/contract_members/contract_members_cubit.dart';
import '../../../core/blocs/contract_members/contract_members_state.dart';
import '../../../core/constants.dart';
import '../../../core/di/di.dart';
import '../../member-detail-screen/member_detail_screen.dart';

class TenantListSection extends StatelessWidget {
  const TenantListSection({super.key, required this.contractId});

  // Bắt buộc phải có contractId để biết lấy danh sách của hợp đồng nào
  final String contractId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Khởi tạo Cubit và tự động gọi API lấy danh sách ngay khi màn hình mở lên
      create: (context) =>
          ContractMembersCubit(getIt<GetContractMembersUsecase>())
            ..fetchMembers(contractId),
      child: _TenantListSectionView(contractId: contractId),
    );
  }
}

class _TenantListSectionView extends StatelessWidget {
  const _TenantListSectionView({required this.contractId});
  final String contractId;

  Widget _buildTenantRow(BuildContext context, ContractMemberEntity member) {
    String initialLetter = member.fullName.trim().isNotEmpty
        ? member.fullName.trim().split(' ').last.toUpperCase()
        : '?';

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        // 1. Mở màn hình chi tiết thành viên và CHỜ đợi kết quả trả về
        final isDeleted = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MemberDetailScreen(
              contractId: contractId,
              memberId: member.id,
              memberName: member.fullName,
              isRoomLeader: member.isRoomLeader,
            ),
          ),
        );

        // 2. Nếu bên màn hình chi tiết báo đã xóa (trả về true), ta sẽ gọi API load lại danh sách
        if (isDeleted == true && context.mounted) {
          await context.read<ContractMembersCubit>().fetchMembers(contractId);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.blue50,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initialLetter,
                style: const TextStyle(
                  color: AppColors.blue700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.isRoomLeader ? "Trưởng phòng" : "Thành viên",
                    style: TextStyle(
                      fontSize: 12,
                      color: member.isRoomLeader
                          ? AppColors.blue700
                          : AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),
            // Mũi tên chỉ ra rằng có thể bấm vào để xem chi tiết
            const Icon(Icons.chevron_right, color: AppColors.slate400),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      // Lắng nghe các trạng thái (Loading, Success, Failure) từ Cubit
      child: BlocBuilder<ContractMembersCubit, ContractMembersState>(
        builder: (context, state) {
          if (state is ContractMembersLoading ||
              state is ContractMembersInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blue700),
            );
          }

          if (state is ContractMembersFailure) {
            return Center(
              child: Text(
                'Lỗi: ${state.message}',
                style: const TextStyle(color: AppColors.red500),
              ),
            );
          }

          if (state is ContractMembersSuccess) {
            final members = state.members;

            return Column(
              children: [
                if (members.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Phòng trống, không có thành viên nào",
                      style: TextStyle(color: AppColors.slate500),
                    ),
                  )
                else
                  ...members.map((member) => _buildTenantRow(context, member)),

                const SizedBox(height: 8),
                const Divider(color: AppColors.slate100, height: 1),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ngày vào ở",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.slate500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Theo hợp đồng",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
