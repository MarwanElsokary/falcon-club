// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:slider_button/slider_button.dart';
// import 'dart:io';
//
// import '../../../core/helpers/constants.dart';
// import '../../../core/helpers/extensions.dart';
// import '../../../core/helpers/shared_pref_helper.dart';
// import '../../../core/helpers/spacing.dart';
// import '../../../core/thems/thems.dart';
// import '../../../core/widget/block_animation.dart';
// import '../../../core/widget/show_error_snack_bar.dart';
// import '../../../core/widget/text_utils.dart';
// import '../../training_details/ui/widget/choose_image_bottom_sheet_widget.dart';
// import '../cubit/MeasurementCubit.dart';
// import '../cubit/measurement_state.dart';
//
// class MeasurementCaptureWidget extends StatelessWidget {
//   const MeasurementCaptureWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<MeasurementCubit, MeasurementState>(
//       listener: (context, state) {
//         if (state is _UploadError) {
//           showErrorSnackBar(context: context, title: state.error);
//         }
//       },
//       builder: (context, state) {
//         final hasImage = state is _ImageSelected;
//         final imagePath = hasImage ? (state as _ImageSelected).imagePath : '';
//
//         return SizedBox(
//           width: context.displayWidth,
//           height: context.displayHeight,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Image preview area (similar to story widget)
//                 Container(
//                   width: context.displayWidth,
//                   height: context.displayHeight / 1.22,
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadiusDirectional.only(
//                       bottomStart: Radius.circular(30.r),
//                       bottomEnd: Radius.circular(30.r),
//                     ),
//                   ),
//                   child: hasImage
//                       ? _buildImagePreview(imagePath)
//                       : _buildPlaceholder(context),
//                 ),
//
//                 verticalSpace(10),
//
//                 // Info section
//                 _buildInfoSection(context, hasImage, imagePath),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildImagePreview(String path) {
//     return ClipRRect(
//       borderRadius: BorderRadiusDirectional.only(
//         bottomStart: Radius.circular(30.r),
//         bottomEnd: Radius.circular(30.r),
//       ),
//       child: Image.file(
//         File(path),
//         fit: BoxFit.cover,
//       ),
//     );
//   }
//
//   Widget _buildPlaceholder(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BlockAnimation(
//             lottiePath: 'assets/lottie/measurement_placeholder.json',
//             width: 200.w,
//           ),
//           verticalSpace(20),
//           TextUtils(
//             fontSize: 24,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//             text: 'القياسات بالذكاء الاصطناعي',
//           ),
//           verticalSpace(10),
//           TextUtils(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: Colors.white.withOpacity(0.7),
//             text: 'التقط صورة لبدء القياس',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoSection(BuildContext context, bool hasImage, String imagePath) {
//     final cubit = context.read<MeasurementCubit>();
//
//     return Container(
//       width: context.displayWidth,
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
//       decoration: BoxDecoration(
//         color: whiteclr,
//         borderRadius: BorderRadiusDirectional.only(
//           topStart: Radius.circular(25.r),
//           topEnd: Radius.circular(25.r),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Handle
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               width: 80.w,
//               height: 5.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100.r),
//                 color: greyClr.withOpacity(0.5),
//               ),
//             ),
//           ),
//
//           verticalSpace(20),
//
//           // Title
//           TextUtils(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: Colors.black,
//             text: 'قياس الجسم بالذكاء الاصطناعي',
//           ),
//
//           verticalSpace(15),
//
//           // Instructions
//           _buildInstructionsExpansion(),
//
//           verticalSpace(20),
//
//           // Start button (similar to training)
//           _buildStartButton(context, hasImage, imagePath, cubit),
//
//           verticalSpace(100),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInstructionsExpansion() {
//     return Theme(
//       data: ThemeData(dividerColor: Colors.transparent),
//       child: ExpansionTile(
//         tilePadding: EdgeInsets.zero,
//         childrenPadding: EdgeInsets.zero,
//         title: TextUtils(
//           fontSize: 13,
//           fontWeight: FontWeight.w700,
//           color: Colors.black,
//           text: 'تعليمات التصوير',
//         ),
//         children: [
//           _buildInstruction('تأكد من وضوح الصورة', Icons.high_quality),
//           _buildInstruction('الوقوف بشكل مستقيم', Icons.accessibility_new),
//           _buildInstruction('خلفية فاتحة ومتناقضة', Icons.palette_outlined),
//           _buildInstruction('عدم وجود أشياء أخرى', Icons.person_remove),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInstruction(String text, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 5.h),
//       child: Row(
//         children: [
//           Icon(icon, size: 16.w, color: mainColor),
//           horizontalSpace(10),
//           Expanded(
//             child: TextUtils(
//               fontSize: 13,
//               fontWeight: FontWeight.w400,
//               color: blackclr,
//               text: text,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStartButton(
//       BuildContext context,
//       bool hasImage,
//       String imagePath,
//       MeasurementCubit cubit,
//       ) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(1000.r),
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF5D2BF4),
//               Color(0xFFF4BE2B),
//               Color(0xFF5D2BF4),
//               Color(0xFF2BB8F4),
//             ],
//             stops: [0.0, 0.2596, 0.6916, 1.0],
//           ),
//         ),
//         padding: EdgeInsets.all(3),
//         child: Container(
//           decoration: BoxDecoration(
//             color: whiteclr,
//             borderRadius: BorderRadius.circular(1000.r),
//           ),
//           child: SliderButton(
//             width: context.displayWidth,
//             radius: 1000.r,
//             action: () async {
//               if (hasImage) {
//                 // Upload
//                 final userId = await SharedPrefHelper.getSecuredString(
//                   SharedPrefKeys.userId,
//                 );
//                 if (userId != null) {
//                   cubit.uploadMeasurement(
//                     imagePath: imagePath,
//                     userId: userId,
//                   );
//                 }
//               } else {
//                 // Show bottom sheet
//                 _showImagePickerSheet(context, cubit);
//               }
//               return false;
//             },
//             label: TextUtils(
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//               text: hasImage ? 'قم بالسحب لبدء القياس' : 'قم بالسحب لالتقاط صورة',
//             ),
//             icon: Container(
//               width: 100.w,
//               height: 100.w,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFEBCD38), Color(0xFF5D2BF4)],
//                 ),
//               ),
//               padding: EdgeInsets.all(12.w),
//               child: Icon(
//                 hasImage ? Icons.upload : Icons.camera_alt,
//                 color: Colors.white,
//                 size: 24.w,
//               ),
//             ),
//             buttonColor: Colors.transparent,
//             backgroundColor: whiteclr,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showImagePickerSheet(BuildContext context, MeasurementCubit cubit) {
//     chooseImageBootomShet(
//       title: '',
//       context: context,
//       cameratab: () async {
//         context.pop();
//         final picker = ImagePicker();
//         final image = await picker.pickImage(source: ImageSource.camera);
//         if (image != null) {
//           cubit.selectImage(image.path);
//         }
//       },
//       galleryatab: () async {
//         context.pop();
//         final picker = ImagePicker();
//         final image = await picker.pickImage(source: ImageSource.gallery);
//         if (image != null) {
//           cubit.selectImage(image.path);
//         }
//       },
//     );
//   }
// }