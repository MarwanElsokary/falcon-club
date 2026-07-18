import 'package:falconclubapp/core/networking/api_result.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falconclubapp/feature/club_team/data/repo/club_team_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockClubTeamRepo extends Mock implements ClubTeamRepo {}

/// A11 — removing a coach used to go through `Club/DeletePlayer?PlayerId=`,
/// the player endpoint, which rejected a coach id with 400 "اللاعب غير موجود".
/// Coaches are Club accounts and must be addressed by `ClubId` via
/// `Club/DeleteClub`. Both removals shared one repo method, so the two paths
/// have to stay pointed at different endpoints.
void main() {
  late _MockClubTeamRepo repo;

  setUp(() {
    repo = _MockClubTeamRepo();
    when(() => repo.deleteCoach(any())).thenAnswer(
      (_) async => const ApiResult<dynamic>.success(<String, dynamic>{}),
    );
    when(() => repo.deletePlayer(any())).thenAnswer(
      (_) async => const ApiResult<dynamic>.success(<String, dynamic>{}),
    );
  });

  test('removing a coach calls DeleteClub, never the player endpoint', () async {
    final ClubTeamCubit cubit = ClubTeamCubit(repo);
    addTearDown(cubit.close);

    await cubit.deleteTrainee('coach-3ddb932a');

    verify(() => repo.deleteCoach('coach-3ddb932a')).called(1);
    verifyNever(() => repo.deletePlayer(any()));
  });

  test('removing a player calls DeletePlayer, never the coach endpoint', () async {
    final ClubTeamCubit cubit = ClubTeamCubit(repo);
    addTearDown(cubit.close);

    await cubit.deletePlayerFromTeam('player-42');

    verify(() => repo.deletePlayer('player-42')).called(1);
    verifyNever(() => repo.deleteCoach(any()));
  });
}
