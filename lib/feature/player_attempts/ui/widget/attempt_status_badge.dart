import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';

class AttemptStatusBadge extends StatelessWidget {
  final int isProcessed;

  const AttemptStatusBadge({super.key, required this.isProcessed});

  String get _label {
    switch (isProcessed) {
      case 0:
        return 'قيد المراجعة';
      case 1:
        return 'مكتمل';
      case 2:
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }

  Color get _color {
    switch (isProcessed) {
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

  IconData get _icon {
    switch (isProcessed) {
      case 0:
        return Icons.hourglass_top_rounded;
      case 1:
        return Icons.check_circle_rounded;
      case 2:
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _color, size: 12.w),
          SizedBox(width: 4.w),
          TextUtils(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: _color,
            text: _label,
          ),
        ],
      ),
    );
  }
}