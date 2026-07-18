import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/favorites/domain/entities/favorite_player.dart';
import 'package:falconclubapp/feature/favorites/domain/favorites_sync.dart';
import 'package:falconclubapp/feature/favorites/domain/usecases/get_favorites.dart';
import 'package:falconclubapp/feature/favorites/domain/usecases/toggle_favorite.dart';
import 'package:falconclubapp/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:falconclubapp/feature/favorites/presentation/cubit/player_favorite_cubit.dart';
import 'package:falconclubapp/feature/favorites/presentation/screens/favorites_screen.dart';
import 'package:falconclubapp/feature/favorites/presentation/widgets/favorite_player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetFavorites extends Mock implements GetFavorites {}

class _MockToggleFavorite extends Mock implements ToggleFavorite {}

const FavoritePlayer _p1 = FavoritePlayer(id: 'p1', name: 'أدم عزام');
const FavoritePlayer _p2 = FavoritePlayer(id: 'p2', name: 'جمال رائد');
const FavoritePlayer _p3 = FavoritePlayer(id: 'p3', name: 'سعد خالد');

/// The on-device scenario, automated: a favourites grid is open (mounted, like
/// under the shell's IndexedStack), then a player is un-favourited from a
/// *separate* cubit (the profile heart). Through the shared [FavoritesSync] the
/// grid must drop that card live — no reload, no revisit.
void main() {
  testWidgets('un-favouriting elsewhere removes the card from a live grid', (
    WidgetTester tester,
  ) async {
    // This test asserts sync behaviour, not layout, so tolerate the synthetic
    // test font's fractional horizontal overflow (guarded separately in
    // favorites_grid_overflow_test). Non-overflow errors still fail.
    final void Function(FlutterErrorDetails)? previousOnError =
        FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    final _MockGetFavorites getFavorites = _MockGetFavorites();
    final _MockToggleFavorite toggleFavorite = _MockToggleFavorite();
    final FavoritesSync sync = FavoritesSync();
    addTearDown(sync.dispose);

    when(getFavorites.call).thenAnswer(
      (_) async => const Right<Failure, List<FavoritePlayer>>(
        <FavoritePlayer>[_p1, _p2, _p3],
      ),
    );
    when(() => toggleFavorite(any())).thenAnswer(
      (_) async => const Right<Failure, Unit>(unit),
    );

    // The grid's cubit (as the mounted tab would have).
    final FavoritesCubit gridCubit = FavoritesCubit(
      getFavorites,
      toggleFavorite,
      sync,
    );
    addTearDown(gridCubit.close);
    await gridCubit.load();

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: BlocProvider<FavoritesCubit>.value(
            value: gridCubit,
            child: const FavoritesScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(FavoritePlayerCard), findsNWidgets(3));
    expect(find.text('أدم عزام'), findsOneWidget);

    // A DIFFERENT cubit (the player-profile heart) un-favourites p1.
    final PlayerFavoriteCubit heartCubit = PlayerFavoriteCubit(
      getFavorites,
      toggleFavorite,
      sync,
    );
    addTearDown(heartCubit.close);
    await heartCubit.load('p1'); // resolves to favourited
    await heartCubit.toggle('p1'); // confirmed → publishes to sync

    await tester.pump(); // deliver the sync event + rebuild
    await tester.pump(const Duration(milliseconds: 50));

    // The grid dropped p1's card live — no navigation, no reload.
    expect(find.text('أدم عزام'), findsNothing);
    expect(find.byType(FavoritePlayerCard), findsNWidgets(2));
  });
}
