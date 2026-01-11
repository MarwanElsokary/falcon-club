import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/widget/anmiate_builder.dart';
import 'package:falcon/core/widget/app_bar_utils.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falcon/feature/experiments/cubit/experiments_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllExperimentScreen extends StatelessWidget {
  const AllExperimentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtils(context: context, title: 'التجارب'.tr()),
      body: BlocBuilder<ExperimentsCubit, ExperimentsState>(
        buildWhen: (previous, current) =>
            current is allTrialsLoading ||
            current is allTrialsSuccess ||
            current is allTrialsError,
        builder: (context, state) {
          return state.maybeWhen(
            allTrialssuccess: (allTrialsdata) {
              return GridView.builder(
                padding: paddingUtils(),
                itemCount: allTrialsdata.data.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 270.h,
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 20.w,
                ),
                itemBuilder: (context, index) {
                  return AnimateBuilder(
                    columnCount: 2,
                    position: index,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(34.r),
                      onTap: () {
                        context.pushNamed(
                          AppRoute.experianceDetailsScreen,
                          arguments: {
                            'title': '${allTrialsdata.data[index].title ?? ''}',
                            'trialId': '${allTrialsdata.data[index].id ?? ''}',
                            'heroTag':
                                "all_experiance_image_hero_${allTrialsdata.data[index].id}", // ✅ بدل 1 بـ index
                            'experianceImage':
                                allTrialsdata.data[index].photoPath ?? '',
                          },
                        );
                      },
                      child: Hero(
                        tag:
                            "all_experiance_image_hero_${allTrialsdata.data[index].id}",
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                34.r,
                              ), // Using .r for responsive border radius
                              child: SizedBox(
                                width: 250.w,
                                height: 295.h,
                                child: CachedNetworkImage(
                                  width: 250.w,
                                  height: 295.h,
                                  imageUrl:
                                      allTrialsdata.data[index].photoPath ?? '',

                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Skeletonizer(
                                    enabled: true,
                                    child: Container(
                                      width: 250.w,
                                      height: 295.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          34.r,
                                        ), // Match the border radius
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: SvgPicture.asset(
                                      'assets/svgs/unavailabeImage.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              start: 0,
                              end: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(34.r),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(
                                        0.0,
                                      ), // rgba(0,0,0,0)
                                      Colors.black, // #000000
                                    ],
                                    stops: [0.5955, 1.0], // 59.55%, 100%
                                  ),
                                ),
                                child: Container(
                                  padding: paddingUtils(),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(34.r),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromRGBO(
                                          0,
                                          0,
                                          0,
                                          0.0,
                                        ), // rgba(0, 0, 0, 0) at 0%
                                        Color.fromRGBO(
                                          93,
                                          43,
                                          244,
                                          0.32,
                                        ), // rgba(93, 43, 244, 0.32) at 75%
                                      ],
                                      stops: [0.0, 0.75],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              bottom: 20.w,
                              start: 20.w,
                              end: 20.w,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextUtils(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      text:
                                          allTrialsdata.data[index].title ?? '',
                                    ),
                                    verticalSpace(10),
                                    Row(
                                      children: [
                                        TextUtils(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          text:
                                              allTrialsdata
                                                  .data[index]
                                                  .categoryName ??
                                              '',
                                        ),
                                        horizontalSpace(5),
                                        ClipOval(
                                          child: SizedBox(
                                            width: 16.w,
                                            height: 16.w,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  allTrialsdata
                                                      .data[index]
                                                      .categoryIcon ??
                                                  '',
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  Skeletonizer(
                                                    enabled: true,
                                                    child: Container(
                                                      height: 16.w,
                                                      width: 16.w,
                                                      decoration:
                                                          const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (
                                                    context,
                                                    url,
                                                    error,
                                                  ) => Container(
                                                    padding: EdgeInsets.all(
                                                      3.w,
                                                    ),

                                                    child: SvgPicture.asset(
                                                      'assets/svgs/unavailabeImage.svg',
                                                      width: 16.w,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            orElse: () {
              return SizedBox(
                width: context.displayWidth / 1,
                height: context.displayHeight / 1.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoActivityIndicator(
                      radius: 20.w,
                      color: Colors.black,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
