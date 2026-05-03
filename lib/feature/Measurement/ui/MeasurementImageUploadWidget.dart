import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

import 'package:slider_button/slider_button.dart';

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/widget/block_animation.dart';
import '../../training_details/ui/widget/choose_image_bottom_sheet_widget.dart';
import '../cubit/MeasurementCubit.dart';
import '../cubit/measurement_state.dart';

class MeasurementImageUploadWidget extends StatefulWidget {
  const MeasurementImageUploadWidget({super.key});

  @override
  State<MeasurementImageUploadWidget> createState() =>
      _MeasurementImageUploadWidgetState();
}

class _MeasurementImageUploadWidgetState
    extends State<MeasurementImageUploadWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementCubit, MeasurementState>(
      builder: (context, state) {
        final cubit = context.read<MeasurementCubit>();
        final hasImage = cubit.imagePath.isNotEmpty;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Image preview area
              GestureDetector(
                onTap: hasImage
                    ? null
                    : () => _showImagePickerSheet(context, cubit),
                child: Container(
                  width: context.displayWidth,
                  height: context.displayHeight / 1.22,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(30.r),
                      bottomEnd: Radius.circular(30.r),
                    ),
                  ),
                  child: hasImage
                      ? ClipRRect(
                          borderRadius: BorderRadiusDirectional.only(
                            bottomStart: Radius.circular(30.r),
                            bottomEnd: Radius.circular(30.r),
                          ),
                          child: Image.file(
                            File(cubit.imagePath),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BlockAnimation(
                                lottiePath: 'assets/lottie/Notification.json',
                                width: 200.w,
                              ),
                              verticalSpace(20),
                              TextUtils(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                text: 'القياسات بالذكاء الاصطناعي'.tr(),
                              ),
                              verticalSpace(10),
                              TextUtils(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.7),
                                text: 'اضغط لالتقاط صورة'.tr(),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              verticalSpace(10),

              // Info section
              Container(
                width: context.displayWidth,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                decoration: BoxDecoration(
                  color: whiteclr,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(25.r),
                    topEnd: Radius.circular(25.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 80.w,
                        height: 5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: greyClr.withOpacity(0.5),
                        ),
                      ),
                    ),

                    verticalSpace(20),

                    TextUtils(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: 'قياس الجسم بالذكاء الاصطناعي'.tr(),
                    ),

                    verticalSpace(15),

                    _buildInstructionsExpansion(),

                    verticalSpace(20),

                    _buildStartButton(context, hasImage, cubit),

                    verticalSpace(30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructionsExpansion() {
    List<Color> catColor = [mainColor, greenClr, kCOlor5, Color(0xFF0C4F45)];
    List<Map<String, dynamic>> instructions = [
      {'text': 'تأكد من وضوح الصورة'.tr(), 'icon': Icons.high_quality},
      {'text': 'الوقوف بشكل مستقيم'.tr(), 'icon': Icons.accessibility_new},
      {'text': 'خلفية فاتحة ومتناقضة'.tr(), 'icon': Icons.palette_outlined},
      {'text': 'عدم وجود أشياء أخرى'.tr(), 'icon': Icons.person_remove},
    ];

    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: TextUtils(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          text: 'تعليمات التصوير'.tr(),
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: instructions.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Row(
                  children: [
                    Container(
                      height: 8.w,
                      width: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: catColor[i % catColor.length],
                      ),
                    ),
                    horizontalSpace(10),
                    Expanded(
                      child: TextUtils(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: blackclr,
                        text: instructions[i]['text'],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(
    BuildContext context,
    bool hasImage,
    MeasurementCubit cubit,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5D2BF4),
            Color(0xFFF4BE2B),
            Color(0xFF5D2BF4),
            Color(0xFF2BB8F4),
          ],
          stops: [0.0, 0.2596, 0.6916, 1.0],
        ),
      ),
      padding: EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: whiteclr,
          borderRadius: BorderRadius.circular(1000.r),
        ),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: SliderButton(
            width: context.displayWidth - 40.w,
            radius: 1000.r,
            action: () async {
              if (hasImage) {
                cubit.uploadMeasurementImage();
              } else {
                _showImagePickerSheet(context, cubit);
              }
              return false;
            },
            label: TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: hasImage
                  ? 'قم بالسحب لبدء القياس'.tr()
                  : 'قم بالسحب لالتقاط صورة'.tr(),
            ),
            icon: Container(
              width: 100.w,
              height: 100.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFEBCD38), Color(0xFF5D2BF4)],
                ),
              ),
              padding: EdgeInsets.all(12.w),
              child: Icon(
                hasImage ? Icons.upload : Icons.camera_alt,
                color: Colors.white,
                size: 24.w,
              ),
            ),
            buttonColor: Colors.transparent,
            backgroundColor: whiteclr,
          ),
        ),
      ),
    );
  }

  void _showImagePickerSheet(BuildContext context, MeasurementCubit cubit) {
    chooseImageBootomShet(
      title: '',
      context: context,
      cameratab: () async {
        context.pop();
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          cubit.setImagePath(image.path);
        }
      },
      galleryatab: () async {
        context.pop();
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          cubit.setImagePath(image.path);
        }
      },
    );
  }
}
