import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/utils/styles.dart';
import '../../cubit/requests_cubit.dart';
import '../../cubit/requests_state.dart';

class RequestsTabSelector extends StatelessWidget {
  const RequestsTabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        final cubit = context.read<RequestsCubit>();
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              _TabItem(
                label: 'طلبات النادي',
                icon: Icons.sports_soccer_rounded,
                isActive: cubit.activeTab == RequestsTab.club,
                onTap: () => cubit.switchTab(RequestsTab.club),
              ),
              _TabItem(
                label: 'طلبات اللاعبين',
                icon: Icons.person_outline_rounded,
                isActive: cubit.activeTab == RequestsTab.player,
                onTap: () => cubit.switchTab(RequestsTab.player),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive ? mainColor : Colors.transparent,
            borderRadius: BorderRadius.circular(11.r),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: mainColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.w,
                color: isActive ? Colors.white : mainColor.withOpacity(0.6),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: isActive
                    ? Styles.bold12.copyWith(color: Colors.white)
                    : Styles.medium12.copyWith(
                        color: mainColor.withOpacity(0.6),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
