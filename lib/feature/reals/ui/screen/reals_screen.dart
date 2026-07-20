import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/reals_cubit.dart';
import '../../cubit/reals_state.dart';
import '../../data/model/real_model.dart';
import '../widget/loadingMoreIndicator.dart';
import '../widget/realsUserInfoOverlay.dart';
import '../widget/reals_actions_overlay ·.dart';
import '../widget/reel_options_menu.dart';
import '../widget/refreshIndicatorOverlay.dart';
import '../widget/stop_and_mute_widget.dart';
import '../widget/video_player_manager.dart';
import '../widget/video_player_widget.dart';
import '../widget/video_preloader.dart';

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

class _RealsScreenState extends State<RealsScreen> with WidgetsBindingObserver {
  // ── Controllers ──────────────────────────────────────────────────────────
  late PageController _pageController;
  late VideoPlayerManager _videoManager;

  // ── Saved references (آمنة في dispose) ───────────────────────────────────
  RealsCubit? _realsCubit;

  // ── State ─────────────────────────────────────────────────────────────────
  int _currentIndex = 0;
  int _lastIndex = 0;
  bool _isPlayNow = true;
  bool _isRefreshing = false;
  bool _iOpenItNow = false;

  // ✅ Key للـ PageView عشان يتبني من أول بعد الـ refresh
  Key _pageViewKey = UniqueKey();

  // ── Data ──────────────────────────────────────────────────────────────────
  List<RealsVide> get reals => _realsCubit?.realsVide ?? [];

  // =========================================================================
  // Lifecycle
  // =========================================================================

  @override
  void initState() {
    super.initState();
    log('initState - RealsScreen');

    WidgetsBinding.instance.addObserver(this);

    _realsCubit = context.read<RealsCubit>();
    _realsCubit!.refreshTrigger.addListener(_onRefreshTriggered);

    _pageController = PageController(initialPage: 0, keepPage: true);
    _videoManager = VideoPlayerManager();
    _videoManager.initializeFirstVideos(reals.length);
  }

  @override
  void didUpdateWidget(RealsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playnowOrNot != widget.playnowOrNot) {
      _handlePlaybackState();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _videoManager.pauseAllExcept(-1);
      if (mounted) setState(() => _isPlayNow = false);
    } else if (state == AppLifecycleState.resumed) {
      if (widget.playnowOrNot && mounted) {
        _videoManager.playVideo(_currentIndex);
        setState(() => _isPlayNow = true);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _realsCubit?.refreshTrigger.removeListener(_onRefreshTriggered);

    VideoPreloader.dispose();
    _videoManager.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // =========================================================================
  // Refresh trigger من MainScreen
  // =========================================================================

  void _onRefreshTriggered() {
    _handleRefresh();
  }

  // =========================================================================
  // Playback
  // =========================================================================

  void _handlePlaybackState() {
    if (widget.playnowOrNot) {
      if (_videoManager.viewIds.containsKey(_lastIndex) && !_iOpenItNow) {
        _videoManager.playVideo(_lastIndex);
        _isPlayNow = true;
      }
      _iOpenItNow = true;
    } else {
      _iOpenItNow = false;
      // Pause *everything*, not just _lastIndex. The shells keep this tab
      // mounted inside an IndexedStack, so leaving the tab never disposes the
      // screen — if any other view were still playing (e.g. after a fast
      // swipe), its audio kept going over whatever screen the user opened next.
      _videoManager.pauseAllExcept(-1);
      _isPlayNow = false;
    }
  }

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
    if (index == _currentIndex) return;

    _currentIndex = index;
    _lastIndex = index;
    _videoManager.playVideo(_currentIndex);

    VideoPreloader.smartPreload(
      allVideoUrls: reals.map((e) => e.video.toString()).toList(),
      currentIndex: index,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _videoManager.cleanupOldViews(index);
    });

    _loadMoreIfNeeded(index);
  }

  void _onVideoTap(int index) {
    _lastIndex = index;
    _videoManager.togglePlay(index);
    if (mounted) {
      setState(() {
        _isPlayNow = _videoManager.isPlaying[index] ?? false;
      });
    }
  }

  void _onMuteTap(int index) {
    _lastIndex = index;
    _videoManager.toggleMute(index);
    if (mounted) setState(() {});
  }

  // =========================================================================
  // Refresh
  // =========================================================================

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    if (!mounted) return;

    setState(() => _isRefreshing = true);

