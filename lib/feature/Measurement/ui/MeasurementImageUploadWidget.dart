import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/thems/thems.dart';
import '../../../core/widget/button_utils.dart';
import '../../../core/widget/padding_utils.dart';
import '../cubit/MeasurementCubit.dart';
import '../cubit/measurement_state.dart';

class MeasurementImageUploadWidget extends StatelessWidget {
  const MeasurementImageUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MeasurementCubit>();

    return Padding(
      padding: paddingUtils(),
      child: Column(
        children: [
          // Image preview or placeholder
          BlocBuilder<MeasurementCubit, MeasurementState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () => _pickImage(context, cubit),
                child: Container(
                  height: 400.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: cubit.imagePath.isEmpty
                          ? Colors.grey.shade300
                          : mainColor,
                      width: 2,
                    ),
                  ),
                  child: cubit.imagePath.isEmpty
                      ? _buildPlaceholder()
                      : _buildImagePreview(cubit.imagePath),
                ),
              );
            },
          ),

          verticalSpace(20),

          // Buttons
          BlocBuilder<MeasurementCubit, MeasurementState>(
            builder: (context, state) {
              final isLoading = state is UploadLoading || state is UploadProgress;
              final hasImage = cubit.imagePath.isNotEmpty;

              return Row(
                children: [
                  if (hasImage) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isLoading ? null : () => cubit.clearImage(),
                        icon: Icon(Icons.delete_outline, size: 20.sp),
                        label: Text('حذف'.tr()),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: BorderSide(color: Colors.red.shade300),
                          foregroundColor: Colors.red.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpace(12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ButtonUtils(
                      text: hasImage
                          ? 'رفع وتحليل الصورة'.tr()
                          : 'اختيار صورة'.tr(),
                      onPressed: isLoading
                          ? () {}
                          : () {
                        if (hasImage) {
                          cubit.uploadMeasurementImage();
                        } else {
                          _pickImage(context, cubit);
                        }
                      },
                      colorstext: Colors.white,
                      background: hasImage ? mainColor : Colors.grey.shade400,
                      border: 12.r,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 80.sp,
          color: Colors.grey.shade400,
        ),
        verticalSpace(16),
        Text(
          'اضغط لاختيار صورة'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        verticalSpace(8),
        Text(
          'قم بتصوير اللاعب في وضعية الوقوف'.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(imagePath),
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 16.sp),
                  horizontalSpace(4),
                  Text(
                    'تم الاختيار'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, MeasurementCubit cubit) async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: mainColor),
              title: Text('التقاط صورة'.tr()),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                );
                if (image != null) {
                  cubit.setImagePath(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: mainColor),
              title: Text('اختيار من المعرض'.tr()),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );
                if (image != null) {
                  cubit.setImagePath(image.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}