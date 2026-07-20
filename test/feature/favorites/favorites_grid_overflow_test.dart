import 'package:falconclubapp/feature/favorites/domain/entities/favorite_player.dart';
import 'package:falconclubapp/feature/favorites/presentation/widgets/favorite_player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// Layout-fit guard for the resized favourites card, which overflowed its grid
/// cell by 3.2px on the bottom at 167.1 × 204.3.
///
/// Honest caveat: the exact 3.2px is a Cairo-font measurement and CANNOT be
/// reproduced here — the synthetic test font's Arabic metrics are shorter, so
/// the same card measures smaller in-test. So instead of chasing the pixel, this
/// (a) measures the card's natural height at the cell width and asserts it fits
/// the cell height with margin, and (b) proves the harness actually detects a
/// vertical overflow (a deliberately short cell is flagged) so the check isn't
/// vacuous. Both run the real card at 1:1 ScreenUtil scaling.
///
/// The cell is taller than the 204.3 this guard was originally written against:
/// the avatar moved to the shared [ProfileAvatar] portrait frame (50×50 → 64×90),
/// which made the card ~40px taller, so `childAspectRatio` went 0.80 → 0.70.
/// This guard caught that change — the height below tracks the grid delegate and
/// must be updated with it.
const double _cellWidth = 167.1;

/// `_cellWidth / childAspectRatio`, i.e. 167.1 / 0.70.
const double _cellHeight = 238.7;

const FavoritePlayer _player = FavoritePlayer(
  id: 'p1',
  name: 'عبدالرحمن جمال الرشيدي',
  position: 'حارس مرمى',
  foot: 'يمين',
  tps: 23.52,
);

/// Starts collecting overflow reports into the returned (live) list; non-overflow
/// errors still fail through the default hook. Filter for vertical AFTER pumping.
List<String> _captureOverflows(WidgetTester tester) {
  final List<String> overflows = <String>[];
  final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final String message = details.exceptionAsString();
    if (message.contains('overflowed')) {
      overflows.add(message);
      return;
    }
    previous?.call(details);
  };
  addTearDown(() => FlutterError.onError = previous);
  return overflows;
}

Iterable<String> _vertical(List<String> overflows) => overflows.where(
  (String m) => m.contains('on the bottom') || m.contains('on the top'),
);

Future<void> _pumpCard(WidgetTester tester, {double? height}) async {
  // physicalSize 1170 / dpr 3 = logical 390 == designSize.width → .w/.h are 1:1
  // with the device that produced the 167.1 × 204.3 cell.
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: _cellWidth,
              height: height,
              child: const FavoritePlayerCard(
                player: _player,
                rankIndex: 0,
                onUnfavorite: _noop,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('the card\'s natural height fits within the grid cell', (
    tester,
  ) async {
    final List<String> overflows = _captureOverflows(tester);
    // Loose height → the card takes its natural content height at the cell width.
    await _pumpCard(tester);

    final double naturalHeight = tester
        .getSize(find.byType(FavoritePlayerCard))
        .height;

    expect(_vertical(overflows), isEmpty);
    expect(
      naturalHeight,
      lessThanOrEqualTo(_cellHeight),
      reason: 'card is ${naturalHeight}px tall; the cell is ${_cellHeight}px',
    );
  });

  testWidgets('the card lays out cleanly at the exact failing cell size', (
    tester,
  ) async {
    final List<String> overflows = _captureOverflows(tester);
    await _pumpCard(tester, height: _cellHeight);

    expect(_vertical(overflows), isEmpty);
    expect(find.byType(FavoritePlayerCard), findsOneWidget);
  });

  testWidgets('a too-short cell IS flagged (the check is not vacuous)', (
    tester,
  ) async {
    final List<String> overflows = _captureOverflows(tester);
    await _pumpCard(tester, height: 120); // far below the content height

    expect(_vertical(overflows), isNotEmpty);
  });
}

void _noop() {}
