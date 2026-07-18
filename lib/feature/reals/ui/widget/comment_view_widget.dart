import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';

import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:falconclubapp/feature/reals/ui/widget/comment_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentViewWidget extends StatelessWidget {
  const CommentViewWidget({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RealsCubit>();

    return Container(
      height: context.displayHeight / 1.4, // بيظهر تدريجيًا
      width: context.displayWidth / 1,
      decoration: BoxDecoration(
        color: whiteclr,
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(30.r),
          topStart: Radius.circular(30.r),
        ),
      ),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            verticalSpace(10),
            Container(
              width: 80.w,
              height: 5.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: greyClr,
              ),
            ),
            verticalSpace(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                horizontalSpace(20),
                Expanded(
                  child: TextUtils(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    text: 'التعليقات'.tr(),
                  ),
                ),
                InkWell(
                  onTap: onTap,
                  child: Icon(Icons.close, size: 24.w, color: blackclr),
                ),
                horizontalSpace(20),
              ],
            ),
            verticalSpace(10),
            Row(
              children: [
                horizontalSpace(20),
                Expanded(
                  child: Divider(
                    color: greyClr.withOpacity(0.7),
                    thickness: 1.w,
                  ),
                ),
                horizontalSpace(20),
              ],
            ),
            verticalSpace(10),
            CommentListWidget(cubit: cubit),
          ],
        ),
      ),
    );
  }
}
