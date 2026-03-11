import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falcon/feature/club_team/cubit/club_team_state.dart';
import 'package:falcon/feature/club_team/data/model/player_report_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

void showPlayerReportsSheet(
    BuildContext context, {
      required String playerId,
      required String playerName,
    }) {
  context.read<ClubTeamCubit>().fetchPlayerReports(playerId);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<ClubTeamCubit>(),
      child: PlayerReportsSheet(
        playerId: playerId,
        playerName: playerName,
      ),
    ),
  );
}

class PlayerReportsSheet extends StatelessWidget {
  final String playerId;
  final String playerName;

  const PlayerReportsSheet({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag indicator ──────────────────────────────────────────────
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 16.h),

          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18.w,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bar_chart_rounded,
                        color: Colors.white, size: 22.w),
                    horizontalSpace(8),
                    TextUtils(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      text: 'التقارير السابقة'.tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // ── List ────────────────────────────────────────────────────────
          Flexible(
            child: BlocBuilder<ClubTeamCubit, ClubTeamState>(
              buildWhen: (prev, curr) =>
              curr is playerReportsLoadingState ||
                  curr is playerReportsSuccessState ||
                  curr is playerReportsErrorState,
              builder: (context, state) {
                return state.maybeWhen(
                  playerReportsLoading: () => Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 14.w,
                      ),
                    ),
                  ),
                  playerReportsError: (error) => Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 40.h, horizontal: 20.w),
                    child: Center(
                      child: TextUtils(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        text: error,
                      ),
                    ),
                  ),
                  playerReportsSuccess: (reports) {
                    if (reports.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(
                          child: TextUtils(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            text: 'لا توجد تقارير سابقة'.tr(),
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 4.h),
                      itemCount: reports.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (_, i) =>
                          _ReportItem(report: reports[i]),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),

          // ── "انشاء تقرير رقمي جديد" button — placeholder for now ──────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to create new report screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: mainColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                icon: Icon(Icons.edit_note_rounded,
                    color: mainColor, size: 20.w),
                label: Text(
                  'انشاء تقرير رقمي جديد'.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: mainColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single report row ────────────────────────────────────────────────────────
class _ReportItem extends StatelessWidget {
  final PlayerReport report;

  const _ReportItem({required this.report});

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        report.captainPhoto != null && report.captainPhoto!.isNotEmpty;
    final dateStr =
    DateFormat('dd/MM/yyyy').format(report.date);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          // Expand arrow — left side in RTL
          Icon(Icons.expand_more_rounded,
              color: Colors.white70, size: 20.w),
          horizontalSpace(12),

          // Captain name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  text: report.captainName,
                ),
                verticalSpace(4),
                Text(
                  dateStr,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(12),

          // Captain photo
          ClipOval(
            child: hasPhoto
                ? CachedNetworkImage(
              imageUrl: report.captainPhoto!,
              width: 40.w,
              height: 40.w,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _photoFallback(),
            )
                : _photoFallback(),
          ),
        ],
      ),
    );
  }

  Widget _photoFallback() {
    return Container(
      width: 40.w,
      height: 40.w,
      color: const Color(0xFF31187D),
      child: Center(
        child: Icon(Icons.person, color: Colors.white70, size: 20.w),
      ),
    );
  }
}