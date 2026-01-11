import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/widget/show_error_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/center_text_utils.dart';
import '../../cubit/creat_real_cubit.dart';

class PublishButtonWidget extends StatelessWidget {
  const PublishButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: () {
        if (context.read<CreatRealCubit>().controller.text.isEmpty) {
          showErrorSnackBar(
            context: context,
            title: 'من فضلك قم ب ادخال وصف الفيديو'.tr(),
          );
        } else {
          context.read<CreatRealCubit>().emitcreatRealStates();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: mainColor,
        ),
        child: CenterTextUtils(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: 'قم بالنشر'.tr(),
        ),
      ),
    );
  }
}
