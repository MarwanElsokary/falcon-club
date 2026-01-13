import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/spacing.dart';

class PasswordValidationWidget extends StatelessWidget {
  final String password;

  const PasswordValidationWidget({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final requirements = [
      _ValidationRequirement(
        text: '8 أحرف على الأقل',
        isValid: AppRegex.hasMinLength(password),
        icon: Icons.text_fields,
      ),
      _ValidationRequirement(
        text: 'حرف كبير (A-Z)',
        isValid: AppRegex.hasUpperCase(password),
        icon: Icons.text_format,
      ),
      _ValidationRequirement(
        text: 'حرف صغير (a-z)',
        isValid: AppRegex.hasLowerCase(password),
        icon: Icons.text_fields_outlined,
      ),
      _ValidationRequirement(
        text: 'رقم (0-9)',
        isValid: AppRegex.hasNumber(password),
        icon: Icons.numbers,
      ),
      _ValidationRequirement(
        text: 'رمز خاص (!@#...)',
        isValid: AppRegex.hasSpecialCharacter(password),
        icon: Icons.star,
      ),
    ];

    final completedCount = requirements.where((r) => r.isValid).length;
    final totalCount = requirements.length;
    final progress = completedCount / totalCount;

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط التقدم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'متطلبات كلمة المرور'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '$completedCount/$totalCount',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: _getProgressColor(progress),
                ),
              ),
            ],
          ),
          verticalSpace(8),

          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: _getProgressColor(progress),
            minHeight: 4.h,
            borderRadius: BorderRadius.circular(2.w),
          ),
          verticalSpace(12),

          // قائمة المتطلبات
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: requirements.map((requirement) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: requirement.isValid
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(
                    color: requirement.isValid
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      requirement.icon,
                      size: 14.sp,
                      color: requirement.isValid ? Colors.green : Colors.red,
                    ),
                    horizontalSpace(6),
                    Text(
                      requirement.text.tr(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: requirement.isValid ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          // مؤشر القوة
          if (password.isNotEmpty) ...[
            verticalSpace(12),
            _buildPasswordStrengthIndicator(password),
          ],
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(String password) {
    final strength = _calculatePasswordStrength(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'قوة كلمة المرور:'.tr(),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            Text(
              strength.label.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: strength.color,
              ),
            ),
          ],
        ),
        verticalSpace(6),
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4.h,
                margin: EdgeInsets.only(right: index < 3 ? 4.w : 0),
                decoration: BoxDecoration(
                  color: index < strength.level
                      ? strength.color
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.4) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    if (progress < 1.0) return Colors.blue;
    return Colors.green;
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    int score = 0;

    if (AppRegex.hasMinLength(password)) score++;
    if (AppRegex.hasUpperCase(password)) score++;
    if (AppRegex.hasLowerCase(password)) score++;
    if (AppRegex.hasNumber(password)) score++;
    if (AppRegex.hasSpecialCharacter(password)) score++;

    if (score <= 1) return PasswordStrength(1, 'ضعيفة', Colors.red);
    if (score <= 2) return PasswordStrength(2, 'متوسطة', Colors.orange);
    if (score <= 3) return PasswordStrength(3, 'جيدة', Colors.blue);
    return PasswordStrength(4, 'قوية', Colors.green);
  }
}

// كائنات مساعدة
class _ValidationRequirement {
  final String text;
  final bool isValid;
  final IconData icon;

  _ValidationRequirement({
    required this.text,
    required this.isValid,
    required this.icon,
  });
}

class PasswordStrength {
  final int level; // 1-4
  final String label;
  final Color color;

  PasswordStrength(this.level, this.label, this.color);
}
