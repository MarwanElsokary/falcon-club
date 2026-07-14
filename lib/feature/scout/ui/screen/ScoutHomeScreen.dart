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
import '../../../home/ui/widget/find_your_direction_widget.dart';
import '../../../home/ui/widget/home_app_bar_widget.dart';
import '../../../home/ui/widget/top_rate_widget/top_player_widget.dart';
import '../../scout_training/cubit/scout_training_cubit.dart';
import '../widget/join_talent_widget_scout.dart';

/// الـ Home الخاص بالكشاف
/// الفرق عن HomeScreen:
/// ✅ بيستخدم ScoutTrainingCubit مش TrainingCubit
/// ✅ مفيش UploadTrainingWidget (الكشاف مش بيرفع تمارين)
class ScoutHomeScreen extends StatefulWidget {
  final VoidCallback? onDrawerTap;

  const ScoutHomeScreen({super.key, this.onDrawerTap});

  @override
  State<ScoutHomeScreen> createState() => _ScoutHomeScreenState();
}

class _ScoutHomeScreenState extends State<ScoutHomeScreen> {
  Future<void> _onRefresh() async {
    context.read<ExperimentsCubit>().emitbestTrials(categoryId: '');
    context.read<ScoutTrainingCubit>().fetchExercises(
      categoryId: '',
      popular: true,
    );
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
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _onRefresh,
                    builder: (context, _, __, ___, ____) => Container(
                      alignment: Alignment.center,
                      child: const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: whiteclr,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        JoinTalentWidgetScout(),
                        verticalSpace(10),
                        FindYourDirectionWidget(),
                        verticalSpace(10),
                        TopPlayerWidget(),
                        // ✅ مفيش UploadTrainingWidget للكشاف
                        verticalSpace(120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // App bar decoration
        PositionedDirectional(
          end: 0,
          child: IgnorePointer(
            child: SvgPicture.asset('assets/svgs/app_bar_icon.svg'),
          ),
        ),

        // App bar content
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
