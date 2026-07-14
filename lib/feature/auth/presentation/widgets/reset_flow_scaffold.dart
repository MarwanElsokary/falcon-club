import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';

/// The chrome shared by all three password-reset screens.
///
/// A faithful port of the original `forget_password_screen.dart` /
/// `send_otp.dart` / `reset_password_screen.dart`: the same transparent,
/// zero-elevation `AppBar` with an `arrow_back_ios_new` leading icon in
/// `mainColor` and the title **"الرجوع"** at 20/w600, the same 24.w horizontal
/// padding, the same 40.h top gap, the same illustration with its icon fallback,
/// and the same subtitle in `mainColor.withAlpha(150)` at 16sp/w700.
///
/// Only the chrome is shared — each screen supplies its own [illustration],
/// [subtitle] and [children]. The Clean Architecture underneath
/// (`PasswordResetCubit`, use cases, repository) is untouched.
class ResetFlowScaffold extends StatelessWidget {
  const ResetFlowScaffold({
    super.key,
    required this.illustration,
    required this.fallbackIcon,
    required this.subtitle,
    required this.children,
    this.illustrationHeight = 180,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// e.g. `assets/images/Frame 1059.png`.
  final String illustration;

  /// Shown when the asset is missing — the original did the same.
  final IconData fallbackIcon;

  final String subtitle;
  final List<Widget> children;
  final double illustrationHeight;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: <Widget>[
              SizedBox(height: 40.h),
              _illustration(context),
              SizedBox(height: 24.h),
              _subtitle(),
              SizedBox(height: 32.h),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) => AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: mainColor),
      onPressed: () => context.pop(),
    ),
    title: Text(
      'الرجوع'.tr(),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: mainColor,
      ),
    ),
  );

  Widget _illustration(BuildContext context) => Image.asset(
    illustration,
    height: illustrationHeight.h,
    cacheWidth:
        (illustrationHeight * MediaQuery.of(context).devicePixelRatio).round(),
    cacheHeight:
        (illustrationHeight * MediaQuery.of(context).devicePixelRatio).round(),
    filterQuality: FilterQuality.medium,
    errorBuilder: (_, __, ___) => Container(
      height: illustrationHeight.h,
      color: Colors.grey[200],
      child: Icon(fallbackIcon, size: 60.w, color: mainColor),
    ),
  );

  Widget _subtitle() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: TextUtils(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: mainColor.withAlpha(150),
      maxlines: 3,
      text: subtitle,
    ),
  );
}
