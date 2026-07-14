import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/upload_image_widget.dart';

/// Optional profile photo.
///
/// ## This is the ORIGINAL design
///
/// A faithful port of `upload_profile_image_widget.dart`: the same 88×129 oval
/// frame with a 5px `secondMainColor` border, the same `unavailabeImage.svg`
/// placeholder, the same circular badge pinned to the bottom-end that flips from
/// `add` to `done` once a photo is chosen, and the same `bootomshet` camera /
/// gallery chooser.
///
/// Two things changed, and neither is visual:
///
/// * It is **controlled** — it reports the picked path through [onPicked]
///   instead of writing into `context.read<LoginCubit>().imagePath`.
/// * It no longer falls back to `CacheHelper.getmyProfile()!.data.photo`. That
///   branch is for *editing* an existing profile; during registration there is
///   no profile yet, so on a signup screen it was unreachable. Compression still
///   happens later, in the data layer's `ImageCompressor`.
class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({
    super.key,
    required this.photoPath,
    required this.onPicked,
  });

  final String? photoPath;
  final ValueChanged<String> onPicked;

  static const double _frameWidth = 88;
  static const double _frameHeight = 129;
  static const double _cornerRadius = 100;
  static const double _borderWidth = 5;
  static const String _placeholderAsset = 'assets/svgs/unavailabeImage.svg';

  bool get _hasPhoto => photoPath != null && photoPath!.isNotEmpty;

  Future<void> _pickFrom(BuildContext context, ImageSource source) async {
    Navigator.pop(context);
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) onPicked(image.path);
  }

  void _openSourceSheet(BuildContext context) {
    bootomshet(
      title: '',
      context: context,
      cameratab: () => _pickFrom(context, ImageSource.camera),
      galleryatab: () => _pickFrom(context, ImageSource.gallery),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(_cornerRadius),
              onTap: () => _openSourceSheet(context),
              child: Container(
                width: _frameWidth.w,
                height: _frameHeight.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_cornerRadius.r),
                  border: Border.all(
                    color: secondMainColor,
                    width: _borderWidth.w,
                  ),
                ),
                child: _hasPhoto ? _chosenPhoto() : _placeholder(),
              ),
            ),
            _badge(),
          ],
        ),
        verticalSpace(30),
      ],
    );
  }

  Widget _chosenPhoto() => Container(
    width: _frameWidth.w,
    height: _frameHeight.w,
    decoration: BoxDecoration(
      color: offWhiteClr,
      borderRadius: BorderRadius.circular(_cornerRadius.r),
      image: DecorationImage(
        image: FileImage(File(photoPath!)),
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget _placeholder() => Container(
    width: _frameWidth.w,
    height: _frameHeight.w,
    decoration: BoxDecoration(
      color: offWhiteClr,
      borderRadius: BorderRadius.circular(_cornerRadius.r),
      border: Border.all(color: offWhiteClr),
    ),
    child: Center(child: SvgPicture.asset(_placeholderAsset)),
  );

  Widget _badge() => PositionedDirectional(
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
        child: Icon(
          _hasPhoto ? Icons.done : Icons.add,
          color: Colors.white,
          size: 16.w,
        ),
      ),
    ),
  );
}
