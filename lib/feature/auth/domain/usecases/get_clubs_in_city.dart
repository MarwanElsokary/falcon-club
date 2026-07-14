import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/club_option.dart';
import '../repositories/club_directory_repository.dart';

/// Loads the club dropdown for the city the user picked.
///
/// The second half of the cascade. Its result is what supplies the `ClubId`
/// that `RegisterClub` requires and the app currently drops (bug B1).
@injectable
class GetClubsInCity implements UseCase<List<ClubOption>, String> {
  const GetClubsInCity(this._repository);

  final ClubDirectoryRepository _repository;

  @override
  ResultFuture<List<ClubOption>> call(String cityId) =>
      _repository.getClubsInCity(cityId);
}
