import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/enums/user_type.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widget/app_bar_utils.dart';
import '../../../../core/widget/button_utils.dart';
import '../../../../core/widget/padding_utils.dart';
import '../../../../core/widget/slide_enimation_widget.dart';

/// Screen shown during signup flow for the user to select their type
/// (Club or Independent Scout) before proceeding to the registration form.
class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  UserType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtils(context: context, title: ''),
      bottomNavigationBar: _buildBottomButton(context),
      body: Container(
        padding: paddingUtils(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideEnimationWidget(
                index: 0,
                child: TextUtils(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  text: 'اختر نوع الحساب'.tr(),
                ),
              ),
              verticalSpace(10),
              SlideEnimationWidget(
                index: 1,
                child: TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  text: 'حدد نوع حسابك للمتابعة'.tr(),
                ),
              ),
              verticalSpace(40),

              // Club option
              SlideEnimationWidget(
                index: 2,
                child: _buildTypeCard(
                  type: UserType.club,
                  icon: Icons.business,
                  title: 'نادي'.tr(),
                  description:
                      'إدارة فريق كامل، إرسال دعوات للاعبين، إنشاء تقارير وإدارة القائمة'
                          .tr(),
                  features: [
                    'إدارة فريق النادي'.tr(),
                    'إرسال دعوات للاعبين'.tr(),
                    'تقارير وملاحظات شاملة'.tr(),
                    'قائمة الاهتمامات'.tr(),
                  ],
                ),
              ),
              verticalSpace(16),

              // Scout option
              SlideEnimationWidget(
                index: 3,
                child: _buildTypeCard(
                  type: UserType.scout,
                  icon: Icons.person_search,
                  title: 'كشاف مستقل'.tr(),
                  description:
                      'استكشاف اللاعبين وتقييمهم وإضافة ملاحظات وتقارير بشكل مستقل'
                          .tr(),
                  features: [
                    'استعراض اللاعبين'.tr(),
                    'إضافة ملاحظات'.tr(),
                    'إنشاء تقارير أداء'.tr(),
                    'مشاهدة اللقطات'.tr(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required UserType type,
    required IconData icon,
    required String title,
    required String description,
    required List<String> features,
  }) {
    final bool isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? mainColor.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? mainColor : Colors.grey.shade300,
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: mainColor.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon container
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? mainColor.withOpacity(0.15)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? mainColor : Colors.grey.shade600,
                    size: 28.w,
                  ),
                ),
                horizontalSpace(12),
                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUtils(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? mainColor : Colors.black,
                        text: title,
                      ),
                      verticalSpace(4),
                      TextUtils(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        text: description,
                        maxlines: 2,
                      ),
                    ],
                  ),
                ),
                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? mainColor : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? mainColor : Colors.grey.shade400,
                      width: 2.w,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: Colors.white, size: 16.w)
                      : null,
                ),
              ],
            ),
            verticalSpace(12),
            // Features list
            Divider(color: Colors.grey.shade200),
            verticalSpace(8),
            ...features.map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: isSelected ? mainColor : Colors.grey.shade400,
                      size: 16.w,
                    ),
                    horizontalSpace(8),
                    TextUtils(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.black87
                          : Colors.grey.shade600,
                      text: feature,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: SafeArea(
        child: ButtonUtils(
          text: 'متابعة'.tr(),
          onPressed: () {
            if (_selectedType == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('يرجى اختيار نوع الحساب'.tr()),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            Navigator.pop(context, _selectedType);
          },
          colorstext: Colors.white,
          background: _selectedType == null
              ? Colors.grey.shade400
              : mainColor,
        ),
      ),
    );
  }
}
