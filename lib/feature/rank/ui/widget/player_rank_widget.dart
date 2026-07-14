import 'dart:developer';
import 'dart:math' hide log;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/show_photo_widget.dart';
import '../../../../core/widget/text_utils.dart';
import '../../cubit/rank_cubit.dart';
import '../../cubit/rank_state.dart';
import '../../data/model/rank_model.dart';

class PlayerRankWidget extends StatefulWidget {
  const PlayerRankWidget({super.key});

  @override
  State<PlayerRankWidget> createState() => _PlayerRankWidgetState();
}

class _PlayerRankWidgetState extends State<PlayerRankWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.reset();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  Animation<double> _buildStagger(int index, int total) {
    final safeTotal = total == 0 ? 1 : total;
    final start = (index / safeTotal) * 0.6;
    final end = start + 0.4;
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RankCubit, RankState>(
      builder: (context, state) {
        if (state is rankLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (state is rankError) {
          return Center(
            child: TextUtils(
              text: (state).error,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          );
        }

        final cubit = context.read<RankCubit>();
        final items = cubit.rankList;
        final isSubscribed = cubit.isSubscribed;

        log('RANK LENGTH => ${items.length}');
        log('IS SUBSCRIBED => $isSubscribed');

        if (items.isEmpty) {
          return Center(
            child: TextUtils(
              text: 'No Players'.tr(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          );
        }

        _startAnimation();

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // ✅ لو مش مشترك: اللاعبين + عنصر إضافي لكارت الاشتراك
          itemCount: isSubscribed ? items.length : items.length + 1,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          itemBuilder: (context, index) {
            if (!isSubscribed && index == items.length) {
              return _buildSubscribeCard(context);
            }
            return _buildPlayerItem(items, index);
          },
        );
      },
    );
  }

  // ✅ نفس شكل _buildSubscribeMessage من ScoutPlayersSection بالظبط
  Widget _buildSubscribeCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: whiteclr,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // أيقونة القفل
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [mainColor.withOpacity(0.1), mainColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white,
                      size: 40.w,
                    ),
                  ),
                ),
                verticalSpace(20),

                // العنوان
                TextUtils(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  text: 'الترتيب الكامل مغلق'.tr(),
                ),
                verticalSpace(12),

                // الوصف
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  text:
                      'اشترك الآن لتكتشف مراكز جميع اللاعبين وتتابع المواهب الأبرز في المنافسة'
                          .tr(),
                  maxlines: 3,
                ),
                verticalSpace(20),

                // المزايا
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: mainColor.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      _buildFeatureItem('عرض ترتيب جميع اللاعبين'),
                      _buildFeatureItem('متابعة المواهب الصاعدة'),
                      _buildFeatureItem('مقارنة النقاط والأداء'),
                      _buildFeatureItem('تحديث فوري للترتيب'),
                    ],
                  ),
                ),
                verticalSpace(25),

                // زر الاشتراك
                ElevatedButton(
                  onPressed: () => context.pushNamed(AppRoute.packageScreen),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextUtils(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        text: 'اشترك الآن'.tr(),
                      ),
                      horizontalSpace(8),
                      Icon(
                        Icons.arrow_back_ios_new,
                        size: 16.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                verticalSpace(10),
              ],
            ),
          ),

          // زخرفة يسار
          PositionedDirectional(
            top: 0,
            start: 0,
            child: SvgPicture.asset('assets/svgs/Group 385.svg', width: 60.w),
          ),
          // زخرفة يمين
          PositionedDirectional(
            end: 0,
            bottom: 0,
            child: SvgPicture.asset('assets/svgs/Group 386-2.svg', width: 80.w),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: mainColor, size: 18.w),
          horizontalSpace(10),
          Expanded(
            child: TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              text: text.tr(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerItem(List<RankList> items, int index) {
    final anim = _buildStagger(index, items.length);

    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        final v = anim.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * -40),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 36.w,
                child: Center(
                  child: index == 0
                      ? SvgPicture.asset(
                          'assets/svgs/Group 432.svg',
                          width: 30.w,
                        )
                      : index == 1
                      ? SvgPicture.asset(
                          'assets/svgs/Group 430.svg',
                          width: 30.w,
                        )
                      : index == 2
                      ? SvgPicture.asset(
                          'assets/svgs/Group 431.svg',
                          width: 30.w,
                        )
                      : TextUtils(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: '${index + 1}',
                        ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.pushNamed(
                      AppRoute.playerProfile,
                      arguments: {
                        'isMyProfile': true,
                        'playerId': '${items[index].id}',
                      },
                    );
                  },
                  child: Row(
                    children: [
                      horizontalSpace(20),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          final photoPath = items[index].photoPath;
                          if (photoPath != null && photoPath.isNotEmpty) {
                            showPhotoDialog(
                              context: context,
                              image: photoPath,
                              name: items[index].name ?? '',
                            );
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFA5731D),
                                    Color(0xFFA5731D),
                                    Color(0xFFE4D48E),
                                  ],
                                  stops: [0.0, 0.476, 1.0],
                                ),
                              ),
                            ),
                            Container(
                              width: 28.w,
                              height: 28.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            ClipOval(
                              child: SizedBox(
                                width: 26.w,
                                height: 26.w,
                                child: _buildPlayerImage(
                                  items[index].photoPath,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      horizontalSpace(10),
                      Expanded(
                        child: TextUtils(
                          maxlines: 1,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: items[index].name ?? 'لا يوجد اسم',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextUtils(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                text: '${items[index].tps ?? '0'}',
              ),
            ],
          ),
          verticalSpace(10),
        ],
      ),
    );
  }

  Widget _buildPlayerImage(String? photoPath) {
    log('IMAGE => $photoPath');

    if (photoPath == null || photoPath.isEmpty) {
      return _defaultImage();
    }

    return CachedNetworkImage(
      imageUrl: photoPath,
      fit: BoxFit.cover,
      placeholder: (_, __) => Skeletonizer(
        enabled: true,
        child: Container(
          width: 26.w,
          height: 26.w,
          decoration: const BoxDecoration(shape: BoxShape.circle),
        ),
      ),
      errorWidget: (_, __, error) {
        log('IMAGE ERROR => $error');
        return _defaultImage();
      },
    );
  }

  Widget _defaultImage() {
    return Container(
      width: 26.w,
      height: 26.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: offWhiteClr,
      ),
      child: ClipOval(
        child: Image.asset('assets/images/Mask group.png', fit: BoxFit.cover),
      ),
    );
  }
}
