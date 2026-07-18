import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../profile/domain/entities/player_profile.dart';
import '../../../profile/presentation/widgets/profile_section_card.dart';

class PlayerMeasurementsWidget extends StatelessWidget {
  final PlayerProfile playerProfile;

  const PlayerMeasurementsWidget({
    super.key,
    required this.playerProfile,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'قياسات اللاعب'.tr(),
      child: _buildMeasurementsGrid(),
    );
  }

  Widget _buildMeasurementsGrid() {
    final BodyMeasurements m = playerProfile.measurements;

    return Column(
      children: [
        // الصف الأول: الطول وعرض الكتفين
        Row(
          children: [
            Expanded(
              child: _buildMeasurementCard(
                label: 'الطول',
                value: _formatValue(m.height),
                unit: 'سم',
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _buildMeasurementCard(
                label: 'عرض الكتفين',
                value: _formatValue(m.shoulderWidth),
                unit: 'سم',
              ),
            ),
          ],
        ),
        verticalSpace(12),

        // الصف الثاني: طول الذراع وزاوية الساق
        Row(
          children: [
            Expanded(
              child: _buildMeasurementCard(
                label: 'طول الذراع',
                value: _formatValue(m.armLength),
                unit: 'سم',
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _buildMeasurementCard(
                label: 'زاوية الساق',
                value: _formatValue(m.avgLegAngle),
                unit: '°',
              ),
            ),
          ],
        ),

        // عرض البيانات الأساسية فقط إذا كانت موجودة
        if (_hasBasicMeasurements()) _buildBasicMeasurementsSection(),
      ],
    );
  }

  Widget _buildBasicMeasurementsSection() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: greyClr.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: greyClr.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات إضافية',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          verticalSpace(8),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'الطول المدخل',
                  _formatValue(playerProfile.height),
                  'سم',
                ),
              ),
              Container(
                height: 20.h,
                width: 1,
                color: greyClr.withOpacity(0.3),
                margin: EdgeInsets.symmetric(horizontal: 8.w),
              ),
              Expanded(
                child: _buildInfoItem(
                  'الوزن',
                  _formatValue(playerProfile.weight),
                  'كجم',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        verticalSpace(4),
        Text(
          '$value $unit',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

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
          colors: [mainColor.withOpacity(0.05), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // العنوان
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            text: label.tr(),
          ),
          verticalSpace(12),

          // القيمة والوحدة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextUtils(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: mainColor,
                text: value,
              ),
              horizontalSpace(4),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: TextUtils(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  text: unit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null ||
        value.toString().isEmpty ||
        value.toString() == 'null') {
      return '--';
    }

    if (value is num) {
      // للقياسات نعرض رقمين عشريين
      return value.toStringAsFixed(2);
    }

    return value.toString();
  }

  bool _hasBasicMeasurements() {
    return playerProfile.height != null || playerProfile.weight != null;
  }
}
