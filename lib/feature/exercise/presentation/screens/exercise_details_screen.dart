import 'package:falconclubapp/feature/exercise/presentation/widgets/exercise_players_paywall.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/widget/showSuccesSnackBar.dart';
import 'package:falconclubapp/core/widget/show_error_snack_bar.dart';
import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_capability.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/attempt_upload_cubit.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/attempt_upload_state.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/exercise_details_cubit.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/exercise_details_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../domain/entities/exercise_details.dart';
import '../../domain/entities/exercise_player.dart';
import '../widgets/exercise_skills_widget.dart';
import '../widgets/exercise_equipment_instructions_widget.dart';

/// The exercise details screen — one screen for every role.
///
/// This is the merge of the old `ClubTrainingDetailsScreen` and
/// `ScoutTrainingDetailsScreen`, which were ~95% identical: same hero image,
/// same white info sheet, same skills/equipment/instructions, same players
/// roster. The only real difference was what a player row let you do (upload vs
/// view) and whether the roster was paywalled — and that is exactly what
/// [ExerciseCapability] models.
///
/// The screen contains **no role check**. It receives an [ExerciseCapability],
/// resolved once at the route from the current viewer, and drives the UI from
/// `capability.rowAction` and `capability.isPaywalled`. That also closes the
/// routing hole permanently: every entry point now lands here, and the viewer's
/// capability — not which route was taken — decides what they can do.
class ExerciseDetailsScreen extends StatefulWidget {
  const ExerciseDetailsScreen({super.key, required this.capability});

