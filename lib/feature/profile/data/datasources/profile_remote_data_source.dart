import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';

/// The one place the profile feature talks to the network.
///
/// Returns the decoded response body (not an entity). Mapping to entities lives
/// in the repository, next to the error translation — the data source's single
/// responsibility is transport. Goes through the shared `ApiService` (Retrofit
/// over the configured `Dio`); no bare `Dio()`, no cache reads.
abstract interface class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> fetchMyProfile();

  Future<Map<String, dynamic>> fetchPlayerProfile(String userId);

  /// PUTs `Club/UpdateProfile` as multipart. [genderApiValue] is the int the
  /// endpoint wants (0/1); [imagePath] is sent as the `Photo` part only when
  /// non-null, so an unchanged photo is left alone.
  Future<void> updateMyProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int genderApiValue,
    String? imagePath,
  });
}

@LazySingleton(as: ProfileRemoteDataSource)
class RetrofitProfileRemoteDataSource implements ProfileRemoteDataSource {
  const RetrofitProfileRemoteDataSource(this._apiService);

  final ApiService _apiService;

  @override
  Future<Map<String, dynamic>> fetchMyProfile() async =>
      Json.asObject(await _apiService.getProfileRaw());

  @override
  Future<Map<String, dynamic>> fetchPlayerProfile(String userId) async {
    // A blank id would ask the backend for "profile of nobody". Refuse before
    // it reaches the wire.
    if (userId.isEmpty) {
      throw const ServerException(message: FailureMessages.resourceNotFound);
    }
    return Json.asObject(await _apiService.getProfileByIdRaw(userId));
  }

  @override
  Future<void> updateMyProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int genderApiValue,
    String? imagePath,
  }) async {
    final Map<String, dynamic> fields = <String, dynamic>{
      'FirstName': firstName,
      'LastName': lastName,
      'PhoneNumber': phone,
      'Gender': genderApiValue,
    };

    if (imagePath != null && imagePath.isNotEmpty) {
      fields['Photo'] = await MultipartFile.fromFile(
        imagePath,
        filename: 'photo.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
    }

    await _apiService.clubUpdateProfile(FormData.fromMap(fields));
  }
}
