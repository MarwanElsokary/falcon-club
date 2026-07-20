import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/show_confirm_dialog.dart';
import 'package:falconclubapp/core/widget/show_error_snack_bar.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../digital_report/cubit/digitalReportCubit.dart';
import '../../../digital_report/data/repo/digitalReportRepo.dart';
import '../../../digital_report/domain/entities/digital_report.dart';
import '../../../digital_report/domain/entities/report_document.dart';
import '../../../digital_report/presentation/cubit/player_reports_cubit.dart';
import '../../../digital_report/presentation/cubit/player_reports_state.dart';
import '../../../digital_report/ui/screens/create_digital_report_screen.dart';

/// يقبل [player] كـ object كامل، أو [playerId] + [playerName] للـ backward compat
void showPlayerReportsSheet(
  BuildContext context, {
  ClubPlayer? player,
  String? playerId,
  String? playerName,
}) {
  // بنبني ClubPlayer بسيط لو جاء بـ id/name منفردين
  final effectivePlayer =
      player ??
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
      create: (_) => getIt<PlayerReportsCubit>()..load(effectivePlayer.id),
      child: _PlayerReportsSheet(player: effectivePlayer),
    ),
  );
}

class _PlayerReportsSheet extends StatelessWidget {
  final ClubPlayer player;

  const _PlayerReportsSheet({required this.player});

  /// Writes the PDF next to the app's other temporary files and hands it to the
  /// platform share sheet — the same route the reels download already takes,
  /// and the reason no storage permission is needed.
  Future<void> _saveAndShare(
    BuildContext context,
    ReportDocument document,
  ) async {
    try {
      final Directory directory = await getTemporaryDirectory();
      final File file = File('${directory.path}/${document.fileName}');
      await file.writeAsBytes(document.bytes, flush: true);

      await Share.shareXFiles(<XFile>[
        XFile(file.path, mimeType: 'application/pdf'),
      ], subject: document.fileName);
    } catch (_) {
      if (!context.mounted) return;
      showErrorSnackBar(
        context: context,
        title: 'تعذّر حفظ الملف'.tr(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerReportsCubit, PlayerReportsState>(
      listenWhen: (PlayerReportsState previous, PlayerReportsState current) =>
          current.readyDocument != null || current.actionError != null,
      listener: (BuildContext context, PlayerReportsState state) async {
        final PlayerReportsCubit cubit = context.read<PlayerReportsCubit>();

        final ReportDocument? document = state.readyDocument;
        if (document != null) {
          cubit.consumeDocument();
          await _saveAndShare(context, document);
          return;
        }

        final String? error = state.actionError;
        if (error != null) {
          cubit.consumeActionError();
          showErrorSnackBar(context: context, title: error);
        }
      },
      child: Container(
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
                      Icon(
                        Icons.bar_chart_rounded,
                        color: Colors.white,
                        size: 22.w,
                      ),
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
              child: BlocBuilder<PlayerReportsCubit, PlayerReportsState>(
                builder: (BuildContext context, PlayerReportsState state) {
                  // Only a first load blanks the list; a refresh after a delete
                  // keeps the remaining rows on screen.
                  if (state.status == PlayerReportsStatus.loading &&
                      state.reports.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: Colors.white,
                          radius: 14.w,
                        ),
                      ),
                    );
                  }

                  if (state.status == PlayerReportsStatus.failure) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40.h,
                        horizontal: 20.w,
                      ),
                      child: Center(
                        child: TextUtils(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                          text: state.errorMessage ?? 'حدث خطأ ما'.tr(),
                        ),
                      ),
                    );
                  }

                  if (state.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: Colors.white38,
                              size: 48.w,
                            ),
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
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    itemCount: state.reports.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, int i) => _ReportItem(
                      report: state.reports[i],
                      isBusy: state.isBusy(state.reports[i].id),
                    ),
                  );
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
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  icon: Icon(
                    Icons.edit_note_rounded,
                    color: mainColor,
                    size: 20.w,
                  ),
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
      ),
    );
  }
}

// ── Report list item ──────────────────────────────────────────────────────────
class _ReportItem extends StatelessWidget {
  final DigitalReport report;
  final bool isBusy;

  const _ReportItem({required this.report, required this.isBusy});

  void _confirmDelete(BuildContext context) {
    // Captured before the dialog: `onConfirm` runs after this context is gone.
    final PlayerReportsCubit cubit = context.read<PlayerReportsCubit>();
    showConfirmDialog(
      context: context,
      isDestructive: true,
      title: 'هل تريد حذف تقرير ${report.displayDate}؟'.tr(),
      onConfirm: () => cubit.delete(report),
    );
  }

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
          // التاريخ + كاتب التقرير.
          //
          // `start` follows the locale, so this reads from the right in Arabic;
          // the previous `end` pinned it to the left. The id is deliberately
          // absent — it identifies the row to the server, not to the user.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  text: report.displayDate,
                ),
                verticalSpace(4),
                // The API's `name` is the coach who wrote the report, not the
                // player it is about — unlabelled it just looked like the
                // player's own name repeated on every row.
                TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white60,
                  text: '${'بواسطة'.tr()}: ${report.playerName}',
                  maxlines: 1,
                ),
              ],
            ),
          ),
          horizontalSpace(8),

          if (isBusy)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 10.w,
              ),
            )
          else ...[
            _RowAction(
              icon: Icons.download_rounded,
              color: Colors.white,
              tooltip: 'تحميل'.tr(),
              onTap: () => context.read<PlayerReportsCubit>().download(report),
            ),
            horizontalSpace(8),
            _RowAction(
              icon: Icons.delete_outline_rounded,
              color: redClr,
              tooltip: 'حذف'.tr(),
              onTap: () => _confirmDelete(context),
            ),
          ],
        ],
      ),
    );
  }
}

/// A round icon button sized to sit inside a report row — the same translucent
/// treatment the sheet's close button uses.
class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.18),
          ),
          child: Center(child: Icon(icon, color: color, size: 17.w)),
        ),
      ),
    );
  }
}

// ── Navigate to create screen ─────────────────────────────────────────────────
Future<bool?> showCreateDigitalReport(
  BuildContext context, {
  required ClubPlayer player,
}) {
  return Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => DigitalReportCubit(getIt<DigitalReportRepo>()),
        child: CreateDigitalReportScreen(player: player),
      ),
      fullscreenDialog: true,
    ),
  );
}
