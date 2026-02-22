import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/button_utils.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:falcon/feature/reals/cubit/reals_state.dart';
import 'package:falcon/feature/reals/data/model/real_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import '../../../reals/cubit/reals_cubit.dart';

class PlayerAllVideosItemWidget extends StatelessWidget {
  const PlayerAllVideosItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RealsCubit, RealsState>(
      builder: (context, state) {
        if (state is realsLoading) {
          return SizedBox();
        }
        final reals = context.watch<RealsCubit>().realsVide;
        if (reals.isNotEmpty) {
          return Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                  mainAxisExtent: 300.h,
                ),
                itemCount: reals.length > 4 ? 4 : reals.length,
                itemBuilder: (context, index) {
                  return _RealsGridItem(
                    real: reals[index],
                    index: index,
                    onTap: () {
                      context.pushNamed(
                        AppRoute.mainRealsScreen,
                        arguments: {'context': context, 'initialIndex': index},
                      );
                    },
                  );
                },
              ),
              verticalSpace(16),
              Visibility(
                visible: reals.length > 4,
                child: ButtonUtils(
                  contantWidget: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: SvgPicture.asset(
                      width: 30.w,
                      'assets/svgs/solar_arrow-up-broken.svg',
                    ),
                  ),
                  text: 'عرض الكل',
                  onPressed: () {
                    context.pushNamed(
                      AppRoute.mainRealsScreen,
                      arguments: {'context': context},
                    );
                  },
                  colorstext: Colors.white,
                  background: mainColor,
                ),
              ),
            ],
          );
        }
        return Center(
          child: Column(
            children: [
              verticalSpace(20),
              CenterTextUtils(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: blackclr,
                text: 'لا يوجد لقطات لهذا اللاعب'.tr(),
              ),
              verticalSpace(20),
            ],
          ),
        );
      },
    );
  }
}

class _RealsGridItem extends StatefulWidget {
  final RealsVide real;
  final int index;
  final VoidCallback onTap;

  const _RealsGridItem({
    required this.real,
    required this.index,
    required this.onTap,
  });

  @override
  State<_RealsGridItem> createState() => _RealsGridItemState();
}

class _RealsGridItemState extends State<_RealsGridItem> {
  bool _isPressed = false;
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.real.video.toString()),
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('❌ Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: Duration(milliseconds: 100),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // عرض أول فريم من الفيديو
              if (!_isInitialized && !_hasError)
                _buildLoadingPlaceholder()
              else if (_hasError)
                _buildErrorPlaceholder()
              else
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),

              // معلومات الفيديو
              if (_isInitialized)
                Positioned(
                  bottom: 8.h,
                  left: 8.w,
                  right: 8.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('assets/svgs/majesticons_share.svg', '0'),
                      _buildStatItem(
                        'assets/svgs/fa7-solid_comment-dots.svg',
                        '${widget.real.commentsCount ?? 0}',
                      ),
                      _buildStatItem(
                        'assets/svgs/mingcute_heart-fill.svg',
                        '${widget.real.likesCount ?? 0}',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String svgPath, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(svgPath, width: 20.w, height: 20.h),
        SizedBox(height: 2.h),
        CenterTextUtils(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          text: _formatCount(int.tryParse(count) ?? 0),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[900]!, Colors.grey[850]!],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'جاري التحميل...',
              style: TextStyle(color: Colors.white70, fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[900]!, Colors.grey[850]!],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_rounded, color: Colors.white54, size: 32.sp),
            SizedBox(height: 6.h),
            Text(
              'فيديو',
              style: TextStyle(color: Colors.white54, fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
