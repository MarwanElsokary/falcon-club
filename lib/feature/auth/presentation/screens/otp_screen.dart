import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/app_bar_utils.dart';
import '../../../../core/widget/button_utils.dart';
import '../../../../core/widget/loading_button_utils.dart';
import '../../../../core/widget/padding_utils.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
import '../../../../core/widget/showSuccesSnackBar.dart';
import '../../../../core/widget/text_utils.dart';
import '../cubit/otp_cubit.dart';
import '../cubit/otp_state.dart';
import '../widgets/otp_input.dart';
import '../widgets/otp_resend_timer.dart';
import '../widgets/registration_window_countdown.dart';

/// Phone confirmation — **one screen for every entry point**.
///
/// It replaces three near-identical wrappers (`pinput_screen_with_navigation`,
/// `club_pinput_screen_with_navigation`, `scout_pinput_screen_with_navigation`),
/// which differed only in where they navigated afterwards. All three now
/// collapse into this, because the destination is always the same: the **login
/// screen**.
///
/// ## It creates no session
///
/// `ConfirmPhoneByOtp` returns no token — verified against the live endpoint. So
/// on success the account is merely *confirmed*, and moves to pending admin
/// approval. The user signs in normally; `LoginClub` answers
/// `status: "Warning"` until an admin approves them.
///
/// It also fixes a bug the club wrapper shipped: its success snackbar sat
/// **outside** the `if (state is VerificationCodeSuccess)` check, so "تم تسجيل
/// طلب النادي بنجاح" fired on *every* state emission — including loading and
/// errors.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  /// Shown to the user so they know which number the code went to. It is **not**
  /// sent anywhere: the endpoints identify the account by the registration
  /// token, not by a phone number.
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<OtpResendTimerState> _timerKey =
      GlobalKey<OtpResendTimerState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _confirm() => context.read<OtpCubit>().confirm(_codeController.text);

  void _onStateChanged(BuildContext context, OtpState state) {
    switch (state) {
      case OtpConfirmed(:final confirmation):
        showSuccesSnackBar(context: context, title: confirmation.message);
        // No session, no auto-login — the account is now awaiting approval.
        context.pushNamedAndRemoveUntil(
          AppRoute.loginScreen,
          predicate: (_) => false,
        );
      case OtpResent(:final message):
        showSuccesSnackBar(context: context, title: message);
        _codeController.clear();
        _timerKey.currentState?.restart();
      case OtpFailed(:final message):
        showErrorSnackBar(context: context, title: message);
      case OtpCredentialExpired():
        // Terminal. Nothing to retry — handled in the builder, not here.
        break;
      case OtpIdle():
      case OtpConfirming():
      case OtpResending():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: _onStateChanged,
      builder: (BuildContext context, OtpState state) => Scaffold(
        appBar: appBarUtils(context: context, title: 'تأكيد رقم الجوال'.tr()),
        bottomNavigationBar: state is OtpCredentialExpired
            ? _restartRegistrationButton()
            : _confirmButton(state),
        body: SingleChildScrollView(
          padding: paddingUtils(),
          child: state is OtpCredentialExpired
              ? _expiredNotice()
              : _codeEntry(context, state),
        ),
      ),
    );
  }

  Widget _codeEntry(BuildContext context, OtpState state) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      verticalSpace(30),
      _instructions(),
      verticalSpace(16),
      // The registration window is ~15 minutes. When it closes, confirming AND
      // resending both start returning 401 and the account can never be
      // confirmed — so the deadline is shown rather than sprung on the user.
      RegistrationWindowCountdown(
        credential: context.read<OtpCubit>().credential,
        onExpired: () => context.read<OtpCubit>().expire(),
      ),
      verticalSpace(24),
      OtpInput(controller: _codeController, onCompleted: (_) => _confirm()),
      verticalSpace(20),
      OtpResendTimer(
        key: _timerKey,
        isResending: state is OtpResending,
        onResend: () => context.read<OtpCubit>().resend(),
      ),
    ],
  );

  /// The dead end, made explicit.
  ///
  /// The backend will not re-issue the registration token, so there is genuinely
  /// nothing to retry here. Saying so — and offering the only route that works —
  /// beats letting the user hammer a code that will never be accepted.
  Widget _expiredNotice() => Column(
    children: <Widget>[
      verticalSpace(60),
      Icon(Icons.timer_off_outlined, color: redColor, size: 56.w),
      verticalSpace(20),
      TextUtils(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        text: 'انتهت مهلة التسجيل'.tr(),
      ),
      verticalSpace(12),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: TextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: greyClr,
          maxlines: 3,
          text: 'انتهت صلاحية جلسة التسجيل. يرجى إنشاء الحساب من جديد لتأكيد رقم جوالك.'
              .tr(),
        ),
      ),
    ],
  );

  Widget _restartRegistrationButton() => Padding(
    padding: paddingUtils(),
    child: ButtonUtils(
      text: 'إنشاء حساب جديد'.tr(),
      onPressed: () => context.pushNamedAndRemoveUntil(
        AppRoute.registrationTypeScreen,
        predicate: (_) => false,
      ),
      colorstext: Colors.white,
      background: mainColor,
    ),
  );

  Widget _instructions() => Column(
    children: <Widget>[
      TextUtils(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        text: 'أدخل رمز التحقق'.tr(),
      ),
      verticalSpace(8),
      TextUtils(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: greyClr,
        text: '${'تم إرسال رمز التحقق إلى'.tr()} ${widget.phoneNumber}',
      ),
    ],
  );

  Widget _confirmButton(OtpState state) => Padding(
    padding: paddingUtils(),
    child: state is OtpConfirming
        ? LoadButtonUtils()
        : ButtonUtils(
            text: 'تأكيد'.tr(),
            onPressed: _confirm,
            colorstext: Colors.white,
            background: mainColor,
          ),
  );
}
