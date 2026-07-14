import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/button_utils.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
import '../../../../core/widget/showSuccesSnackBar.dart';
import '../../domain/entities/password_reset_ticket.dart';
import '../cubit/password_reset_cubit.dart';
import '../cubit/password_reset_state.dart';
import '../widgets/password_strength_panel.dart';
import '../widgets/reset_flow_scaffold.dart';

/// Step 3 — choose a new password.
///
/// Visually this is the original `reset_password_screen.dart`: the same "الرجوع"
/// app bar, the same 200×200 `Frame 1059 (2).png` illustration with its
/// `lock_reset` fallback, the same "انشأ كلمة سر جديدة" heading, the same
/// filled 12w-radius password fields with visibility toggles, the same
/// requirements card with its progress bar and coloured chips, and the same
/// full-width "تأكيد تغيير كلمة المرور" button.
///
/// Underneath, the 579-line original is gone: the confirmation match and every
/// strength rule are checked in the domain by `Password.createConfirmed`, before
/// any I/O — not inline against a form key. On success it routes to **login**;
/// resetting a password does not sign you in.
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.ticket});

  /// Authorises exactly one password change. Never logged, never persisted.
  final PasswordResetTicket ticket;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmation = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmationHidden = true;
  String _typedPassword = '';

  @override
  void initState() {
    super.initState();
    _password.addListener(
      () => setState(() => _typedPassword = _password.text),
    );
  }

  @override
  void dispose() {
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      showErrorSnackBar(
        context: context,
        title: 'من فضلك أدخل بيانات صحيحة'.tr(),
      );
      return;
    }
    context.read<PasswordResetCubit>().submitNewPassword(
      ticket: widget.ticket,
      password: _password.text,
      confirmation: _confirmation.text,
    );
  }

  void _onStateChanged(BuildContext context, PasswordResetState state) {
    switch (state) {
      case PasswordResetCompleted(:final message):
        showSuccesSnackBar(context: context, title: message);
        context.pushNamedAndRemoveUntil(
          AppRoute.loginScreen,
          predicate: (_) => false,
        );
      case PasswordResetFailed(:final message):
        showErrorSnackBar(context: context, title: message);
      case PasswordResetIdle():
      case PasswordResetInProgress():
      case ResetCodeSent():
      case ResetCodeResent():
      case ResetOtpVerified():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listener: _onStateChanged,
      builder: (BuildContext context, PasswordResetState state) => Form(
        key: _formKey,
        child: ResetFlowScaffold(
          illustration: 'assets/images/Frame 1059 (2).png',
          fallbackIcon: Icons.lock_reset,
          illustrationHeight: 200,
          crossAxisAlignment: CrossAxisAlignment.start,
          subtitle: 'انشأ كلمة سر جديدة'.tr(),
          children: <Widget>[
            _passwordField(),
            PasswordStrengthPanel(password: _typedPassword),
            verticalSpace(20),
            _confirmationField(),
            verticalSpace(40),
            _submitButton(state),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _passwordField() => TextFormField(
    controller: _password,
    obscureText: _isPasswordHidden,
    decoration: _decoration(
      label: 'كلمة المرور الجديدة'.tr(),
      isHidden: _isPasswordHidden,
      onToggle: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
    ),
    validator: (String? value) =>
        (value == null || value.isEmpty) ? 'كلمة المرور مطلوبة'.tr() : null,
  );

  Widget _confirmationField() => TextFormField(
    controller: _confirmation,
    obscureText: _isConfirmationHidden,
    decoration: _decoration(
      label: 'تأكيد كلمة المرور'.tr(),
      isHidden: _isConfirmationHidden,
      onToggle: () =>
          setState(() => _isConfirmationHidden = !_isConfirmationHidden),
    ),
    validator: (String? value) => (value == null || value.isEmpty)
        ? 'تأكيد كلمة المرور مطلوب'.tr()
        : null,
  );

  /// The original's field styling: filled, 12w radius, grey border, mainColor on
  /// focus, and a grey visibility toggle.
  InputDecoration _decoration({
    required String label,
    required bool isHidden,
    required VoidCallback onToggle,
  }) => InputDecoration(
    filled: true,
    fillColor: fillColor,
    hintText: '********',
    labelText: label,
    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.w),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.w),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.w),
      borderSide: const BorderSide(color: mainColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.w),
      borderSide: const BorderSide(color: Colors.red),
    ),
    suffixIcon: IconButton(
      onPressed: onToggle,
      icon: Icon(
        isHidden ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey.shade600,
      ),
    ),
  );

  Widget _submitButton(PasswordResetState state) {
    if (state is PasswordResetInProgress) {
      return const Center(
        child: CircularProgressIndicator(color: mainColor, strokeWidth: 2),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ButtonUtils(
        text: 'تأكيد تغيير كلمة المرور'.tr(),
        onPressed: _submit,
        colorstext: Colors.white,
        background: mainColor,
      ),
    );
  }
}
