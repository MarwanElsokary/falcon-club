import 'package:equatable/equatable.dart';

import '../../domain/entities/city.dart';
import '../../domain/entities/club_option.dart';

/// The city → club cascade's state.
///
/// One immutable object holds the whole cascade, so the "clubs belong to the
/// selected city" invariant lives in one place. The legacy widgets kept
/// `universityList`, `collegesList`, `selectedUniversityId` and
/// `selectedCollegesId` as **public mutable fields on `LoginCubit`**, mutated
/// directly from two `StatefulWidget`s via `setState`.
final class ClubDirectoryState extends Equatable {
  const ClubDirectoryState({
    this.cities = const <City>[],
    this.clubs = const <ClubOption>[],
    this.selectedCity,
    this.selectedClub,
    this.isLoadingCities = false,
    this.isLoadingClubs = false,
    this.errorMessage,
  });

  final List<City> cities;
  final List<ClubOption> clubs;
  final City? selectedCity;
  final ClubOption? selectedClub;
  final bool isLoadingCities;
  final bool isLoadingClubs;
  final String? errorMessage;

  /// The club dropdown is inert until a city is chosen — the cascade's rule,
  /// stated once.
  bool get isClubSelectionEnabled => selectedCity != null && !isLoadingClubs;

  ClubDirectoryState copyWith({
    List<City>? cities,
    List<ClubOption>? clubs,
    City? selectedCity,
    ClubOption? selectedClub,
    bool? isLoadingCities,
    bool? isLoadingClubs,
    String? errorMessage,
    bool clearSelectedClub = false,
    bool clearError = false,
  }) => ClubDirectoryState(
    cities: cities ?? this.cities,
    clubs: clubs ?? this.clubs,
    selectedCity: selectedCity ?? this.selectedCity,
    selectedClub: clearSelectedClub ? null : (selectedClub ?? this.selectedClub),
    isLoadingCities: isLoadingCities ?? this.isLoadingCities,
    isLoadingClubs: isLoadingClubs ?? this.isLoadingClubs,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  List<Object?> get props => [
    cities,
    clubs,
    selectedCity,
    selectedClub,
    isLoadingCities,
    isLoadingClubs,
    errorMessage,
  ];
}
