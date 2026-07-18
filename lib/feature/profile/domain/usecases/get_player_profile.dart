import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/player_profile.dart';
import '../repositories/profile_repository.dart';

/// Loads a viewed player's profile by id (`Player/GetProfileById`).
@injectable
class GetPlayerProfile implements UseCase<PlayerProfile, String> {
  const GetPlayerProfile(this._repository);

  final ProfileRepository _repository;

  @override
  ResultFuture<PlayerProfile> call(String userId) =>
      _repository.getPlayerProfile(userId);
}
