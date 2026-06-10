import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/reals_cubit.dart';
import '../../data/model/real_model.dart';
import '../widget/loadingMoreIndicator.dart';
import '../widget/realsUserInfoOverlay.dart';
import '../widget/reals_actions_overlay ·.dart';
import '../widget/refreshIndicatorOverlay.dart';
import '../widget/stop_and_mute_widget.dart';
import '../widget/video_player_manager.dart';
import '../widget/video_player_widget.dart';
import '../widget/video_preloader.dart';

/// 🎬 Reals Screen
/// الشاشة الرئيسية لعرض الفيديوهات
class RealsScreen extends StatefulWidget {
  const RealsScreen({
    super.key,
    required this.ontap,
    required this.playnowOrNot,
    required this.playerProfile,
  });

  final Function() ontap;
  final bool playnowOrNot;
  final bool playerProfile;

  @override
  State<RealsScreen> createState() => _RealsScreenState();
}

class _RealsScreenState extends State<RealsScreen> {
  // Controllers
  late PageController _pageController;
  late VideoPlayerManager _videoManager;

  // State
  int _currentIndex = 0;
  int _lastIndex = 0;
  bool _isPlayNow = true;
  bool _isRefreshing = false;
  bool _iOpenItNow = false;

  // Data
  List<RealsVide> get reals => context.read<RealsCubit>().realsVide;

  @override
  void initState() {
    super.initState();
    log('initState - RealsScreen');

    _pageController = PageController(initialPage: 0, keepPage: true);
    _videoManager = VideoPlayerManager();
    _videoManager.initializeFirstVideos(reals.length);
  }

  @override
  void dispose() {
    _videoManager.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ========================================================================
  // LIFECYCLE METHODS
  // ========================================================================

  void _handlePlaybackState() {
    if (widget.playnowOrNot) {
      if (_videoManager.viewIds.containsKey(_lastIndex) && !_iOpenItNow) {
        _videoManager.playVideo(_lastIndex);
      }
      _iOpenItNow = true;
    } else {
      _iOpenItNow = false;
      if (_videoManager.viewIds.containsKey(_lastIndex)) {
        _videoManager.pauseVideo(_lastIndex);
      }
    }
  }

  // ========================================================================
  // VIDEO CALLBACKS
  // ========================================================================

  void _onViewCreated(int index, int viewId) {
    _videoManager.registerView(index, viewId);

    if (index == 0 && _currentIndex == 0 && widget.playnowOrNot) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && widget.playnowOrNot) {
          _videoManager.playVideo(index);
          setState(() => _isPlayNow = true);
        }
      });
    }
  }

  void _onPageChanged(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      _lastIndex = index;
      _videoManager.playVideo(_currentIndex);

      VideoPreloader.smartPreload(
        allVideoUrls: reals.map((e) => e.video.toString()).toList(),
        currentIndex: index,
      );

      _videoManager.cleanupOldViews(index);
      _loadMoreIfNeeded(index);
    }
  }

  void _onVideoTap(int index) {
    _lastIndex = index;
    _videoManager.togglePlay(index);
    setState(() {
      _isPlayNow = _videoManager.isPlaying[index] ?? false;
    });
  }

  void _onMuteTap(int index) {
    _lastIndex = index;
    _videoManager.toggleMute(index);
    setState(() {});
  }

  // ========================================================================
  // REFRESH & PAGINATION
  // ========================================================================

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      await _videoManager.pauseAllExcept(-1);

      final playerId = ''; // TODO: احصل على playerId الصحيح
      await context.read<RealsCubit>().refreshReals(playerId: playerId);

      _videoManager.dispose();
      _videoManager = VideoPlayerManager();
      _videoManager.initializeFirstVideos(reals.length);

      _currentIndex = 0;
      _lastIndex = 0;

      if (_pageController.hasClients) {
        await _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      log('⚠️ Refresh error: $e');
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  void _loadMoreIfNeeded(int index) {
    final cubit = context.read<RealsCubit>();

    if (index >= reals.length - 2 &&
        !cubit.isLoadingMore &&
        cubit.hasMoreData) {
      final playerId = ''; // TODO: احصل على playerId الصحيح
      cubit.loadMoreReals(playerId: playerId);
    }
  }

  // ========================================================================
  // USER INTERACTION CALLBACKS
  // ========================================================================

  Future<void> _onUserProfileTap() async {
    if (_videoManager.viewIds.containsKey(_lastIndex)) {
      await _videoManager.pauseVideo(_lastIndex);
    }

    context.read<MainCubit>().openProfile = true;
    await Future.delayed(const Duration(milliseconds: 500));
    _iOpenItNow = false;
  }

  // ========================================================================
  // BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    _handlePlaybackState();

    return PopScope(
      onPopInvoked: (didPop) {
        if (_videoManager.viewIds.containsKey(_lastIndex)) {
          _videoManager.pauseVideo(_lastIndex);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Main Content
            RefreshIndicator(
              onRefresh: _handleRefresh,
              color: Colors.white,
              backgroundColor: Colors.grey[900],
              strokeWidth: 3,
              displacement: 80,
              child: _buildPageView(),
            ),

            // Back Button (للـ Profile)
            if (widget.playerProfile) _buildBackButton(),

            // Refresh Indicator Overlay
            if (_isRefreshing) const RefreshIndicatorOverlay(),
          ],
        ),
      ),
    );
  }

  // ========================================================================
  // BUILD HELPERS
  // ========================================================================

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      itemCount: reals.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        _videoManager.initializeVideo(index);
        return _buildVideoPage(index);
      },
    );
  }

  Widget _buildVideoPage(int index) {
    final reel = reals[index];

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video Player
          VideoPlayerWidget(
            videoUrl: reel.video.toString(),
            index: index,
            onPlatformViewCreated: (viewId) => _onViewCreated(index, viewId),
            onTap: () => _onVideoTap(index),
          ),

          // Actions Overlay
          RealsActionsOverlay(
            index: index,
            reelId: reel.id,
            playerProfile: widget.playerProfile,
            onCommentTap: widget.ontap,
          ),

          // User Info Overlay
          RealsUserInfoOverlay(
            index: index,
            playerProfile: widget.playerProfile,
            onUserTap: _onUserProfileTap,
          ),

          // Play/Pause Overlay
          _buildPlayPauseOverlay(index),

          // Loading More Indicator
          if (index == reals.length - 1 &&
              context.watch<RealsCubit>().isLoadingMore)
            const LoadingMoreIndicator(),
        ],
      ),
    );
  }

  Widget _buildPlayPauseOverlay(int index) {
    final isPlaying = _videoManager.isPlaying[index] ?? false;
    final isMuted = _videoManager.muted[index] ?? false;

    return PositionedDirectional(
      end: 100.w,
      top: 0,
      bottom: 200.h,
      start: 0,
      child: GestureDetector(
        onTap: () => _onVideoTap(index),
        behavior: HitTestBehavior.translucent,
        child: _isPlayNow
            ? const SizedBox.expand()
            : StopAndMuteWidget(
                isPlaying: isPlaying,
                muted: isMuted,
                toggleMute: () => _onMuteTap(index),
                togglePlay: () => _onVideoTap(index),
              ),
      ),
    );
  }

  Widget _buildBackButton() {
    return PositionedDirectional(
      top: 40.w,
      start: 0.w,
      end: 20.w,
      child: InkWell(
        onTap: () => context.pop(),
        child: Row(
          children: [
            const BackButton(color: Colors.white),
            Expanded(
              child: TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                text: 'الرجوع'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
