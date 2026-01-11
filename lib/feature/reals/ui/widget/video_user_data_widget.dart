import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/main_screen/cubit/main_cubit.dart';
import 'package:falcon/feature/reals/cubit/reals_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VideoUserDataWidget extends StatefulWidget {
  const VideoUserDataWidget({
    super.key,
    required this.onTab,
    required this.index,
    required this.playerProfile,
  });
  final Function() onTab;
  final int index;
  final bool playerProfile;

  @override
  State<VideoUserDataWidget> createState() => _VideoUserDataWidgetState();
}

class _VideoUserDataWidgetState extends State<VideoUserDataWidget> {
  bool showAllComment = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: context.displayWidth / 1,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                widget.onTab();
                if (widget.playerProfile) {
                  context.pop();
                } else {
                  log(
                    context
                            .read<RealsCubit>()
                            .realsVide[widget.index]
                            .playerId
                            .toString() +
                        context
                            .read<RealsCubit>()
                            .realsVide[widget.index]
                            .isMyReel
                            .toString(),
                  );
                  await context.pushNamed(
                    AppRoute.playerProfile,
                    arguments: {
                      'playerId':
                          context
                              .read<RealsCubit>()
                              .realsVide[widget.index]
                              .playerId ??
                          '',
                      'isMyProfile': context
                          .read<RealsCubit>()
                          .realsVide[widget.index]
                          .isMyReel,
                    },
                  );
                  // هنا بيتنفذ أول ما نرجع
                  print("First Screen");
                  context.read<MainCubit>().openProfile = false;
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 34.w,
                      height: 34.w,
                      child: CachedNetworkImage(
                        imageUrl:
                            context
                                .read<RealsCubit>()
                                .realsVide[widget.index]
                                .playerPhoto ??
                            '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Skeletonizer(
                          enabled: true,
                          child: Container(
                            height: 34.w,
                            width: 34.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset('assets/images/Mask group.png'),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: offWhiteClr.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.all(10.w),
                          child: SvgPicture.asset(
                            'assets/svgs/unavailabeImage.svg',
                          ),
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(7),
                  TextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    text:
                        context
                            .read<RealsCubit>()
                            .realsVide[widget.index]
                            .playerName ??
                        '',
                  ),
                ],
              ),
            ),
            verticalSpace(5),
            InkWell(
              onTap: () {
                log('message');
                setState(() {
                  showAllComment = !showAllComment;
                });
                // show full comment
              },
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextUtils(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          maxlines: null,
                          text:
                              context
                                  .read<RealsCubit>()
                                  .realsVide[widget.index]
                                  .description ??
                              '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
