import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/utils/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../cubit/requests_cubit.dart';
import '../../cubit/requests_state.dart';
import '../../data/model/club_request_model.dart';
import '../../data/model/player_request_model.dart';
import 'request_card_widget.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        return switch (state) {
          RequestsLoading() => _LoadingSkeleton(),
          RequestsError(:final message) => _ErrorView(message: message),
          ClubRequestsSuccess(:final data) when data.isEmpty =>
            const _EmptyView(),
          ClubRequestsSuccess(:final data) => _ClubList(data: data),
          PlayerRequestsSuccess(:final data) when data.isEmpty =>
            const _EmptyView(),
          PlayerRequestsSuccess(:final data) => _PlayerList(data: data),
          // أثناء action loading نفضل نعرض آخر list
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

// ── Club List ─────────────────────────────────────────────────────────────────

class _ClubList extends StatelessWidget {
  final List<ClubRequestModel> data;

  const _ClubList({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 4.h, bottom: 100.h),
      itemCount: data.length,
      itemBuilder: (_, i) => RequestCardWidget.club(request: data[i]),
    );
  }
}

// ── Player List ───────────────────────────────────────────────────────────────

class _PlayerList extends StatelessWidget {
  final List<PlayerRequestModel> data;

  const _PlayerList({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 4.h, bottom: 100.h),
      itemCount: data.length,
      itemBuilder: (_, i) => RequestCardWidget.player(request: data[i]),
    );
  }
}

// ── Skeleton ──────────────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 4.h),
        itemCount: 5,
        itemBuilder: (_, __) => RequestCardWidget.club(
          request: const ClubRequestModel(
            id: 'x',
            name: 'اسم اللاعب هنا',
            phone: '0501234567',
            email: 'example@email.com',
            gender: 'ذكر',
          ),
        ),
      ),
    );
  }
}

// ── Empty ─────────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(color: fillColor, shape: BoxShape.circle),
            child: Icon(Icons.inbox_outlined, size: 48.w, color: mainColor),
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد طلبات حالياً',
            style: Styles.bold16.copyWith(color: mainColor),
          ),
          SizedBox(height: 8.h),
          Text(
            'ستظهر هنا طلبات الانضمام عند وصولها',
            style: Styles.regular12.copyWith(color: Colors.black38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: fillColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_soccer_rounded,
                size: 60.w,
                color: mainColor.withOpacity(.7),
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              'تعذر تحميل الطلبات',
              style: Styles.bold18.copyWith(color: mainColor),
            ),

            SizedBox(height: 8.h),

            Text(
              message,
              style: Styles.regular14.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),

            ElevatedButton.icon(
              onPressed: () {
                context.read<RequestsCubit>().fetchRequests();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
