import 'package:injectable/injectable.dart';

import '../../../../core/networking/api_service.dart';

/// Fetches the terms & privacy copy.
abstract interface class TermsRemoteDataSource {
  Future<List<String>> fetchTermsAndPolicies();
}

/// The endpoint returns an untyped body — sometimes a list of paragraphs,
/// sometimes a single string. `LoginCubit.getTermsAndPolicies()` handles both
/// shapes today; this preserves that tolerance rather than tightening it and
/// risking an empty dialog.
@LazySingleton(as: TermsRemoteDataSource)
class RetrofitTermsRemoteDataSource implements TermsRemoteDataSource {
  const RetrofitTermsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<String>> fetchTermsAndPolicies() async {
    final response = await _apiService.getTermsAndPolicies();
    return _asParagraphs(response);
  }

  List<String> _asParagraphs(Object? body) => switch (body) {
    List<Object?> items => items
        .map((Object? item) => item?.toString() ?? '')
        .where((String paragraph) => paragraph.isNotEmpty)
        .toList(growable: false),
    String single when single.isNotEmpty => <String>[single],
    _ => const <String>[],
  };
}
