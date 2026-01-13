import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/thems/thems.dart';
import '../../cubit/forget_password_cubit.dart';

// ignore: must_be_immutable
class PinPutWidgetForget extends StatelessWidget {
  const PinPutWidgetForget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width / 1,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
          length: 6,
          onChanged: (value) {
            // استخدام ForgetPasswordCubit بدلاً من LoginCubit
            final cubit = context.read<ForgetPasswordCubit>();
            cubit.otpController.text = value;

            // تفعيل/تعطيل زر التحقق
            cubit.updateVerifyButtonState(value.length);
          },
          onCompleted: (v) {
            // عند اكتمال الرمز، التحقق تلقائياً
            final cubit = context.read<ForgetPasswordCubit>();
            cubit.otpController.text = v;
            if (v.length == 6) {
              cubit.verifyOtp();
            }
          },
          focusedPinTheme: PinTheme(
            height: 47.w,
            width: 62.w,
            textStyle: const TextStyle(fontSize: 20),
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: mainColor, width: 1.8.w),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          defaultPinTheme: PinTheme(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            height: 45.w,
            width: 60.w,
            textStyle: const TextStyle(fontSize: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: greyClr),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}