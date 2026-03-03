import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class IdDocumentsSection extends StatelessWidget {
  const IdDocumentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GIẤY TỜ TÙY THÂN',
          style: TextStyle(
            color: AppColors.slate400,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _DocTile(
                title: 'MẶT TRƯỚC CCCD',
                image: AssetImage('assets/images/apartment.jpg'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _DocTile(
                title: 'MẶT SAU CCCD',
                image: AssetImage('assets/images/apartment.jpg'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DocTile extends StatelessWidget {
  final String title;
  final ImageProvider image;

  const _DocTile({
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 92,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: image,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}