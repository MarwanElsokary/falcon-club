import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FavIconClick extends StatefulWidget {
  const FavIconClick({
    super.key,
    required this.lottiePath,
    this.width,
    this.height,
    this.repeat = true,
    this.reverse = false,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.onAnimationComplete,
    this.start = false,
  });

  final String lottiePath;
  final double? width;
  final double? height;
  final bool repeat;
  final bool reverse;
  final BoxFit fit;
  final Alignment alignment;
  final VoidCallback? onAnimationComplete;
  final bool start;

  @override
  State<FavIconClick> createState() => _FavIconClickState();
}

class _FavIconClickState extends State<FavIconClick>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isLoaded = false;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _setupAnimationListener();
  }

  void _setupAnimationListener() {
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();

        // Only repeat if widget.repeat is true AND we haven't started from widget.start
        if (widget.repeat && !_hasStarted) {
          if (widget.reverse) {
            _controller.reverse();
          } else {
            _controller.forward(from: 0);
          }
        }
      } else if (status == AnimationStatus.dismissed &&
          widget.repeat &&
          widget.reverse &&
          !_hasStarted) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(FavIconClick oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if start changed from false to true
    if (!oldWidget.start && widget.start && _isLoaded) {
      _hasStarted = true;
      _controller.forward();
    }
    // Check if start changed from true to false
    else if (oldWidget.start && !widget.start && _isLoaded) {
      _controller.value = 0.0;
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: _isLoaded ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Lottie.asset(
          widget.lottiePath,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          alignment: widget.alignment,
          controller: _controller,
          onLoaded: (composition) {
            setState(() {
              _isLoaded = true;
            });
            _controller.duration = composition.duration;
            if (widget.start) {
              _hasStarted = true;
              _controller.forward();
            } else {
              // When start = false, show animation at start position and stop
              _controller.value = 0.0;
              _controller.stop();
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: widget.width,
              height: widget.height ?? 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.grey,
                size: 48,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Usage Examples:

// Basic usage - animation at start position and stopped
class BasicUsageExample extends StatelessWidget {
  const BasicUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavIconClick(
      lottiePath: 'assets/svgs/notification.json',
      start: false, // Shows first frame and stops
    );
  }
}

// Start animation once and stop
class SingleAnimationExample extends StatelessWidget {
  const SingleAnimationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavIconClick(
      lottiePath: 'assets/svgs/notification.json',
      start: true, // Will play once and stop
    );
  }
}

// Toggle between start/stop states
class ToggleAnimationExample extends StatefulWidget {
  const ToggleAnimationExample({super.key});

  @override
  State<ToggleAnimationExample> createState() => _ToggleAnimationExampleState();
}

class _ToggleAnimationExampleState extends State<ToggleAnimationExample> {
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FavIconClick(
          lottiePath: 'assets/animations/heart.json',
          start: _isAnimating,
          width: 100,
          height: 100,
          onAnimationComplete: () {
            // Reset to start position after animation completes
            setState(() {
              _isAnimating = false;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isAnimating = !_isAnimating;
            });
          },
          child: Text(_isAnimating ? 'Stop Animation' : 'Start Animation'),
        ),
      ],
    );
  }
}

// Manual control - click to animate once, then return to start
class ManualControlExample extends StatefulWidget {
  const ManualControlExample({super.key});

  @override
  State<ManualControlExample> createState() => _ManualControlExampleState();
}

class _ManualControlExampleState extends State<ManualControlExample> {
  bool _shouldStart = false;

  void _triggerAnimation() {
    setState(() {
      _shouldStart = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _triggerAnimation,
          child: FavIconClick(
            lottiePath: 'assets/animations/heart.json',
            start: _shouldStart,
            width: 100,
            height: 100,
            onAnimationComplete: () {
              print('Heart animation completed!');
              // Return to start position
              setState(() {
                _shouldStart = false;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _triggerAnimation,
          child: const Text('Animate Heart'),
        ),
      ],
    );
  }
}
