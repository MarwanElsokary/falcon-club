import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../thems/thems.dart';

/// The app's profile photo: a tall rounded portrait with a [secondMainColor]
/// frame.
///
/// This treatment existed in three places — `PlayerImageWidget`, and inline in
/// both the coach and scout profile screens — byte-identical apart from the
/// fallback drawn when the image fails. Nothing was reusable, so a fourth copy
/// was the only way to reuse it. The shape is deliberate: a non-square box with
/// a very large radius reads as a stadium/pill, not a circle.
///
/// Sizing is a parameter because the same treatment is wanted at card scale,
/// where 98×139 would dominate. Keep the ~1:1.42 portrait ratio when overriding
/// — the shape depends on the box staying taller than it is wide.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fallback,
    this.borderWidth,
  });

  final String? imageUrl;

  /// Defaults to 98.w — resolved in [build] because ScreenUtil is not available
  /// at const-construction time.
  final double? width;

  /// Defaults to 139.w.
  final double? height;

  /// Drawn (inside a 20.w padding) when the image is missing or fails. Defaults
  /// to a person glyph.
  final Widget? fallback;

  /// Defaults to 5.w.
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    final double w = width ?? 98.w;
    final double h = height ?? 139.w;
    final BorderRadius radius = BorderRadius.circular(100.r);

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: secondMainColor, width: borderWidth ?? 5.w),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: CachedNetworkImage(
          width: w,
          height: h,
          imageUrl: imageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (BuildContext context, String url) => Skeletonizer(
            enabled: true,
            child: Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
          errorWidget: (BuildContext context, String url, Object error) =>
              Padding(
                padding: EdgeInsets.all(20.w),
                child:
                    fallback ??
                    Icon(Icons.person, color: Colors.white, size: 40.w),
              ),
        ),
      ),
    );
  }
}
