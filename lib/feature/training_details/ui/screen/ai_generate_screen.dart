import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';

import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/block_animation.dart';
import 'package:falconclubapp/core/widget/button_utils.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widget/center_text_utils.dart';
import '../../../last_attempt/ui/widget/last_attempt_app_bar_widget.dart';

class AiGenerateScreen extends StatelessWidget {
  const AiGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: lastAttemptAppBar(
        context: context,
        title: 'ملخص الآداء بالمدرب الذكي'.tr(),
      ),
      backgroundColor: mainColor,
      body: Stack(
        children: [
          Container(
            width: context.displayWidth / 1,
            padding: paddingUtils(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlockAnimation(
                  lottiePath: 'assets/lottie/Notification.json',
                  width: context.displayWidth / 1.5,
                ),
                CenterTextUtils(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  text: ' سوف يتم ارسال اشعار لك عند الانتهاء من تقيم الفيديو'
                      .tr(),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            bottom: 20.w,
            start: 20.w,
            end: 20.w,
            child: ButtonUtils(
              text: 'متابعه التمارين',
              border: 30.r,
              borderColor: Colors.transparent,
              onPressed: () {
                context.pop();
              },
              colorstext: Colors.white,
              // ignore: deprecated_member_use
              background: offWhiteClr.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
