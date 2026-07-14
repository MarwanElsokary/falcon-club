import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/comment_button_widget.dart';
import '../widget/fav_reals_widget.dart';
import '../widget/share_icon_button.dart';

/// 🎛️ Reals Actions Overlay
/// Widget منفصل للـ Actions (Like, Comment, Share)
class RealsActionsOverlay extends StatelessWidget {
  final int index;
  final int reelId;
  final bool playerProfile;
  final VoidCallback onCommentTap;

  const RealsActionsOverlay({
    super.key,
    required this.index,
    required this.reelId,
    required this.playerProfile,
    required this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      end: 20.w,
      bottom: playerProfile ? 20.h : 100.h,
      start: 20.w,
      top: 0,
      // 🔥 مهم جداً: IgnorePointer بيخلي المنطقة الفاضية transparent للـ gestures
      child: IgnorePointer(
        ignoring: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 🔥 كل widget يكون absorbing للـ pointer بس في منطقته
            AbsorbPointer(
              absorbing: false,
              child: FavRealsWidget(key: ValueKey('fav_$reelId'), index: index),
            ),

            verticalSpace(10),

            // Comment Button
            AbsorbPointer(
              absorbing: false,
              child: CommentButtonWidget(index: index, onTap: onCommentTap),
            ),

            verticalSpace(10),

            // Share Button - 🔥 الأهم!
            AbsorbPointer(
              absorbing: false,
              child: ShareIconButton(index: index),
            ),
          ],
        ),
      ),
    );
  }
}
