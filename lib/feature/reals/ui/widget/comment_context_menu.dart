import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/reals_cubit.dart';
import '../../cubit/reals_state.dart';

/// 🎯 Comment Context Menu
/// منيو سريع شفاف (زي انستجرام) بيظهر فوق الكومنت لحظة الـ long press
/// فيه أيقونتين بس: تعديل / حذف — يظهر بس لو الكومنت بتاع المستخدم الحالي
class CommentContextMenu {
  static OverlayEntry? _currentEntry;

  static void show({
    required BuildContext context,
    required Offset position,
    required RealsCubit cubit,
    required dynamic comment,
  }) {
    hide(); // يقفل أي منيو فاتح قبل كده

    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (overlayContext) {
        return _ContextMenuContent(
          position: position,
          onReady: (_) {},
          onEdit: () {
            hide();
            _openEditSheet(context, cubit, comment);
          },
          onDelete: () {
            hide();
            _confirmDelete(context, cubit, comment);
          },
          onDismiss: hide,
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }

  static void _openEditSheet(
      BuildContext context,
      RealsCubit cubit,
      dynamic comment,
      ) {
    final controller = TextEditingController(
      text: comment.description?.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: BlocProvider<RealsCubit>.value(
            value: cubit,
            child: BlocListener<RealsCubit, RealsState>(
              listener: (listenerContext, state) {
                if (state is updateCommentSuccess) {
                  Navigator.pop(sheetContext);
                } else if (state is updateCommentError) {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 24.w),
                decoration: BoxDecoration(
                  color: whiteclr,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.w,
                      margin: EdgeInsets.only(bottom: 16.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: greyClr.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    Text(
                      'تعديل التعليق'.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: blackmainColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      maxLines: 3,
                      minLines: 1,
                      style: TextStyle(fontSize: 14.sp, color: blackmainColor),
                      cursorColor: mainColor,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fillColor,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide(color: mainColor, width: 1.2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 13.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          final newText = controller.text.trim();
                          if (newText.isEmpty) return;
                          cubit.updateComment(
                            commentId: comment.id,
                            comment: newText,
                          );
                        },
                        child: Text(
                          'حفظ التعديل'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void _confirmDelete(
      BuildContext context,
      RealsCubit cubit,
      dynamic comment,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider<RealsCubit>.value(
          value: cubit,
          child: BlocListener<RealsCubit, RealsState>(
            listener: (listenerContext, state) {
              if (state is deleteCommentSuccess) {
                Navigator.pop(dialogContext);
              } else if (state is deleteCommentError) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            child: Dialog(
              backgroundColor: whiteclr,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.w,
                      decoration: BoxDecoration(
                        color: redClr.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: redClr,
                        size: 26.w,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'حذف التعليق؟'.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: blackmainColor,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'لن تتمكن من استعادته بعد الحذف'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.sp, color: blackclr),
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: greyClr),
                              padding: EdgeInsets.symmetric(vertical: 12.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text(
                              'إلغاء'.tr(),
                              style: TextStyle(
                                color: blackmainColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: redClr,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              cubit.deleteComment(commentId: comment.id);
                            },
                            child: Text(
                              'حذف'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// الـ overlay content نفسه - أيقونتين بـ fade + scale animation
class _ContextMenuContent extends StatefulWidget {
  final Offset position;
  final void Function(AnimationController) onReady;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDismiss;

  const _ContextMenuContent({
    required this.position,
    required this.onReady,
    required this.onEdit,
    required this.onDelete,
    required this.onDismiss,
  });

  @override
  State<_ContextMenuContent> createState() => _ContextMenuContentState();
}

class _ContextMenuContentState extends State<_ContextMenuContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    widget.onReady(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // نتأكد إن المنيو ما يخرجش برّه حدود الشاشة من الناحيتين
    double left = widget.position.dx;
    const menuWidth = 104.0;
    if (left + menuWidth > screenWidth - 12) {
      left = screenWidth - menuWidth - 12;
    }
    if (left < 12) left = 12;

    return Stack(
      children: [
        // طبقة شفافة تقفل المنيو لو دوست برّه
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onDismiss,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),
        Positioned(
          left: left,
          top: widget.position.dy,
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteclr,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MenuIconButton(
                        icon: Icons.edit_outlined,
                        color: mainColor,
                        onTap: widget.onEdit,
                      ),
                      Container(width: 1, height: 26, color: greyClr.withOpacity(0.4)),
                      _MenuIconButton(
                        icon: Icons.delete_outline,
                        color: redClr,
                        onTap: widget.onDelete,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}