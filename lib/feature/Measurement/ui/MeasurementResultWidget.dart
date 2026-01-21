import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/extensions.dart';
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
          /// ================= Image =================
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CachedNetworkImage(
              imageUrl: measurement.image ?? '',
              height: 600.h,
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

          /// ================= Measurements (Profile Style) =================
          Container(
            width: context.displayWidth,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: whiteclr,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'قياسات اللاعب'.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                verticalSpace(15),

                /// Row 1
                Row(
                  children: [
                    Expanded(
                      child: _buildMeasurementCard(
                        label: 'الطول',
                        value: _formatValue(measurement.heightCm),
                        unit: 'سم',
                      ),
                    ),
                    horizontalSpace(12),
                    Expanded(
                      child: _buildMeasurementCard(
                        label: 'عرض الكتفين',
                        value: _formatValue(measurement.shoulderWidthCm),
                        unit: 'سم',
                      ),
                    ),
                  ],
                ),

                verticalSpace(12),

                /// Row 2
                Row(
                  children: [
                    Expanded(
                      child: _buildMeasurementCard(
                        label: 'طول الذراع',
                        value: _formatValue(measurement.armLengthCm),
                        unit: 'سم',
                      ),
                    ),
                    horizontalSpace(12),
                    Expanded(
                      child: _buildMeasurementCard(
                        label: 'زاوية الساق',
                        value: _formatValue(measurement.avgLegAngle),
                        unit: '°',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          verticalSpace(30),
        ],
      ),
    );
  }

  /// ================= Card (نفس البروفايل) =================
  Widget _buildMeasurementCard({
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: mainColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            mainColor.withOpacity(0.05),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            label.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: mainColor,
                ),
              ),
              horizontalSpace(4),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= Formatter =================
  String _formatValue(dynamic value) {
    if (value == null || value.toString() == 'null') {
      return '--';
    }
    if (value is num) {
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }
}
