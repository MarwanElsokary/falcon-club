import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/spacing.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/club_option.dart';
import '../cubit/club_directory_cubit.dart';
import '../cubit/club_directory_state.dart';
import 'searchable_dropdown.dart';

/// The city → club cascade.
///
/// Visually this is the original `SelectUniWidget` + `SelectCollageWidget`: same
/// searchable `DropdownButton2`, same `location_city` / `sports_soccer` icons,
/// same "اختر المدينة أولاً" disabled hint on the club dropdown, same styling.
///
/// The duplication is gone, though: those were two ~250-line `StatefulWidget`s
/// that shared all of their chrome and each mutated `LoginCubit`'s public
/// fields directly. Both now render through one [SearchableDropdown], and the
/// selection lives in [ClubDirectoryCubit] — which clears the chosen club when
/// the city changes, so a `ClubId` from a different city can never be submitted.
class CityClubSelectors extends StatelessWidget {
  const CityClubSelectors({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClubDirectoryCubit, ClubDirectoryState>(
      builder: (BuildContext context, ClubDirectoryState state) => Column(
        children: <Widget>[
          _cityDropdown(context, state),
          verticalSpace(16),
          _clubDropdown(context, state),
        ],
      ),
    );
  }

  Widget _cityDropdown(BuildContext context, ClubDirectoryState state) =>
      SearchableDropdown<City>(
        value: state.selectedCity,
        items: state.cities,
        labelOf: (City city) => city.name,
        onChanged: (City city) =>
            context.read<ClubDirectoryCubit>().selectCity(city),
        icon: Icons.location_city,
        hint: 'اختر المدينة'.tr(),
        disabledHint: 'اختر المدينة'.tr(),
        searchHint: 'ابحث عن مدينة...'.tr(),
        isLoading: state.isLoadingCities,
        isEnabled: !state.isLoadingCities,
      );

  Widget _clubDropdown(BuildContext context, ClubDirectoryState state) =>
      SearchableDropdown<ClubOption>(
        value: state.selectedClub,
        items: state.clubs,
        labelOf: (ClubOption club) => club.name,
        onChanged: (ClubOption club) =>
            context.read<ClubDirectoryCubit>().selectClub(club),
        icon: Icons.sports_soccer,
        hint: 'اختر النادي'.tr(),
        disabledHint: 'اختر المدينة أولاً'.tr(),
        searchHint: 'ابحث عن نادي...'.tr(),
        isLoading: state.isLoadingClubs,
        isEnabled: state.isClubSelectionEnabled,
      );
}
