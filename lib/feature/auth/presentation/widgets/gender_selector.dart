import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../../shared/domain/entities/gender.dart';

/// Male / female picker.
///
/// A pure, controlled widget: it takes the current [value] and reports changes
/// through [onChanged]. It does not reach into a cubit — `EditGenderWidget`
/// currently writes straight into `context.read<LoginCubit>().gender`.
///
/// [value] being `null` means "not chosen yet", which the domain rejects rather
/// than silently defaulting to male (finding B5).
class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key, required this.value, required this.onChanged});

  final Gender? value;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: _option(Gender.male, 'رجل'.tr())),
        SizedBox(width: 12.w),
        Expanded(child: _option(Gender.female, 'أنثى'.tr())),
      ],
    );
  }

  Widget _option(Gender gender, String label) {
    final bool isSelected = value == gender;
    return InkWell(
      onTap: () => onChanged(gender),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? mainColor.withValues(alpha: 0.08) : fillColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? mainColor : greyClr.withValues(alpha: 0.4),
          ),
        ),
        child: Center(
          child: TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? mainColor : greyClr,
            text: label,
          ),
        ),
      ),
    );
  }
}
