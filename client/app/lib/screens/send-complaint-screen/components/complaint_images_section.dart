import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants.dart';

class ComplaintImagesSection extends StatelessWidget {
  const ComplaintImagesSection({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onRemoveImage,
  });

  final List<XFile> images;
  final VoidCallback onAddImage;
  final void Function(int index) onRemoveImage;

  static const int maxImages = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hình ảnh minh chứng',
          style: TextStyle(
            color: AppColors.gray800,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(maxImages, (index) {
            if (index < images.length) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < maxImages - 1 ? 12 : 0),
                  child: _ImagePreviewBox(
                    imageFile: images[index],
                    onRemove: () => onRemoveImage(index),
                  ),
                ),
              );
            }
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < maxImages - 1 ? 12 : 0),
                child: _UploadBox(
                  onPressed: images.length < maxImages ? onAddImage : null,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 10),
          child: Text(
            '* Tải lên tối đa 3 ảnh minh chứng tình trạng hiện tại.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagePreviewBox extends StatefulWidget {
  const _ImagePreviewBox({required this.imageFile, required this.onRemove});

  final XFile imageFile;
  final VoidCallback onRemove;

  @override
  State<_ImagePreviewBox> createState() => _ImagePreviewBoxState();
}

class _ImagePreviewBoxState extends State<_ImagePreviewBox> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _loadBytes();
  }

  Future<void> _loadBytes() async {
    final bytes = await widget.imageFile.readAsBytes();
    if (mounted) setState(() => _bytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = _bytes != null
        ? Image.memory(
            _bytes!,
            height: 88,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _brokenPlaceholder(),
          )
        : Container(
            height: 88,
            color: AppColors.slate100,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );

    return Stack(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: image),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: widget.onRemove,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _brokenPlaceholder() => Container(
        height: 88,
        color: AppColors.slate100,
        child: const Icon(Icons.broken_image, color: AppColors.slate400),
      );
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: 30,
              color: onPressed != null ? AppColors.gray400 : AppColors.slate200,
            ),
          ),
        ),
      ),
    );
  }
}
