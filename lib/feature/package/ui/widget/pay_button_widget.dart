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
                  // افتح صفحة الـ verification
                  context.pushNamed(
                    AppRoute.paymentVerificationScreen,
                    arguments: {
                      'verificationUrl': response['verificationUrl'],
                      'packageId': packageModel.id,
                    },
                  );
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
                onPressed: () {
                  final formKey = context.read<PackageCubit>().formKey;
                  if (formKey.currentState?.validate() ?? false) {
                    context.read<PackageCubit>().emitpayPackageStates(
                      packageId: packageModel.id,
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
}
