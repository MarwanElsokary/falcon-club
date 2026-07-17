import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';

import '../../../../shared/domain/entities/attempt.dart';
import 'attempt_status_visuals.dart';

class AttemptStatusBadge extends StatelessWidget {
  final AttemptStatus status;

  const AttemptStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color = status.color;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, color: color, size: 12.w),
          SizedBox(width: 4.w),
          TextUtils(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
            text: status.label,
          ),
        ],
      ),
    );
  }
}
