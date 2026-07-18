import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/profile.dart';
import '../entities/player_profile.dart';

/// Reads profiles.
///
/// Two shapes, two endpoints:
///
/// * [getMyProfile] — the **current user** (`Club/GetProfile`), a lean account
///   record. The role is not in the payload; the implementation resolves it from
///   the stored session.
/// * [getPlayerProfile] — a **viewed player** (`Player/GetProfileById`), the rich
///   record with physical attributes, club and measurements.
///
/// Replaces the borrowed god-cubit path (`MainCubit.emitMyProfile` /
/// `emitProfileById` / `ClubTeamCubit.emitMyProfile`), which fetched both through
/// the same untyped `MyProfileModel` with no domain boundary.
abstract interface class ProfileRepository {
  ResultFuture<Profile> getMyProfile();

  ResultFuture<PlayerProfile> getPlayerProfile(String userId);
}
