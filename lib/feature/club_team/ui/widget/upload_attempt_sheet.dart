import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/club_exercises_model.dart';

void showUploadAttemptSheet(
  BuildContext context, {
  required ClubExercise exercise,
  required ClubPlayer player,
  required Future<void> Function(String videoPath) onUpload, // ✅ argument واحد
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _UploadAttemptSheet(
      exercise: exercise,
      player: player,
      onUpload: onUpload, // ✅ argument واحد
    ),
  );
}

class _UploadAttemptSheet extends StatefulWidget {
  final ClubExercise exercise;
  final ClubPlayer player;
  final Future<void> Function(String videoPath) onUpload;

  const _UploadAttemptSheet({
    required this.exercise,
    required this.player,
    required this.onUpload,
  });

  @override
  State<_UploadAttemptSheet> createState() => _UploadAttemptSheetState();
}

class _UploadAttemptSheetState extends State<_UploadAttemptSheet> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedVideo;
  bool _isUploading = false;
  int _progress = 0;

  Future<void> _pickVideo(ImageSource source) async {
    final XFile? video = await _picker.pickVideo(source: source);
    if (video == null) return;
    if (!mounted) return;

    setState(() {
      _selectedVideo = File(video.path);
      _isUploading = true;
      _progress = 0;
    });

    try {
      await widget.onUpload(video.path); // ✅ argument واحد بس
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: greenClr,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.w),
              SizedBox(width: 8.w),
              const Text(
                'تمت إضافة المحاولة بنجاح ✓',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: redClr,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Text(
            e.toString().replaceAll('Exception: ', ''),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      padding: EdgeInsets.only(
        top: 16.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ────────────────────────────────────────────
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

          // ── Exercise header ───────────────────────────────────
          _buildExerciseHeader(),
          verticalSpace(16),

          Divider(color: greyClr.withOpacity(0.15), height: 1),
          verticalSpace(16),

          // ── Player row ────────────────────────────────────────
          _buildPlayerRow(),
          verticalSpace(24),

          // ── Progress / Buttons ────────────────────────────────
          if (_isUploading)
            _buildProgress()
          else ...[
            if (_selectedVideo != null) _buildSelectedFile(),
            _buildActionButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildExerciseHeader() {
    final hasPhoto = (widget.exercise.photoPath ?? '').isNotEmpty;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: SizedBox(
            width: 64.w,
            height: 64.w,
            child: hasPhoto
                ? CachedNetworkImage(
                    imageUrl: widget.exercise.photoPath!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: mainColor.withOpacity(0.08)),
                    errorWidget: (_, __, ___) => _exerciseFallback(),
                  )
                : _exerciseFallback(),
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
                text: widget.exercise.title,
                maxlines: 2,
              ),
              if (widget.exercise.skills.isNotEmpty) ...[
                verticalSpace(6),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  children: widget.exercise.skills.take(3).map((s) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: TextUtils(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: mainColor,
                        text: s,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _exerciseFallback() {
    return Container(
      color: mainColor.withOpacity(0.08),
      child: Icon(Icons.sports_soccer_rounded, color: mainColor, size: 28.w),
    );
  }

  Widget _buildPlayerRow() {
    final hasPhoto = (widget.player.photoPath ?? '').isNotEmpty;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
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
                      imageUrl: widget.player.photoPath!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _playerFallback(),
                    )
                  : _playerFallback(),
            ),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  text: widget.player.name,
                  maxlines: 1,
                ),
                TextUtils(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: greyClr,
                  text: widget.player.position.isNotEmpty
                      ? widget.player.position
                      : 'لاعب',
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.upload_rounded, color: mainColor, size: 20.w),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: _progress / 100,
            backgroundColor: greyClr.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(mainColor),
            minHeight: 10.h,
          ),
        ),
        verticalSpace(10),
        TextUtils(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: mainColor,
          text: 'جاري رفع الفيديو... $_progress%',
        ),
        verticalSpace(8),
      ],
    );
  }

  Widget _buildSelectedFile() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.videocam_rounded, color: mainColor, size: 20.w),
          horizontalSpace(8),
          Expanded(
            child: Text(
              _selectedVideo!.path.split('/').last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _pickVideo(ImageSource.camera),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 18.w,
                  ),
                  horizontalSpace(6),
                  TextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    text: 'كاميرا',
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
                color: fillColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: mainColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_rounded,
                    color: mainColor,
                    size: 18.w,
                  ),
                  horizontalSpace(6),
                  TextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: mainColor,
                    text: 'المعرض',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _playerFallback() {
    return Container(
      color: mainColor.withOpacity(0.2),
      alignment: Alignment.center,
      child: Text(
        widget.player.name.isNotEmpty ? widget.player.name[0] : '؟',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
