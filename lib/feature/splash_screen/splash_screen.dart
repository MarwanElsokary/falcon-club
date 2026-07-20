import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/thems/thems.dart';

import 'package:flutter/foundation.dart';

import '../../core/di/dependency_injection.dart';
import '../../core/error/failures.dart';
import '../../core/routing/routes.dart';
import '../../shared/presentation/routing/role_router.dart';
import '../auth/domain/entities/auth_session.dart';
import '../auth/domain/entities/session_diagnostics.dart';
import '../auth/domain/usecases/describe_session.dart';
import '../auth/domain/usecases/read_session.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  /// Every delayed callback on this screen, so they can be cancelled.
  ///
  /// These were bare `Timer(...)` calls that ran `setState` / `forward()` with
  /// no ownership and no `mounted` check. Splash routes onward part-way through
  /// its own animation, so a pending timer could easily fire after the State was
  /// gone.
  final List<Timer> _timers = <Timer>[];

  void _after(Duration delay, VoidCallback action) {
    _timers.add(
      Timer(delay, () {
        if (!mounted) return;
        action();
      }),
    );
  }

  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  // ====== أنيميشن النص ======
  late AnimationController textController;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  // ====== أنيميشن الدوران ======
  late AnimationController rotationController;
  late Animation<double> rotationAnimation;

  // ====== أنيميشن التشويش (Blur) ======
  late AnimationController blurController;
  late Animation<double> blurAnimation;

  double _opacity = 0;
  bool _value = true;
  bool showText = false;

  static const Duration _splashHold = Duration(milliseconds: 1100);

  /// Decides where to go once the splash animation finishes.
  ///
  /// Previously this read the token and the role straight out of secure storage
  /// and re-derived the role→route mapping inline — one of three such
  /// dispatchers in the app, which disagreed with each other. It now asks the
  /// domain (`ReadSession`) and defers the mapping to [RoleRouter], so there is
  /// exactly one definition of "where does a Club user land?".
  Future<void> _routeOnwards() async {
    await Future.delayed(_splashHold);
    if (!mounted) return;

    await _logStoredSession();

    final session = await getIt<ReadSession>()();
    if (!mounted) return;

    final String route = session.fold(
      // A storage failure is not a reason to strand the user on the splash —
      // send them to sign in and let them recover.
      (_) => AppRoute.onBoardingScreen,
      (AuthSession? current) => current == null
          ? AppRoute.onBoardingScreen
          : RoleRouter.homeRouteFor(current.role),
    );

    context.pushNamedAndRemoveUntil(route, predicate: (_) => false);
  }

  /// Debug-only: prints what is actually in session storage, so a session that
  /// exists when it should not can be diagnosed instead of guessed at.
  ///
  /// Redacted — it reports the token's length and expiry, never its value.
  Future<void> _logStoredSession() async {
    if (!kDebugMode) return;
    final diagnostics = await getIt<DescribeSession>()();
    diagnostics.fold(
      (Failure failure) => debugPrint('🔐 session probe failed: ${failure.message}'),
      (SessionDiagnostics stored) => debugPrint('🔐 $stored'),
    );
  }

  @override
  void initState() {
    super.initState();

    // ==============================
    // أنيميشن اللوجو
    // ==============================
    scaleController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 0),
        )..addStatusListener((status) async {
          if (status == AnimationStatus.completed) {
            setState(() {
              showText = true;
            });

            // نشغل أنيميشن النص هنا
            textController.forward();

            _after(const Duration(milliseconds: 300), () {
              scaleController.reset();
            });
          }
        });

    scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 12,
    ).animate(scaleController);

    // ==============================
    // أنيميشن الدوران (من معوج لمستقيم)
    // ==============================
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    rotationAnimation =
        Tween<double>(
          begin: 0.9, // زاوية الميل في البداية
          end: 0.0, // مستقيم في النهاية
        ).animate(
          CurvedAnimation(parent: rotationController, curve: Curves.elasticOut),
        );

    // ==============================
    // أنيميشن التشويش (من مشوش لواضح)
    // ==============================
    blurController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    blurAnimation = Tween<double>(
      begin: 10.0, // مشوش جداً في البداية
      end: 0.0, // واضح تماماً في النهاية
    ).animate(CurvedAnimation(parent: blurController, curve: Curves.easeInOut));

    _after(const Duration(milliseconds: 600), () {
      setState(() {
        _opacity = 1.0;
        // هنخليه يفضل كبير ومشوش لمدة دقيقة
        // _value = false; // هنشيل دي من هنا
      });

      // نستنى دقيقة كاملة قبل ما نبدأ الأنيميشن
      _after(const Duration(milliseconds: 0), () {
        setState(() {
          _value = false; // دلوقتي يبدأ يصغر
        });
        rotationController.forward();
        blurController.forward();
      });
    });

    _after(const Duration(milliseconds: 1400), () {
      setState(() {
        scaleController.forward();
      });
    });

    // ==============================
    // أنيميشن النص (Slide + Fade)
    // من الشمال لليمين
    // ==============================
    textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeOut));

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    for (final Timer timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    scaleController.dispose();
    textController.dispose();
    rotationController.dispose();
    blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.displayWidth,
        height: context.displayHeight,
        child: Stack(
          children: [
            SizedBox(
              width: context.displayWidth,
              height: context.displayHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            ),
            PositionedDirectional(
              top: 0,
              end: context.displayWidth / 2.3,
              bottom: 0,
              start: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    onEnd: _routeOnwards,
                    width: showText ? 140.w : 0,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SlideTransition(
                            position: slideAnimation,
                            child: FadeTransition(
                              opacity: fadeAnimation,
                              child: Image.asset(
                                'assets/images/fteet.png',
                                width: 150.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ====== اللوجو في النص ======
            PositionedDirectional(
              top: 0,
              end: 0,
              bottom: 0,
              start: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ====== مسافة فاضية على يمين الصورة ======
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: showText ? 130.w : 0,
                  ),
                  AnimatedOpacity(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(seconds: 4),
                    opacity: _opacity,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        rotationController,
                        blurController,
                      ]),
                      builder: (context, child) {
                        return ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: blurAnimation.value,
                            sigmaY: blurAnimation.value,
                          ),
                          child: Transform.rotate(
                            angle: rotationAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        color: whiteclr,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(seconds: 2),
                        height: _value ? 200.w : 80.w,
                        width: _value ? 200.w : 80.w,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(50.w),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/splashlogo.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget page;
  final Widget route;

  ThisIsFadeRoute({required this.page, required this.route})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) => page,
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) => FadeTransition(opacity: animation, child: route),
      );
}
