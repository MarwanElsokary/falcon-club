import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/domain/entities/profile.dart';
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
  ProfileCubit(this._getMyProfile) : super(const ProfileInitial());

  final GetMyProfile _getMyProfile;

  Future<void> load() async {
    if (isClosed) return;
    emit(const ProfileLoading());

    final result = await _getMyProfile();
    if (isClosed) return;

    emit(
      result.match(
        (failure) => ProfileFailure(failure.message),
        (Profile profile) => ProfileLoaded(profile),
      ),
    );
  }
}
