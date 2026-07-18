import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/key_value_store.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/profile.dart';
import '../../../../shared/domain/entities/user_role.dart';
import '../../domain/entities/player_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/player_profile_model.dart';
import '../models/profile_model.dart';

/// [ProfileRepository] over the network.
///
/// **Not cached.** A profile is small, read on demand, and the coach edits their
/// own — serving a stale copy is the wrong default. (Entitlement caching for the
/// app-wide `SubscriptionReader` is a separate concern, handled where the
/// self-profile screen is wired in Phase 2.)
///
/// The self-profile's [role] is read from the stored session
/// ([StorageKeys.userRole] — the same key sign-in writes and the exercise
/// capability reads), because `Club/GetProfile` does not return one.
@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(
    this._remoteDataSource,
    this._store,
    this._errorMapper,
  );

  final ProfileRemoteDataSource _remoteDataSource;
  final KeyValueStore _store;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<Profile> getMyProfile() async {
    try {
      final Map<String, dynamic> body = await _remoteDataSource.fetchMyProfile();
      final UserRole role = UserRole.fromApiValue(
        _store.readString(StorageKeys.userRole),
      );
      return Right<Failure, Profile>(ProfileModel.fromJson(body, role: role));
    } catch (error) {
      return Left<Failure, Profile>(_errorMapper.map(error));
    }
  }

  @override
  ResultFuture<PlayerProfile> getPlayerProfile(String userId) async {
    try {
      final Map<String, dynamic> body = await _remoteDataSource
          .fetchPlayerProfile(userId);
      return Right<Failure, PlayerProfile>(PlayerProfileModel.fromJson(body));
    } catch (error) {
      return Left<Failure, PlayerProfile>(_errorMapper.map(error));
    }
  }
}
