import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/cache/cach_Helper.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/upload_image_widget.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/thems/thems.dart';

class UploadProfileImageWidget extends StatefulWidget {
  const UploadProfileImageWidget({super.key});

  @override
  State<UploadProfileImageWidget> createState() =>
      _UploadProfileImageWidgetState();
}

class _UploadProfileImageWidgetState extends State<UploadProfileImageWidget> {
  final ImagePicker _picker = ImagePicker();

  File? selectedImage;

  Future<void> getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        // فتح شاشة القص
        setState(() {
          selectedImage = File(image.path);
        });
        context.read<LoginCubit>().imagePath = image.path;
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                bootomshet(
                  title: '',
                  context: context,
                  cameratab: () {
                    getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  galleryatab: () {
                    getImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                );
              },
              child: Container(
                width: 88.w,
                height: 129.w,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(color: secondMainColor, width: 5.w),
                ),
                child: selectedImage != null
                    ? Container(
                        width: 88.w,
                        height: 129.w,
                        decoration: BoxDecoration(
                          color: offWhiteClr,
                          borderRadius: BorderRadius.circular(100.r),
                          image: DecorationImage(
                            image: FileImage(selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : CacheHelper.getmyProfile() != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          100.r,
                        ), // Using .r for responsive border radius
                        child: CachedNetworkImage(
                          width: 98.w,
                          height: 139.w,
                          imageUrl:
                              CacheHelper.getmyProfile()!.data.photo ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Skeletonizer(
                            enabled: true,
                            child: Container(
                              width: 98.w,
                              height: 139.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  20.r,
                                ), // Match the border radius
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Padding(
                            padding: EdgeInsets.all(20.w),
                            child: SvgPicture.asset(
                              'assets/svgs/unavailabeImage.svg',
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 88.w,
                        height: 129.w,
                        decoration: BoxDecoration(
                          color: offWhiteClr,
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(color: offWhiteClr),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svgs/unavailabeImage.svg',
                          ),
                        ),
                      ),
              ),
            ),
            PositionedDirectional(
              end: 1,
              bottom: 2,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                  ),
                  child: selectedImage != null
                      ? Icon(Icons.done, color: Colors.white, size: 16.w)
                      : Icon(Icons.add, color: Colors.white, size: 16.w),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(30),
      ],
    );
  }
}
