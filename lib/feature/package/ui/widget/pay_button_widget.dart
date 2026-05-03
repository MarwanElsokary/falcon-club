import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/button_utils.dart';
import 'package:falconclubapp/core/widget/loading_button_utils.dart';
import 'package:falconclubapp/core/widget/padding_nav_bar.dart';
import 'package:falconclubapp/core/widget/showSuccesSnackBar.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
import 'package:falconclubapp/feature/package/cubit/package_cubit.dart';
import 'package:falconclubapp/feature/package/data/model/pakcage_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
import '../../../../core/widget/text_utils.dart';
import '../../cubit/package_state.dart';

class PayButtonWidget extends StatefulWidget {
  const PayButtonWidget({super.key, required this.packageModel});

  final PackageModel packageModel;

  @override
  State<PayButtonWidget> createState() => _PayButtonWidgetState();
}

class _PayButtonWidgetState extends State<PayButtonWidget> {
  bool _agreedToTerms = false;
  List<String> _termsAndPolicies = [];

  @override
  void initState() {
    super.initState();
    _loadTermsAndPolicies();
  }

  void _loadTermsAndPolicies() {
    final cubit = context.read<PackageCubit>();
    _termsAndPolicies = cubit.termsAndPolicies;

    if (_termsAndPolicies.isEmpty) {
      cubit.getTermsAndPolicies().then((_) {
        if (mounted) {
          setState(() {
            _termsAndPolicies = cubit.termsAndPolicies;
          });
        }
      });
    }
  }

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

                if (response['requiresVerification'] == true &&
                    response['verificationUrl'] != null) {
                  _launchVerificationUrl(response['verificationUrl'], context);
                } else if (response['success'] == true) {
                  showSuccesSnackBar(
                    context: context,
                    title: 'مبروك تم الاشتراك في الباقه بنجاح',
                  );
                  context.pushNamedAndRemoveUntil(
                    AppRoute.clubMainScreen,
                    predicate: (route) => false,
                  );
                } else {
                  showErrorSnackBar(
                    title: response['message'] ?? 'فشلت عملية الدفع',
                    context: context,
                  );
                }
              },
              payPackageerror: (error) {
                showErrorSnackBar(context: context, title: error);
              },
            );
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔥 Checkbox الموافقة على الشروط والأحكام
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                        activeColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              fontFamily: 'Cairo',
                            ),
                            children: [
                              TextSpan(text: 'أوافق على '.tr()),
                              TextSpan(
                                text: 'الشروط والسياسيات'.tr(),
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _showTermsDialog(context);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                verticalSpace(15),

                // 🔥 زر الدفع
                state.maybeWhen(
                  payPackageloading: () => LoadButtonUtils(),
                  orElse: () => ButtonUtils(
                    text:
                    '${'قم بالدفع : '.tr()}${widget.packageModel.price.toString()}${'ر.س'.tr()}',
                    onPressed: () async {
                      // 🔥 التحقق من الموافقة على الشروط
                      if (!_agreedToTerms) {
                        showErrorSnackBar(
                          context: context,
                          title: 'يجب الموافقة على الشروط والسياسيات للمتابعة'
                              .tr(),
                        );
                        return;
                      }

                      final formKey = context.read<PackageCubit>().formKey;
                      if (formKey.currentState?.validate() ?? false) {
                        final cubit = context.read<PackageCubit>();
                        final cardNumber = cubit.controller.cardNumber.text;
                        final cardName = cubit.controller.cardName.text;
                        final cvv = cubit.controller.cvv.text;
                        final expireData = cubit.controller.expireData.text;

                        if (cardNumber.isEmpty ||
                            cardName.isEmpty ||
                            cvv.isEmpty ||
                            expireData.isEmpty) {
                          showErrorSnackBar(
                            title: 'من فضلك تأكد من إدخال جميع البيانات'.tr(),
                            context: context,
                          );
                          return;
                        }

                        if (cardNumber.replaceAll(' ', '').length != 16) {
                          showErrorSnackBar(
                            title: 'رقم البطاقة يجب أن يكون 16 رقم'.tr(),
                            context: context,
                          );
                          return;
                        }

                        if (cvv.length != 3) {
                          showErrorSnackBar(
                            title: 'رمز التحقق يجب أن يكون 3 أرقام'.tr(),
                            context: context,
                          );
                          return;
                        }

                        if (!RegExp(
                          r'^(0[1-9]|1[0-2])\/\d{2}$',
                        ).hasMatch(expireData)) {
                          showErrorSnackBar(
                            title: 'تاريخ الانتهاء غير صحيح'.tr(),
                            context: context,
                          );
                          return;
                        }

                        context.read<PackageCubit>().emitpayPackageStates(
                          packageId: widget.packageModel.id,
                        );
                      } else {
                        showErrorSnackBar(
                          title: 'من فضلك تأكد من صحة البيانات المدخلة'.tr(),
                          context: context,
                        );
                      }
                    },
                    colorstext: Colors.white,
                    background: mainColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 🔥 Dialog للشروط والأحكام
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: TextUtils(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: mainColor,
          text: 'الشروط والسياسيات'.tr(),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_termsAndPolicies.isEmpty)
                Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _termsAndPolicies
                      .map((term) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: TextUtils(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      text: '• $term',
                    ),
                  ))
                      .toList(),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: mainColor,
              text: 'فهمت'.tr(),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _launchVerificationUrl(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        print('Verification URL opened in browser');

        await Future.delayed(const Duration(seconds: 1));

        context.pushNamedAndRemoveUntil(
          AppRoute.clubMainScreen,
          predicate: (route) => false,
        );
      } else {
        print('Cannot launch URL: $url');
        showErrorSnackBar(
          title: 'حدث خطأ في فتح صفحة التحقق',
          context: context,
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      showErrorSnackBar(title: 'حدث خطأ: $e', context: context);
    }
  }
}