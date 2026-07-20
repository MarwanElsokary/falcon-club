import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/reals_cubit.dart';
import '../../cubit/reals_state.dart';

/// ⋮ Reel Options Menu
/// يظهر بس لو الريل ده ملك المستخدم الحالي (isMyReel == true)
/// بيفتح bottom sheet فيه Edit / Delete
class ReelOptionsMenu extends StatelessWidget {
  final int reelId;
  final String currentDescription;

  const ReelOptionsMenu({
    Key? key,
    required this.reelId,
    required this.currentDescription,
  }) : super(key: key);

  void _openOptions(BuildContext context) {
    final cubit = context.read<RealsCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: TextUtils(
                  text: 'تعديل'.tr(),
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openEditDialog(context, cubit);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: TextUtils(
                  text: 'حذف'.tr(),
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDelete(context, cubit);
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  void _openEditDialog(BuildContext context, RealsCubit cubit) {
    final controller = TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider<RealsCubit>.value(
          value: cubit,
          child: BlocListener<RealsCubit, RealsState>(
            listener: (listenerContext, state) {
              if (state is updateReelSuccess) {
                Navigator.pop(dialogContext);
              } else if (state is updateReelError) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: AlertDialog(
              backgroundColor: Colors.grey[900],
              title: TextUtils(
                text: 'تعديل الوصف'.tr(),
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              content: TextField(
                controller: controller,
                autofocus: true,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'اكتب الوصف الجديد'.tr(),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: TextUtils(
                    text: 'إلغاء'.tr(),
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final newDescription = controller.text.trim();
                    if (newDescription.isEmpty) return;
                    cubit.updateReel(
                      reelId: reelId,
                      description: newDescription,
                    );
                  },
                  child: TextUtils(
                    text: 'حفظ'.tr(),
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, RealsCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider<RealsCubit>.value(
          value: cubit,
          child: BlocListener<RealsCubit, RealsState>(
            listener: (listenerContext, state) {
              if (state is deleteReelSuccess) {
                Navigator.pop(dialogContext);
              } else if (state is deleteReelError) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: AlertDialog(
              backgroundColor: Colors.grey[900],
              title: TextUtils(
                text: 'حذف الريل'.tr(),
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              content: TextUtils(
                text: 'هل أنت متأكد من حذف هذا الريل؟'.tr(),
                color: Colors.grey[300]!,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: TextUtils(
                    text: 'إلغاء'.tr(),
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    cubit.deleteReel(reelId: reelId);
                  },
                  child: TextUtils(
                    text: 'حذف'.tr(),
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openOptions(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.more_vert, color: Colors.white, size: 22.w),
      ),
    );
  }
}
