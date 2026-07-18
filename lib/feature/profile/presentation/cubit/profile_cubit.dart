import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/domain/entities/profile.dart';
import '../../domain/profile_cache.dart';
import '../../domain/usecases/get_my_profile.dart';
import 'profile_state.dart';

/// Drives a self-profile screen (Coach / MainClub) over the domain.
///
/// Replaces the display half of `ClubTeamCubit.emitMyProfile`, which fetched the
/// current user through the untyped `MyProfileModel` and cached it inline. This
/// depends only on [GetMyProfile] (DIP) and emits the domain [Profile]. The
/// entitlement cache the app-wide `SubscriptionReader` reads is kept fresh by
/// the shells' `emitMyProfile`, so this cubit does not write it.
@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getMyProfile, this._cache)
    : super(const ProfileInitial());

  final GetMyProfile _getMyProfile;
  final ProfileCache _cache;

  /// Stale-while-revalidate: show the last-loaded profile instantly (so a
  /// freshly-provided cubit — e.g. the drawer's, recreated on every open —
  /// doesn't flash blank), then refresh behind it. Only a cold cache shows the
  /// loading state, and a refresh failure keeps the stale profile on screen.
  Future<void> load() async {
    if (isClosed) return;

    final Profile? cached = _cache.value;
    emit(cached != null ? ProfileLoaded(cached) : const ProfileLoading());

    final result = await _getMyProfile();
    if (isClosed) return;

    result.match(
      (failure) {
        if (cached == null) emit(ProfileFailure(failure.message));
      },
      (Profile profile) {
        _cache.save(profile);
        // Deduped by Equatable when nothing changed — no needless rebuild.
        emit(ProfileLoaded(profile));
      },
    );
  }
}
