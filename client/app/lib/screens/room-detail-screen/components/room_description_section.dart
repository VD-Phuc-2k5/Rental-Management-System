import 'package:app/core/collapse_text.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class RoomDescriptionSection extends StatefulWidget {
  final String description;

  const RoomDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  State<RoomDescriptionSection> createState() => _RoomDescriptionSectionState();
}

class _RoomDescriptionSectionState extends State<RoomDescriptionSection> {
  bool _isExpanded = false;
  static const int _wordLimit = 30;

  @override
  Widget build(BuildContext context) {
    final wordCount = CollapseText.getWordCount(widget.description);
    final shouldTruncate = wordCount > _wordLimit;
    final displayText = shouldTruncate && !_isExpanded
        ? CollapseText.getTruncatedText(widget.description, _wordLimit)
        : widget.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.slate500,
              height: 1.5,
            ),
            children: [
              TextSpan(text: displayText),
              if (shouldTruncate)
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        _isExpanded ? ' Thu gọn' : ' Xem thêm',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}