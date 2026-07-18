import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/profile.dart';
import '../repositories/profile_repository.dart';

/// Loads the current user's own profile (`Club/GetProfile`).
@injectable
class GetMyProfile implements UseCaseWithoutInput<Profile> {
  const GetMyProfile(this._repository);

  final ProfileRepository _repository;

  @override
  ResultFuture<Profile> call() => _repository.getMyProfile();
}
