import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falcon/core/helpers/spacing.dart';

import 'package:falcon/core/widget/text_utils.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/padding_utils.dart';

import '../../../login/cubit/login_cubit.dart';
import '../../../login/cubit/login_state.dart';
import '../widget/pin_put_button_widget.dart';
import '../widget/pin_put_widget.dart';
import '../widget/timer_widget.dart';

class PinputScreen extends StatelessWidget {
  const PinputScreen({super.key, required this.phoneNumber});
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteclr,
      appBar: AppBar(backgroundColor: whiteclr),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.w),
        child: PinPutButtonWidget(phoneNumber: phoneNumber),
      ),
      body: SafeArea(
        child: Container(
          padding: paddingUtils(),
          child: SingleChildScrollView(
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUtils(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: 'التحقق'.tr(),
                    ),
                    verticalSpace(10),
                    TextUtils(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: blackclr,
                      text:
                          '${'أرسلنا رمزًا إلى الاميل الخاص بك'.tr()} $phoneNumber',
                    ),
                    verticalSpace(25),

                    //pinput
                    const PinPutWidget(),
                    verticalSpace(15),
                    //timer
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TimerWidget(phoneNumber: phoneNumber),
                    ),
                    verticalSpace(30),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
