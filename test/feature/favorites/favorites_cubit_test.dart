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

const FavoritePlayer _p1 = FavoritePlayer(id: 'p1', name: 'أدم');
const FavoritePlayer _p2 = FavoritePlayer(id: 'p2', name: 'جمال');
const FavoritePlayer _p3 = FavoritePlayer(id: 'p3', name: 'سعد');

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

  group('load', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'success emits [Loading, Loaded]',
      build: () {
        when(getFavorites.call).thenAnswer(
          (_) async => const Right<Failure, List<FavoritePlayer>>(
            <FavoritePlayer>[_p1, _p2],
          ),
        );
        return FavoritesCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.load(),
      expect: () => <Matcher>[
        isA<FavoritesLoading>(),
        isA<FavoritesLoaded>().having(
          (s) => s.players,
          'players',
          <FavoritePlayer>[_p1, _p2],
        ),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'failure emits [Loading, Failure]',
      build: () {
        when(getFavorites.call).thenAnswer(
          (_) async => const Left<Failure, List<FavoritePlayer>>(
            ServerFailure(message: 'فشل'),
          ),
        );
        return FavoritesCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.load(),
      expect: () => <Matcher>[
        isA<FavoritesLoading>(),
        isA<FavoritesFailure>().having((s) => s.message, 'message', 'فشل'),
      ],
    );
  });

  group('unfavorite', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'success: optimistic removal, then a silent re-read replaces the list',
      seed: () => const FavoritesLoaded(<FavoritePlayer>[_p1, _p2, _p3]),
      build: () {
        when(() => toggleFavorite(any())).thenAnswer(
          (_) async => const Right<Failure, Unit>(unit),
        );
        // The authoritative re-read (server also dropped p2 meanwhile).
        when(getFavorites.call).thenAnswer(
          (_) async =>
              const Right<Failure, List<FavoritePlayer>>(<FavoritePlayer>[_p3]),
        );
        return FavoritesCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.unfavorite('p1'),
      expect: () => <Matcher>[
        isA<FavoritesLoaded>().having(
          (s) => s.players,
          'optimistic',
          <FavoritePlayer>[_p2, _p3],
        ),
        isA<FavoritesLoaded>().having(
          (s) => s.players,
          'refetched',
          <FavoritePlayer>[_p3],
        ),
      ],
      verify: (_) {
        verify(() => toggleFavorite('p1')).called(1);
        verify(getFavorites.call).called(1); // the silent refresh
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'failure: optimistic removal then rollback with an action error',
      seed: () => const FavoritesLoaded(<FavoritePlayer>[_p1, _p2]),
      build: () {
        when(() => toggleFavorite(any())).thenAnswer(
          (_) async => const Left<Failure, Unit>(
            ServerFailure(message: 'تعذر'),
          ),
        );
        return FavoritesCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.unfavorite('p1'),
      expect: () => <Matcher>[
        isA<FavoritesLoaded>().having(
          (s) => s.players,
          'optimistic',
          <FavoritePlayer>[_p2],
        ),
        isA<FavoritesActionError>()
            .having((s) => s.players, 'rolled back', <FavoritePlayer>[_p1, _p2])
            .having((s) => s.message, 'message', 'تعذر'),
      ],
      verify: (_) => verifyNever(getFavorites.call), // no refetch on failure
    );
  });

  group('refresh (pull-to-refresh)', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'success re-reads to Loaded with no loading flash',
      seed: () => const FavoritesLoaded(<FavoritePlayer>[_p1]),
      build: () {
        when(getFavorites.call).thenAnswer(
          (_) async => const Right<Failure, List<FavoritePlayer>>(
            <FavoritePlayer>[_p1, _p2],
          ),
        );
        return FavoritesCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.refresh(),
      expect: () => <Matcher>[
        isA<FavoritesLoaded>().having(
          (s) => s.players,
          'players',
          <FavoritePlayer>[_p1, _p2],
        ),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'failure while loaded keeps the grid and surfaces an action error',
      seed: () => const FavoritesLoaded(<FavoritePlayer>[_p1]),
      build: () {
        when(getFavorites.call).thenAnswer(
          (_) async => const Left<Failure, List<FavoritePlayer>>(
            ServerFailure(message: 'فشل التحديث'),
          ),
        );
        return FavoritesCubit(getFavorites, toggleFavorite, sync);
      },
      act: (c) => c.refresh(),
      expect: () => <Matcher>[
        isA<FavoritesActionError>()
            .having((s) => s.players, 'kept', <FavoritePlayer>[_p1])
            .having((s) => s.message, 'message', 'فشل التحديث'),
      ],
    );
  });

  group('external sync (FavoritesSync)', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'a change for a listed player (un-favourited elsewhere) drops the card live',
      seed: () => const FavoritesLoaded(<FavoritePlayer>[_p1, _p2]),
      build: () => FavoritesCubit(getFavorites, toggleFavorite, sync),
      act: (_) => sync.notifyChanged('p1'),
      wait: const Duration(milliseconds: 50),
      expect: () => <Matcher>[
        isA<FavoritesLoaded>().having(
          (s) => s.players,
          'players',
          <FavoritePlayer>[_p2],
        ),
      ],
      verify: (_) => verifyNever(getFavorites.call), // instant removal, no refetch
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'a change for an unlisted player (favourited elsewhere) triggers a re-read',
      seed: () => const FavoritesLoaded(<FavoritePlayer>[_p1]),
      build: () {
        when(getFavorites.call).thenAnswer(
          (_) async => const Right<Failure, List<FavoritePlayer>>(
            <FavoritePlayer>[_p1, _p2],
          ),
        );
        return FavoritesCubit(getFavorites, toggleFavorite, sync);
      },
      act: (_) => sync.notifyChanged('p2'),
      wait: const Duration(milliseconds: 50),
      expect: () => <Matcher>[
        isA<FavoritesLoaded>().having(
          (s) => s.players,
          'players',
          <FavoritePlayer>[_p1, _p2],
        ),
      ],
      verify: (_) => verify(getFavorites.call).called(1),
    );
  });
}
