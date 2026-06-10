import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/utils/styles.dart';

import '../../cubit/requests_cubit.dart';
import '../../cubit/requests_state.dart';
import '../../data/model/club_request_model.dart';
import '../../data/model/player_request_model.dart';

// ── Unified Card — named constructors للـ Club والـ Player ───────────────────

class RequestCardWidget extends StatelessWidget {
  final String id;
  final String? name;
  final String? phone;
  final String? email;
  final String? gender;
  final String? photoPath;
  final bool isClub;

  const RequestCardWidget._({
    required this.id,
    required this.isClub,
    this.name,
    this.phone,
    this.email,
    this.gender,
    this.photoPath,
  });

  factory RequestCardWidget.club({required ClubRequestModel request}) =>
      RequestCardWidget._(
        id: request.id,
        isClub: true,
        name: request.name,
        phone: request.phone,
        email: request.email,
        gender: request.gender,
        photoPath: request.photoPath,
      );

  factory RequestCardWidget.player({required PlayerRequestModel request}) =>
      RequestCardWidget._(
        id: request.id,
        isClub: false,
        name: request.name,
        phone: request.phone,
        email: request.email,
        gender: request.gender,
        photoPath: request.photoPath,
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        final isActioning = state is RequestActionLoading;
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
                    _Avatar(photoPath: photoPath, name: name ?? ''),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _InfoSection(
                        name: name,
                        phone: phone,
                        email: email,
                        gender: gender,
                      ),
                    ),
                  ],
                ),
              ),
              // ── الأزرار ──
              _ActionButtons(id: id, isClub: isClub, isLoading: isActioning),
            ],
          ),
        );
      },
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String? photoPath;
  final String name;

  const _Avatar({required this.photoPath, required this.name});

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

class _InfoSection extends StatelessWidget {
  final String? name, phone, email, gender;

  const _InfoSection({this.name, this.phone, this.email, this.gender});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name ?? '—',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Styles.bold14.copyWith(color: mainColor),
        ),
        SizedBox(height: 4.h),
        if (phone != null) _InfoRow(icon: Icons.phone_outlined, text: phone!),
        if (email != null) ...[
          SizedBox(height: 3.h),
          _InfoRow(icon: Icons.email_outlined, text: email!),
        ],
        if (gender != null) ...[
          SizedBox(height: 4.h),
          _GenderBadge(gender: gender!),
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

class _GenderBadge extends StatelessWidget {
  final String gender;

  const _GenderBadge({required this.gender});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(gender, style: Styles.medium10.copyWith(color: mainColor)),
    );
  }
}

// ── Action Buttons ────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final String id;
  final bool isClub;
  final bool isLoading;

  const _ActionButtons({
    required this.id,
    required this.isClub,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RequestsCubit>();

    return Container(
      decoration: BoxDecoration(
        color: fillColor.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18.r),
          bottomRight: Radius.circular(18.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        children: [
          // قبول
          Expanded(
            flex: 3,
            child: _ActionBtn(
              label: 'قبول',
              icon: Icons.check_rounded,
              color: mainColor,
              isLoading: isLoading,
              onTap: () =>
                  isClub ? cubit.acceptClub(id) : cubit.acceptPlayer(id),
            ),
          ),
          SizedBox(width: 8.w),
          // رفض
          Expanded(
            flex: 3,
            child: _ActionBtn(
              label: 'رفض',
              icon: Icons.close_rounded,
              color: const Color(0xFFFF6B35),
              isLoading: isLoading,
              onTap: () =>
                  isClub ? cubit.rejectClub(id) : cubit.rejectPlayer(id),
            ),
          ),
          SizedBox(width: 8.w),
          // حذف
          Expanded(
            flex: 2,
            child: _ActionBtn(
              label: 'حذف',
              icon: Icons.delete_outline_rounded,
              color: Colors.red.shade400,
              isLoading: isLoading,
              onTap: () => _confirmDelete(context, cubit),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, RequestsCubit cubit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الحذف'),
        content: Text(
          isClub
              ? 'هل تريد حذف هذا النادي نهائياً؟'
              : 'هل تريد حذف هذا اللاعب نهائياً؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isClub) {
                cubit.deleteClub(id);
              } else {
                cubit.deletePlayer(id);
              }
            },
            child: Text('حذف', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isLoading ? color.withOpacity(0.4) : color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14.w, color: isLoading ? Colors.white54 : color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: Styles.bold12.copyWith(
                color: isLoading ? Colors.white54 : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
