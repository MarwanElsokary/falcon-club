import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/domain/entities/attempt.dart';
import '../widget/ai_loading_widget.dart';
import '../widget/ai_score/ai_score_widget.dart';
import '../widget/ai_video_widget.dart';
import '../widget/attempt_status_badge.dart';
import '../widget/last_attempt_app_bar_widget.dart';
import '../widget/reject_reason_widget.dart';

class PlayerAttemptDetailScreen extends StatelessWidget {
  final Attempt attempt;
  final int attemptIndex;
  final String playerName;

  const PlayerAttemptDetailScreen({
    super.key,
    required this.attempt,
    required this.attemptIndex,
    required this.playerName,
  });

  /// The URL to play: the AI-annotated render once analysis exists, otherwise the
  /// raw upload. Both are already resolved to absolute URLs by the data layer;
  /// `null` means there is nothing playable (see [_buildVideoCard]).
  String? get _videoUrl =>
      attempt.hasAnalysis ? attempt.aiVideoUrl : attempt.videoUrl;

  @override
  Widget build(BuildContext context) {
    final bool isProcessed = attempt.status == AttemptStatus.completed;
    final bool isPending = attempt.status == AttemptStatus.underReview;
    final bool isRejected = attempt.status == AttemptStatus.rejected;
    final bool hasSkills = attempt.skills.isNotEmpty;

    return Scaffold(
      appBar: lastAttemptAppBar(
        context: context,
        title: 'محاولة ${attemptIndex + 1}',
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          // ── بطاقة اللاعب + رقم المحاولة ─────────────────────────
          _buildTopCard(context),
          // ── التفاصيل ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                children: [
                  verticalSpace(20),

                  // Score / Loading / no skills
                  if (isProcessed && hasSkills)
                    AiScoreWidget(skill: attempt.skills)
                  else if (isProcessed && !hasSkills)
                    _buildNoSkillsWidget()
                  else if (isPending)
                    const AiLoadingWidget(),

                  verticalSpace(20),

                  // الفيديو
                  _buildVideoCard(context, isProcessed, isRejected),

                  verticalSpace(16),

                  // سبب الرفض
                  if (isRejected)
                    RejectReasonWidget(
                      rejectedReason: attempt.rejectionReason ?? '',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15.w, 8.h, 15.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // رقم
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                text: '${attemptIndex + 1}',
              ),
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  text: playerName,
                ),
                verticalSpace(4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.white70,
                      size: 12.w,
                    ),
                    SizedBox(width: 4.w),
                    TextUtils(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      text: attempt.submittedLabel ?? '',
                    ),
                  ],
                ),
              ],
            ),
          ),
          AttemptStatusBadge(status: attempt.status),
        ],
      ),
    );
  }

  Widget _buildVideoCard(
    BuildContext context,
    bool isProcessed,
    bool isRejected,
  ) {
    return Container(
      width: context.displayWidth,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/svgs/mingcute_ai-fill.svg', width: 20.w),
              horizontalSpace(10),
              Expanded(
                child: TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: mainColor,
                  text: isProcessed
                      ? 'تحليل المدرب الذكي'
                      : isRejected
                      ? 'تمت المراجعة'
                      : 'جاري المراجعة',
                ),
              ),
            ],
          ),
          verticalSpace(15),
          // Guard: a null/empty URL means there is nothing to play. Show a clear
          // state instead of handing an empty string to the player, which would
          // sit on its loading spinner forever — the old failure mode when the
          // relative aiVideo path never resolved.
          if (_videoUrl != null && _videoUrl!.isNotEmpty)
            AiVideoWidget(videoUrl: _videoUrl!)
          else
            _buildNoVideoWidget(),
          verticalSpace(10),
        ],
      ),
    );
  }

  Widget _buildNoVideoWidget() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: greyClr.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off_rounded, size: 40.w, color: greyClr),
          verticalSpace(8),
          TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: greyClr,
            text: 'لا يوجد فيديو متاح',
          ),
        ],
      ),
    );
  }

  Widget _buildNoSkillsWidget() {
    return Container(
      height: 160.w,
      width: 160.w,
      margin: EdgeInsets.symmetric(vertical: 20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 36.w, color: Colors.white),
          verticalSpace(12),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
