import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/favorites/domain/entities/favorite_player.dart';
import 'package:falconclubapp/feature/favorites/domain/favorites_sync.dart';
import 'package:falconclubapp/feature/favorites/domain/usecases/get_favorites.dart';
import 'package:falconclubapp/feature/favorites/domain/usecases/toggle_favorite.dart';
import 'package:falconclubapp/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:falconclubapp/feature/favorites/presentation/cubit/favorites_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetFavorites extends Mock implements GetFavorites {}

class _MockToggleFavorite extends Mock implements ToggleFavorite {}

const FavoritePlayer _a = FavoritePlayer(id: 'a', name: 'أحمد');
const FavoritePlayer _b = FavoritePlayer(id: 'b', name: 'خالد');

/// A failed toggle leaves the grid on screen as [FavoritesActionError]. The
/// guard used to require [FavoritesLoaded], so every later tap returned
/// silently — one dropped request permanently disabled un-favouriting.
void main() {
  late _MockGetFavorites getFavorites;
  late _MockToggleFavorite toggleFavorite;
  late FavoritesSync sync;

  setUp(() {
    getFavorites = _MockGetFavorites();
    toggleFavorite = _MockToggleFavorite();
    sync = FavoritesSync();
  });

  FavoritesCubit build() => FavoritesCubit(getFavorites, toggleFavorite, sync);

  blocTest<FavoritesCubit, FavoritesState>(
    'un-favourite still works after a previous toggle failed',
    build: () {
      when(() => getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoritePlayer>>(
          <FavoritePlayer>[_a, _b],
        ),
      );
      // First toggle fails, second succeeds.
      var call = 0;
      when(() => toggleFavorite(any())).thenAnswer((_) async {
        call++;
        return call == 1
            ? const Left<Failure, Unit>(ServerFailure(message: 'offline'))
            : const Right<Failure, Unit>(unit);
      });
      return build();
    },
    act: (FavoritesCubit c) async {
      await c.load();
      await c.unfavorite('a'); // fails → FavoritesActionError
      await c.unfavorite('b'); // must still be attempted
    },
    verify: (_) {
      // Two real attempts: the second tap was NOT swallowed by the guard.
      verify(() => toggleFavorite(any())).called(2);
    },
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'the failed toggle rolls back and keeps the grid on screen',
    build: () {
      when(() => getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoritePlayer>>(
          <FavoritePlayer>[_a, _b],
        ),
      );
      when(() => toggleFavorite(any())).thenAnswer(
        (_) async => const Left<Failure, Unit>(ServerFailure(message: 'offline')),
      );
      return build();
    },
    act: (FavoritesCubit c) async {
      await c.load();
      await c.unfavorite('a');
    },
    verify: (FavoritesCubit c) {
      final FavoritesState s = c.state;
      expect(s, isA<FavoritesActionError>());
      // The rolled-back list is still displayable — that is what lets the
      // next tap proceed.
      expect(s.displayedPlayers, <FavoritePlayer>[_a, _b]);
    },
  );

  test('displayedPlayers exposes the grid for both rendering states', () {
    expect(
      const FavoritesLoaded(<FavoritePlayer>[_a]).displayedPlayers,
      <FavoritePlayer>[_a],
    );
    expect(
      const FavoritesActionError(<FavoritePlayer>[_a], 'x').displayedPlayers,
      <FavoritePlayer>[_a],
    );
    // States with nothing on screen stay null, so actions correctly no-op.
    expect(const FavoritesInitial().displayedPlayers, isNull);
    expect(const FavoritesLoading().displayedPlayers, isNull);
    expect(const FavoritesFailure('x').displayedPlayers, isNull);
  });
}
