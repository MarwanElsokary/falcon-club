import '../../../../core/usecase/usecase.dart';
import '../entities/trial.dart';

/// Reads trials (تجارب) — themed collections of exercises.
abstract interface class TrialRepository {
  ResultFuture<Trial> getTrialDetails(String trialId);
}
