import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/button_utils.dart';
import 'package:falcon/core/widget/loading_button_utils.dart';
import 'package:falcon/core/widget/padding_nav_bar.dart';
import 'package:falcon/core/widget/showSuccesSnackBar.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:falcon/feature/package/cubit/package_cubit.dart';
import 'package:falcon/feature/package/data/model/pakcage_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/package_state.dart';

class PayButtonWidget extends StatelessWidget {
  const PayButtonWidget({super.key, required this.packageModel});
  final PackageModel packageModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingNavBar(),
      child: SlideEnimationWidget(
        index: 0,
        child: BlocConsumer<PackageCubit, PackageState>(
          listener: (context, state) {
            state.whenOrNull(
              payPackagesuccess: (response) {
                print('Payment Response: $response');

                // تحقق من الـ response
                if (response['requiresVerification'] == true &&
                    response['verificationUrl'] != null) {
                  // افتح صفحة الـ verification في متصفح خارجي
                  _launchVerificationUrl(response['verificationUrl'], context);
                } else if (response['success'] == true) {
                  // الدفع نجح مباشرة بدون verification
                  showSuccesSnackBar(
                    context: context,
                    title: 'مبروك تم الاشتراك في الباقه بنجاح',
                  );
                  context.pushNamedAndRemoveUntil(
                    AppRoute.mainScreen,
                    predicate: (route) => false,
                  );
                } else {
                  // الدفع فشل
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response['message'] ?? 'فشلت عملية الدفع'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              payPackageerror: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              payPackageloading: () => LoadButtonUtils(),
              orElse: () => ButtonUtils(
                text:
                '${'قم بالدفع : '.tr()}${packageModel.price.toString()}${'ر.س'.tr()}',
                onPressed: () async {
                  final formKey = context.read<PackageCubit>().formKey;
                  if (formKey.currentState?.validate() ?? false) {
                    // تحقق صحة البيانات
                    final cubit = context.read<PackageCubit>();
                    final cardNumber = cubit.controller.cardNumber.text;
                    final cardName = cubit.controller.cardName.text;
                    final cvv = cubit.controller.cvv.text;
                    final expireData = cubit.controller.expireData.text;

                    // تحقق من صحة البيانات الأساسية
                    if (cardNumber.isEmpty ||
                        cardName.isEmpty ||
                        cvv.isEmpty ||
                        expireData.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('من فضلك تأكد من إدخال جميع البيانات'.tr()),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // تحقق من صحة رقم البطاقة (16 رقم)
                    if (cardNumber.replaceAll(' ', '').length != 16) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('رقم البطاقة يجب أن يكون 16 رقم'.tr()),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // تحقق من صحة CVV (3 أرقام)
                    if (cvv.length != 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('رمز التحقق يجب أن يكون 3 أرقام'.tr()),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // تحقق من صحة تاريخ الانتهاء
                    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(expireData)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تاريخ الانتهاء غير صحيح'.tr()),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // إذا كانت كل البيانات صحيحة، قم بالدفع
                    context.read<PackageCubit>().emitpayPackageStates(
                      packageId: packageModel.id,
                    );
                  } else {
                    // إذا كانت البيانات غير صحيحة، عرض رسالة خطأ
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('من فضلك تأكد من صحة البيانات المدخلة'.tr()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                colorstext: Colors.white,
                background: mainColor,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchVerificationUrl(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        print('Verification URL opened in browser');

        // انتظر ثانية واحدة ثم ارجع إلى الشاشة الرئيسية مباشرة
        await Future.delayed(const Duration(seconds: 1));

        // العودة إلى الشاشة الرئيسية
        context.pushNamedAndRemoveUntil(
          AppRoute.mainScreen,
          predicate: (route) => false,
        );
      } else {
        print('Cannot launch URL: $url');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ في فتح صفحة التحقق'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}