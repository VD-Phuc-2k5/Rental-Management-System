import 'package:app/core/constants.dart';
import 'package:app/screens/transfer-leader-role-screen/transfer_leader_role_screen.dart';
import 'package:flutter/material.dart';

class Member {
  final String name;
  final String role;
  final bool isLeader;

  const Member({required this.name, required this.role, this.isLeader = false});
}

class MemberListSection extends StatelessWidget {
  final List<Member> members;
  final VoidCallback onAddMember;
  final void Function(int index) onDeleteMember;

  const MemberListSection({
    super.key,
    required this.members,
    required this.onAddMember,
    required this.onDeleteMember,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.0, color: AppColors.slate200),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(10),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: AppColors.blue50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people_outline_sharp,
                  color: AppColors.blue700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Danh sách thành viên",
                style: TextStyle(
                  color: AppColors.blue900,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(members.length, (i) {
            final member = members[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _MemberCard(
                name: member.name,
                role: member.role,
                isLeader: member.isLeader,
                onDelete: () => onDeleteMember(i),
              ),
            );
          }),
          const SizedBox(height: 4),
          _AddButton(text: '+ Thêm thành viên', onPressed: onAddMember),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String name;
  final String role;
  final bool isLeader;
  final VoidCallback onDelete;

  const _MemberCard({
    required this.name,
    required this.role,
    required this.isLeader,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.blue900,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: const TextStyle(
                        color: AppColors.slate500,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: AppColors.red500),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (isLeader) ...[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TransferLeaderRoleScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                "Chuyển quyền trưởng phòng",
                style: TextStyle(
                  color: AppColors.blue700,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _AddButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.blue700, width: 1.5),
          color: Colors.transparent,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.blue700,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
