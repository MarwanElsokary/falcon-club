import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/player_attempts_model.dart';
import 'attempt_status_badge.dart';

class AttemptCardWidget extends StatelessWidget {
  final PlayerAttempt attempt;
  final int index;
  final int exerciseId;
  final String playerName;

  const AttemptCardWidget({
    super.key,
    required this.attempt,
    required this.index,
    required this.exerciseId,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoute.playerAttemptDetailScreen,
        arguments: {
          'attempt': attempt,
          'attemptIndex': index,
          'playerName': playerName,
          'exerciseId': exerciseId,
        },
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // ── شريط جانبي ملوّن ─────────────────────────────
                Container(
                  width: 5.w,
                  color: _statusColor,
                ),
                // ── المحتوى ──────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    child: Row(
                      children: [
                        // رقم المحاولة (دائرة)
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: TextUtils(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: mainColor,
                              text: '${index + 1}',
                            ),
                          ),
                        ),
                        horizontalSpace(12),
                        // تفاصيل
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextUtils(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                text: 'محاولة ${index + 1}',
                              ),
                              verticalSpace(4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 12.w,
                                    color: greyClr,
                                  ),
                                  SizedBox(width: 4.w),
                                  TextUtils(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: greyClr,
                                    text: attempt.date ?? '',
                                  ),
                                ],
                              ),
                              verticalSpace(8),
                              AttemptStatusBadge(
                                isProcessed: attempt.isProcessed,
                              ),
                            ],
                          ),
                        ),
                        // سكور لو موجود
                        if (attempt.isProcessed == 1 &&
                            attempt.skills.isNotEmpty)
                          _buildScoreChip(),
                        // سهم
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14.w,
                          color: greyClr,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (attempt.isProcessed) {
      case 0:
        return const Color(0xFFF39C12);
      case 1:
        return const Color(0xFF27AE60);
      case 2:
        return const Color(0xFFE74C3C);
      default:
        return greyClr;
    }
  }

  Widget _buildScoreChip() {
    // متوسط الـ scores
    final avg = attempt.skills.map((s) => s.score).reduce((a, b) => a + b) /
        attempt.skills.length;
    final clamped = avg.clamp(0.0, 10.0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5D2BF4), Color(0xFF31187D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            text: clamped.toStringAsFixed(1),
          ),
          TextUtils(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            text: '/ 10',
          ),
        ],
      ),
    );
  }
}