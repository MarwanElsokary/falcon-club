import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/media/image_compressor.dart';
import '../../domain/entities/club_option.dart';
import '../../domain/entities/registration_details.dart';
import '../../domain/entities/registration_fields.dart';
import '../constants/auth_request_fields.dart';

/// Builds the multipart body for `RegisterClub` / `RegisterScout`.
///
/// SRP: the *only* place that knows the wire shape of a registration request.
///
/// ## The exhaustive switch is the point
///
/// [_clubFields] switches over the sealed [RegistrationDetails]. Dart checks it
/// for exhaustiveness, so introducing a third registration kind fails to compile
/// here until it is handled — which is the OCP-friendly replacement for
/// `if (role == 'Scout')` branching.
///
/// It is also what guarantees B1 cannot come back: the `ClubRegistrationDetails`
/// branch reads `details.club.id` into [AuthRequestFields.clubId], and the type
/// system already guaranteed the club is there.
@lazySingleton
class RegistrationRequestBuilder {
  const RegistrationRequestBuilder(this._imageCompressor);

  final ImageCompressor _imageCompressor;

  Future<FormData> build(RegistrationDetails details) async {
    final Map<String, dynamic> body = <String, dynamic>{
      ..._commonFields(details.fields),
      ..._clubFields(details),
    };
    final MultipartFile? photo = await _photoOf(details.fields);
    if (photo != null) body[AuthRequestFields.photo] = photo;
    return FormData.fromMap(body);
  }

  /// Shared by both registration kinds.
  ///
  /// Note `Email` really is an email here — unlike on `LoginClub`, where the
  /// same field name carries the phone number. Both misnomers are documented in
  /// [AuthRequestFields]; nothing above the data layer has to know.
  Map<String, dynamic> _commonFields(RegistrationFields fields) =>
      <String, dynamic>{
        // One named constant, three call sites — replaces the "ClubId" / "1" /
        // "<phone>Id" junk the app sends today (finding B2).
        AuthRequestFields.fcmToken: AuthRequestFields.unlinkedFcmToken,
        AuthRequestFields.firstName: fields.firstName,
        AuthRequestFields.lastName: fields.lastName,
        AuthRequestFields.registrationEmail: fields.email.value,
        AuthRequestFields.phoneNumber: fields.phone.value,
        AuthRequestFields.gender: fields.gender.apiValue,
        AuthRequestFields.password: fields.password.value,
      };

  /// The only difference between the two requests.
  Map<String, dynamic> _clubFields(RegistrationDetails details) =>
      switch (details) {
        ClubRegistrationDetails(:final ClubOption club) => <String, dynamic>{
          AuthRequestFields.clubId: club.id,
        },
        // Scout registration is club-less by design — confirmed with product.
        ScoutRegistrationDetails() => const <String, dynamic>{},
      };

  Future<MultipartFile?> _photoOf(RegistrationFields fields) async {
    final String? path = fields.photoPath;
    if (path == null || path.isEmpty) return null;
    return _imageCompressor.toCompressedMultipart(path);
  }
}
