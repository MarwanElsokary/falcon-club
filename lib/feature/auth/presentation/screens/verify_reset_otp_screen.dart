import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
import '../../../../core/widget/showSuccesSnackBar.dart';
import '../../domain/value_objects/otp_code.dart';
import '../cubit/password_reset_cubit.dart';
import '../cubit/password_reset_state.dart';
import '../widgets/reset_flow_scaffold.dart';
import '../widgets/reset_otp_input.dart';
import '../widgets/reset_resend_timer.dart';

/// Step 2 — enter the reset code, receive the ticket.
///
/// Visually this is the original `send_otp.dart`: the same "الرجوع" app bar, the
/// same `Frame 1059 (1).png` illustration with its `verified_user` fallback, the
/// same subtitle naming the `+966` number, the same white 60×45 code boxes, the
/// same "إعادة الإرسال" countdown, and the same full-width `ElevatedButton`
/// ("تحقق") that stays grey until six digits are entered.
///
/// Underneath: `PasswordResetCubit` → `VerifyPasswordResetOtp`. Resend now
/// actually calls the backend — the original's did nothing at all.
class VerifyResetOtpScreen extends StatefulWidget {
  const VerifyResetOtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerifyResetOtpScreen> createState() => _VerifyResetOtpScreenState();
}

class _VerifyResetOtpScreenState extends State<VerifyResetOtpScreen> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<ResetResendTimerState> _timerKey =
      GlobalKey<ResetResendTimerState>();

  bool get _isComplete => _codeController.text.length == OtpCode.length;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() => context.read<PasswordResetCubit>().verifyCode(
    phone: widget.phoneNumber,
    typedCode: _codeController.text,
  );

  void _onStateChanged(BuildContext context, PasswordResetState state) {
    switch (state) {
      case ResetOtpVerified(:final ticket):
        context.pushNamed(
          AppRoute.resetPasswordScreen,
          arguments: <String, dynamic>{'ticket': ticket},
        );
      case ResetCodeResent(:final message):
        showSuccesSnackBar(context: context, title: message);
        _codeController.clear();
        _timerKey.currentState?.restart();
      case PasswordResetFailed(:final message):
        showErrorSnackBar(context: context, title: message);
      case PasswordResetIdle():
      case PasswordResetInProgress():
      case ResetCodeSent():
      case PasswordResetCompleted():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listener: _onStateChanged,
      builder: (BuildContext context, PasswordResetState state) =>
          ResetFlowScaffold(
            illustration: 'assets/images/Frame 1059 (1).png',
            fallbackIcon: Icons.verified_user,
            subtitle:
                '${'نرجو ادخال الكود المرسل الي رقمك'.tr()} +966 ${widget.phoneNumber}',
            children: <Widget>[
              ResetOtpInput(
                controller: _codeController,
                onChanged: (_) => setState(() {}),
                onCompleted: (_) => _verify(),
              ),
              verticalSpace(24),
              ResetResendTimer(
                key: _timerKey,
                isResending: state is PasswordResetInProgress,
                onResend: () => context
                    .read<PasswordResetCubit>()
                    .resendCode(widget.phoneNumber),
              ),
              verticalSpace(24),
              _verifyButton(state),
            ],
          ),
    );
  }

  Widget _verifyButton(PasswordResetState state) {
    if (state is PasswordResetInProgress) {
      return const Center(
        child: CircularProgressIndicator(color: mainColor, strokeWidth: 2),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isComplete ? _verify : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isComplete ? mainColor : Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        child: Text(
          'تحقق'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