  final ExerciseCapability capability;

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: BlocBuilder<ExerciseDetailsCubit, ExerciseDetailsState>(
        builder: (context, state) => switch (state) {
          ExerciseDetailsLoaded(:final ExerciseDetails details) =>
            _buildContent(context, details),
          // A failure used to fall through to the spinner, so a failed details
          // fetch span forever with no way to tell it had failed.
          ExerciseDetailsFailure(:final String message) => _buildError(message),
          _ => _buildLoading(),
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Stack(
      children: [
        const Center(child: CupertinoActivityIndicator(color: Colors.white)),
        PositionedDirectional(
          child: SafeArea(child: BackButton(color: Colors.white)),
        ),
      ],
    );
  }

  /// Keeps the back button reachable — the failure state previously rendered
  /// the spinner, leaving the screen stuck with no way to know what happened.
  Widget _buildError(String message) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: CenterTextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              maxlines: 4,
              text: message,
            ),
          ),
        ),
        PositionedDirectional(
          child: SafeArea(child: BackButton(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ExerciseDetails details,
  ) {
    return Stack(
      children: [
        SizedBox(
          width: context.displayWidth,
          height: context.displayHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildExerciseImage(details),
                Container(
                  height: 10.h,
                  width: context.displayWidth,
                  color: mainColor,
                ),
                _buildInfoSection(context, details),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          child: SafeArea(child: BackButton(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildExerciseImage(ExerciseDetails details) {
    return SizedBox(
      width: context.displayWidth,
      height: 320.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: details.photoUrl ?? '',
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Skeletonizer(enabled: true, child: Container(color: mainColor)),
            errorWidget: (_, __, ___) => Container(
              color: mainColor,
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/unavailabeImage.svg',
                  width: 60.w,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, mainColor.withOpacity(0.7)],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 16.h,
            start: 16.w,
            end: 16.w,
            child: TextUtils(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              text: details.title,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    ExerciseDetails details,
  ) {
    return Container(
      color: mainColor,
      child: Container(
        width: context.displayWidth,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(25.r),
            topEnd: Radius.circular(25.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(7),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 80.w,
                height: 5.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: greyClr.withOpacity(0.5),
                ),
              ),
            ),
            verticalSpace(12),
            TextUtils(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: details.title,
            ),
            verticalSpace(7),
            TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: blackclr,
              text: details.description ?? '',
            ),
            verticalSpace(15),
            ExerciseSkillsWidget(skills: details.skillNames),
            verticalSpace(15),
            ExerciseEquipmentInstructionsWidget(
              equipment: details.equipment,
              instructions: details.playerInstructions,
            ),
            verticalSpace(20),
            _buildPlayersSection(context, details),
            verticalSpace(100),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersSection(BuildContext context, ExerciseDetails details) {
    // The roster arrives inside the same ExerciseDetails as the rest of the
    // screen — one fetch, not two — so there is no separate loading/error state
    // to reconcile here. This section only renders once details have loaded.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people_alt_rounded, color: mainColor, size: 20.w),
            horizontalSpace(8),
            TextUtils(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: 'اللاعبين',
            ),
          ],
        ),
        verticalSpace(12),
        _buildPlayersList(context, details.players, details.id),
      ],
    );
  }

  Widget _buildPlayersList(
    BuildContext context,
    List<ExercisePlayer> players,
    String exerciseId,
  ) {
    // The injected capability decides — not the screen, and not a service
    // locator reached from inside a widget.
    final bool isPaywalled = widget.capability.isPaywalled;

    if (players.isEmpty) {
      // For a paywalled viewer an empty roster is indistinguishable from a
      // hidden one, so claiming "لا يوجد لاعبون بعد" would be asserting
      // something we cannot know. Prompt instead.
      if (isPaywalled) return const ExercisePlayersPaywall();

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: mainColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Icon(Icons.people_outline, color: greyClr, size: 40.w),
            verticalSpace(8),
            TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: greyClr,
              text: 'لا يوجد لاعبون بعد',
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: players.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _PlayerRow(
              player: players[index],
              exerciseId: exerciseId,
              capability: widget.capability,
            ),
          ),
        ),
        // A Club is never paywalled, so this is inert for them — the capability
        // decides, not the screen you happen to be on.
        if (isPaywalled) ...[verticalSpace(10), const ExercisePlayersPaywall()],
        verticalSpace(20),
      ],
    );
  }

}

// ── صف اللاعب ────────────────────────────────────────────────────────
class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.player,
    required this.exerciseId,
    required this.capability,
  });

  final ExercisePlayer player;
  final String exerciseId;
  final ExerciseCapability capability;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = player.hasPhoto;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: mainColor.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mainColor, width: 2),
                ),
                child: ClipOval(
                  child: hasPhoto
                      ? CachedNetworkImage(
                          imageUrl: player.photoUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: mainColor.withOpacity(0.2)),
                          errorWidget: (_, __, ___) => _fallback(),
                        )
                      : _fallback(),
                ),
              ),
              PositionedDirectional(
                bottom: 0,
                end: 0,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoute.playerAttemptsScreen,
                    arguments: {
                      'exerciseId': exerciseId,
                      'playerId': player.id,
                      'playerName': player.name,
                      'playerPhoto': player.photoUrl,
                      'totalAttempts': player.attemptCount,
                    },
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: greenClr,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${player.attemptCount}',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // No maxLines: a long name wraps to a second line and the row
                // grows taller, rather than being clipped with an ellipsis or
                // pushing the "المحاولات: N" count out of view.
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  text: player.name,
                ),
                verticalSpace(3),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoute.playerAttemptsScreen,
                    arguments: {
                      'exerciseId': exerciseId,
                      'playerId': player.id,
                      'playerName': player.name,
                      'playerPhoto': player.photoUrl,
                      'totalAttempts': player.attemptCount,
                    },
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextUtils(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: mainColor,
                          text: 'المحاولات: ${player.attemptCount}',
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10.w,
                        color: mainColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          // Exhaustive over the sealed action, so a role added later cannot
          // quietly fall through to "upload" — it becomes a compile error here.
          switch (capability.rowAction) {
            UploadAttemptAction() => _uploadButton(context),
            ViewAttemptsAction() => _viewAttemptsButton(context),
          },
        ],
      ),
    );
  }

  /// Club/coach only.
  Widget _uploadButton(BuildContext context) => GestureDetector(
    onTap: () => _showAddAttemptSheet(context),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, color: Colors.white, size: 14.w),
          horizontalSpace(4),
          Text(
            'محاولة',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );

  /// What a Scout (or MainClub) gets instead: the same read-only "مشاهدة" action
  /// `ScoutPlayersSection` already offers, so the two paths agree.
  Widget _viewAttemptsButton(BuildContext context) => GestureDetector(
    onTap: () => _openAttempts(context),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.visibility_outlined, color: mainColor, size: 14.w),
          horizontalSpace(4),
          Text(
            'مشاهدة',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: mainColor,
            ),
          ),
        ],
      ),
    ),
  );

  void _openAttempts(BuildContext context) => Navigator.of(context).pushNamed(
    AppRoute.playerAttemptsScreen,
    // exerciseId is passed as a String — the route casts `args['exerciseId'] as
    // String`. The other two nav sites (the badge and the name taps) already do.
    // This one lagged behind as an int, so tapping "مشاهدة" (Scout/MainClub's
    // view-attempts action) crashed on the cast.
    arguments: {
      'exerciseId': exerciseId,
      'playerId': player.id,
      'playerName': player.name,
      'playerPhoto': player.photoUrl,
      'totalAttempts': player.attemptCount,
    },
  );

  Widget _fallback() {
    return Container(
      color: mainColor.withOpacity(0.2),
      alignment: Alignment.center,
      child: Text(
        player.initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _showAddAttemptSheet(BuildContext context) {
    // Two cubits, two jobs. `AttemptUploadCubit` runs the upload; the screen's
    // `ExerciseDetailsCubit` owns the exercise (details + roster) and is reloaded
    // once the upload succeeds — the attempt count on the row has just changed,
    // and the upload has already invalidated the cached details.
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ExerciseDetailsCubit>()),
          BlocProvider(create: (_) => getIt<AttemptUploadCubit>()),
        ],
        child: _AddAttemptSheet(player: player, exerciseId: exerciseId),
      ),
    );
  }
}

