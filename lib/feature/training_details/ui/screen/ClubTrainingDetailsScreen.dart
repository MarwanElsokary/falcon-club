import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import 'package:falconclubapp/feature/experiance_details_screen/cubit/experiance_details_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../experiance_details_screen/data/model/exerciseWithPlayersModel.dart';
import '../../../training_details/data/model/exercise_details_model.dart';
import '../../../training_details/cubit/training_details_cubit.dart';
import '../../../training_details/cubit/training_details_state.dart';
import '../widget/training_details_cat_widget.dart';
import '../widget/training_expansion_tile_widget.dart';

class ClubTrainingDetailsScreen extends StatefulWidget {
  const ClubTrainingDetailsScreen({super.key});

  @override
  State<ClubTrainingDetailsScreen> createState() =>
      _ClubTrainingDetailsScreenState();
}

class _ClubTrainingDetailsScreenState extends State<ClubTrainingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final exerciseId = context.read<TrainingDetailsCubit>().currentExerciseId;
    if (exerciseId != null) {
      context.read<ExperianceDetailsCubit>().fetchExercisePlayers(
        exerciseId: exerciseId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: BlocBuilder<TrainingDetailsCubit, TrainingDetailsState>(
        buildWhen: (prev, curr) =>
            curr is exerciseDetailsLoading ||
            curr is exerciseDetailsSuccess ||
            curr is exerciseDetailsError,
        builder: (context, state) {
          return state.maybeWhen(
            exerciseDetailssuccess: (exerciseDetails) =>
                _buildContent(context, exerciseDetails),
            orElse: () => _buildLoading(),
          );
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

  Widget _buildContent(
    BuildContext context,
    ExerciseDetailsModel exerciseDetails,
  ) {
    return Stack(
      children: [
        SizedBox(
          width: context.displayWidth,
          height: context.displayHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildExerciseImage(exerciseDetails),
                Container(
                  height: 10.h,
                  width: context.displayWidth,
                  color: mainColor,
                ),
                _buildInfoSection(context, exerciseDetails),
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

  Widget _buildExerciseImage(ExerciseDetailsModel exerciseDetails) {
    return SizedBox(
      width: context.displayWidth,
      height: 320.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: exerciseDetails.data.photoPath ?? '',
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
              text: exerciseDetails.data.title ?? '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    ExerciseDetailsModel exerciseDetails,
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
              text: exerciseDetails.data.title ?? '',
            ),
            verticalSpace(7),
            TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: blackclr,
              text: exerciseDetails.data.description ?? '',
            ),
            verticalSpace(15),
            TrainingDetailsCatWidget(skills: exerciseDetails.data.skills),
            verticalSpace(15),
            TrainingExpansionTileWidget(exerciseDetails: exerciseDetails),
            verticalSpace(20),
            _buildPlayersSection(context),
            verticalSpace(100),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersSection(BuildContext context) {
    final exerciseId =
        context.read<TrainingDetailsCubit>().currentExerciseId ?? '';

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
        BlocBuilder<ExperianceDetailsCubit, ExperianceDetailsState>(
          buildWhen: (prev, curr) =>
              (curr is exercisePlayersLoading &&
                  curr.exerciseId == exerciseId) ||
              (curr is exercisePlayersSuccess &&
                  curr.exerciseId == exerciseId) ||
              (curr is exercisePlayersError && curr.exerciseId == exerciseId),
          builder: (context, state) {
            final cached = context
                .read<ExperianceDetailsCubit>()
                .getCachedExercisePlayers(exerciseId);
            if (cached != null) {
              return _buildPlayersList(
                context,
                cached.data.players,
                exerciseId,
              );
            }
            if (state is exercisePlayersLoading &&
                state.exerciseId == exerciseId) {
              return _buildSkeleton();
            }
            if (state is exercisePlayersSuccess &&
                state.exerciseId == exerciseId) {
              return _buildPlayersList(
                context,
                state.data.data.players,
                exerciseId,
              );
            }
            if (state is exercisePlayersError &&
                state.exerciseId == exerciseId) {
              return _buildError(context, exerciseId);
            }
            return _buildSkeleton();
          },
        ),
      ],
    );
  }

  Widget _buildPlayersList(
    BuildContext context,
    List<ExercisePlayer> players,
    String exerciseId,
  ) {
    if (players.isEmpty) {
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: players.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: _PlayerRow(player: players[index], exerciseId: exerciseId),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 4,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Container(
            height: 64.h,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String exerciseId) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: redClr.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: redClr,
            text: 'تعذّر تحميل اللاعبين',
          ),
          verticalSpace(8),
          ElevatedButton(
            onPressed: () => context
                .read<ExperianceDetailsCubit>()
                .fetchExercisePlayers(exerciseId: exerciseId),
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

// ── صف اللاعب ────────────────────────────────────────────────────────
class _PlayerRow extends StatelessWidget {
  const _PlayerRow({required this.player, required this.exerciseId});

  final ExercisePlayer player;
  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = player.photo != null && player.photo.toString().isNotEmpty;

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
                          imageUrl: player.photo.toString(),
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
                      'exerciseId': int.tryParse(exerciseId) ?? 0,
                      'playerId': player.id.toString(),
                      'playerName': player.name.toString(),
                      'playerPhoto': player.photo?.toString(),
                      'totalAttempts': player.attemptCount ?? 0,
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
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  text: player.name.toString(),
                  maxlines: 1,
                ),
                verticalSpace(3),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoute.playerAttemptsScreen,
                    arguments: {
                      'exerciseId': int.tryParse(exerciseId) ?? 0,
                      'playerId': player.id.toString(),
                      'playerName': player.name.toString(),
                      'playerPhoto': player.photo?.toString(),
                      'totalAttempts': player.attemptCount ?? 0,
                    },
                  ),
                  child: Row(
                    children: [
                      TextUtils(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: mainColor,
                        text: 'المحاولات: ${player.attemptCount}',
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
          GestureDetector(
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
          ),
        ],
      ),
    );
  }

  Widget _fallback() {
    final name = player.name.toString();
    return Container(
      color: mainColor.withOpacity(0.2),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0] : '؟',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _showAddAttemptSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<ExperianceDetailsCubit>(),
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

  Future<void> _uploadVideo(String path) async {
    setState(() {
      _isUploading = true;
      _progress = 0;
    });
    await context.read<ExperianceDetailsCubit>().addAttemptForPlayer(
      playerId: widget.player.id.toString(),
      exerciseId: widget.exerciseId,
      videoPath: path,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        widget.player.photo != null &&
        widget.player.photo.toString().isNotEmpty;

    return BlocListener<ExperianceDetailsCubit, ExperianceDetailsState>(
      listener: (context, state) {
        if (state is clubAddAttemptSuccess) {
          Navigator.pop(context);
          // أعد تحميل اللاعبين عشان يتحدث العداد
          context.read<ExperianceDetailsCubit>().fetchExercisePlayers(
            exerciseId: widget.exerciseId,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: greenClr,
              content: const Text(
                'تمت إضافة المحاولة بنجاح ✓',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        if (state is clubAddAttemptError) {
          setState(() => _isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: redClr,
              content: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        if (state is clubAddAttemptProgress) {
          setState(() => _progress = state.progress);
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
                            imageUrl: widget.player.photo.toString(),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: mainColor.withOpacity(0.2),
                            alignment: Alignment.center,
                            child: Text(
                              widget.player.name.toString().isNotEmpty
                                  ? widget.player.name.toString()[0]
                                  : '؟',
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
                        text: widget.player.name.toString(),
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
