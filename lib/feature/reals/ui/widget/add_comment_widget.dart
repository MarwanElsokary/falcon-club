import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/cache/cach_Helper.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/showSuccesSnackBar.dart';
import 'package:falcon/core/widget/text_from_field_utils_widget.dart';
import 'package:falcon/feature/reals/cubit/reals_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/model/real_model.dart';

class AddCommentWidget extends StatefulWidget {
  const AddCommentWidget({super.key});

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  bool showSendButton = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(20.r),
          topStart: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          verticalSpace(10),
          Row(
            children: [
              Expanded(
                child: TextFromFieldUtilsWidget(
                  controller: context.read<RealsCubit>().commetnController,
                  obscureText: false,
                  onChange: (data) {
                    if (data!.isNotEmpty) {
                      setState(() {
                        showSendButton = true;
                      });
                    } else {
                      setState(() {
                        showSendButton = false;
                      });
                    }
                    return null;
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'من فضلك تأكد من ادخال الاسم'.tr();
                    }
                    return null;
                  },
                  fillColor: fillColor,

                  textInputType: TextInputType.text,
                  hintText: '',
                  lableText: 'اضف تعليقك هنا...'.tr(),
                  textInputAction: TextInputAction.next,
                ),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () async {
                  context.read<RealsCubit>().addCommentReel(
                    reelId: context
                        .read<RealsCubit>()
                        .realsVide[context.read<RealsCubit>().currentIndex]
                        .id,
                  );
                  context.read<RealsCubit>().videoComment.insert(
                    0,
                    Comment(
                      playerId: '......',
                      id: 0,
                      description: context
                          .read<RealsCubit>()
                          .commetnController
                          .text,
                      creationTime: 'الان',
                      isMyComment: true,
                      playerName:
                          CacheHelper.getmyProfile()!.data.firstName ?? "",
                      playerPhoto: CacheHelper.getmyProfile()!.data.photo ?? "",
                    ),
                  );
                  // استدعاء الفانكشن الجديدة
                  context.read<RealsCubit>().addCommentWithNotifier();
                  context.read<RealsCubit>().commetnController.clear();
                  showSuccesSnackBar(
                    context: context,
                    title: 'تم اضافه تعليقك'.tr(),
                  );
                  context.read<RealsCubit>().addComment = true;
                  context.read<RealsCubit>().show.value = !context
                      .read<RealsCubit>()
                      .show
                      .value;
                  await Future.delayed(Duration(milliseconds: 150));
                  setState(() {
                    showSendButton = false;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: showSendButton ? 45.w : 0,
                  height: showSendButton ? 45.w : 0,
                  margin: EdgeInsetsDirectional.only(start: 10.w),
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: fillColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/svgs/send-svgrepo-com.svg',
                    width: 30.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
