import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../cubit/reals_cubit.dart';
import 'comment_context_menu.dart';

class CommentListWidget extends StatelessWidget {
  final RealsCubit cubit;
  const CommentListWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cubit.show,
      builder: (context, show, _) {
        return cubit.videoComment.isEmpty
            ? CenterTextUtils(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: blackclr,
          text: 'التعليق سوف يظهر هنا',
        )
            : SizedBox(
          width: context.displayWidth,
          height: context.displayHeight / 2,
          child: ListView.builder(
            itemCount: cubit.videoComment.length,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemBuilder: (context, index) {
              return _CommentItem(index: index, cubit: cubit);
            },
          ),
        );
      },
    );
  }
}

/// ---- COMMENT ITEM ----
class _CommentItem extends StatelessWidget {
  final int index;
  final RealsCubit cubit;

  const _CommentItem({required this.index, required this.cubit});

  void _handleLongPress(BuildContext context, Offset globalPosition) {
    final comment = cubit.videoComment[index];
    final isMyComment = comment.isMyComment == true;
    if (!isMyComment) return;

    CommentContextMenu.show(
      context: context,
      position: globalPosition,
      cubit: cubit,
      comment: comment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) =>
          _handleLongPress(context, details.globalPosition),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {},
                child: ClipOval(
                  child: SizedBox(
                    width: 37.w,
                    height: 37.w,
                    child: CachedNetworkImage(
                      imageUrl: cubit.videoComment[index].playerPhoto ?? '',
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Skeletonizer(
                        enabled: true,
                        child: Container(
                          width: 37.w,
                          height: 37.w,
                          decoration:
                          const BoxDecoration(shape: BoxShape.circle),
                          child: Image.asset('assets/images/Mask group.png'),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: greyClr.withOpacity(0.4),
                        child: Padding(
                          padding: EdgeInsets.all(7.w),
                          child: SvgPicture.asset(
                            'assets/svgs/profile.svg',
                            color: mainColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              horizontalSpace(7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUtils(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: cubit.videoComment[index].playerName,
                    ),
                    verticalSpace(2),
                    TextUtils(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: blackclr,
                      text: cubit.videoComment[index].creationTime,
                    ),
                  ],
                ),
              ),
            ],
          ),

          verticalSpace(10),

          TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            text: cubit.videoComment[index].description,
          ),

          verticalSpace(10),

          Divider(
            color: index == cubit.videoComment.length - 1
                ? Colors.transparent
                : greyClr.withOpacity(0.7),
          ),
          verticalSpace(10),
        ],
      ),
    );
  }
}