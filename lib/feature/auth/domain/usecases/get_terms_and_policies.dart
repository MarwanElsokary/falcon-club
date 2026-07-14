import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/terms_repository.dart';

/// Loads the terms & privacy text for the signup screens.
@injectable
class GetTermsAndPolicies implements UseCaseWithoutInput<List<String>> {
  const GetTermsAndPolicies(this._repository);

  final TermsRepository _repository;

  @override
  ResultFuture<List<String>> call() => _repository.getTermsAndPolicies();
}
