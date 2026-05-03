import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:falconclubapp/feature/club_team/ui/widget/upload_attempt_sheet.dart';
import 'package:falconclubapp/feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/club_exercises_cubit.dart';
import '../../cubit/club_exercises_state.dart';
import '../../data/model/club_exercises_model.dart';
import 'exercise_list_item_widget.dart';
import 'package:falconclubapp/core/di/dependency_injection.dart';

/// يُستدعى هكذا:
/// showAssignExerciseSheet(context, player: player);
void showAssignExerciseSheet(BuildContext context,
    {required ClubPlayer player}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<ClubExercisesCubit>()..fetchExercises(),
        ),
        // ← getIt مباشرة — مش محتاجين ExperianceDetailsCubit في الـ context بتاع الشاشة
        BlocProvider(
          create: (_) => getIt<ExperianceDetailsCubit>(),
        ),
      ],
      child: _AssignExerciseSheet(player: player),
    ),
  );
}

class _AssignExerciseSheet extends StatefulWidget {
  final ClubPlayer player;

  const _AssignExerciseSheet({required this.player});

  @override
  State<_AssignExerciseSheet> createState() => _AssignExerciseSheetState();
}

class _AssignExerciseSheetState extends State<_AssignExerciseSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ClubExercise> _filtered(List<ClubExercise> all) {
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all
        .where((e) =>
    e.title.toLowerCase().contains(q) ||
        e.description.toLowerCase().contains(q) ||
        e.skills.any((s) => s.toLowerCase().contains(q)))
        .toList();
  }

  void _onExerciseTap(BuildContext ctx, ClubExercise ex) {
    // احفظ الـ cubit قبل ما نعمل pop — لأن بعد pop الـ context ممكن يتشال
    final cubit = ctx.read<ExperianceDetailsCubit>();
    Navigator.pop(ctx);
    showUploadAttemptSheet(
      ctx,
      exercise: ex,
      player: widget.player,
      cubit: cubit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: whiteclr,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: Column(
            children: [
              verticalSpace(12),
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: greyClr.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              verticalSpace(16),

              // ── Header ────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    _playerAvatar(),
                    horizontalSpace(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextUtils(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            text: widget.player.name,
                          ),
                          TextUtils(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: greyClr,
                            text: 'اختر تمريناً لرفع فيديو',
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: BoxDecoration(
                          color: greyClr.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: greyClr, size: 18.w),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(16),

              // ── Search ────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    style: TextStyle(fontSize: 13.sp, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن تمرين...',
                      hintStyle: TextStyle(fontSize: 13.sp, color: greyClr),
                      prefixIcon:
                      Icon(Icons.search, color: greyClr, size: 18.w),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ),
              verticalSpace(16),

              // ── List ──────────────────────────────────────────────
              Expanded(
                child: BlocBuilder<ClubExercisesCubit, ClubExercisesState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SizedBox.shrink(),
                      loading: () => Center(
                        child: CupertinoActivityIndicator(
                          radius: 14.w,
                          color: mainColor,
                        ),
                      ),
                      error: (err) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: redClr, size: 40.w),
                            verticalSpace(10),
                            TextUtils(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              text: err,
                            ),
                            verticalSpace(12),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<ClubExercisesCubit>()
                                  .fetchExercises(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: mainColor),
                              child: const Text('إعادة المحاولة',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      success: (model) {
                        final filtered = _filtered(model.data);
                        if (filtered.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off_rounded,
                                    color: greyClr, size: 48.w),
                                verticalSpace(12),
                                TextUtils(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: greyClr,
                                  text: 'لا توجد تمارين مطابقة',
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 20.w)
                              .copyWith(bottom: 40.h),
                          itemCount: filtered.length,
                          itemBuilder: (_, index) {
                            final ex = filtered[index];
                            return ExerciseListItemWidget(
                              exercise: ex,
                              onTap: () => _onExerciseTap(context, ex),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _playerAvatar() {
    final hasPhoto =
        widget.player.photoPath != null && widget.player.photoPath!.isNotEmpty;
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [mainColor, secondMainColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipOval(
        child: hasPhoto
            ? Image.network(
          widget.player.photoPath!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _avatarFallback(),
        )
            : _avatarFallback(),
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        widget.player.name.isNotEmpty ? widget.player.name[0] : '؟',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}