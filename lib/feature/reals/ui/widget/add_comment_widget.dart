import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/cache/cach_Helper.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/showSuccesSnackBar.dart';
import 'package:falconclubapp/core/widget/text_from_field_utils_widget.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
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
                  final RealsCubit cubit = context.read<RealsCubit>();

                  // The cubit already refuses to send blank text, but the widget
                  // used to run the whole optimistic path regardless: it
                  // inserted an empty comment into reel.comments, bumped the
                  // counter and reported success, so a stray tap left a phantom
                  // blank comment that survived reopening the sheet.
                  final String text = cubit.commetnController.text.trim();
                  if (text.isEmpty) return;

                  // May be null when the profile cache is empty/expired — the
                  // `!` here used to crash the whole sheet.
                  final profile = CacheHelper.getmyProfile();

                  // Reads the controller itself, so it must run before clear().
                  cubit.addCommentReel(
                    reelId: cubit.realsVide[cubit.currentIndex].id,
                  );
                  cubit.addCommentLocally(
                    Comment(
                      playerId: '......',
                      id: 0,
                      description: text,
                      creationTime: 'الان',
                      isMyComment: true,
                      playerName: profile?.data.firstName ?? '',
                      playerPhoto: profile?.data.photo ?? '',
                    ),
                  );
                  cubit.addCommentWithNotifier();
                  cubit.commetnController.clear();
                  showSuccesSnackBar(
                    context: context,
                    title: 'تم اضافه تعليقك'.tr(),
                  );
                  cubit.addComment = true;
                  cubit.show.value = !cubit.show.value;
                  await Future.delayed(Duration(milliseconds: 150));
                  if (!mounted) return;
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