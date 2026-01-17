import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/thems/thems.dart';

class MeasurementInstructionsWidget extends StatelessWidget {
  const MeasurementInstructionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              horizontalSpace(12),
              Text(
                'تعليمات مهمة للحصول على أفضل نتائج'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
            ],
          ),

          verticalSpace(16),

          _buildInstructionItem(
            icon: Icons.high_quality,
            text: 'يجب أن تكون الصورة واضحة وبجودة عالية'.tr(),
          ),

          verticalSpace(12),

          _buildInstructionItem(
            icon: Icons.accessibility_new,
            text: 'اللاعب يجب أن يكون في وضعية الوقوف بشكل مستقيم'.tr(),
          ),

          verticalSpace(12),

          _buildInstructionItem(
            icon: Icons.palette_outlined,
            text: 'استخدام خلفية فاتحة ومتناقضة مع لون ملابس اللاعب'.tr(),
          ),

          verticalSpace(12),

          _buildInstructionItem(
            icon: Icons.person_remove,
            text: 'تجنب وجود أشياء أخرى في الصورة غير اللاعب والكرة'.tr(),
          ),

          verticalSpace(16),

          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.image_outlined,
                  color: Colors.green.shade700,
                  size: 20.sp,
                ),
                horizontalSpace(8),
                Expanded(
                  child: Text(
                    'الصيغ المدعومة: JPEG, PNG, JPG'.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: mainColor,
          size: 20.sp,
        ),
        horizontalSpace(12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}