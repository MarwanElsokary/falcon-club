import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../../shared/domain/value_objects/password.dart';

/// Live checklist of the password rules.
///
/// ## This one widget replaces five copies
///
/// The requirements list is currently copy-pasted into
/// `password_validation_widget`, `reset_password_screen`, `scout_sign_up_screen`,
/// `club_sign_up_screen`, and `signup_iput_data_widget` — each with its own
/// hard-coded rule descriptions and its own
/// `requirements.where((r) => r.isValid).length` counter. Five places to edit,
/// and nothing keeping them in agreement with what the domain actually enforces.
///
/// Here the rules come from [PasswordRule] — the same enum `Password.create`
/// validates against — so the checklist and the validation can never disagree.
/// Adding a rule adds a row here automatically.
class PasswordRequirementsChecklist extends StatelessWidget {
  const PasswordRequirementsChecklist({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final List<PasswordRule> unmet = Password.unmetRulesOf(password);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PasswordRule.values
          .map(
            (PasswordRule rule) =>
                _requirementRow(rule, isMet: !unmet.contains(rule)),
          )
          .toList(growable: false),
    );
  }

  Widget _requirementRow(PasswordRule rule, {required bool isMet}) => Padding(
    padding: EdgeInsets.symmetric(vertical: 2.h),
    child: Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14.w,
          color: isMet ? greenClr : greyClr,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: TextUtils(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isMet ? greenClr : greyClr,
            text: rule.description,
          ),
        ),
      ],
    ),
  );
}
