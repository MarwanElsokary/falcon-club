import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/repositories/terms_repository.dart';
import '../datasources/terms_remote_data_source.dart';

@LazySingleton(as: TermsRepository)
class TermsRepositoryImpl implements TermsRepository {
  const TermsRepositoryImpl(this._remoteDataSource, this._errorMapper);

  final TermsRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<List<String>> getTermsAndPolicies() async {
    try {
      final List<String> paragraphs = await _remoteDataSource
          .fetchTermsAndPolicies();
      return Right<Failure, List<String>>(paragraphs);
    } catch (error) {
      return Left<Failure, List<String>>(_errorMapper.map(error));
    }
  }
}
