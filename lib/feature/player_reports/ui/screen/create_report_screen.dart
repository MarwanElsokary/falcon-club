import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateReportScreen extends StatefulWidget {
  final String playerId;
  final String playerName;

  const CreateReportScreen({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _notesController = TextEditingController();

  // Skill ratings (out of 60 as per Figma)
  final Map<String, double> skillRatings = {
    'القوة': 0,
    'المراوغة': 0,
    'التدخل': 0,
    'التحكم': 0,
    'السرعة': 0,
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'تقرير جديد'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player name
            Text(
              widget.playerName,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            verticalSpace(24),

            // Skill ratings
            ...skillRatings.entries.map((entry) {
              return _buildSkillSlider(entry.key, entry.value);
            }),

            verticalSpace(20),

            // Notes
            Text(
              'ملاحظات إضافية'.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            verticalSpace(8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'اكتب ملاحظاتك هنا...'.tr(),
                hintStyle: TextStyle(color: Colors.white30),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
              ),
            ),

            verticalSpace(32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveReport,
                icon: Icon(Icons.save_outlined, size: 20.w),
                label: Text(
                  'حفظ التقرير'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: mainColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillSlider(String skillName, double value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skillName.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '${skillRatings[skillName]!.toInt()} / 60',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
              overlayColor: Colors.white24,
              trackHeight: 4.h,
            ),
            child: Slider(
              value: skillRatings[skillName]!,
              min: 0,
              max: 60,
              divisions: 60,
              onChanged: (val) {
                setState(() {
                  skillRatings[skillName] = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _saveReport() {
    // TODO: Call API to save report
    Navigator.pop(context);
  }
}
