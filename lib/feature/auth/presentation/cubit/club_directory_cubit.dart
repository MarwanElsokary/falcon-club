import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/club_option.dart';
import '../../domain/usecases/get_cities.dart';
import '../../domain/usecases/get_clubs_in_city.dart';
import 'club_directory_state.dart';

/// Drives the city → club cascade on the Club signup screen.
///
/// Its whole job is to keep the two dropdowns consistent. Selecting a city
/// **clears the previously selected club** ([selectCity]) — otherwise a user
/// could pick a club in Riyadh, switch to Jeddah, and submit a `ClubId` that
/// does not belong to the selected city.
@injectable
class ClubDirectoryCubit extends Cubit<ClubDirectoryState> {
  ClubDirectoryCubit(this._getCities, this._getClubsInCity)
    : super(const ClubDirectoryState());

  final GetCities _getCities;
  final GetClubsInCity _getClubsInCity;

  Future<void> loadCities() async {
    emit(state.copyWith(isLoadingCities: true, clearError: true));
    final result = await _getCities();
    emit(
      result.fold(
        (Failure failure) => state.copyWith(
          isLoadingCities: false,
          errorMessage: failure.message,
        ),
        (List<City> cities) =>
            state.copyWith(isLoadingCities: false, cities: cities),
      ),
    );
  }

  /// Selects a city and reloads its clubs, discarding any stale club choice.
  Future<void> selectCity(City city) async {
    emit(
      state.copyWith(
        selectedCity: city,
        clubs: const <ClubOption>[],
        clearSelectedClub: true,
        isLoadingClubs: true,
        clearError: true,
      ),
    );
    final result = await _getClubsInCity(city.id);
    emit(
      result.fold(
        (Failure failure) => state.copyWith(
          isLoadingClubs: false,
          errorMessage: failure.message,
        ),
        (List<ClubOption> clubs) =>
            state.copyWith(isLoadingClubs: false, clubs: clubs),
      ),
    );
  }

  void selectClub(ClubOption club) =>
      emit(state.copyWith(selectedClub: club, clearError: true));
}
