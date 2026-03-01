import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class AddOnServicesSectionUi extends StatelessWidget {
  const AddOnServicesSectionUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children:  [
          _ServiceRow(icon: Icons.wifi, name: 'Internet', price: '100.000', enabled: true),
          const Divider(height: 1),
          _ServiceRow(icon: Icons.cleaning_services, name: 'Vệ sinh', price: '50.000', enabled: true),
          const Divider(height: 1),
          _ServiceRow(icon: Icons.shield_outlined, name: 'Bảo vệ', price: '0', enabled: false),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatefulWidget {
  final IconData icon;
  final String name;
  final String price;
  final bool enabled;
  //final bool disabled;

  const _ServiceRow({
    required this.icon,
    required this.name,
    required this.price,
    required this.enabled,
   // this.disabled = false,
  });

  @override
  State<_ServiceRow> createState() => _ServiceRowState();
}

class _ServiceRowState extends State<_ServiceRow> {
  late bool _enabled;
  
  @override
  void initState() {
    super.initState();
    _enabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEFF6FF),
            ),
            child: Icon(widget.icon, color: AppColors.blue500, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.name,
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gray900),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              widget.price,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                //color: widget.disabled ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),

            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return const Color(0xFFE5E7EB);
              return _enabled ? AppColors.blue700 : AppColors.gray200;
            }),

            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return const Color(0xFFCBD5E1);
              return Colors.white;
            }),
          ),
        ],
      ),
    );
  }
}