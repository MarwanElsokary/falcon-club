import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/thems/thems.dart';

class CommentButtonWidget extends StatelessWidget {
  const CommentButtonWidget({
    super.key,
    required this.onTap,
    required this.index,
  });
  final Function() onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RealsCubit>();
    final reel = cubit.realsVide[index];
    final commentCountNotifier = cubit.commentCountNotifiers[reel.id]!;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            debugPrint('Opening comments for reel ${reel.id}');

            // حفظ الـ index الحالي
            cubit.currentIndex = index;

            // تحميل الكومنتات
            cubit.videoComment.clear();
            cubit.videoComment.addAll(reel.comments);
            cubit.reelId = reel.id;

            // فتح الكومنتات
            onTap();
          },
          child: ClipOval(
            child: Container(
              width: 45.w,
              height: 45.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset('assets/svgs/Frame 755.svg'),
            ),
          ),
        ),
        verticalSpace(3),
        SizedBox(
          width: 45.w,
          child: ValueListenableBuilder<int>(
            valueListenable: commentCountNotifier,
            builder: (context, commentCount, child) {
              return CenterTextUtils(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                text: '$commentCount',
              );
            },
          ),
        ),
      ],
    );
  }
}
