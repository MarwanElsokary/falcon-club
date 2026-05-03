import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../digital_report/cubit/digitalReportCubit.dart';
import '../../../digital_report/data/model/digitalReportModel.dart';
import '../../../digital_report/data/repo/digitalReportRepo.dart';
import '../../../digital_report/ui/screens/create_digital_report_screen.dart';

/// يقبل [player] كـ object كامل، أو [playerId] + [playerName] للـ backward compat
void showPlayerReportsSheet(
    BuildContext context, {
      ClubPlayer? player,
      String? playerId,
      String? playerName,
    }) {
  // بنبني ClubPlayer بسيط لو جاء بـ id/name منفردين
  final effectivePlayer = player ??
      ClubPlayer(
        id: playerId ?? '',
        accountNumber: '',
        name: playerName ?? '',
        age: 0,
        gender: '',
        position: '',
        direction: 0,
        foot: '',
        tps: 0,
      );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => DigitalReportCubit(getIt<DigitalReportRepo>())
        ..fetchReports(effectivePlayer.id),
      child: _PlayerReportsSheet(player: effectivePlayer),
    ),
  );
}

class _PlayerReportsSheet extends StatelessWidget {
  final ClubPlayer player;

  const _PlayerReportsSheet({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
      BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ────────────────────────────────────────────────────
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

          // ── Header ────────────────────────────────────────────────────
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
                      child: Icon(Icons.close_rounded,
                          color: Colors.white, size: 18.w),
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
                      text: 'التقارير الرقمية',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // ── List ──────────────────────────────────────────────────────
          Flexible(
            child: BlocBuilder<DigitalReportCubit, DigitalReportState>(
              builder: (context, state) {
                if (state is DigitalReportListLoading) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Center(
                      child: CupertinoActivityIndicator(
                          color: Colors.white, radius: 14.w),
                    ),
                  );
                }
                if (state is DigitalReportListError) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 40.h, horizontal: 20.w),
                    child: Center(
                      child: TextUtils(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        text: state.error,
                      ),
                    ),
                  );
                }
                if (state is DigitalReportListSuccess) {
                  if (state.reports.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.description_outlined,
                                color: Colors.white38, size: 48.w),
                            verticalSpace(12),
                            TextUtils(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white60,
                              text: 'لا توجد تقارير سابقة',
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 4.h),
                    itemCount: state.reports.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, i) =>
                        _ReportItem(report: state.reports[i]),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // ── إنشاء تقرير جديد ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await showCreateDigitalReport(context, player: player);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: mainColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r)),
                ),
                icon: Icon(Icons.edit_note_rounded,
                    color: mainColor, size: 20.w),
                label: Text(
                  'إنشاء تقرير رقمي جديد',
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

// ── Report list item ──────────────────────────────────────────────────────────
class _ReportItem extends StatelessWidget {
  final DigitalReportSummary report;

  const _ReportItem({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          // رقم التقرير
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#${report.id}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          horizontalSpace(12),

          // الاسم + التاريخ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  text: report.name,
                ),
                verticalSpace(4),
                Text(
                  report.date,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Icon(Icons.description_rounded,
              color: Colors.white38, size: 20.w),
        ],
      ),
    );
  }
}

// ── Navigate to create screen ─────────────────────────────────────────────────
Future<bool?> showCreateDigitalReport(BuildContext context,
    {required ClubPlayer player}) {
  return Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) =>
            DigitalReportCubit(getIt<DigitalReportRepo>()),
        child: CreateDigitalReportScreen(player: player),
      ),
      fullscreenDialog: true,
    ),
  );
}