import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/button_utils.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import '../cubit/password_reset_cubit.dart';
import '../cubit/password_reset_state.dart';
import '../widgets/reset_flow_scaffold.dart';
import '../widgets/saudi_phone_field.dart';

/// Step 1 — ask for a reset code.
///
/// Visually this is the original `forget_password_screen.dart`: the same
/// transparent "الرجوع" app bar, the same `Frame 1059.png` illustration with its
/// `lock_reset` fallback, the same subtitle, the same pill-shaped 9-digit phone
/// field with the `+966` suffix and `phone_android` icon, and the same
/// full-width button that stays grey until nine digits are entered.
///
/// Underneath it is the new `PasswordResetCubit` → `RequestPasswordReset` use
/// case → `PasswordResetRepository`. The old screen built its cubit inline with
/// `getIt<ForgetPasswordRepo>()` inside `build()`.
class RequestResetScreen extends StatefulWidget {
  const RequestResetScreen({super.key});

  @override
  State<RequestResetScreen> createState() => _RequestResetScreenState();
}

class _RequestResetScreenState extends State<RequestResetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  /// Mirrors the original: the button is only `mainColor` once the number is
  /// complete.
  bool get _isComplete =>
      _phoneController.text.length == PhoneNumber.saudiInputLength;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<PasswordResetCubit>().requestReset(_phoneController.text);
      return;
    }
    showErrorSnackBar(
      context: context,
      title: 'من فضلك ادخل رقم هاتفك بشكل صحيح'.tr(),
    );
  }

  void _onStateChanged(BuildContext context, PasswordResetState state) {
    switch (state) {
      case ResetCodeSent():
        context.pushNamed(
          AppRoute.sendOtp,
          arguments: <String, dynamic>{'phoneNumber': _phoneController.text},
        );
      case PasswordResetFailed(:final message):
        showErrorSnackBar(context: context, title: message);
      case PasswordResetIdle():
      case PasswordResetInProgress():
      case ResetCodeResent():
      case ResetOtpVerified():
      case PasswordResetCompleted():
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
          illustration: 'assets/images/Frame 1059.png',
          fallbackIcon: Icons.lock_reset,
          subtitle: 'ادخل رقم هاتفك وسوف يتم ارسال كود إليك'.tr(),
          children: <Widget>[
            _phoneField(),
            SizedBox(height: 24.h),
            _sendButton(state),
          ],
        ),
      ),
    );
  }

  Widget _phoneField() => SaudiPhoneField(
    controller: _phoneController,
    onChanged: (_) => setState(() {}),
    trailingIcon: const Icon(
      Icons.phone_android,
      color: Colors.grey,
      size: 20,
    ),
    validator: (String? value) {
      if (value == null || value.isEmpty) {
        return 'من فضلك تأكد من ادخال رقم الجوال'.tr();
      }
      if (value.length != PhoneNumber.saudiInputLength) {
        return 'رقم الجوال يجب أن يكون 9 أرقام'.tr();
      }
      return null;
    },
  );

  Widget _sendButton(PasswordResetState state) {
    if (state is PasswordResetInProgress) {
      return const Center(
        child: CircularProgressIndicator(color: mainColor, strokeWidth: 2),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ButtonUtils(
        text: 'ارسال'.tr(),
        onPressed: _submit,
        colorstext: Colors.white,
        background: _isComplete ? mainColor : Colors.grey[400]!,
      ),
    );
  }
}
