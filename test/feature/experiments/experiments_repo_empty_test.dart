import 'package:dio/dio.dart';
import 'package:falconclubapp/core/networking/api_result.dart';
import 'package:falconclubapp/core/networking/api_service.dart';
import 'package:falconclubapp/feature/experiments/data/model/all_trials_model.dart';
import 'package:falconclubapp/feature/experiments/data/repo/experiments_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApiService extends Mock implements ApiService {}

/// A DioException shaped exactly like the live backend's empty-collection reply:
/// HTTP 400 with a body of `{"message": "<msg>"}` and no `status_code`.
DioException _badRequest(String message) {
  final RequestOptions options = RequestOptions(path: '/club/GetAllTrials');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: 400,
      data: <String, dynamic>{'message': message},
    ),
  );
}

/// Bug C: `GetAllTrials` answers "no trials" with **400 + "No Trials Found"** —
/// an empty collection, not a failure. Treated as an error it fell through to
/// the screen's loading spinner, so an empty result looked like a screen stuck
/// loading. The repo must turn that one specific shape into an empty list while
/// still surfacing genuine failures.
void main() {
  late _MockApiService api;
  late ExperimentsRepo repo;

  setUp(() {
    api = _MockApiService();
    repo = ExperimentsRepo(api);
  });

  Future<ApiResult<AllTrialsModel>> fetch() =>
      repo.allTrials(categoryId: '', popular: 'false');

  T fold<T>(
    ApiResult<AllTrialsModel> result, {
    required T Function(AllTrialsModel) onSuccess,
    required T Function() onFailure,
  }) => result.when(
    success: onSuccess,
    failure: (_) => onFailure(),
  );

  test('400 "No Trials Found" becomes an empty list, not a failure', () async {
    when(
      () => api.allTrials(any(), any()),
    ).thenThrow(_badRequest('No Trials Found'));

    final ApiResult<AllTrialsModel> result = await fetch();

    final AllTrialsModel model = fold(
      result,
      onSuccess: (AllTrialsModel m) => m,
      onFailure: () => fail('a "No Trials Found" 400 must be an empty success'),
    );
    expect(model.data, isEmpty);
  });

  // The detector keys on the backend's convention, not the literal word
  // "Trials", so the same fix covers "No Exercises Found" etc. if reused.
  test('any 400 "No … Found" message is treated as empty', () async {
    when(
      () => api.allTrials(any(), any()),
    ).thenThrow(_badRequest('No Exercises Found'));

    final ApiResult<AllTrialsModel> result = await fetch();

    expect(
      fold(result, onSuccess: (_) => true, onFailure: () => false),
      isTrue,
    );
  });

  test('a genuine 400 (a different message) is STILL a failure', () async {
    when(
      () => api.allTrials(any(), any()),
    ).thenThrow(_badRequest('Invalid category id'));

    final ApiResult<AllTrialsModel> result = await fetch();

    expect(
      fold(result, onSuccess: (_) => false, onFailure: () => true),
      isTrue,
      reason: 'not the empty-collection shape — must surface as an error',
    );
  });

  test('a 500 is a failure, never an empty list', () async {
    final RequestOptions options = RequestOptions(path: '/club/GetAllTrials');
    when(() => api.allTrials(any(), any())).thenThrow(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 500,
          data: <String, dynamic>{'message': 'Internal Server Error'},
        ),
      ),
    );

    final ApiResult<AllTrialsModel> result = await fetch();

    expect(
      fold(result, onSuccess: (_) => false, onFailure: () => true),
      isTrue,
    );
  });

  test('a successful response passes straight through', () async {
    when(() => api.allTrials(any(), any())).thenAnswer(
      (_) async => AllTrialsModel(
        message: 'Success',
        data: <AllTrialsList>[AllTrialsList.fromJson(<String, dynamic>{'id': 7})],
      ),
    );

    final ApiResult<AllTrialsModel> result = await fetch();

    final AllTrialsModel model = fold(
      result,
      onSuccess: (AllTrialsModel m) => m,
      onFailure: () => fail('a 200 must succeed'),
    );
    expect(model.data, hasLength(1));
  });
}