// ── Bottom Sheet إضافة محاولة ─────────────────────────────────────────
class _AddAttemptSheet extends StatefulWidget {
  const _AddAttemptSheet({required this.player, required this.exerciseId});

  final ExercisePlayer player;
  final String exerciseId;

  @override
  State<_AddAttemptSheet> createState() => _AddAttemptSheetState();
}

class _AddAttemptSheetState extends State<_AddAttemptSheet> {
  File? _selectedVideo;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  int _progress = 0;

  Future<void> _pickVideo(ImageSource source) async {
    final XFile? video = await _picker.pickVideo(source: source);
    if (video == null) return;
    setState(() => _selectedVideo = File(video.path));
    _uploadVideo(video.path);
  }

  void _uploadVideo(String path) {
    setState(() {
      _isUploading = true;
      _progress = 0;
    });
    // No try/catch: the cubit never throws. Every outcome — the domain's Scout
    // ban, a blank path, a transport error, success — arrives as a state below.
    context.read<AttemptUploadCubit>().uploadAttempt(
      playerId: widget.player.id,
      exerciseId: widget.exerciseId,
      videoPath: path,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = widget.player.hasPhoto;

    return BlocListener<AttemptUploadCubit, AttemptUploadState>(
      listener: (context, state) {
        // The app's shared snackbars, not a hand-rolled ScaffoldMessenger call.
        // This screen and `upload_attempt_sheet` each built their own SnackBar
        // with their own colours and shape, so the same upload reported success
        // two different ways depending on which sheet you opened it from.
        switch (state) {
          case AttemptUploadSuccess():
            Navigator.pop(context);
            // Reload the exercise so the attempt count on the row updates. The
            // upload already invalidated the cached details, so this refetches
            // fresh — no manual cache eviction, no separate roster cubit.
            context.read<ExerciseDetailsCubit>().reload(widget.exerciseId);
            showSuccesSnackBar(
              context: context,
              title: 'تمت إضافة المحاولة بنجاح'.tr(),
            );
          case AttemptUploadFailure(:final String message):
            setState(() => _isUploading = false);
            showErrorSnackBar(context: context, title: message);
          case AttemptUploadInProgress(:final int percent):
            setState(() => _progress = percent);
          case AttemptUploadIdle():
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.only(
          top: 20.h,
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
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

            // معلومات اللاعب
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: mainColor, width: 2),
                  ),
                  child: ClipOval(
                    child: hasPhoto
                        ? CachedNetworkImage(
                            imageUrl: widget.player.photoUrl ?? '',
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: mainColor.withOpacity(0.2),
                            alignment: Alignment.center,
                            child: Text(
                              widget.player.initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUtils(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        text: widget.player.name,
                      ),
                      TextUtils(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: greyClr,
                        text: 'المحاولات: ${widget.player.attemptCount}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            verticalSpace(20),

            // لو بيرفع — Progress
            if (_isUploading) ...[
              LinearProgressIndicator(
                value: _progress / 100,
                backgroundColor: greyClr.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                minHeight: 8.h,
                borderRadius: BorderRadius.circular(10.r),
              ),
              verticalSpace(8),
              CenterTextUtils(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: mainColor,
                text: 'جاري الرفع... $_progress%',
              ),
              verticalSpace(16),
            ],

            // لو فيديو اتختار
            if (_selectedVideo != null && !_isUploading)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.videocam, color: mainColor, size: 20.w),
                    horizontalSpace(8),
                    Expanded(
                      child: Text(
                        _selectedVideo!.path.split('/').last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // أزرار الاختيار
            if (!_isUploading) ...[
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickVideo(ImageSource.camera),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18.w,
                            ),
                            horizontalSpace(6),
                            Text(
                              'كاميرا',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickVideo(ImageSource.gallery),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: blueClr.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: blueClr.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library,
                              color: blueClr,
                              size: 18.w,
                            ),
                            horizontalSpace(6),
                            Text(
                              'المعرض',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: blueClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
