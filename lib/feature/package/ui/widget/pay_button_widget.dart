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
            if (state is payPackageSuccess) {
              showSuccesSnackBar(
                context: context,
                title: 'مبروك تم الاشتراك في الباقه بنجاح'.tr(),
              );
              context.pushNamedAndRemoveUntil(
                AppRoute.mainScreen,
                predicate: (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is payPackageLoading) {
              return LoadButtonUtils();
            }
            return ButtonUtils(
              text:
                  '${'قم بالدفع : '.tr()}${packageModel.price.toString()}${'ر.س'.tr()}',
              onPressed: () {
                context.read<PackageCubit>().emitpayPackageStates(
                  packageId: packageModel.id,
                );
              },
              colorstext: Colors.white,
              background: mainColor,
            );
          },
        ),
      ),
    );
  }
}
