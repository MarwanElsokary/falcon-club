import 'dart:developer';

import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/showSuccesSnackBar.dart';
import 'package:falconclubapp/core/widget/show_error_snack_bar.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/training_details/ui/widget/attmeps_allert_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slider_button/slider_button.dart';

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';

import '../../cubit/training_details_cubit.dart';
import '../../cubit/training_details_state.dart';
import '../../data/model/exercise_details_model.dart';
import 'choose_image_bottom_sheet_widget.dart';

class StartTrainingButton extends StatefulWidget {
  const StartTrainingButton({super.key, required this.exerciseDetails});
  final ExerciseDetailsModel exerciseDetails;

  @override
  State<StartTrainingButton> createState() => _StartTrainingButtonState();
}

class _StartTrainingButtonState extends State<StartTrainingButton> {
  File? selectedVideo;
  final ImagePicker _picker = ImagePicker();

  Future<void> getVideo(ImageSource source) async {
    try {
      final XFile? video = await _picker.pickVideo(source: source);
      if (video != null) {
        setState(() {
          selectedVideo = File(video.path); // File الفيديو المختار
          context.read<TrainingDetailsCubit>().videoPath =
              video.path; // حفظ المسار في الكيوبت
        });
        context.read<TrainingDetailsCubit>().emitAddAttemptStates(
          curexerciseId: '${widget.exerciseDetails.data.id ?? '0'}',
        );
      } else {
        // المستخدم لغى اختيار الفيديو
        log('No video selected.');
      }
    } catch (e) {
      log('Error picking video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocConsumer<TrainingDetailsCubit, TrainingDetailsState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is addAttemptError) {
            showErrorSnackBar(context: context, title: state.error);
          }
          if (state is addAttemptSuccess) {
            context.pushReplacementNamed(AppRoute.aiGenerateScreen);
            showSuccesSnackBar(context: context, title: 'تم رفع الفيدو بنجاح');
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000.r),
            ),
            child: Stack(
              children: [
                // البوردر Gradient
                GestureDetector(
                  onTap: () {
                    log('message');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000.r),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF5D2BF4),
                          Color(0xFFF4BE2B),
                          Color(0xFF5D2BF4),
                          Color(0xFF2BB8F4),
                        ],
                        stops: [0.0, 0.2596, 0.6916, 1.0],
                      ),
                    ),
                    padding: EdgeInsets.all(3), // سمك البوردر
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteclr, // خلفية داخلية
                        borderRadius: BorderRadius.circular(1000.r),
                      ),
                      child: SliderButton(
                        width: context.displayWidth / 1,
                        radius: 1000.r,
                        action: () async {
                          if (widget.exerciseDetails.data.attemptsCount == 0) {
                            showErrorSnackBar(
                              context: context,
                              title: 'ليس لديك محاولات يمكن استخدمها',
                            );
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true, // لو محتاج ارتفاع كامل
                              backgroundColor: whiteclr,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                ),
                              ),

                              builder: (c) => AttmepsAllertWidget(
                                onPressed: () {
                                  context.pop();
                                  chooseImageBootomShet(
                                    title: '',
                                    context: context,
                                    cameratab: () {
                                      getVideo(ImageSource.camera);
                                      context.pop();
                                    },
                                    galleryatab: () {
                                      getVideo(ImageSource.gallery);
                                      context.pop();
                                    },
                                  );
                                },
                                exerciseDetails: widget.exerciseDetails,
                              ),
                            );
                          }
                          print("تم السحب");
                          return false;
                        },
                        label: TextUtils(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          text: 'قم بالسحب لبدأ التمرين',
                        ),
                        icon: Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: AlignmentDirectional.centerStart,
                              end: AlignmentDirectional.centerEnd,
                              colors: [Color(0xFFEBCD38), Color(0xFF5D2BF4)],
                              stops: [0.0, 1.0],
                            ),
                          ),
                          padding: EdgeInsets.all(12.w),
                          child: SvgPicture.asset(
                            'assets/svgs/solar_football-broken.svg',
                            width: 24.w,
                          ),
                        ),
                        buttonColor: Colors.transparent,
                        backgroundColor: whiteclr,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
