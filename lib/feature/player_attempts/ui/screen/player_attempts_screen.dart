import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../cubit/player_attempts_cubit.dart';
import '../../cubit/player_attempts_state.dart';
import '../widget/attempt_card_widget.dart';
import '../widget/attempt_status_badge.dart';

class PlayerAttemptsScreen extends StatefulWidget {
  final int exerciseId;
  final String playerId;
  final String playerName;
  final String? playerPhoto;
  final int totalAttempts;

  const PlayerAttemptsScreen({
    super.key,
    required this.exerciseId,
    required this.playerId,
    required this.playerName,
    this.playerPhoto,
    required this.totalAttempts,
  });

  @override
  State<PlayerAttemptsScreen> createState() => _PlayerAttemptsScreenState();
}

class _PlayerAttemptsScreenState extends State<PlayerAttemptsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlayerAttemptsCubit>().fetchPlayerAttempts(
      exerciseId: widget.exerciseId,
      playerId: widget.playerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteclr,
      body: Stack(
        children: [
          // ── خلفية SVG ─────────────────────────────────────────────
          PositionedDirectional(
            start: 0,
            top: 0,
            child: SvgPicture.asset('assets/svgs/Group 386.svg', width: 120.w),
          ),
          // ── محتوى ──────────────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildPlayerInfo(),
                verticalSpace(8),
                _buildSummaryRow(),
                verticalSpace(12),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: mainColor,
                size: 16.w,
              ),
            ),
          ),
          horizontalSpace(12),
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: 'محاولات اللاعب',
          ),
        ],
      ),
    );
  }

  // ── بطاقة اللاعب ────────────────────────────────────────────────────────────
  Widget _buildPlayerInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [mainColor, secondMainColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.w),
              color: Colors.white.withOpacity(0.2),
            ),
            child: ClipOval(
              child: widget.playerPhoto != null &&
                  widget.playerPhoto!.isNotEmpty
                  ? Image.network(
                widget.playerPhoto!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _photoFallback(),
              )
                  : _photoFallback(),
            ),
          ),
          horizontalSpace(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  text: widget.playerName,
                ),
                verticalSpace(4),
                TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  text: 'عدد المحاولات: ${widget.totalAttempts}',
                ),
              ],
            ),
          ),
          // أيقونة
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.sports_soccer_rounded,
              color: Colors.white,
              size: 22.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoFallback() {
    return Container(
      color: Colors.white.withOpacity(0.2),
      alignment: Alignment.center,
      child: Text(
        widget.playerName.isNotEmpty ? widget.playerName[0] : '؟',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── ملخص الحالات ─────────────────────────────────────────────────────────
  Widget _buildSummaryRow() {
    return BlocBuilder<PlayerAttemptsCubit, PlayerAttemptsState>(
      builder: (context, state) {
        return state.maybeWhen(
          success: (model) {
            final total = model.data.length;
            final done = model.data.where((a) => a.isProcessed == 1).length;
            final pending = model.data.where((a) => a.isProcessed == 0).length;
            final rejected = model.data.where((a) => a.isProcessed == 2).length;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  _summaryChip('$total', 'الكل', mainColor),
                  horizontalSpace(8),
                  _summaryChip('$done', 'مكتمل', const Color(0xFF27AE60)),
                  horizontalSpace(8),
                  _summaryChip('$pending', 'قيد المراجعة', const Color(0xFFF39C12)),
                  horizontalSpace(8),
                  _summaryChip('$rejected', 'مرفوض', const Color(0xFFE74C3C)),
                ],
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _summaryChip(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            TextUtils(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
              text: count,
            ),
            TextUtils(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.8),
              text: label,
            ),
          ],
        ),
      ),
    );
  }

  // ── الـ body (loading / error / list) ──────────────────────────────────────
  Widget _buildBody() {
    return BlocBuilder<PlayerAttemptsCubit, PlayerAttemptsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => Center(
            child: CupertinoActivityIndicator(radius: 15.w, color: mainColor),
          ),
          error: (err) => _buildError(err),
          success: (model) {
            if (model.data.isEmpty) {
              return _buildEmpty();
            }
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 100.h, top: 4.h),
              itemCount: model.data.length,
              itemBuilder: (context, index) {
                return AttemptCardWidget(
                  attempt: model.data[index],
                  index: index,
                  exerciseId: widget.exerciseId,
                  playerName: widget.playerName,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, color: greyClr, size: 60.w),
          verticalSpace(16),
          TextUtils(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: greyClr,
            text: 'لا توجد محاولات بعد',
          ),
        ],
      ),
    );
  }

  Widget _buildError(String err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: redClr, size: 48.w),
          verticalSpace(12),
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            text: err,
          ),
          verticalSpace(16),
          ElevatedButton(
            onPressed: () => context
                .read<PlayerAttemptsCubit>()
                .fetchPlayerAttempts(
              exerciseId: widget.exerciseId,
              playerId: widget.playerId,
            ),
            style: ElevatedButton.styleFrom(backgroundColor: mainColor),
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}