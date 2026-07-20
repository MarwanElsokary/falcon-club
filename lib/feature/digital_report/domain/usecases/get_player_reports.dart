import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/digital_report.dart';
import '../repositories/digital_reports_repository.dart';

/// Loads a player's report history (`Club/PlayerDigitalReports`).
@injectable
class GetPlayerReports implements UseCase<List<DigitalReport>, String> {
  const GetPlayerReports(this._repository);

  final DigitalReportsRepository _repository;

  @override
  ResultFuture<List<DigitalReport>> call(String playerId) =>
      _repository.getReports(playerId);
}
