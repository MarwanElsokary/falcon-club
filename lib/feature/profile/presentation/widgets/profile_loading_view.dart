import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The white spinner both self-profile screens show while loading.
class ProfileLoadingView extends StatelessWidget {
  const ProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: CupertinoActivityIndicator(color: Colors.white, radius: 15.w),
  );
}
