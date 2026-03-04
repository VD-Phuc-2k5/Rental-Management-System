import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';
import 'models.dart';

class MemberSelectionList extends StatelessWidget {
  final List<RoomMember> members;
  final String? selectedMemberId;
  final ValueChanged<String> onMemberSelected;

  const MemberSelectionList({
    super.key,
    required this.members,
    required this.selectedMemberId,
    required this.onMemberSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chọn trưởng phòng mới",
          style: TextStyle(
            color: AppColors.slate900,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        ...members.map(
          (member) => _MemberRadioTile(
            member: member,
            isSelected: selectedMemberId == member.id,
            onTap: () => onMemberSelected(member.id),
          ),
        ),
      ],
    );
  }
}

class _MemberRadioTile extends StatelessWidget {
  final RoomMember member;
  final bool isSelected;
  final VoidCallback onTap;

  const _MemberRadioTile({
    required this.member,
    required this.isSelected,
    required this.onTap,
  });

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blue100,
      ),
      child: member.avatarUrl != null
          ? ClipOval(
              child: Image.network(
                member.avatarUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              ),
            )
          : _buildDefaultAvatar(),
    );
  }

  Widget _buildDefaultAvatar() {
    final initials = _getInitials(member.name);
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: AppColors.blue700,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';

    if (parts.length >= 2) {
      final secondLast = parts[parts.length - 2];
      final last = parts[parts.length - 1];
      return '${secondLast[0]}${last[0]}'.toUpperCase();
    }

    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isSelected ? AppColors.blue700 : AppColors.slate200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.role,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.blue700 : AppColors.slate300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
