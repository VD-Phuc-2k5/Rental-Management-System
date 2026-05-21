import 'package:core/constants.dart';
import 'package:domain/room.dart';
import 'package:flutter/material.dart';

const _kAmenities = [
  ('AC', Icons.ac_unit, 'Điều hòa'),
  ('BED', Icons.bed, 'Giường'),
  ('WASHING_MACHINE', Icons.local_laundry_service, 'Máy giặt'),
  ('BALCONY', Icons.balcony, 'Ban công'),
  ('WATER_HEATER', Icons.water, 'Nóng lạnh'),
  ('FRIDGE', Icons.kitchen, 'Tủ lạnh'),
  ('TABLE_CHAIR', Icons.chair, 'Bàn ghế'),
  ('TV', Icons.tv, 'TV'),
  ('WARDROBE', Icons.door_sliding, 'Tủ quần áo'),
  ('KITCHEN', Icons.restaurant, 'Bếp'),
];

class RoomAmenitySelector extends StatelessWidget {
  const RoomAmenitySelector({
    super.key,
    required this.includedCodes,
    required this.addonPrices,
    required this.onIncludedChanged,
    required this.onAddonChanged,
  });

  final Set<String> includedCodes;
  final Map<String, double> addonPrices;
  final void Function(Set<String>) onIncludedChanged;
  final void Function(Map<String, double>) onAddonChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          icon: Icons.check_circle_outline,
          label: 'Tiện ích có sẵn (miễn phí)',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _kAmenities.map((a) {
            final selected = includedCodes.contains(a.$1);
            return GestureDetector(
              onTap: () {
                final next = Set<String>.from(includedCodes);
                if (selected) {
                  next.remove(a.$1);
                } else {
                  next.add(a.$1);
                }
                final nextAddon = Map<String, double>.from(addonPrices)
                  ..remove(a.$1);
                onIncludedChanged(next);
                onAddonChanged(nextAddon);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.blue700.withAlpha(26)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color:
                        selected ? AppColors.blue700 : AppColors.slate300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      a.$2,
                      size: 14,
                      color: selected
                          ? AppColors.blue700
                          : AppColors.slate500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      a.$3,
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: selected
                            ? AppColors.blue700
                            : AppColors.slate600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Divider(color: AppColors.slate100, thickness: 1),
        const SizedBox(height: 12),
        const _SectionHeader(
          icon: Icons.add_shopping_cart,
          label: 'Tiện ích thuê thêm (phụ thu)',
        ),
        const SizedBox(height: 4),
        const Text(
          'Thiết lập giá cho tiện ích khách thuê có thể chọn thêm',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: AppColors.slate400,
          ),
        ),
        const SizedBox(height: 10),
        ..._kAmenities
            .where((a) => !includedCodes.contains(a.$1))
            .map(
              (a) => _AddonRow(
                amenity: a,
                isEnabled: addonPrices.containsKey(a.$1),
                price: addonPrices[a.$1] ?? 0,
                onToggle: (enabled) {
                  final next = Map<String, double>.from(addonPrices);
                  if (enabled) {
                    next[a.$1] = 0;
                  } else {
                    next.remove(a.$1);
                  }
                  onAddonChanged(next);
                },
                onPriceChanged: (price) {
                  final next = Map<String, double>.from(addonPrices)
                    ..[a.$1] = price;
                  onAddonChanged(next);
                },
              ),
            ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.blue700),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.slate700,
          ),
        ),
      ],
    );
  }
}

class _AddonRow extends StatefulWidget {
  const _AddonRow({
    required this.amenity,
    required this.isEnabled,
    required this.price,
    required this.onToggle,
    required this.onPriceChanged,
  });

  final (String, IconData, String) amenity;
  final bool isEnabled;
  final double price;
  final void Function(bool) onToggle;
  final void Function(double) onPriceChanged;

  @override
  State<_AddonRow> createState() => _AddonRowState();
}

class _AddonRowState extends State<_AddonRow> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: widget.price > 0 ? widget.price.toInt().toString() : '',
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: widget.isEnabled,
            onChanged: (v) => widget.onToggle(v ?? false),
            activeColor: AppColors.blue700,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 4),
          Icon(widget.amenity.$2, size: 16, color: AppColors.slate500),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              widget.amenity.$3,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.slate700,
              ),
            ),
          ),
          if (widget.isEnabled)
            SizedBox(
              width: 130,
              height: 36,
              child: TextField(
                controller: _ctrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  color: AppColors.slate900,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  suffixText: 'đ/tháng',
                  suffixStyle: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    color: AppColors.slate400,
                  ),
                  filled: true,
                  fillColor: AppColors.slate50,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: AppColors.slate200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: AppColors.blue700),
                  ),
                ),
                onChanged: (v) {
                  final parsed =
                      double.tryParse(v.replaceAll('.', '')) ?? 0;
                  widget.onPriceChanged(parsed);
                },
              ),
            ),
        ],
      ),
    );
  }
}

List<RoomAddonAmenity> addonPricesToList(Map<String, double> prices) =>
    prices.entries
        .map((e) => RoomAddonAmenity(code: e.key, monthlyPrice: e.value))
        .toList();