    try {
      await _videoManager.pauseAllExcept(-1);

      // No playerId: the cubit refreshes whichever feed is loaded (global or a
      // specific player's), instead of forcing the global one.
      await _realsCubit?.refreshReals();

      _videoManager.dispose();
      _videoManager = VideoPlayerManager();
      _videoManager.initializeFirstVideos(reals.length);

      _currentIndex = 0;
      _lastIndex = 0;
      _iOpenItNow = false;

      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }

      // ✅ جبر الـ PageView يتبني من أول عشان الفيديو الجديد يتسجل صح
      if (mounted) {
        setState(() {
          _pageViewKey = UniqueKey();
        });
      }

      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      log('⚠️ Refresh error: $e');
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  // =========================================================================
  // Load more
  // =========================================================================

  void _loadMoreIfNeeded(int index) {
    final cubit = _realsCubit;
    if (cubit == null) return;

    if (index >= reals.length - 2 &&
        !cubit.isLoadingMore &&
        cubit.hasMoreData) {
      // Paginate the feed that is actually loaded — see RealsCubit.activePlayerId.
      cubit.loadMoreReals();
    }
  }

  // =========================================================================
  // User profile tap
  // =========================================================================

  Future<void> _onUserProfileTap() async {
    if (_videoManager.viewIds.containsKey(_lastIndex)) {
      await _videoManager.pauseVideo(_lastIndex);
    }
    if (!mounted) return;
    // MainCubit is only in scope when reels is opened from a screen that
    // provides it (e.g. the player profile). In the three shells it lives in
    // tab 0's subtree, which is a sibling of the reels tab — reading it there
    // threw ProviderNotFoundException and killed the avatar tap.
    try {
      context.read<MainCubit>().openProfile = true;
    } catch (_) {
      // Not available in this context; nothing to sync.
    }
    await Future.delayed(const Duration(milliseconds: 500));
    _iOpenItNow = false;
  }

  // =========================================================================
  // Reel deleted
  // =========================================================================

  void _handleReelDeleted() {
    _videoManager.pauseAllExcept(-1);

    _videoManager.dispose();
    _videoManager = VideoPlayerManager();
    _videoManager.initializeFirstVideos(reals.length);

    if (_currentIndex >= reals.length) {
      _currentIndex = reals.isEmpty ? 0 : reals.length - 1;
    }
    _lastIndex = _currentIndex;

    if (mounted) {
      setState(() {
        _pageViewKey = UniqueKey();
      });
    }
    if (_pageController.hasClients && reals.isNotEmpty) {
      _pageController.jumpToPage(_currentIndex);
    }

    if (mounted) setState(() {});
  }

  // =========================================================================
  // Build
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return BlocListener<RealsCubit, RealsState>(
      listener: (context, state) {
        if (state is deleteReelSuccess) {
          _handleReelDeleted();
        }
      },
      child: PopScope(
        onPopInvoked: (didPop) {
          if (_videoManager.viewIds.containsKey(_lastIndex)) {
            _videoManager.pauseVideo(_lastIndex);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _handleRefresh,
                color: Colors.white,
                backgroundColor: Colors.grey[900],
                strokeWidth: 3,
                displacement: 80,
                child: _buildPageView(),
              ),

              if (widget.playerProfile) _buildBackButton(),

              if (_isRefreshing) const RefreshIndicatorOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // PageView
  // =========================================================================

  Widget _buildPageView() {
    return PageView.builder(
      key: _pageViewKey,
      // ✅ هيجبر الـ PageView يتبني من أول بعد الـ refresh
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
          VideoPlayerWidget(
            videoUrl: reel.video.toString(),
            index: index,
            onPlatformViewCreated: (viewId) => _onViewCreated(index, viewId),
            onTap: () => _onVideoTap(index),
          ),

          _buildGradientOverlay(),

          RealsActionsOverlay(
            index: index,
            reelId: reel.id,
            playerProfile: widget.playerProfile,
            onCommentTap: widget.ontap,
          ),

          RealsUserInfoOverlay(
            index: index,
            playerProfile: widget.playerProfile,
            onUserTap: _onUserProfileTap,
          ),

          _buildPlayPauseOverlay(index),

          if (reel.isMyReel == true)
            Positioned(
              top: 40.h,
              right: 16.w,
              child: ReelOptionsMenu(
                reelId: reel.id,
                currentDescription: reel.description?.toString() ?? '',
              ),
            ),

          if (index == reals.length - 1 &&
              (_realsCubit?.isLoadingMore ?? false))
            const LoadingMoreIndicator(),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 280.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.75),
              Colors.black.withOpacity(0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
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
