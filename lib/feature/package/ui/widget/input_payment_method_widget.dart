import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/package/cubit/package_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/text_from_field_utils_widget.dart';
import 'visa_expiry_text_form_field.dart';

class InputPaymentMethodWidget extends StatelessWidget {
  const InputPaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<PackageCubit>().formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUtils(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: 'رقم البطاقة'.tr(),
          ),
          verticalSpace(10),
          //card number
          TextFromFieldUtilsWidget(
            controller: context.read<PackageCubit>().controller.cardNumber,
            obscureText: false,
            validator: (v) {
              if (v!.isEmpty) {
                return 'من فضلك تأكد من ادخال رقم البطاقة'.tr();
              }
              return null;
            },
            fillColor: fillColor,
            textInputType: TextInputType.text,
            hintText: '**** ****  ****  ****',

            textInputAction: TextInputAction.next,
          ),
          verticalSpace(20),
          TextUtils(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: 'اسم صاحب البطاقة'.tr(),
          ),
          verticalSpace(10),
          //card name
          TextFromFieldUtilsWidget(
            controller: context.read<PackageCubit>().controller.cardName,
            obscureText: false,
            validator: (v) {
              if (v!.isEmpty) {
                return 'من فضلك تأكد من ادخال الاسم الموجود علي البطاقة'.tr();
              }
              return null;
            },
            fillColor: fillColor,
            textInputType: TextInputType.text,
            hintText: 'اكتب الاسم الموجود علي البطاقة'.tr(),
            textInputAction: TextInputAction.next,
          ),
          verticalSpace(20),
          Row(
            children: [
              //رمز التحقق
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUtils(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: 'رمز التحقق'.tr(),
                    ),
                    verticalSpace(10),
                    //card name
                    TextFromFieldUtilsWidget(
                      maxLength: 3,
                      controller: context.read<PackageCubit>().controller.cvv,
                      obscureText: false,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return 'من فضلك تأكد من ادخال رمز التحقق'.tr();
                        }
                        return null;
                      },
                      fillColor: fillColor,
                      textInputType: TextInputType.text,
                      hintText: 'ادخل رمز التحقق'.tr(),
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              horizontalSpace(20),
              //تاريخ الانتهاء
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUtils(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: 'تاريخ الانتهاء'.tr(),
                    ),
                    verticalSpace(10),
                    //card exoire
                    VisaExpiryTextFormField(
                      controller: context
                          .read<PackageCubit>()
                          .controller
                          .expireData,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
