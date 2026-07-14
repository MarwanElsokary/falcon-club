import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../shared/domain/value_objects/password.dart';

/// The password-requirements panel from the original reset screen.
///
/// A faithful port of `reset_password_screen.dart`'s
/// `_buildPasswordValidationWidget` (line 363): the same `grey[50]` card with a
/// 12w radius, grey border and soft shadow; the same header row
/// (**"متطلبات كلمة المرور"** with an `n/5` counter); the same
/// `LinearProgressIndicator` at 4h with the red → orange → blue → green ramp;
/// and the same `Wrap` of pill chips, green-tinted when satisfied and red-tinted
/// when not, each with its own icon.
///
/// ## The rules come from the domain
///
/// The original re-implemented them via `AppRegex.hasMinLength` / `hasUpperCase`
/// / … — a fifth copy of a rule set that lived in five places. Here the source of
/// truth is [PasswordRule], the same enum `Password.createConfirmed` validates
/// against, so what the user is shown and what actually gets enforced cannot
/// drift apart. Only the *presentation* (icon and original wording) is mapped
/// here.
class PasswordStrengthPanel extends StatelessWidget {
  const PasswordStrengthPanel({super.key, required this.password});

  final String password;

  /// The original's icon and wording for each rule.
  static const Map<PasswordRule, (IconData, String)> _presentation =
      <PasswordRule, (IconData, String)>{
        PasswordRule.minimumLength: (Icons.text_fields, '8 أحرف على الأقل'),
        PasswordRule.hasUppercase: (Icons.text_format, 'حرف كبير (A-Z)'),
        PasswordRule.hasLowercase: (
          Icons.text_fields_outlined,
          'حرف صغير (a-z)',
        ),
        PasswordRule.hasDigit: (Icons.numbers, 'رقم (0-9)'),
        PasswordRule.hasSpecialCharacter: (Icons.star, 'رمز خاص (!@#...)'),
      };

  @override
  Widget build(BuildContext context) {
    final List<PasswordRule> unmet = Password.unmetRulesOf(password);
    final int total = PasswordRule.values.length;
    final int met = total - unmet.length;
    final double progress = met / total;

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _header(met, total, progress),
          verticalSpace(8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: _progressColor(progress),
            minHeight: 4.h,
            borderRadius: BorderRadius.circular(2.w),
          ),
          verticalSpace(12),
          _chips(unmet),
        ],
      ),
    );
  }

  Widget _header(int met, int total, double progress) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        'متطلبات كلمة المرور'.tr(),
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
      Text(
        '$met/$total',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: _progressColor(progress),
        ),
      ),
    ],
  );

  Widget _chips(List<PasswordRule> unmet) => Wrap(
    spacing: 8.w,
    runSpacing: 8.h,
    children: PasswordRule.values
        .map((PasswordRule rule) => _chip(rule, isMet: !unmet.contains(rule)))
        .toList(growable: false),
  );

  Widget _chip(PasswordRule rule, {required bool isMet}) {
    final (IconData icon, String label) =
        _presentation[rule] ?? (Icons.check, rule.description);
    final Color accent = isMet ? Colors.green : Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isMet ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(
          color: accent.withValues(alpha: isMet ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14.sp, color: accent),
          horizontalSpace(6),
          Text(
            label.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }

  static Color _progressColor(double progress) {
    if (progress < 0.4) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    if (progress < 1.0) return Colors.blue;
    return Colors.green;
  }
}
