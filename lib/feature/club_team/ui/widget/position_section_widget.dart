import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/club_team/data/model/club_player_model.dart';
import 'package:falcon/feature/club_team/ui/widget/player_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionSectionWidget extends StatelessWidget {
  final String title;
  final String icon;
  final List<ClubPlayer> players;

  const PositionSectionWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header — title + emoji aligned to start (right in RTL)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(icon, style: TextStyle(fontSize: 20.sp)),
              horizontalSpace(8),
              TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: title.tr(),
              ),
              horizontalSpace(6),
              Text(
                '(${players.length})',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: greyClr,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        verticalSpace(12),

        // Horizontal list of player cards
        SizedBox(
          height: 270.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: players.length,
            itemBuilder: (_, i) => Padding(
              padding: EdgeInsetsDirectional.only(end: 12.w),
              child: PlayerCardWidget(player: players[i]),
            ),
          ),
        ),
        verticalSpace(20),
      ],
    );
  }
}
