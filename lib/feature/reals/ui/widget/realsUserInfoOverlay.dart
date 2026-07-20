import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/video_user_data_widget.dart';

/// 👤 Reals User Info Overlay
/// Widget منفصل لعرض معلومات المستخدم
class RealsUserInfoOverlay extends StatelessWidget {
  final int index;
  final bool playerProfile;
  final VoidCallback onUserTap;

  const RealsUserInfoOverlay({
    Key? key,
    required this.index,
    required this.playerProfile,
    required this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      bottom: playerProfile ? 20.h : 110.h,
      start: 20.w,
      end: 75.w,
      child: Row(
        children: [
          Expanded(
            child: VideoUserDataWidget(
              playerProfile: playerProfile,
              index: index,
              onTab: onUserTap,
            ),
          ),
        ],
      ),
    );
  }
}