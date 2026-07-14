import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/session_diagnostics.dart';
import '../repositories/session_repository.dart';

/// Reports what is in session storage, without revealing the token.
///
/// A debugging tool, not a product feature: call it to find out *why* the app
/// thinks someone is signed in.
@injectable
class DescribeSession implements UseCaseWithoutInput<SessionDiagnostics> {
  const DescribeSession(this._repository);

  final SessionRepository _repository;

  @override
  ResultFuture<SessionDiagnostics> call() => _repository.describeSession();
}
