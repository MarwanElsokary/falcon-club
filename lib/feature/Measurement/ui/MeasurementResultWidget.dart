import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/thems/thems.dart';
import '../../../core/widget/padding_utils.dart';
import '../data/model/MeasurementModel.dart';

class MeasurementResultWidget extends StatelessWidget {
  final MeasurementModel measurement;

  const MeasurementResultWidget({
    super.key,
    required this.measurement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingUtils(),
      child: Column(
        children: [
          // Success animation
          Lottie.asset(
            'assets/lottie/success.json',
            width: 150.w,
            height: 150.h,
            repeat: false,
          ),

          verticalSpace(10),

          // Success message
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
                horizontalSpace(12),
                Expanded(
                  child: Text(
                    'تم حفظ جميع البيانات في قاعدة البيانات بنجاح'.tr(),
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          verticalSpace(20),

          // Analyzed image
          Text(
            'الصورة بعد التحليل'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),

          verticalSpace(12),

          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CachedNetworkImage(
              imageUrl: measurement.image ?? '',
              height: 300.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(color: mainColor),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: Icon(Icons.error, color: Colors.red, size: 40.sp),
              ),
            ),
          ),

          verticalSpace(20),

          // Measurements card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  mainColor.withOpacity(0.1),
                  mainColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: mainColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'نتائج القياسات'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                verticalSpace(20),
                _buildMeasurementRow(
                  icon: Icons.height,
                  label: 'الطول'.tr(),
                  value: '${_formatValue(measurement.heightCm)} سم',
                ),
                verticalSpace(12),
                _buildMeasurementRow(
                  icon: Icons.accessibility,
                  label: 'عرض الكتفين'.tr(),
                  value: '${_formatValue(measurement.shoulderWidthCm)} سم',
                ),
                verticalSpace(12),
                if (measurement.armLengthCm != null) ...[
                  _buildMeasurementRow(
                    icon: Icons.back_hand,
                    label: 'طول الذراع'.tr(),
                    value: '${_formatValue(measurement.armLengthCm)} سم',
                  ),
                  verticalSpace(12),
                ],
                _buildMeasurementRow(
                  icon: Icons.compare_arrows,
                  label: 'متوسط زاوية الساق'.tr(),
                  value: '${_formatValue(measurement.avgLegAngle)}°',
                ),
              ],
            ),
          ),

          verticalSpace(20),

          // Important note
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.orange.shade700, size: 20.sp),
                    horizontalSpace(8),
                    Text(
                      'ملاحظة هامة'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
                verticalSpace(8),
                Text(
                  'يرجى مراجعة هذه القياسات مع المدرب الخاص بك لوضع خطة تدريبية مناسبة لتطوير أدائك البدني.'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.orange.shade800,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          verticalSpace(30),
        ],
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return '--';
    if (value is num) {
      return value.toStringAsFixed(1);
    }
    return value.toString();
  }

  Widget _buildMeasurementRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: mainColor, size: 24.sp),
          ),
          horizontalSpace(16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
        ],
      ),
    );
  }
}