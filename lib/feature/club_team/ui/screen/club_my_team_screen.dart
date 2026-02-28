import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/club_team/ui/widget/position_section_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/club_team_cubit.dart';
import '../../cubit/club_team_state.dart';

class ClubMyTeamScreen extends StatefulWidget {
  const ClubMyTeamScreen({super.key});

  @override
  State<ClubMyTeamScreen> createState() => _ClubMyTeamScreenState();
}

class _ClubMyTeamScreenState extends State<ClubMyTeamScreen> {
  // Fixed display order — sections not in this list are skipped
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
    return Scaffold(
      backgroundColor: whiteclr,
      body: SafeArea(
        child: Column(
          children: [
            verticalSpace(12),
            _buildHeader(),
            verticalSpace(12),
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
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "الرجوع" — left side in RTL layout
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward_ios, color: mainColor, size: 14.w),
                horizontalSpace(4),
                TextUtils(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                  text: 'الرجوع'.tr(),
                ),
              ],
            ),
          ),
          // Title — right side in RTL layout
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.groups, color: mainColor, size: 26.w),
              horizontalSpace(6),
              TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'فريق النادي'.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Content ─────────────────────────────────────────────────────────────────
  Widget _buildContent() {
    final grouped = context.read<ClubTeamCubit>().cachedGroupedPlayers;

    // Only show sections that have at least one player, in fixed order
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

  // ── Error ────────────────────────────────────────────────────────────────────
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
            onPressed: () {
              context.read<ClubTeamCubit>().fetchClubPlayers();
            },
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
