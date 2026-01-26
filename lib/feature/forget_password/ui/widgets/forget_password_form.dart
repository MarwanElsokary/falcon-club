import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../signup/ui/widget/phone_auth_text_from_field.dart';
import '../../cubit/forget_password_cubit.dart';

class ForgetPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(String) onChanged;

  const ForgetPasswordForm({
    super.key,
    required this.formKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();

    return Form(
      key: formKey,
      child: PhoneAuthTextFormField(
        controller: cubit.phoneController,
        obscureText: false,
        validator: (v) {
          if (v == null || v.isEmpty) {
            return 'من فضلك تأكد من ادخال رقم الجوال'.tr();
          } else if (v.length != 11) {
            return 'رقم الجوال يجب أن يكون 11 أرقام'.tr();
          }
          return null;
        },
        textInputType: TextInputType.phone,
        hintText: "5X XXX XXXX",
        maxLength: 11,
        onChanged: (value) {
          onChanged(value);
        },
        suffix: const Icon(Icons.phone_android, color: Colors.grey, size: 20),
      ),
    );
  }
}
