import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/trial.dart';
import '../repositories/trial_repository.dart';

/// Loads a trial and the exercises it contains.
@injectable
class GetTrialDetails implements UseCase<Trial, String> {
  const GetTrialDetails(this._repository);

  final TrialRepository _repository;

  @override
  ResultFuture<Trial> call(String trialId) =>
      _repository.getTrialDetails(trialId);
}
