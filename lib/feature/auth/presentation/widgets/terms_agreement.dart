import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';
import '../cubit/terms_cubit.dart';

/// The consent checkbox, and the dialog behind it.
///
/// ## This is the ORIGINAL design
///
/// A faithful port of the terms block from `club_sign_up_screen.dart`
/// (lines 523-576) and its `_showTermsDialog` (line 640): the same `fillColor`
/// pill with a 12r radius, the same rounded 4r checkbox in `mainColor`, the same
/// `RichText` in Cairo 13sp with the underlined **"الشروط والسياسات"** link, and
/// the same 20r rounded dialog with bulleted `• ` paragraphs and a **"فهمت"**
/// dismiss button.
///
/// ## Why it exists at all
///
/// The original required consent: `_agreedToTerms` gated the submit button
/// (`club_sign_up_screen.dart:581`). When the two 700-line signup screens were
/// unified into one `RegistrationScreen`, the checkbox was **dropped** — so
/// accounts could be created without accepting the terms. That is a compliance
/// gap, not a styling one.
///
/// What changed is only the plumbing: the text comes from [TermsCubit] (backed
/// by the `GetTermsAndPolicies` use case) instead of a `List<String>` field on a
/// 700-line `State`, and this widget is controlled — [isAgreed] and [onChanged]
/// live on the screen, which is what gates submission.
class TermsAgreement extends StatelessWidget {
  const TermsAgreement({
    super.key,
    required this.isAgreed,
    required this.onChanged,
  });

  final bool isAgreed;
  final ValueChanged<bool> onChanged;

  static const String _unavailableMessage =
      'تعذر تحميل الشروط والسياسات حالياً. بالمتابعة فإنك توافق على شروط الاستخدام وسياسة الخصوصية.';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isAgreed,
            onChanged: (bool? value) => onChanged(value ?? false),
            activeColor: mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Expanded(child: _consentText(context)),
        ],
      ),
    );
  }

  Widget _consentText(BuildContext context) => RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
        fontFamily: 'Cairo',
      ),
      children: <InlineSpan>[
        TextSpan(text: 'أوافق على '.tr()),
        TextSpan(
          text: 'الشروط والسياسات'.tr(),
          style: TextStyle(
            color: mainColor,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _showTermsDialog(context),
        ),
      ],
    ),
  );

  void _showTermsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider<TermsCubit>.value(
        value: context.read<TermsCubit>(),
        child: const _TermsDialog(),
      ),
    );
  }
}

/// The original 20r-rounded dialog, with bulleted paragraphs and a "فهمت"
/// dismiss.
class _TermsDialog extends StatelessWidget {
  const _TermsDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: TextUtils(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: mainColor,
        text: 'الشروط والسياسات'.tr(),
      ),
      content: SingleChildScrollView(
        child: BlocBuilder<TermsCubit, TermsState>(
          builder: (BuildContext context, TermsState state) => _body(state),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: mainColor,
            text: 'فهمت'.tr(),
          ),
        ),
      ],
    );
  }

  /// A failed fetch degrades to a plain notice — it never prevents the user from
  /// consenting. The checkbox itself remains mandatory; only the *display*
  /// degrades. Blocking registration because a GET failed would be the worse
  /// outcome.
  Widget _body(TermsState state) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator(color: mainColor));
    }
    if (!state.hasText) {
      return TextUtils(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
        maxlines: 6,
        text: _TermsDialog._unavailable.tr(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: state.paragraphs
          .map(
            (String paragraph) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                maxlines: 100,
                text: '• $paragraph',
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  static const String _unavailable = TermsAgreement._unavailableMessage;
}
