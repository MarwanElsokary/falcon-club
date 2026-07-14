import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_from_field_utils_widget.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../../shared/domain/entities/gender.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import 'gender_selector.dart';
import 'password_requirements_checklist.dart';
import 'profile_photo_picker.dart';

/// The fields shared by Club and Scout registration.
///
/// One widget, both screens. The two legacy signup screens are 702 and 628
/// lines and **82% identical** — the same form, the same terms dialog, the same
/// password checklist, the same `_ValidationItem` class, copy-pasted. The only
/// real difference is the club dropdown, which the Club screen composes *around*
/// this widget rather than forking it.
///
/// Controlled throughout: it owns no state, mutates no cubit, and validates
/// nothing authoritatively. The field validators give instant feedback; the
/// domain (`RegistrationFields.create`) decides.
class RegistrationForm extends StatelessWidget {
  const RegistrationForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.password,
    required this.gender,
    required this.onGenderChanged,
    required this.photoPath,
    required this.onPhotoPicked,
    required this.isPasswordHidden,
    required this.onTogglePasswordVisibility,
    this.clubSelectors,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  /// The live password text, for the requirements checklist.
  final String password;

  final Gender? gender;
  final ValueChanged<Gender> onGenderChanged;
  final String? photoPath;
  final ValueChanged<String> onPhotoPicked;
  final bool isPasswordHidden;
  final VoidCallback onTogglePasswordVisibility;

  /// Club registration passes the city → club cascade here. Scout passes
  /// nothing — it is club-less by design, so there is no dropdown to disable or
  /// hide.
  final Widget? clubSelectors;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _photoSection(),
          verticalSpace(20),
          _nameRow(),
          verticalSpace(20),
          _emailField(),
          verticalSpace(20),
          _phoneField(context),
          verticalSpace(20),
          _sectionLabel('الجنس'.tr()),
          verticalSpace(8),
          GenderSelector(value: gender, onChanged: onGenderChanged),
          if (clubSelectors != null) ...<Widget>[
            verticalSpace(20),
            clubSelectors!,
          ],
          verticalSpace(20),
          _passwordField(),
          verticalSpace(8),
          PasswordRequirementsChecklist(password: password),
        ],
      ),
    );
  }

  Widget _nameRow() => Row(
    children: <Widget>[
      Expanded(
        child: _textField(
          controller: firstNameController,
          label: 'الاسم الأول'.tr(),
          hint: 'مروان',
          requiredMessage: 'الاسم الأول مطلوب',
        ),
      ),
      SizedBox(width: 12, height: 0),
      Expanded(
        child: _textField(
          controller: lastNameController,
          label: 'الاسم الأخير'.tr(),
          hint: 'ياسر',
          requiredMessage: 'الاسم الأخير مطلوب',
        ),
      ),
    ],
  );

  Widget _emailField() => _textField(
    controller: emailController,
    label: 'البريد الإلكتروني'.tr(),
    hint: 'email@gmail.com',
    requiredMessage: 'البريد الإلكتروني مطلوب',
    keyboardType: TextInputType.emailAddress,
  );

  /// The photo picker, centred with its caption — as on the original screens.
  ///
  /// It must be wrapped in [Center] explicitly: the surrounding [Column] uses
  /// `CrossAxisAlignment.start`, and in this app's RTL layout `start` is the
  /// **right** edge, which pinned the frame to the right side of the screen.
  Widget _photoSection() => Center(
    child: Column(
      children: <Widget>[
        ProfilePhotoPicker(photoPath: photoPath, onPicked: onPhotoPicked),
        TextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          text: 'اضغط لإضافة صورة شخصية'.tr(),
        ),
      ],
    ),
  );

  /// Capped at [PhoneNumber.saudiInputLength] and auto-advances when full —
  /// both behaviours the original `PhoneAuthTextFormField` had.
  ///
  /// This is an *input* limit: it stops bad input at the keystroke instead of at
  /// submit. It does not replace `PhoneNumber.forSaudiRegistration`, which
  /// remains the authority on whether the number is actually valid.
  Widget _phoneField(BuildContext context) => TextFromFieldUtilsWidget(
    controller: phoneController,
    obscureText: false,
    validator: (String? value) => (value == null || value.trim().isEmpty)
        ? 'رقم الجوال مطلوب'.tr()
        : null,
    fillColor: fillColor,
    textInputType: TextInputType.phone,
    maxLength: PhoneNumber.saudiInputLength,
    onChange: (String? value) {
      if (value?.length == PhoneNumber.saudiInputLength) {
        FocusScope.of(context).nextFocus();
      }
      return null;
    },
    hintText: '5X XXX XXXX',
    lableText: 'رقم الجوال'.tr(),
    textInputAction: TextInputAction.next,
  );

  Widget _passwordField() => TextFromFieldUtilsWidget(
    controller: passwordController,
    obscureText: isPasswordHidden,
    validator: (String? value) =>
        (value == null || value.isEmpty) ? 'كلمة المرور مطلوبة'.tr() : null,
    fillColor: fillColor,
    textInputType: TextInputType.visiblePassword,
    hintText: '******',
    lableText: 'كلمة المرور'.tr(),
    textInputAction: TextInputAction.done,
    suffix: IconButton(
      onPressed: onTogglePasswordVisibility,
      icon: Icon(
        isPasswordHidden ? Icons.visibility_off : Icons.visibility,
        color: mainColor,
      ),
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String requiredMessage,
    TextInputType keyboardType = TextInputType.text,
  }) => TextFromFieldUtilsWidget(
    controller: controller,
    obscureText: false,
    validator: (String? value) =>
        (value == null || value.trim().isEmpty) ? requiredMessage.tr() : null,
    fillColor: fillColor,
    textInputType: keyboardType,
    hintText: hint,
    lableText: label,
    textInputAction: TextInputAction.next,
  );

  Widget _sectionLabel(String text) => TextUtils(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    text: text,
  );
}
