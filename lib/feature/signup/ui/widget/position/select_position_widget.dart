import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPositionWidget extends StatelessWidget {
  const SelectPositionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoute.positionScreen,
          arguments: {'context': context},
        );
      },
      child: ValueListenableBuilder(
        valueListenable: loginCubit.positionName,
        builder: (context, positionName, _) {
          return Container(
            height: 47.h,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: positionName == ''
                      ? mainColor.withOpacity(0.5)
                      : Colors.black,
                  text: positionName == '' ? 'اختر موقعك'.tr() : positionName,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
