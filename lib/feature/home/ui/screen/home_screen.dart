import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../experiments/cubit/experiments_cubit.dart';
import '../../../main_screen/cubit/main_cubit.dart';
import '../../../training/cubit/training_cubit.dart';
import '../widget/find_your_direction_widget.dart';
import '../widget/home_app_bar_widget.dart';
import '../widget/join_talent_widget/join_talent_widget.dart';
import '../widget/top_rate_widget/top_player_widget.dart';
import '../widget/upload_training_wdget/upload_training_widget.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onDrawerTap;

  const HomeScreen({super.key, this.onDrawerTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _onRefresh() async {
    // امسح الـ cache عشان يجيب البيانات من جديد



    // أعد الـ fetch
    context.read<ExperimentsCubit>().emitbestTrials(categoryId: '');
    context.read<TrainingCubit>().emitallExercises(categoryId: '', popular: true);
    context.read<MainCubit>().emitCategories();

    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: whiteclr,
          appBar: PreferredSize(
            preferredSize: Size(context.displayWidth, 66.h),
            child: Container(color: whiteclr),
          ),
          body: Container(
            color: mainColor,
            child: ClipRect(
              child: CustomScrollView(
                // ← ده اللي بيخلي الريفريش يشتغل
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _onRefresh,
                    builder: (context, refreshState, pulledExtent,
                        refreshTriggerPullDistance, refreshIndicatorExtent) {
                      return Container(
                        alignment: Alignment.center,
                        child: const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: whiteclr,
                          ),
                        ),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        JoinTalentWidget(),
                        verticalSpace(10),
                        FindYourDirectionWidget(),
                        verticalSpace(10),
                        TopPlayerWidget(),
                        UploadTrainingWidget(),
                        verticalSpace(120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        PositionedDirectional(
          end: 0,
          child: IgnorePointer(
            child: SvgPicture.asset('assets/svgs/app_bar_icon.svg'),
          ),
        ),

        PositionedDirectional(
          top: 0,
          start: 0,
          end: 0,
          child: SafeArea(
            child: HomeAppBarWidget(onDrawerTap: widget.onDrawerTap),
          ),
        ),
      ],
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return child;
  }
}