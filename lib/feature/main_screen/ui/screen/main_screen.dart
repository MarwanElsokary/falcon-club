// import 'dart:developer';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:falconclubapp/core/helpers/extensions.dart';
// import 'package:falconclubapp/core/helpers/spacing.dart';
// import 'package:falconclubapp/core/routing/routes.dart';
// import 'package:falconclubapp/core/widget/center_text_utils.dart';
// import 'package:falconclubapp/feature/experiments/cubit/experiments_cubit.dart';
// import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
//
// import '../../../../core/di/dependency_injection.dart';
// import '../../../../core/thems/thems.dart';
// import '../../../creat_real/ui/screen/creat_real_screen.dart';
// import '../../../experiments/ui/screen/experiment_screen.dart';
// import '../../../home/ui/screen/home_screen.dart';
// import '../../../reals/ui/screen/main_reals_screen.dart';
// import '../../../signup/ui/widget/profile_completion_middleware.dart';
// import '../../../signup/ui/widget/profile_completion_progress.dart';
// import '../../../training/cubit/training_cubit.dart';
// import '../../../training/ui/screen/training_screen.dart';
// import '../../cubit/main_cubit.dart';
// import '../widget/custom_drawer_widget.dart';
// import '../widget/upload_button_widget.dart';
//
// // ignore: must_be_immutable
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // 🔥 تفعيل استدعاء الـ API
//     context.read<MainCubit>().emitMyProfile();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: context.read<MainCubit>().sliderDrawerKey,
//       drawer: CustomDrawer(),
//
//       body: Stack(
//         children: [
//           IndexedStack(
//             index: context.read<MainCubit>().currentIndex.value,
//             children: [
//               MultiBlocProvider(
//                 providers: [
//                   BlocProvider(
//                     create: (context) =>
//                     getIt<ExperimentsCubit>()
//                       ..emitbestTrials(categoryId: ''),
//                   ),
//                   BlocProvider(
//                     create: (context) =>
//                     getIt<TrainingCubit>()
//                       ..emitallExercises(categoryId: '', popular: true),
//                   ),
//                 ],
//                 child: const HomeScreen(),
//               ),
//
//               BlocProvider(
//                 create: (context) => getIt<ExperimentsCubit>()
//                   ..emitallTrials(categoryId: '')
//                   ..emitbestTrials(categoryId: ''),
//                 child: const ExperimentScreen(),
//               ),
//
//               CreatRealScreen(
//                 playAnimation:
//                 context.read<MainCubit>().currentIndex.value == 2,
//               ),
//               BlocProvider(
//                 create: (context) =>
//                 getIt<TrainingCubit>()
//                   ..emitallExercises(categoryId: '', popular: false),
//                 child: const TrainingScreen(),
//               ),
//               BlocProvider(
//                 create: (context) => getIt<RealsCubit>()
//                   ..emitreals(playerId: ''),
//                 child: MainRealsScreen(
//                   playerProfile: false,
//                   playnowOrNot: context.read<MainCubit>().openProfile
//                       ? false
//                       : context.read<MainCubit>().currentIndex.value == 4,
//                 ),
//               ),
//             ],
//           ),
//           PositionedDirectional(
//             bottom: 0,
//             start: 0,
//             end: 0,
//             child: ValueListenableBuilder(
//               valueListenable: context.read<MainCubit>().currentIndex,
//               builder: (context, currentIndex, _) {
//                 log(currentIndex.toString());
//                 return ValueListenableBuilder(
//                   valueListenable: context.read<MainCubit>().show,
//                   builder: (context, show, _) {
//                     return AnimatedContainer(
//                       duration: Duration(milliseconds: 300),
//                       width: context.displayWidth / 1,
//                       height: show ? 130.h : 0,
//
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             SlideEnimationWidget(
//                               index: 0,
//                               child: Stack(
//                                 children: [
//                                   Column(
//                                     children: [
//                                       verticalSpace(50),
//                                       Container(
//                                         height: 80.h,
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                             fit: BoxFit.fill,
//                                             image: AssetImage(
//                                               'assets/images/Subtract.png',
//                                             ),
//                                           ),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                           children: List.generate(5, (index) {
//                                             bool isSelected =
//                                                 currentIndex == index;
//
//                                             return Expanded(
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   if (index != 2) {
//                                                     setState(() {
//                                                       context
//                                                           .read<MainCubit>()
//                                                           .currentIndex
//                                                           .value =
//                                                           index;
//                                                     });
//                                                   }
//                                                   print(currentIndex);
//                                                 },
//                                                 splashColor: Colors.transparent,
//                                                 highlightColor:
//                                                 Colors.transparent,
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                                   children: [
//                                                     // Icon
//                                                     SizedBox(
//                                                       height: isSelected
//                                                           ? 26.h
//                                                           : 24.h,
//                                                       width: isSelected
//                                                           ? 26.h
//                                                           : 24.h,
//                                                       child: isSelected
//                                                           ? listOfActiveIcons[index]
//                                                           : listOfInactiveIcons[index],
//                                                     ),
//                                                     CenterTextUtils(
//                                                       fontSize: 10,
//                                                       fontWeight: isSelected
//                                                           ? FontWeight.w700
//                                                           : FontWeight.w500,
//                                                       color: isSelected
//                                                           ? mainColor
//                                                           : mainColor
//                                                           .withOpacity(
//                                                         0.5,
//                                                       ),
//                                                       text: title[index],
//                                                     ),
//                                                     verticalSpace(5),
//                                                     AnimatedContainer(
//                                                       duration: const Duration(
//                                                         milliseconds: 300,
//                                                       ),
//                                                       height: index == 2
//                                                           ? 0
//                                                           : isSelected
//                                                           ? 7.h
//                                                           : 0.h,
//                                                       width: 7.w,
//                                                       decoration: BoxDecoration(
//                                                         color: mainColor,
//                                                         shape: BoxShape.circle,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   ProfileCheckWrapper(
//                                     showInHome: true,
//                                     child: const SizedBox.shrink(),
//                                   ),
//                                   PositionedDirectional(
//                                     start: 0,
//                                     end: 0,
//                                     top: 0,
//                                     child: UploadButtonWidget(
//                                       ontap: () {
//                                         print('object');
//                                         setState(() {
//                                           context
//                                               .read<MainCubit>()
//                                               .currentIndex
//                                               .value =
//                                           2;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Inactive SVG icons
//   List listOfInactiveIcons = [
//     SvgPicture.asset(
//       'assets/svgs/home_unSelect.svg',
//       color: mainColor.withOpacity(0.5),
//     ),
//     SvgPicture.asset(
//       'assets/svgs/Experiments_un_select.svg',
//       color: mainColor.withOpacity(0.5),
//     ),
//     Container(),
//     SvgPicture.asset(
//       'assets/svgs/Training_un_select.svg',
//       color: mainColor.withOpacity(0.5),
//     ),
//     SvgPicture.asset(
//       'assets/svgs/reals_un_select.svg',
//       color: mainColor.withOpacity(0.5),
//     ),
//   ];
//
//   /// Active SVG icons
//   List listOfActiveIcons = [
//     SvgPicture.asset('assets/svgs/home_select.svg'),
//     SvgPicture.asset('assets/svgs/Experiments_select.svg'),
//     Container(),
//     SvgPicture.asset('assets/svgs/Training_select.svg'),
//     SvgPicture.asset('assets/svgs/reals_select.svg'),
//   ];
//   List title = [
//     'الرئيسية'.tr(),
//     'التجارب'.tr(),
//     '',
//     'التدريبات'.tr(),
//     'منشورات'.tr(),
//   ];
// }