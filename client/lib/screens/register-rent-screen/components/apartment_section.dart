import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class RegisterRentApartmentSection extends StatelessWidget {
  const RegisterRentApartmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageHeader(
            imagePath: 'assets/images/apartment.jpg',
            tagText: 'Căn hộ dịch vụ',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleRow(
                  title: 'Căn hộ Mini 301',
                  onFav: () {},
                ),
                const SizedBox(height: 6),
                const _AddressRow(
                  text: 'Số 18, Ngõ 86, Phố Chùa Láng, Đống Đa, Hà Nội',
                ),
                const SizedBox(height: 10),
                const _SpecsRow(
                  area: '35m²',
                  bed: '1 PN',
                  bath: '1 WC',
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                const _PriceRow(
                  price: '4.500.000đ',
                  unit: '/tháng',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _ImageHeader extends StatelessWidget {
  final String imagePath;
  final String tagText;

  const _ImageHeader({required this.imagePath, required this.tagText});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                tagText,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onFav;

  const _TitleRow({required this.title, required this.onFav});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Color(0xFF111417)),
          ),
        ),
        IconButton(
          onPressed: onFav,
          icon: const Icon(Icons.favorite_border),
        ),
      ],
    );
  }
}

class _AddressRow extends StatelessWidget {
  final String text;
  const _AddressRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF647487)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF647487), height: 1.3,fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _SpecsRow extends StatelessWidget {
  final String area;
  final String bed;
  final String bath;

  const _SpecsRow({required this.area, required this.bed, required this.bath});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.grey, fontSize: 14);
    return Row(
      children: const [
        Icon(Icons.square_foot_outlined, size: 14, color: Color(0xFF647487)),
        SizedBox(width: 6),
        Text('35m²', style: style),
        SizedBox(width: 16),
        Icon(Icons.bed_outlined, size: 14, color: Color(0xFF647487)),
        SizedBox(width: 6),
        Text('1 PN', style: style),
        SizedBox(width: 16),
        Icon(Icons.bathtub_outlined, size: 14, color: Color(0xFF647487)),
        SizedBox(width: 6),
        Text('1 WC', style: style),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String price;
  final String unit;

  const _PriceRow({required this.price, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Giá thuê', style: TextStyle(color: Color(0xFF647487),fontSize: 14)),
        const Spacer(),
        Text(
          price,
          style: const TextStyle(
            color: AppColors.blue700,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 4),
        Text(unit, style: const TextStyle(color: Color(0xFF647487),fontSize: 14)),
      ],
    );
  }
}