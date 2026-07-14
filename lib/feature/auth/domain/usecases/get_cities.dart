import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/city.dart';
import '../repositories/club_directory_repository.dart';

/// Loads the city dropdown for Club registration.
///
/// SRP: one verb. Replaces `LoginCubit.loadCountries()`, which lives in a
/// 589-line cubit alongside login, three registration flows, OTP, image
/// compression, and JWT decoding.
@injectable
class GetCities implements UseCaseWithoutInput<List<City>> {
  const GetCities(this._repository);

  final ClubDirectoryRepository _repository;

  @override
  ResultFuture<List<City>> call() => _repository.getCities();
}
