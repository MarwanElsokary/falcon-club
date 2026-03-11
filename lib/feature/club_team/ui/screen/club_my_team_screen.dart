import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/club_team/ui/widget/position_section_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../cubit/club_exercises_cubit.dart';
import '../../cubit/club_team_cubit.dart';
import '../../cubit/club_team_state.dart';

class ClubMyTeamScreen extends StatefulWidget {
  const ClubMyTeamScreen({super.key});

  @override
  State<ClubMyTeamScreen> createState() => _ClubMyTeamScreenState();
}

class _ClubMyTeamScreenState extends State<ClubMyTeamScreen> {
  static const List<String> _sectionOrder = [
    'الحارس',
    'الدفاع',
    'خط الوسط',
    'الهجوم',
  ];
  static const Map<String, String> _sectionEmoji = {
    'الحارس': '🧤',
    'الدفاع': '❤️',
    'خط الوسط': '🔄',
    'الهجوم': '⚡',
  };

  @override
  void initState() {
    super.initState();
    context.read<ClubTeamCubit>().fetchClubPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClubExercisesCubit>(),
      child: Scaffold(
        backgroundColor: whiteclr,
        body: Stack(
          children: [
            // ── خط الـ background — نفس ExperimentScreen ─────────────────────
            PositionedDirectional(
              start: 0,
              top: 0,
              child: SvgPicture.asset('assets/svgs/Group 386.svg', width: 120.w),
            ),

            // ── المحتوى ────────────────────────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  _buildHeader(),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: BlocBuilder<ClubTeamCubit, ClubTeamState>(
                      buildWhen: (prev, curr) =>
                      curr is clubPlayersLoading ||
                          curr is clubPlayersSuccess ||
                          curr is clubPlayersError,
                      builder: (context, state) {
                        return state.maybeWhen(
                          clubPlayersloading: () => Center(
                            child: CupertinoActivityIndicator(radius: 15.w),
                          ),
                          clubPlayerserror: (error) => _buildError(error),
                          clubPlayerssuccess: (_) => _buildContent(),
                          orElse: () => Center(
                            child: CupertinoActivityIndicator(radius: 15.w),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header — بدون كلمة "الرجوع"، بس السهم ────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.groups, color: mainColor, size: 26.w),
          SizedBox(width: 6.w),
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: 'فريق النادي'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final grouped = context.read<ClubTeamCubit>().cachedGroupedPlayers;
    final visibleSections = _sectionOrder
        .where((key) => (grouped[key]?.isNotEmpty ?? false))
        .toList();

    if (visibleSections.isEmpty) {
      return Center(
        child: TextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: greyClr,
          text: 'لا يوجد لاعبون في هذا النادي'.tr(),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 100.h),
      child: Column(
        children: visibleSections
            .map(
              (key) => PositionSectionWidget(
            title: key,
            icon: _sectionEmoji[key] ?? '',
            players: grouped[key]!,
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: redClr, size: 40.w),
          verticalSpace(10),
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            text: error,
          ),
          verticalSpace(16),
          ElevatedButton(
            onPressed: () => context.read<ClubTeamCubit>().fetchClubPlayers(),
            style: ElevatedButton.styleFrom(backgroundColor: mainColor),
            child: Text(
              'إعادة المحاولة'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}