import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/update_profile_params.dart';
import '../repositories/profile_repository.dart';

/// Saves the current user's own profile (`Club/UpdateProfile`).
///
/// Success carries no value — the screen re-fetches through [ProfileRepository]
/// .getMyProfile so the display always reflects what the server actually stored,
/// rather than trusting the request echo.
@injectable
class UpdateMyProfile implements UseCase<Unit, UpdateProfileParams> {
  const UpdateMyProfile(this._repository);

  final ProfileRepository _repository;

  @override
  ResultFuture<Unit> call(UpdateProfileParams params) =>
      _repository.updateMyProfile(params);
}
