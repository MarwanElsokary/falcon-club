import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../../../../shared/domain/entities/gender.dart';
import '../../domain/entities/club_option.dart';
import '../cubit/club_directory_cubit.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/registration_state.dart';
import '../widgets/city_club_selectors.dart';
import '../widgets/registration_form.dart';
import '../widgets/terms_agreement.dart';

/// The signup screen — **one screen for both Club and Scout**.
///
/// It talks to [RegistrationCubit], the abstract base, so the concrete cubit
/// (Club or Scout) is chosen by the router and this screen never branches on
/// role. The single difference is [requiresClub], which adds the city → club
/// cascade.
///
/// That replaces two forked screens of 702 and 628 lines that were 82% identical
/// — duplicated terms dialog, duplicated password checklist, duplicated
/// `_ValidationItem` class, all so one could call `registerClub()` and the other
/// `registerScout()`.
///
/// ## Registration does not sign you in
///
/// On success it routes to the **login screen**. There is no session to persist
/// — `RegistrationOutcome` carries no token by construction — so the user
/// authenticates normally, and if their account is not yet approved the login
/// endpoint tells them so.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    super.key,
    required this.title,
    required this.requiresClub,
  });

  final String title;

  /// Club registration needs a `ClubId`; scout registration is club-less.
  final bool requiresClub;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Gender? _gender;
  String? _photoPath;
  bool _isPasswordHidden = true;
  String _passwordText = '';

  /// Consent is mandatory. The original screens gated the submit button on this
  /// (`club_sign_up_screen.dart:581`); it was lost when the two forked screens
  /// were unified, letting accounts be created without accepting the terms.
  bool _hasAgreedToTerms = false;

  static const String _mustAgreeMessage =
      'يرجى الموافقة على الشروط والأحكام للمتابعة';

  @override
  void initState() {
    super.initState();
    _password.addListener(
      () => setState(() => _passwordText = _password.text),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // Blocks registration until the terms are accepted — same as the original.
    if (!_hasAgreedToTerms) {
      showErrorSnackBar(context: context, title: _mustAgreeMessage.tr());
      return;
    }
    context.read<RegistrationCubit>().submit(
      RegistrationInput(
        firstName: _firstName.text,
        lastName: _lastName.text,
        email: _email.text,
        phone: _phone.text,
        password: _password.text,
        gender: _gender,
        photoPath: _photoPath,
        club: _selectedClub,
      ),
    );
  }

  /// Only Club registration provides a [ClubDirectoryCubit], so only it can have
  /// a selected club. Reading it on the Scout screen would throw — hence the
  /// guard rather than a null-safe read.
  ClubOption? get _selectedClub => widget.requiresClub
      ? context.read<ClubDirectoryCubit>().state.selectedClub
      : null;

  void _onStateChanged(BuildContext context, RegistrationState state) {
    switch (state) {
      case RegistrationSucceeded(:final outcome):
        showSuccesSnackBar(context: context, title: outcome.message);
        // Straight to phone confirmation, as the original flow did. The
        // credential rides along: the OTP endpoints take no phone number and no
        // user id, so that Bearer token is the only thing that identifies the
        // account. It is NOT a session — confirming leads to the login screen.
        context.pushNamedAndRemoveUntil(
          AppRoute.otpScreen,
          predicate: (_) => false,
          arguments: <String, dynamic>{
            'credential': outcome.credential,
            'phoneNumber': _phone.text,
          },
        );
      case RegistrationFailed(:final message):
        showErrorSnackBar(context: context, title: message);
      case RegistrationIdle():
      case RegistrationInProgress():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationCubit, RegistrationState>(
      listener: _onStateChanged,
      builder: (BuildContext context, RegistrationState state) => Scaffold(
        appBar: appBarUtils(context: context, title: widget.title),
        bottomNavigationBar: _submitButton(state),
        body: SingleChildScrollView(
          padding: paddingUtils(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSpace(10),
              _form(),
              verticalSpace(16),
              TermsAgreement(
                isAgreed: _hasAgreedToTerms,
                onChanged: (bool agreed) =>
                    setState(() => _hasAgreedToTerms = agreed),
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form() => RegistrationForm(
    formKey: _formKey,
    firstNameController: _firstName,
    lastNameController: _lastName,
    emailController: _email,
    phoneController: _phone,
    passwordController: _password,
    password: _passwordText,
    gender: _gender,
    onGenderChanged: (Gender gender) => setState(() => _gender = gender),
    photoPath: _photoPath,
    onPhotoPicked: (String path) => setState(() => _photoPath = path),
    isPasswordHidden: _isPasswordHidden,
    onTogglePasswordVisibility: () =>
        setState(() => _isPasswordHidden = !_isPasswordHidden),
    clubSelectors: widget.requiresClub ? const CityClubSelectors() : null,
  );

  Widget _submitButton(RegistrationState state) => Padding(
    padding: paddingUtils(),
    child: state is RegistrationInProgress
        ? LoadButtonUtils()
        : ButtonUtils(
            text: 'إنشاء حساب'.tr(),
            onPressed: _submit,
            colorstext: Colors.white,
            background: mainColor,
          ),
  );
}
