import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/loading_button_utils.dart';
import '../../../../core/widget/button_utils.dart';
import '../../../../core/widget/padding_utils.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
import '../../../../core/widget/slide_enimation_widget.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../../shared/presentation/routing/role_router.dart';
import '../../domain/entities/registration_credential.dart';
import '../cubit/sign_in_cubit.dart';
import '../cubit/sign_in_state.dart';
import '../widgets/sign_in_form.dart';

/// The sign-in screen.
///
/// Replaces `login_screen.dart` + `login_button_widget.dart`, which between them
/// held **two** competing `BlocListener`/`BlocConsumer`s that each fired on the
/// same success state and each ran their own `pushNamedAndRemoveUntil` — with
/// *different* destinations for a Club user. Here there is exactly one listener
/// and one navigation call, and the destination comes from [RoleRouter].
///
/// It also reads no storage. The old screen re-read the token and the role from
/// `SharedPrefHelper` after a 1100 ms `Future.delayed` in order to decide where
/// to go; the session now arrives in the success state.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    // The lookup lives in the cubit — the screen no longer reaches into the
    // service locator for it.
    context.read<SignInCubit>().loadPendingRegistration();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<SignInCubit>().signIn(
      phone: _phoneController.text,
      password: _passwordController.text,
    );
  }

  void _goToOtp(RegistrationCredential credential) {
    context.pushNamed(
      AppRoute.otpScreen,
      arguments: <String, dynamic>{
        'credential': credential,
        'phoneNumber': _phoneController.text,
      },
    );
  }

  void _onStateChanged(BuildContext context, SignInState state) {
    switch (state.attempt) {
      case SignInSucceeded(:final session):
        context.pushNamedAndRemoveUntil(
          RoleRouter.homeRouteFor(session.role),
          predicate: (_) => false,
        );
      case SignInFailed(:final message):
        // Covers both "not confirmed" (a 400) and "pending approval" (a 200
        // with status Warning) — the server's own message either way.
        showErrorSnackBar(context: context, title: message);
      case SignInIdle():
      case SignInInProgress():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: _onStateChanged,
      builder: (BuildContext context, SignInState state) => Scaffold(
        bottomNavigationBar: _submitButton(state),
        body: SizedBox(
          width: context.displayWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_header(context), _content()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Align(
    alignment: Alignment.center,
    child: SlideEnimationWidget(
      index: 0,
      child: Image.asset(
        'assets/images/login_image.png',
        fit: BoxFit.cover,
        width: context.displayWidth,
        height: 400.w,
      ),
    ),
  );

  Widget _content() => Padding(
    padding: paddingUtils(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextUtils(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          text: 'تسجيل دخول'.tr(),
        ),
        verticalSpace(30),
        SignInForm(
          formKey: _formKey,
          phoneController: _phoneController,
          passwordController: _passwordController,
          isPasswordHidden: _isPasswordHidden,
          onTogglePasswordVisibility: () =>
              setState(() => _isPasswordHidden = !_isPasswordHidden),
        ),
        _forgotPasswordLink(),
      ],
    ),
  );

  Widget _forgotPasswordLink() => Align(
    alignment: Alignment.topLeft,
    child: TextButton(
      onPressed: () => context.pushNamed(AppRoute.forgetPasswordScreen),
      child: Text(
        'نسيت كلمة المرور؟'.tr(),
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: mainColor.withValues(alpha: 0.8),
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  Widget _submitButton(SignInState state) => Padding(
    padding: paddingUtils(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (state.attempt is SignInInProgress)
          LoadButtonUtils()
        else
          ButtonUtils(
            text: 'تسجيل الدخول'.tr(),
            onPressed: _submit,
            colorstext: Colors.white,
            background: mainColor,
          ),
        if (state.pendingRegistration case final RegistrationCredential pending)
          _confirmPhoneLink(pending),
        verticalSpace(8),
        _createAccountLink(),
      ],
    ),
  );

  /// Shown only when an unconfirmed registration is still confirmable.
  ///
  /// This is the recovery path for someone who registered, closed the app before
  /// entering the code, and came back later — otherwise their account is
  /// permanently unusable, because login refuses an unconfirmed phone and the
  /// backend will not re-issue the token needed to confirm it.
  ///
  /// It is gated on the credential, not on the error text, so it cannot misfire
  /// on the *pending approval* state (a 200, where the phone is already
  /// confirmed and there is nothing to do but wait).
  Widget _confirmPhoneLink(RegistrationCredential credential) =>
      TextButton.icon(
        onPressed: () => _goToOtp(credential),
        icon: Icon(Icons.verified_outlined, color: mainColor, size: 18.sp),
        label: Text(
          'تأكيد رقم الجوال'.tr(),
          style: TextStyle(
            color: mainColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
        ),
      );

  /// Route to registration (Club or Scout — the type screen asks which).
  ///
  /// This link exists on the legacy `LoginButtonWidget` and was dropped when the
  /// screen was rebuilt. Without it there is no way to reach signup at all.
  Widget _createAccountLink() => TextButton(
    onPressed: () => context.pushNamed(AppRoute.registrationTypeScreen),
    child: Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: 'ليس لديك حساب؟'.tr(),
            style: TextStyle(
              color: blackclr,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: 'اشتراك'.tr(),
            style: TextStyle(
              color: mainColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    ),
  );
}
