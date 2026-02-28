import 'package:flutter/material.dart';

class TenantMembersSection extends StatelessWidget {
  final List<TenantMember> members;
  final VoidCallback onAddMember;
  final void Function(int index) onDeleteMember;
  final void Function(int index) onSetLeader;

  const TenantMembersSection({
    super.key,
    required this.members,
    required this.onAddMember,
    required this.onDeleteMember,
    required this.onSetLeader,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _OutlineAddButton(
          text: '+ Thêm thành viên',
          onPressed: onAddMember,
        ),
        const SizedBox(height: 18),
        const _SectionTitle(text: 'THÀNH VIÊN'),
        const SizedBox(height: 10),
        ...List.generate(members.length, (i) {
          final m = members[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MemberCard(
              name: m.name,
              role: m.role,
              onDelete: () => onDeleteMember(i),
              onSetLeader: () => onSetLeader(i),
              selected: m.isLeader,
            ),
          );
        }),
      ],
    );
  }
}

class TenantMember {
  final String name;
  final String role;
  final bool isLeader;

  const TenantMember({
    required this.name,
    required this.role,
    this.isLeader = false,
  });
}

class _OutlineAddButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _OutlineAddButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF195AA4), width: 1.4),
          color: Colors.white,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF195AA4),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF195AA4),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback onDelete;
  final VoidCallback onSetLeader;
  final bool selected;

  const _MemberCard({
    required this.name,
    required this.role,
    required this.onDelete,
    required this.onSetLeader,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? const Color(0xFF195AA4) : Colors.grey,
            ),
            const SizedBox(width: 10),
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF1F5F9),
              ),
              child: const Icon(Icons.person_outline, color: Colors.grey),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(role, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: onSetLeader,
                    child: const Text(
                      'Chọn làm trưởng phòng',
                      style: TextStyle(
                        color: Color(0xCC195AA4),
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}