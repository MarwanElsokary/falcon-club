import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_from_field_utils_widget.dart';

/// The phone + password fields.
///
/// The `Form` and its `GlobalKey` live **here**, in the widget layer. That is
/// the point: `LoginCubit` currently holds two `GlobalKey<FormState>`s and calls
/// `formKey.currentState!.validate()` from inside the state layer — reaching
/// into the widget tree from a cubit.
///
/// These validators are only for *instant* feedback and are deliberately as
/// permissive as today's login screen (non-empty). The authoritative rules live
/// in the domain (`PhoneNumber`, and the server for the password), so the two
/// can never drift into disagreeing about what is valid.
class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.isPasswordHidden,
    required this.onTogglePasswordVisibility,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool isPasswordHidden;
  final VoidCallback onTogglePasswordVisibility;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [_phoneField(), verticalSpace(20), _passwordField()],
      ),
    );
  }

  Widget _phoneField() => TextFromFieldUtilsWidget(
    controller: phoneController,
    obscureText: false,
    validator: (String? value) =>
        (value == null || value.trim().isEmpty) ? _phoneRequired.tr() : null,
    fillColor: fillColor,
    textInputType: TextInputType.phone,
    hintText: '05x xxx xxxx',
    lableText: 'رقم الجوال'.tr(),
    textInputAction: TextInputAction.next,
  );

  Widget _passwordField() => TextFromFieldUtilsWidget(
    controller: passwordController,
    obscureText: isPasswordHidden,
    validator: (String? value) =>
        (value == null || value.isEmpty) ? _passwordRequired.tr() : null,
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

  static const String _phoneRequired = 'من فضلك تأكد من ادخال رقم الجوال';
  static const String _passwordRequired = 'من فضلك أدخل كلمة المرور';
}
