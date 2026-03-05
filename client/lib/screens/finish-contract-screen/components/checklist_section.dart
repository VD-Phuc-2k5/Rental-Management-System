import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ChecklistSection extends StatefulWidget {
  const ChecklistSection({super.key});

  @override
  State<ChecklistSection> createState() => _ChecklistSectionState();
}

class _ChecklistSectionState extends State<ChecklistSection> {
  bool _isFloorGood = true;
  bool _isWallGood = false;
  bool _isAcGood = true;

  Widget _buildChecklistItem({
    required String title,
    required IconData icon,
    required bool isGood,
    required ValueChanged<bool> onChanged,
    bool showBottomBorder = true,
    Widget? damagedInputWidget,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: showBottomBorder
            ? const Border(bottom: BorderSide(color: AppColors.slate200))
            : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.slate100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.slate500, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.slate900,
                    ),
                  ),
                ),
                Text(
                  isGood ? "Tốt" : "Hư hại",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: isGood ? AppColors.green500 : AppColors.slate400,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 24,
                  width: 44,
                  child: Switch(
                    value: isGood,
                    onChanged: onChanged,
                    activeColor: AppColors.white,
                    activeTrackColor: AppColors.green500,
                    inactiveThumbColor: AppColors.white,
                    inactiveTrackColor: AppColors.slate200,
                  ),
                ),
              ],
            ),
          ),

          if (!isGood && damagedInputWidget != null) damagedInputWidget,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kiểm tra tình trạng phòng",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.slate900,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.slate200),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              children: [
                _buildChecklistItem(
                  title: "Sàn nhà",
                  icon: Icons.grid_view,
                  isGood: _isFloorGood,
                  onChanged: (val) => setState(() => _isFloorGood = val),
                ),
                _buildChecklistItem(
                  title: "Tường",
                  icon: Icons.format_paint_outlined,
                  isGood: _isWallGood,
                  onChanged: (val) => setState(() => _isWallGood = val),
                  damagedInputWidget: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red50,
                      border: Border.all(color: AppColors.red100),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Phí sửa chữa / Khấu trừ",
                          style: TextStyle(
                            color: AppColors.red600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          initialValue: "300.000",
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.slate900,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffixText: " đ",
                            suffixStyle: const TextStyle(
                              color: AppColors.slate400,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildChecklistItem(
                  title: "Điều hòa",
                  icon: Icons.ac_unit,
                  isGood: _isAcGood,
                  showBottomBorder: false,
                  onChanged: (val) => setState(() => _isAcGood = val),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
