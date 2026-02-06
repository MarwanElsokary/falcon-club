import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

import '../../../experiments/cubit/experiments_cubit.dart';
import '../../../main_screen/cubit/main_cubit.dart';
import '../../../training/cubit/training_cubit.dart';
import '../widget/find_your_direction_widget.dart';
import '../widget/home_app_bar_widget.dart';
import '../widget/join_talent_widget/join_talent_widget.dart';
import '../widget/top_rate_widget/top_player_widget.dart';
import '../widget/upload_training_wdget/upload_training_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _onRefresh() async {
    final mainCubit = context.read<MainCubit>();

    // Reload APIs
    context.read<ExperimentsCubit>().emitbestTrials(categoryId: '');
    context.read<TrainingCubit>()
        .emitallExercises(categoryId: '', popular: true);

    // لو عندك بيانات تانية
    mainCubit.emitCategories();

    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: whiteclr,
          appBar: PreferredSize(
            preferredSize: Size(context.displayWidth / 1, 66.h),
            child: Container(color: whiteclr),
          ),
          body: Container(
            color: mainColor, // 👈 رجعنا الخلفية الأصلية
            child: ClipRect(
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _onRefresh,
                    builder: (context, refreshState, pulledExtent,
                        refreshTriggerPullDistance, refreshIndicatorExtent) {
                      return Center(
                        child: SizedBox(
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
          child: IgnorePointer(
            child: SafeArea(child: HomeAppBarWidget()),
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

