import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/widgets/common_appbar.dart';
import '../../core/constants.dart';
import '../../core/di/di.dart';
import 'package:domain/rental_request.dart';

import 'components/member_profile_header.dart';
import 'components/primary_call_button.dart';
import 'components/danger_bottom_button.dart';
import 'components/penalty_dialog.dart'; // File bạn vừa tạo ở Bước 4.2

import '../../core/blocs/remove_member/remove_member_cubit.dart';
import '../../core/blocs/remove_member/remove_member_state.dart';
import '../../core/blocs/penalty/penalty_cubit.dart';
import '../../core/blocs/penalty/penalty_state.dart';

class MemberDetailScreen extends StatelessWidget {
  const MemberDetailScreen({
    super.key,
    required this.contractId,
    required this.memberId,
    required this.memberName,
    required this.isRoomLeader,
  });

  final String contractId;
  final String memberId;
  final String memberName;
  final bool isRoomLeader;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              RemoveMemberCubit(getIt<RemoveContractMemberUsecase>()),
        ),
        // Cung cấp thêm PenaltyCubit cho tính năng Phạt
        BlocProvider(
          create: (context) => PenaltyCubit(
            getIt<CreatePenaltyUsecase>(),
            getIt<GetContractDetailUsecase>(),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          // Lắng nghe trạng thái Xóa
          BlocListener<RemoveMemberCubit, RemoveMemberState>(
            listener: (context, state) {
              if (state is RemoveMemberSuccess) {
                showToast(
                  message: 'Đã xóa thành viên thành công',
                  type: ToastType.success,
                );
                Navigator.pop(context, true);
              } else if (state is RemoveMemberFailure) {
                showToast(
                  message: 'Xóa thất bại: ${state.message}',
                  type: ToastType.error,
                );
              }
            },
          ),
          // Lắng nghe trạng thái Phạt
          BlocListener<PenaltyCubit, PenaltyState>(
            listener: (context, state) {
              if (state is PenaltySuccess) {
                showToast(
                  message: 'Đã tạo phiếu phạt thành công!',
                  type: ToastType.success,
                );
              } else if (state is PenaltyFailure) {
                showToast(
                  message: 'Lập phiếu phạt thất bại: ${state.message}',
                  type: ToastType.error,
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.grayBackground,
          appBar: const CommonAppBar(title: 'Thông tin thành viên'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MemberProfileHeader(
                  name: memberName,
                  role: isRoomLeader ? 'Trưởng phòng' : 'Thành viên',
                  joinMonth: DateTime.now().month,
                  joinYear: DateTime.now().year,
                ),
                const SizedBox(height: 16),
                const PrimaryCallButton(),
              ],
            ),
          ),
          bottomNavigationBar: _buildActionButtons(context),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ============ NÚT PHẠT VI PHẠM ============
            BlocBuilder<PenaltyCubit, PenaltyState>(
              builder: (context, state) {
                final isLoading = state is PenaltyLoading;
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.orange500,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            // Mở popup nhập lý do và số tiền
                            final result =
                                await showDialog<Map<String, dynamic>>(
                                  context: context,
                                  builder: (_) => const PenaltyDialog(),
                                );

                            // Nếu có kết quả trả về -> Gọi API phạt
                            if (result != null && context.mounted) {
                              await context.read<PenaltyCubit>().submitPenalty(
                                contractId: contractId,
                                amount: result['amount'],
                                reason: result['reason'],
                              );
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.orange500,
                            ),
                          )
                        : const Text(
                            'Phạt vi phạm',
                            style: TextStyle(
                              color: AppColors.orange500,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // ============ NÚT XÓA THÀNH VIÊN ============
            if (!isRoomLeader)
              BlocBuilder<RemoveMemberCubit, RemoveMemberState>(
                builder: (context, state) {
                  final isLoading = state is RemoveMemberLoading;
                  return DangerBottomButton(
                    text: 'Xóa thành viên',
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () async {
                            final confirm = await showDeleteDialog(context);
                            if (confirm == true && context.mounted) {
                              await context
                                  .read<RemoveMemberCubit>()
                                  .removeMember(
                                    contractId: contractId,
                                    memberId: memberId,
                                  );
                            }
                          },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
