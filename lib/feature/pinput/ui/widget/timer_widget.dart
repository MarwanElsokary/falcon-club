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
import '../../../login/cubit/login_cubit.dart';
import '../../../login/cubit/login_state.dart';

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

  // "Send Again"
  void _restartCountdown() {
    setState(() {
      _isDone = false; // Reset the done
      _duration = const Duration(
        seconds: 60,
      ); // Reset the duration to 60 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isDone
        ? AnimateBuilder(
            columnCount: 1,
            position: 0,
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is Success) {
                  showSuccesSnackBar(
                    context: context,
                    title: 'تم اعاده ارسال الكود بنجاح'.tr(),
                  );
                  _restartCountdown;
                }

                if (state is Error) {
                  showErrorSnackBar(
                    context: context,
                    title: 'من فضلك حاول وقت اخر.'.tr(),
                  );
                }
              },
              builder: (context, state) {
                return TextButtonUtils(
                  onPressed: () {
                    //resend otp
                    context.read<LoginCubit>().controller.phone.text =
                        widget.phoneNumber;
                    // context.read<LoginCubit>().emitloginStates();
                    // _restartCountdown;
                  },
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: state is Loading ? greyClr : blackclr,
                  text: state is Loading
                      ? 'أعد الإرسال...'.tr()
                      : 'لم تستلم الرمز؟ أعد الإرسال'.tr(),
                );
              },
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  //resend otp
                  context.read<LoginCubit>().controller.phone.text =
                      widget.phoneNumber;
                  // context.read<LoginCubit>().emitloginStates();
                  // _restartCountdown;
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
                  duration: _duration, // Show the countdown duration
                  decoration: const BoxDecoration(color: Colors.transparent),
                  style: const TextStyle(
                    color: blackclr,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  onDone: _onDone, // Trigger _onDone when countdown finishes
                ),
              ),
            ],
          );
  }
}
