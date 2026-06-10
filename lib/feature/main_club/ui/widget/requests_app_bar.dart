import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/utils/styles.dart';

import '../../cubit/requests_cubit.dart';
import '../../cubit/requests_state.dart';


class RequestsAppBar extends StatelessWidget {
  const RequestsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 16.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF761CBC), mainColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.inbox_rounded,
              color: Colors.white,
              size: 22.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلبات الانضمام',
                  style: Styles.bold18.copyWith(color: Colors.white),
                ),
                BlocBuilder<RequestsCubit, RequestsState>(
                  builder: (context, state) {
                    final count = switch (state) {
                      ClubRequestsSuccess(:final data) => data.length,
                      PlayerRequestsSuccess(:final data) => data.length,
                      _ => 0,
                    };
                    return Text(
                      '$count طلب',
                      style: Styles.regular12.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<RequestsCubit, RequestsState>(
            builder: (context, state) {
              final isLoading =
                  state is RequestsLoading || state is RequestActionLoading;
              return GestureDetector(
                onTap: () => context.read<RequestsCubit>().fetchRequests(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: isLoading
                      ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}