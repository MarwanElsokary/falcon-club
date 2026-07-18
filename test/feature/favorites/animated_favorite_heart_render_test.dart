import 'package:falconclubapp/feature/favorites/presentation/widgets/animated_favorite_heart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// The heart is a Lottie widget (Reels like-button style), so there is no
/// `Icons.favorite` to assert; these guard that it renders, taps drive the
/// callback, and a null onTap is inert — no crash through the real pipeline.
Future<void> _pump(
  WidgetTester tester, {
  required bool isFavorited,
  required VoidCallback? onTap,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: AnimatedFavoriteHeart(isFavorited: isFavorited, onTap: onTap),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('renders for both states without error', (tester) async {
    await _pump(tester, isFavorited: true, onTap: () {});
    expect(find.byType(AnimatedFavoriteHeart), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _pump(tester, isFavorited: false, onTap: () {});
    expect(find.byType(AnimatedFavoriteHeart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping fires onTap and animates without error', (tester) async {
    int taps = 0;
    await _pump(tester, isFavorited: false, onTap: () => taps++);

    await tester.tap(find.byType(AnimatedFavoriteHeart));
    await tester.pump(); // kick the burst
    await tester.pump(const Duration(milliseconds: 650)); // settle it

    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a null onTap makes it inert', (tester) async {
    await _pump(tester, isFavorited: false, onTap: null);

    await tester.tap(find.byType(AnimatedFavoriteHeart));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
