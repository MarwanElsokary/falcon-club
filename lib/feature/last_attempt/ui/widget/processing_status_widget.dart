import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';

class ProcessingStatusWidget extends StatelessWidget {
  final String status;
  final String message;
  final IconData icon;
  final Color color;

  const ProcessingStatusWidget({
    super.key,
    required this.status,
    required this.message,
    required this.icon,
    required this.color,
  });

  factory ProcessingStatusWidget.pending() {
    return ProcessingStatusWidget(
      status: 'قيد المعالجة',
      message: 'جاري تحليل الفيديو، قد يستغرق بضع دقائق',
      icon: Icons.hourglass_top,
      color: Color(0xFFF39C12),
    );
  }

  factory ProcessingStatusWidget.success() {
    return ProcessingStatusWidget(
      status: 'مكتمل',
      message: 'تم تحليل الفيديو بنجاح',
      icon: Icons.check_circle,
      color: Color(0xFF27AE60),
    );
  }

  factory ProcessingStatusWidget.failed() {
    return ProcessingStatusWidget(
      status: 'مرفوض',
      message: 'تم رفض الفيديو',
      icon: Icons.cancel,
      color: Color(0xFFE74C3C),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                  text: status,
                ),
                SizedBox(height: 4.w),
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  text: message,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}