import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/cubit/user_type_cubit.dart';
import 'package:falcon/core/enums/user_type.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/model/player_card_model.dart';

class PlayerCardWidget extends StatelessWidget {
  final PlayerCardData player;
  final VoidCallback? onInviteTap;

  const PlayerCardWidget({
    super.key,
    required this.player,
    this.onInviteTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInvited = player.isInvited == true;
    final userType = context.watch<UserTypeCubit>().state;
    final bool canInvite = userType.canSendInvitations;

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoute.playerProfile,
          arguments: {
            'isMyProfile': false,
            'playerId': '${player.id}',
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Player photo
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: player.photo ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Skeletonizer(
                        enabled: true,
                        child: Container(color: Colors.grey[200]),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFFEFF4FF),
                        child: Icon(
                          Icons.person,
                          size: 40.w,
                          color: mainColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    // Jersey number badge
                    if (player.jerseyNumber != null)
                      Positioned(
                        top: 8.w,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '${player.jerseyNumber}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Player info
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Name
                    CenterTextUtils(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: player.fullName,
                      maxlines: 1,
                    ),

                    // Team name
                    if (player.teamName != null)
                      CenterTextUtils(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        text: '${player.teamName}',
                        maxlines: 1,
                      ),

                    // XP Points
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14.w),
                        horizontalSpace(4),
                        Text(
                          '${player.tps ?? player.xpPoints ?? 0} XP',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: mainColor,
                          ),
                        ),
                      ],
                    ),

                    // Invitation button (club only)
                    if (canInvite)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isInvited ? null : onInviteTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isInvited ? Colors.grey[300] : mainColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isInvited)
                                Icon(Icons.check_circle,
                                    size: 14.w, color: Colors.teal),
                              if (isInvited) horizontalSpace(4),
                              Text(
                                isInvited
                                    ? 'تم ارسال دعوة'.tr()
                                    : 'ارسال دعوة'.tr(),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isInvited ? Colors.black54 : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
