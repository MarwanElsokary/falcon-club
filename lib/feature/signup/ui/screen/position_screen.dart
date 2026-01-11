import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/app_bar_utils.dart';
import 'package:falcon/core/widget/button_utils.dart';

import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../login/cubit/login_cubit.dart';
import '../widget/position/position_widget.dart';

class PositionScreen extends StatelessWidget {
  const PositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF248c33),
      appBar: appBarUtils(context: context, title: 'اختر مركز العب'.tr()),
      body: Stack(
        children: [
          SizedBox(
            width: context.displayWidth / 1,
            height: context.displayHeight / 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [verticalSpace(20), PositionWidget()],
              ),
            ),
          ),

          PositionedDirectional(
            bottom: 20.w,
            start: 20.w,
            end: 20.w,
            child: ValueListenableBuilder(
              valueListenable: context.read<LoginCubit>().positionID,
              builder: (context, positionID, _) {
                return positionID > 0
                    ? SlideEnimationWidget(
                        index: 0,
                        child: ButtonUtils(
                          text: 'تأكيد الموقع',
                          border: 30.r,
                          borderColor: Colors.transparent,
                          onPressed: () {
                            context.pop();
                          },
                          colorstext: Colors.white,
                          background: offWhiteClr.withOpacity(0.2),
                        ),
                      )
                    : SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
