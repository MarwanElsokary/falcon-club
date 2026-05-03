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
            // ValueListenableBuilder(
            //   valueListenable: cubit.show,
            //   builder: (context, show, _) {
            //     return cubit.videoComment.isEmpty
            //         ? CenterTextUtils(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w700,
            //             color: blackclr,
            //             text: 'التعليق سوف يظهر هنا',
            //           )
            //         : SizedBox(
            //             width: context.displayWidth / 1,
            //             height: context.displayHeight / 2,
            //             child: ListView.builder(
            //               itemCount: cubit.videoComment.length,
            //               shrinkWrap: true,
            //               padding: EdgeInsets.symmetric(horizontal: 20.w),
            //               itemBuilder: (context, index) {
            //                 return Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     //
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       crossAxisAlignment: CrossAxisAlignment.center,
            //                       children: [
            //                         InkWell(
            //                           borderRadius: BorderRadius.circular(100),
            //                           onTap: () {},
            //                           child: ClipOval(
            //                             child: SizedBox(
            //                               width: 37.w,
            //                               height: 37.w,
            //                               child: CachedNetworkImage(
            //                                 imageUrl:
            //                                     cubit
            //                                         .videoComment[index]
            //                                         .playerPhoto ??
            //                                     '',
            //                                 fit: BoxFit.cover,
            //                                 placeholder: (context, url) =>
            //                                     Skeletonizer(
            //                                       enabled: true,
            //                                       child: Container(
            //                                         height: 37.w,
            //                                         width: 37.w,
            //                                         decoration:
            //                                             const BoxDecoration(
            //                                               shape:
            //                                                   BoxShape.circle,
            //                                             ),
            //                                         child: Image.asset(
            //                                           'assets/images/Mask group.png',
            //                                         ),
            //                                       ),
            //                                     ),
            //                                 errorWidget:
            //                                     (
            //                                       context,
            //                                       url,
            //                                       error,
            //                                     ) => Container(
            //                                       color: greyClr.withOpacity(
            //                                         0.4,
            //                                       ),
            //                                       child: Padding(
            //                                         padding: EdgeInsets.all(
            //                                           7.w,
            //                                         ),
            //                                         child: SvgPicture.asset(
            //                                           'assets/svgs/profile.svg',
            //                                           color: mainColor,
            //                                         ),
            //                                       ),
            //                                     ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                         horizontalSpace(7),
            //                         Expanded(
            //                           child: Column(
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.start,
            //                             children: [
            //                               TextUtils(
            //                                 fontSize: 13,
            //                                 fontWeight: FontWeight.w700,
            //                                 color: Colors.black,
            //                                 text: cubit
            //                                     .videoComment[index]
            //                                     .playerName,
            //                               ),
            //                               verticalSpace(2),
            //                               TextUtils(
            //                                 fontSize: 10,
            //                                 fontWeight: FontWeight.w700,
            //                                 color: blackclr,
            //                                 text: cubit
            //                                     .videoComment[index]
            //                                     .creationTime,
            //                               ),
            //                             ],
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     verticalSpace(10),
            //                     TextUtils(
            //                       fontSize: 13,
            //                       fontWeight: FontWeight.w400,
            //                       color: Colors.black,
            //                       text: cubit.videoComment[index].description,
            //                     ),
            //                     verticalSpace(10),

            //                     Divider(
            //                       color: index == 9
            //                           ? Colors.transparent
            //                           : greyClr.withOpacity(0.7),
            //                     ),
            //                     verticalSpace(index == 9 ? 80 : 10),
            //                   ],
            //                 );
            //               },
            //             ),
            //           );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
