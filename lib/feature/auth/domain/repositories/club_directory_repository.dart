import '../../../../core/usecase/usecase.dart';
import '../entities/city.dart';
import '../entities/club_option.dart';

/// The city → club cascade used by Club registration.
///
/// ISP: two reads. It is not part of [AuthRepository] because listing clubs is
/// not authentication — a screen that shows the dropdowns has no business
/// being able to call `login()`.
///
/// Endpoint note: this is backed by `Player/GetCountries` and
/// `Player/GetClubsByCountry`, **not** `Dashboard/GetClubLists`. The latter was
/// evaluated (finding B8) and rejected: it is a flat, paginated admin listing
/// whose only filter is `search` — it has no city parameter, so it cannot drive
/// a cascade without fetching every page and filtering client-side.
abstract interface class ClubDirectoryRepository {
  ResultFuture<List<City>> getCities();

  ResultFuture<List<ClubOption>> getClubsInCity(String cityId);
}
