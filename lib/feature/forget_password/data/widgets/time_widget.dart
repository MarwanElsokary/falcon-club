import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/anmiate_builder.dart';
import '../../../../core/widget/showSuccesSnackBar.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
import '../../../../core/widget/text_button_utils.dart';
import '../../../../core/widget/text_utils.dart';
import '../../cubit/forget_password_cubit.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration _duration = const Duration(seconds: 60);
  bool _isDone = false;

  void _onDone() {
    setState(() {
      _isDone = true;
    });
  }

  void _restartCountdown() {
    setState(() {
      _isDone = false;
      _duration = const Duration(seconds: 60);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isDone
        ? AnimateBuilder(
            columnCount: 1,
            position: 0,
            child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
              listener: (context, state) {
                state.whenOrNull(
                  otpSent: (message) {
                    showSuccesSnackBar(
                      context: context,
                      title: 'تم اعاده ارسال الكود بنجاح'.tr(),
                    );
                    _restartCountdown();
                  },
                  error: (message) {
                    showErrorSnackBar(
                      context: context,
                      title: 'من فضلك حاول وقت اخر.'.tr(),
                    );
                  },
                );
              },
              builder: (context, state) {
                final cubit = context.read<ForgetPasswordCubit>();

                // التحقق من حالة التحميل باستخدام maybeWhen
                bool isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                return Align(
                  alignment: Alignment.centerRight,
                  child: TextButtonUtils(
                    onPressed: () {
                      if (!isLoading) {
                        cubit.phoneController.text = widget.phoneNumber;
                        cubit.resendOtp();
                        _restartCountdown();
                      }
                    },
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isLoading ? mainColor : mainColor,
                    text: isLoading
                        ? 'أعد الإرسال...'.tr()
                        : 'لم تستلم الرمز؟ أعد الإرسال'.tr(),
                  ),
                );
              },
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  final cubit = context.read<ForgetPasswordCubit>();
                  cubit.phoneController.text = widget.phoneNumber;
                  cubit.resendOtp();
                  _restartCountdown();
                },
                child: TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: blackclr,
                  text: 'إعادة الإرسال'.tr(),
                ),
              ),
              Localizations.override(
                context: context,
                locale: const Locale('en'),
                child: SlideCountdown(
                  duration: _duration,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  style: const TextStyle(
                    color: blackclr,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  onDone: _onDone,
                ),
              ),
            ],
          );
  }
}
