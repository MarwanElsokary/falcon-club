import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/anmiate_builder.dart';
import '../../../../core/widget/center_text_utils.dart';

class StopAndMuteWidget extends StatelessWidget {
  const StopAndMuteWidget({
    super.key,
    required this.togglePlay,
    required this.toggleMute,
    required this.isPlaying,
    required this.muted,
  });
  final Function() togglePlay;
  final Function() toggleMute;
  final bool isPlaying;
  final bool muted;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        horizontalSpace(70),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            verticalSpace(170),
            AnimateBuilder(
              columnCount: 1,
              position: 0,
              child: InkWell(
                onTap: togglePlay,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40.w,
                  ),
                ),
              ),
            ),
            verticalSpace(10),
            AnimateBuilder(
              columnCount: 1,
              position: 1,
              child: InkWell(
                onTap: toggleMute,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40.w,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(20.r),
                          bottomStart: Radius.circular(20.r),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          muted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    Container(
                      height: 40.w,
                      padding: EdgeInsetsDirectional.only(end: 10.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20.r),
                          bottomEnd: Radius.circular(20.r),
                        ),
                      ),
                      child: Center(
                        child: CenterTextUtils(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: muted ? 'تشغيل الصوت'.tr() : 'كتم الصوت'.tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
