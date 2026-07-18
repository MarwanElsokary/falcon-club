import 'package:injectable/injectable.dart';

import '../../../shared/domain/entities/profile.dart';

/// The last successfully-loaded [Profile] for this session, in memory.
///
/// The drawer provides a fresh [ProfileCubit] on every open (a `getIt` factory),
/// so without this each open started from nothing and flashed blank until the
/// network answered. As a `@lazySingleton` this outlives those per-open cubits:
/// [ProfileCubit.load] shows [value] instantly and revalidates behind it
/// (stale-while-revalidate). No TTL — the fetch always runs; this only removes
/// the visible gap while it does.
@lazySingleton
class ProfileCache {
  Profile? _profile;

  Profile? get value => _profile;

  void save(Profile profile) => _profile = profile;
}
