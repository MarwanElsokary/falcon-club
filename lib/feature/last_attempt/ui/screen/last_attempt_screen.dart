import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../training_details/data/model/exercise_details_model.dart';
import '../widget/ai_loading_widget.dart';
import '../widget/ai_score/ai_score_widget.dart';
import '../widget/ai_video_widget.dart';
import '../widget/attempt_count.dart';
import '../widget/last_attempt_app_bar_widget.dart';
import '../widget/reject_reason_widget.dart';

class LastAttemptScreen extends StatefulWidget {
  const LastAttemptScreen({super.key, required this.exerciseDetails});
  final ExerciseDetailsModel exerciseDetails;

  @override
  State<LastAttemptScreen> createState() => _LastAttemptScreenState();
}

class _LastAttemptScreenState extends State<LastAttemptScreen> {
  int _selectedAttemptIndex = 0;

  @override
  void initState() {
    super.initState();
    final attempts = widget.exerciseDetails.data.attempts;
    if (attempts.isNotEmpty) {
      // اختيار آخر محاولة تم معالجتها بشكل افتراضي
      for (int i = attempts.length - 1; i >= 0; i--) {
        if (attempts[i].isProcessed == 1) {
          _selectedAttemptIndex = i;
          break;
        }
      }
      _selectedAttemptIndex = attempts.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final attempts = widget.exerciseDetails.data.attempts;
    if (attempts.isEmpty) {
      return _buildNoAttemptsScreen();
    }

    final selectedAttempt = attempts[_selectedAttemptIndex];

    return Scaffold(
      appBar: lastAttemptAppBar(
        context: context,
        title: 'ملخص الآداء بالمدرب الذكي'.tr(),
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          // عرض قائمة المحاولات (ارتفاع ثابت)
          _buildAttemptsSelector(attempts),

          // عرض تفاصيل المحاولة (يأخذ المساحة المتبقية)
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20.w),
              child: Column(
                children: [
                  verticalSpace(20),
                  _buildAttemptDetails(selectedAttempt),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAttemptsScreen() {
    return Scaffold(
      appBar: lastAttemptAppBar(
        context: context,
        title: 'ملخص الآداء بالمدرب الذكي'.tr(),
      ),
      backgroundColor: mainColor,
      body: Center(
        child: Text(
          'لا توجد محاولات متاحة',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAttemptsSelector(List<Attempt> attempts) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: mainColor,
                size: 18.w,
              ),
              horizontalSpace(8),
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: mainColor,
                text: 'المحاولات',
              ),
            ],
          ),
          verticalSpace(10),
          SizedBox(
            height: 70.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: attempts.length,
              separatorBuilder: (context, index) => horizontalSpace(8),
              itemBuilder: (context, index) {
                final attempt = attempts[index];
                final isSelected = _selectedAttemptIndex == index;
                final status = _getAttemptStatus(attempt);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAttemptIndex = index;
                    });
                  },
                  child: Container(
                    width: 110.w,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: isSelected ? mainColor : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected ? mainColor : Colors.grey.shade300,
                        width: 1.2.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.2) : _getStatusColor(status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : _getStatusColor(status),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          verticalSpace(4),
                          TextUtils(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : mainColor,
                            text: 'محاولة ${index + 1}',
                          ),
                          verticalSpace(2),
                          Text(
                            attempt.date ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getAttemptStatus(Attempt attempt) {
    if (attempt.isProcessed == 0) {
      return 'قيد المراجعة';
    } else if (attempt.isProcessed == 1) {
      return 'مكتمل';
    } else if (attempt.isProcessed == 2) {
      return 'مرفوض';
    }
    return 'غير معروف';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'قيد المراجعة':
        return Color(0xFFF39C12);
      case 'مكتمل':
        return Color(0xFF27AE60);
      case 'مرفوض':
        return Color(0xFFE74C3C);
      default:
        return Colors.grey;
    }
  }

  Widget _buildAttemptDetails(Attempt attempt) {
    final hasSkills = attempt.skills.isNotEmpty;
    final isRejected = attempt.rejectedReason != null;
    final isProcessed = attempt.isProcessed == 1;
    final isPending = attempt.isProcessed == 0;

    return Column(
      children: [
        // عرض النتيجة إذا كانت المهارات متوفرة والمحاولة مكتملة
        if (isProcessed && hasSkills)
          AiScoreWidget(skill: attempt.skills)
        else if (isProcessed && !hasSkills)
          _buildNoSkillsWidget()
        else if (isPending)
            AiLoadingWidget(),

        verticalSpace(20),

        // Ai Video
        Container(
          width: context.displayWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svgs/mingcute_ai-fill.svg',
                    width: 20.w,
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextUtils(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: mainColor,
                      text: isProcessed
                          ? 'تحليل المدرب الذكي'
                          : isRejected
                          ? 'تمت المراجعة'
                          : 'جاري المراجعة',
                    ),
                  ),
                ],
              ),
              verticalSpace(15),
              AiVideoWidget(
                videoUrl: attempt.aiVideo ?? attempt.video,
              ),
              verticalSpace(10),
            ],
          ),
        ),
        verticalSpace(15),

        // عرض سبب الرفض أو عدد المحاولات
        if (isRejected)
          RejectReasonWidget(rejectedReason: attempt.rejectedReason ?? '')
        else
          AttemptCount(
            attemCount: '${widget.exerciseDetails.data.attemptsCount ?? '0'}',
          ),
      ],
    );
  }

  Widget _buildNoSkillsWidget() {
    return Container(
      height: 160.w,
      width: 160.w,
      margin: EdgeInsets.symmetric(vertical: 20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 36.w,
            color: Colors.white,
          ),
          verticalSpace(12),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpace(4),
          Text(
            'لم يتم العثور على تحليل للمهارات',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}