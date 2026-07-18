import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/favorites/domain/entities/favorite_player.dart';
import 'package:falconclubapp/feature/favorites/domain/favorites_sync.dart';
import 'package:falconclubapp/feature/favorites/domain/usecases/get_favorites.dart';
import 'package:falconclubapp/feature/favorites/domain/usecases/toggle_favorite.dart';
import 'package:falconclubapp/feature/favorites/presentation/cubit/player_favorite_cubit.dart';
import 'package:falconclubapp/feature/favorites/presentation/cubit/player_favorite_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetFavorites extends Mock implements GetFavorites {}

class _MockToggleFavorite extends Mock implements ToggleFavorite {}

const FavoritePlayer _p1 = FavoritePlayer(id: 'p1', name: 'أدم');
const FavoritePlayer _p2 = FavoritePlayer(id: 'p2', name: 'جمال');

void main() {
  late _MockGetFavorites getFavorites;
  late _MockToggleFavorite toggleFavorite;
  late FavoritesSync sync;

  setUp(() {
    getFavorites = _MockGetFavorites();
    toggleFavorite = _MockToggleFavorite();
    sync = FavoritesSync();
  });

  tearDown(() => sync.dispose());

  void favoritesAre(List<FavoritePlayer> players) {
    when(getFavorites.call).thenAnswer(
      (_) async => Right<Failure, List<FavoritePlayer>>(players),
    );
  }

  group('load resolves membership', () {
    blocTest<PlayerFavoriteCubit, PlayerFavoriteState>(
      'favourited when the player is in the list',
      build: () {
        favoritesAre(<FavoritePlayer>[_p1, _p2]);
        return PlayerFavoriteCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.load('p1'),
      expect: () => <Matcher>[
        isA<PlayerFavoriteReady>().having((s) => s.isFavorited, 'fav', true),
      ],
    );

    blocTest<PlayerFavoriteCubit, PlayerFavoriteState>(
      'not favourited when absent',
      build: () {
        favoritesAre(<FavoritePlayer>[_p2]);
        return PlayerFavoriteCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.load('p1'),
      expect: () => <Matcher>[
        isA<PlayerFavoriteReady>().having((s) => s.isFavorited, 'fav', false),
      ],
    );

    blocTest<PlayerFavoriteCubit, PlayerFavoriteState>(
      'load failure falls back to not-favourited (heart still usable)',
      build: () {
        when(getFavorites.call).thenAnswer(
          (_) async => const Left<Failure, List<FavoritePlayer>>(
            ServerFailure(message: 'x'),
          ),
        );
        return PlayerFavoriteCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.load('p1'),
      expect: () => <Matcher>[
        isA<PlayerFavoriteReady>().having((s) => s.isFavorited, 'fav', false),
      ],
    );
  });

  group('toggle', () {
    blocTest<PlayerFavoriteCubit, PlayerFavoriteState>(
      'success flips optimistically and keeps it',
      seed: () => const PlayerFavoriteReady(false),
      build: () {
        when(() => toggleFavorite(any())).thenAnswer(
          (_) async => const Right<Failure, Unit>(unit),
        );
        return PlayerFavoriteCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.toggle('p1'),
      expect: () => <Matcher>[
        isA<PlayerFavoriteReady>().having((s) => s.isFavorited, 'fav', true),
      ],
      verify: (_) => verify(() => toggleFavorite('p1')).called(1),
    );

    blocTest<PlayerFavoriteCubit, PlayerFavoriteState>(
      'failure flips then rolls back with an action error',
      seed: () => const PlayerFavoriteReady(true),
      build: () {
        when(() => toggleFavorite(any())).thenAnswer(
          (_) async => const Left<Failure, Unit>(
            ServerFailure(message: 'تعذر'),
          ),
        );
        return PlayerFavoriteCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.toggle('p1'),
      expect: () => <Matcher>[
        isA<PlayerFavoriteReady>().having((s) => s.isFavorited, 'optimistic', false),
        isA<PlayerFavoriteActionError>()
            .having((s) => s.isFavorited, 'rolled back', true)
            .having((s) => s.message, 'message', 'تعذر'),
      ],
    );

    blocTest<PlayerFavoriteCubit, PlayerFavoriteState>(
      'does nothing while the state is still unknown',
      build: () => PlayerFavoriteCubit(getFavorites, toggleFavorite, sync),
      act: (c) => c.toggle('p1'),
      expect: () => <Matcher>[],
      verify: (_) => verifyNever(() => toggleFavorite(any())),
    );
  });

  group('publishes to FavoritesSync (drives live grid updates)', () {
    test('a confirmed toggle notifies with the playerId', () async {
      favoritesAre(const <FavoritePlayer>[]);
      when(() => toggleFavorite(any())).thenAnswer(
        (_) async => const Right<Failure, Unit>(unit),
      );
      final PlayerFavoriteCubit cubit = PlayerFavoriteCubit(
        getFavorites,
        toggleFavorite,
        sync,
      );
      addTearDown(cubit.close);
      final List<String> events = <String>[];
      final sub = sync.changes.listen(events.add);
      addTearDown(sub.cancel);

      await cubit.load('p9'); // resolve so the toggle proceeds
      await cubit.toggle('p9');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(events, <String>['p9']);
    });

    test('a failed toggle notifies nothing', () async {
      favoritesAre(const <FavoritePlayer>[]);
      when(() => toggleFavorite(any())).thenAnswer(
        (_) async => const Left<Failure, Unit>(ServerFailure(message: 'x')),
      );
      final PlayerFavoriteCubit cubit = PlayerFavoriteCubit(
        getFavorites,
        toggleFavorite,
        sync,
      );
      addTearDown(cubit.close);
      final List<String> events = <String>[];
      final sub = sync.changes.listen(events.add);
      addTearDown(sub.cancel);

      await cubit.load('p9');
      await cubit.toggle('p9');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(events, isEmpty);
    });
  });
}
