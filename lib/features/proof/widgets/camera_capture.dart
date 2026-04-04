import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// Camera and gallery capture widget for proof photos.
///
/// Displays a placeholder or image preview with buttons to capture
/// from camera or pick from gallery.
class CameraCapture extends StatelessWidget {
  /// Creates a [CameraCapture].
  const CameraCapture({
    required this.onImagePicked,
    this.imageFile,
    this.label,
    super.key,
  });

  /// Called with the picked image file.
  final ValueChanged<File> onImagePicked;

  /// The currently selected image file, if any.
  final File? imageFile;

  /// Optional label above the capture area (e.g. "Before", "After").
  final String? label;

  Future<void> _pickFromCamera(BuildContext context) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      imageQuality: 80,
    );
    if (picked != null) onImagePicked(File(picked.path));
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 80,
    );
    if (picked != null) onImagePicked(File(picked.path));
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(label!, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.xs),
          ],
          Container(
            height: AppSpacing.xxl * 4,
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: AppRadius.cardRadius,
              border: Border.all(color: AppColors.lightGray),
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(imageFile!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageFile == null
                ? Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: AppColors.sunsetOrange,
                            size: AppSpacing.xl,
                          ),
                          onPressed: () => _pickFromCamera(context),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        IconButton(
                          icon: const Icon(
                            Icons.photo_library,
                            color: AppColors.sunsetOrange,
                            size: AppSpacing.xl,
                          ),
                          onPressed: () => _pickFromGallery(context),
                        ),
                      ],
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: CircleAvatar(
                        backgroundColor: AppColors.navy,
                        radius: AppSpacing.md,
                        child: IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColors.white,
                            size: AppSpacing.md,
                          ),
                          onPressed: () => _pickFromGallery(context),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      );
}
