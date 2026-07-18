import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/utils/styles.dart';
import 'package:falconclubapp/core/widget/show_confirm_dialog.dart';

import '../../../club_team/cubit/club_team_cubit.dart';
import '../../../club_team/cubit/club_team_state.dart';
import '../../data/model/club_trainee_model.dart';

class TraineeCardWidget extends StatelessWidget {
  final ClubTrainee trainee;

  const TraineeCardWidget({super.key, required this.trainee});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClubTeamCubit, ClubTeamState>(
      builder: (context, state) {
        final isDeleting = state.maybeWhen(
          deleteTraineeLoading: () => true,
          orElse: () => false,
        );

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: const Color(0xFFF0EAF8)),
            boxShadow: [
              BoxShadow(
                color: mainColor.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── المعلومات ──
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Row(
                  children: [
                    _TraineeAvatar(
                      photoPath: trainee.photoPath,
                      name: trainee.name,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _TraineeInfo(
                        name: trainee.name,
                        phone: trainee.phone,
                        email: trainee.email,
                        gender: trainee.gender,
                        accountNumber: trainee.accountNumber,
                      ),
                    ),
                  ],
                ),
              ),
              // ── زر الحذف ──
              _DeleteButton(
                traineeId: trainee.id,
                traineeName: trainee.name,
                isLoading: isDeleting,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _TraineeAvatar extends StatelessWidget {
  final String? photoPath;
  final String name;

  const _TraineeAvatar({required this.photoPath, required this.name});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && photoPath!.isNotEmpty;
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: mainColor.withOpacity(0.3), width: 2.w),
        gradient: const LinearGradient(
          colors: [Color(0xFF761CBC), mainColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipOval(
        child: hasPhoto
            ? CachedNetworkImage(
          imageUrl: photoPath!,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _InitialFallback(name: name),
        )
            : _InitialFallback(name: name),
      ),
    );
  }
}

class _InitialFallback extends StatelessWidget {
  final String name;
  const _InitialFallback({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0] : '؟',
        style: Styles.bold18.copyWith(color: Colors.white),
      ),
    );
  }
}

// ── Info ──────────────────────────────────────────────────────────────────────

class _TraineeInfo extends StatelessWidget {
  final String name;
  final String? phone;
  final String? email;
  final String? gender;
  final String? accountNumber;

  const _TraineeInfo({
    required this.name,
    this.phone,
    this.email,
    this.gender,
    this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Styles.bold14.copyWith(color: mainColor),
        ),
        SizedBox(height: 4.h),
        if (phone != null)
          _InfoRow(icon: Icons.phone_outlined, text: phone!),
        if (email != null) ...[
          SizedBox(height: 3.h),
          _InfoRow(icon: Icons.email_outlined, text: email!),
        ],
        if (accountNumber != null) ...[
          SizedBox(height: 3.h),
          _InfoRow(icon: Icons.badge_outlined, text: '#$accountNumber'),
        ],
        if (gender != null) ...[
          SizedBox(height: 5.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              gender!,
              style: Styles.medium10.copyWith(color: mainColor),
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12.w, color: mainColor.withOpacity(0.6)),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.regular12.copyWith(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

// ── Delete Button ─────────────────────────────────────────────────────────────

class _DeleteButton extends StatelessWidget {
  final String traineeId;
  final String traineeName;
  final bool isLoading;

  const _DeleteButton({
    required this.traineeId,
    required this.traineeName,
    required this.isLoading,
  });

  void _confirmDelete(BuildContext context) {
    final ClubTeamCubit cubit = context.read<ClubTeamCubit>();
    showConfirmDialog(
      context: context,
      isDestructive: true,
      title: 'هل تريد حذف "$traineeName" من الفريق؟'.tr(),
      onConfirm: () => cubit.deleteTrainee(traineeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.red.shade400;
    return Container(
      decoration: BoxDecoration(
        color: fillColor.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18.r),
          bottomRight: Radius.circular(18.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: GestureDetector(
        onTap: isLoading ? null : () => _confirmDelete(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isLoading
                ? color.withOpacity(0.4)
                : color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 15.w,
                color: isLoading ? Colors.white54 : color,
              ),
              SizedBox(width: 6.w),
              Text(
                'حذف من الفريق',
                style: Styles.bold12.copyWith(
                  color: isLoading ? Colors.white54 : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}