import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/app_bar_utils.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/package/data/model/pakcage_model.dart';
import 'package:falcon/feature/package/ui/widget/pay_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/choose_pay_ment_method.dart';
import '../widget/input_payment_method_widget.dart';

class PackagePayMentScreen extends StatelessWidget {
  const PackagePayMentScreen({super.key, required this.packageModel});
  final PackageModel packageModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtils(context: context, title: 'طريقة الدفع'.tr()),
      bottomNavigationBar: PayButtonWidget(packageModel: packageModel),
      body: Container(
        padding: paddingUtils(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: mainColor,
                text: 'كمّل اشتراكك واختر الطريقة اللي تناسبك. الدفع آمن وسريع.'
                    .tr(),
              ),
              verticalSpace(20),
              //
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  image: DecorationImage(
                    image: AssetImage('assets/images/Frame 1079.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextUtils(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        text: packageModel.name ?? 'الخطة المدفوعة'.tr(),
                      ),
                    ),
                    TextUtils(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      text: '${packageModel.price.toString()}ر.س'.tr(),
                    ),
                  ],
                ),
              ),
              verticalSpace(20),
              //choose payment method
              ChoosePayMentMethod(),
              verticalSpace(20),
              //input payMent Method data
              InputPaymentMethodWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
