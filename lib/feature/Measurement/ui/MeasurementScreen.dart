import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/extensions.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/thems/thems.dart';
import '../../../core/widget/padding_utils.dart';
import '../cubit/MeasurementCubit.dart';
import '../cubit/measurement_state.dart';
import 'MeasurementImageUploadWidget.dart';
import 'MeasurementInstructionsWidget.dart';
import 'MeasurementResultWidget.dart';
import 'UploadProgressWidget.dart';

class MeasurementScreen extends StatelessWidget {
  const MeasurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background decoration
          SizedBox(
            height: context.displayHeight,
            width: context.displayWidth,
          ),

          // Content
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            top: 10.w,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Back button
                    Visibility(
                      visible: Navigator.canPop(context),
                      child: Row(
                        children: [
                          const BackButton(color: Colors.black),
                          Expanded(
                            child: Text(
                              'الرجوع',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    verticalSpace(10),

                    // Title
                    Padding(
                      padding: paddingUtils(),
                      child: Text(
                        'القياسات بالذكاء الاصطناعي'.tr(),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ),

                    verticalSpace(20),

                    // Instructions
                    const MeasurementInstructionsWidget(),

                    verticalSpace(30),

                    // Image upload
                    const MeasurementImageUploadWidget(),

                    verticalSpace(30),

                    // Result or Upload button
                    BlocBuilder<MeasurementCubit, MeasurementState>(
                      builder: (context, state) {
                        if (state is MeasurementInitial) {
                          return const SizedBox.shrink();
                        } else if (state is UploadLoading) {
                          return UploadProgressWidget();
                        } else if (state is UploadProgress) {
                          return UploadProgressWidget(progress: state.progress);
                        } else if (state is UploadSuccess) {
                          return MeasurementResultWidget(measurement: state.measurement);
                        } else if (state is UploadError) {
                          return Padding(
                            padding: paddingUtils(),
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red, size: 24.sp),
                                  horizontalSpace(12),
                                  Expanded(
                                    child: Text(
                                      state.error,
                                      style: TextStyle(
                                        color: Colors.red.shade900,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}