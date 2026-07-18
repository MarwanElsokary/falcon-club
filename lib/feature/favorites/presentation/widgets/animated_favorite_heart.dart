import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// A favourite toggle reusing the **Reels like-button** Lottie heart
/// (`heart like animation*.json`), playing its like-burst on toggle so
/// favouriting feels alive rather than an instant swap. Just the heart — no halo
/// behind it.
///
/// [isFavorited] drives which Lottie plays (filled/burst vs empty); [onTap] null
/// disables it (used while the true state is still loading). Same tap feel as
/// Reels — the burst runs when favouriting, resets when un-favouriting.
class AnimatedFavoriteHeart extends StatefulWidget {
  const AnimatedFavoriteHeart({
    super.key,
    required this.isFavorited,
    required this.onTap,
    this.size = 54,
  });

  final bool isFavorited;
  final VoidCallback? onTap;
  final double size;

  @override
  State<AnimatedFavoriteHeart> createState() => _AnimatedFavoriteHeartState();
}

class _AnimatedFavoriteHeartState extends State<AnimatedFavoriteHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const String _liked = 'assets/lottie/heart like animation-3.json';
  static const String _idle = 'assets/lottie/heart like animation.json';

  @override
  void initState() {
    super.initState();
    // A fallback duration so forward()/reset() are safe even before the Lottie
    // finishes loading (onLoaded overrides it with the composition's duration).
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    final VoidCallback? onTap = widget.onTap;
    if (onTap == null) return;
    // Same feel as the Reels like button: burst when favouriting, reset when
    // un-favouriting. isFavorited is still the pre-tap value here.
    if (widget.isFavorited) {
      _controller.reset();
    } else {
      _controller.forward(from: 0);
    }
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final double d = widget.size.w;
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: d,
        height: d,
        child: Lottie.asset(
          widget.isFavorited ? _liked : _idle,
          fit: BoxFit.contain,
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            // Rest a favourited heart on its filled last frame (rather than the
            // burst's empty frame 0) unless a tap is animating.
            if (widget.isFavorited &&
                _controller.status == AnimationStatus.dismissed) {
              _controller.value = 1.0;
            }
          },
        ),
      ),
    );
  }
}
