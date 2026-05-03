import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/show_error_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/text_utils.dart';
import '../../creat_real/ui/widget/upload_progras_widget.dart';
import '../cubit/MeasurementCubit.dart';
import '../cubit/measurement_state.dart';
import 'MeasurementImageUploadWidget.dart';
import 'MeasurementResultWidget.dart';
import 'UploadProgressWidget.dart';

class MeasurementScreen extends StatelessWidget {
  const MeasurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: BlocConsumer<MeasurementCubit, MeasurementState>(
        listener: (context, state) {
          state.maybeWhen(
            uploadError: (error) {
              showErrorSnackBar(context: context, title: error);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Main content
              Column(
                children: [
                  SafeArea(
                    child: Row(
                      children: [
                        const  BackButton(color: Colors.white),
                        Expanded(
                          child: TextUtils(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            text: 'الرجوع'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Show result or upload widget
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: state.maybeWhen(
                        uploadSuccess: (measurement) =>
                            MeasurementResultWidget(measurement: measurement),
                        orElse: () => const MeasurementImageUploadWidget(),
                      ),
                    ),
                  ),
                ],
              ),

              // Upload progress overlay
              if (state is UploadLoading || state is UploadProgress)
                const Positioned.fill(child: UploadProgressWidgets()),
            ],
          );
        },
      ),
    );
  }
}
