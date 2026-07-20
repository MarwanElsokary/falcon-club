import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/digital_reports_repository.dart';

/// Removes a report (`Dashboard/DeleteDigitalReport`).
@injectable
class DeleteDigitalReport implements UseCase<Unit, int> {
  const DeleteDigitalReport(this._repository);

  final DigitalReportsRepository _repository;

  @override
  ResultFuture<Unit> call(int reportId) => _repository.deleteReport(reportId);
}
