import "package:app/core/constants.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import 'dart:typed_data';

class ImageUploadSection extends StatelessWidget {
  final List<XFile> selectedImages;
  final VoidCallback onAddImage;
  final Function(int) onRemoveImage;
  final int maxImages;

  const ImageUploadSection({
    super.key,
    required this.selectedImages,
    required this.onAddImage,
    required this.onRemoveImage,
    this.maxImages = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        const Text(
          "Hình ảnh đính kèm",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        if (selectedImages.isNotEmpty)
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: [
              ...selectedImages.asMap().entries.map(
                (entry) => _buildImagePreview(entry.key, entry.value),
              ),
              if (selectedImages.length < maxImages) _buildAddImageButton(),
            ],
          )
        else
          _buildAddImageButton(),
        Text(
          "Tối đa $maxImages ảnh",
          style: const TextStyle(fontSize: 12, color: AppColors.slate500),
        ),
      ],
    );
  }

  Widget _buildImagePreview(int index, XFile image) {
    return FutureBuilder<Uint8List>(
      future: image.readAsBytes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        }

        return Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.slate200),
                image: DecorationImage(
                  image: MemoryImage(snapshot.data!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.red500,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
                onPressed: () => onRemoveImage(index),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: onAddImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.slate100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.slate300,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: AppColors.slate500,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              "Thêm ảnh",
              style: TextStyle(color: AppColors.slate500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
