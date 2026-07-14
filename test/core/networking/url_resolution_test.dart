import 'package:dio/dio.dart';
import 'package:falconclubapp/core/networking/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';

/// Proves what URL Dio *actually* builds for each endpoint.
///
/// No network call: `RequestOptions.uri` is pure, and it is the exact code Dio
/// runs to turn (baseUrl, path) into the request URL. Retrofit populates those
/// two fields from `@RestApi(baseUrl:)` and the `@POST(path)` annotation, so
/// this reproduces the real thing.
///
/// The question: the forgot-password constants start with a leading slash
/// (`'/Account/CheckOtp'`) while every other endpoint does not
/// (`'Account/LoginClub'`). If Dio resolved these the way `Uri.resolve` does,
/// the leading slash would discard the `/api/` base path and every
/// forgot-password call would 404.
void main() {
  Uri urlFor(String path) =>
      RequestOptions(baseUrl: ApiConstants.apiBaseUrl, path: path).uri;

  test('the base URL is what we think it is', () {
    expect(ApiConstants.apiBaseUrl, 'https://falconai.net/api/');
  });

  group('endpoints WITHOUT a leading slash (the app-wide convention)', () {
    test('resolve under /api/', () {
      expect(
        urlFor(ApiConstants.login).toString(),
        'https://falconai.net/api/Account/LoginClub',
      );
      expect(
        urlFor(ApiConstants.registerClub).toString(),
        'https://falconai.net/api/Account/RegisterClub',
      );
    });
  });

  group('endpoints WITH a leading slash (forgot-password)', () {
    // The decisive assertions. Swagger says the real paths are under /api/.
    test('checkOtp resolves under /api/ — the leading slash is absorbed', () {
      expect(
        urlFor(ApiConstants.checkOtp).toString(),
        'https://falconai.net/api/Account/CheckOtp',
      );
    });

    test('resetPassword resolves under /api/', () {
      expect(
        urlFor(ApiConstants.resetPassword).toString(),
        'https://falconai.net/api/Account/ResetPassword',
      );
    });

    test('forgetPasswordByPhone resolves under /api/', () {
      expect(
        urlFor(ApiConstants.forgetPasswordByPhone).toString(),
        'https://falconai.net/api/Account/ForgetPasswordByOtpPhone',
      );
    });
  });

  group('the two spellings are equivalent under Dio', () {
    test('leading slash and no leading slash produce the same URL', () {
      expect(
        urlFor('/Account/CheckOtp').toString(),
        urlFor('Account/CheckOtp').toString(),
      );
    });

    test('no /api/ segment is ever dropped', () {
      for (final String path in <String>[
        ApiConstants.checkOtp,
        ApiConstants.resetPassword,
        ApiConstants.forgetPasswordByPhone,
        ApiConstants.getTermsAndPolicies,
        ApiConstants.acceptClub,
      ]) {
        expect(
          urlFor(path).path,
          startsWith('/api/'),
          reason: '$path must resolve under /api/',
        );
      }
    });
  });
}
