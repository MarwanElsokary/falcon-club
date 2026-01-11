// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/thems/thems.dart';
import '../../../login/cubit/login_cubit.dart';

// ignore: must_be_immutable
class PinPutWidget extends StatelessWidget {
  const PinPutWidget({super.key});

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
            context.read<LoginCubit>().changeVerifyButtonStatus(value.length);
          },
          onCompleted: (v) {
            context.read<LoginCubit>().controller.verifyCode.text = v;
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
