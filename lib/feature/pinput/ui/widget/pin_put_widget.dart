// file name: pin_put_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../../login/cubit/login_cubit.dart';

class PinPutWidget extends StatelessWidget {
  const PinPutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: 6,
        controller: cubit.controller.verifyCode,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        showCursor: true,
        autofocus: true,
        keyboardType: TextInputType.number,

        // 👇 ده اللي هيخلي الزرار يتفعل تلقائياً
        onChanged: (value) {
          // مش محتاج تعمل حاجة هنا لأن احنا بنستمع للـ controller
          // في PinPutButtonWidget باستخدام ValueListenableBuilder
        },

        // 🚀 OPTIONAL: لو عايز التحقق يحصل أوتوماتيكياً بعد كتابة 6 أرقام
        onCompleted: (pin) {
          // هيتنفذ لما المستخدم يكمل كتابة 6 أرقام
          cubit.verifyOtp();
        },
      ),
    );
  }
}