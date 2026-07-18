import 'package:falconclubapp/feature/favorites/domain/entities/favorite_player.dart';
import 'package:falconclubapp/feature/favorites/presentation/widgets/animated_favorite_heart.dart';
import 'package:falconclubapp/feature/favorites/presentation/widgets/favorite_player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// The old `FavoritePlayerCardWidget` threw `LateInitializationError` at build
/// (an unassigned `late _reelsFuture` read by a FutureBuilder). This guards that
/// the replacement renders without that crash — pumped through the real pipeline.
void main() {
  const FavoritePlayer player = FavoritePlayer(
    id: 'p1',
    name: 'أدم عزام الشويكي',
    position: 'ظهير ايسر',
    foot: 'يمين',
    tps: 23.52,
  );

  testWidgets('FavoritePlayerCard renders without a late-init crash', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    int taps = 0;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 180,
                child: FavoritePlayerCard(
                  player: player,
                  rankIndex: 0,
                  onUnfavorite: () => taps++,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('أدم عزام الشويكي'), findsOneWidget);
    expect(find.text('ظهير ايسر'), findsOneWidget);
    expect(find.text('23.5'), findsOneWidget); // tps, one decimal
    expect(find.text('1'), findsOneWidget); // rank badge
    expect(find.byType(AnimatedFavoriteHeart), findsOneWidget); // un-fav heart

    // The heart calls back without navigating.
    await tester.tap(find.byType(AnimatedFavoriteHeart));
    expect(taps, 1);
  });
}
