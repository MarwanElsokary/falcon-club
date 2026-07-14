import 'package:dio/dio.dart';
import 'package:falconclubapp/core/media/image_compressor.dart';
import 'package:falconclubapp/feature/auth/data/constants/auth_request_fields.dart';
import 'package:falconclubapp/feature/auth/data/models/registration_request_builder.dart';
import 'package:falconclubapp/feature/auth/domain/entities/club_option.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_details.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_fields.dart';
import 'package:falconclubapp/shared/domain/entities/gender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockImageCompressor extends Mock implements ImageCompressor {}

void main() {
  late _MockImageCompressor imageCompressor;
  late RegistrationRequestBuilder builder;

  const String clubGuid = '6bc273f8-17e2-45c4-a281-be27a1464273';
  const ClubOption club = ClubOption(id: clubGuid, name: 'نادي الهلال');

  RegistrationFields fieldsWith({String? photoPath}) =>
      RegistrationFields.create(
        firstName: 'مروان',
        lastName: 'ياسر',
        email: 'mmaasnnas@gmail.com',
        phone: '500000005',
        password: 'Str0ng!Pass',
        gender: Gender.male,
        photoPath: photoPath,
      ).getRight().toNullable()!;

  /// FormData exposes its scalar fields as (key, value) pairs.
  Map<String, String> fieldsOf(FormData form) => <String, String>{
    for (final MapEntry<String, String> entry in form.fields)
      entry.key: entry.value,
  };

  setUp(() {
    imageCompressor = _MockImageCompressor();
    builder = RegistrationRequestBuilder(imageCompressor);
  });

  group('club registration', () {
    // THE regression test for B1. The app currently makes the user pick a club,
    // blocks submission until they do, and then omits ClubId from the body.
    test('sends ClubId — the field the app drops today', () async {
      final FormData form = await builder.build(
        ClubRegistrationDetails(fields: fieldsWith(), club: club),
      );

      expect(fieldsOf(form)[AuthRequestFields.clubId], clubGuid);
    });

    test('sends every field the contract requires', () async {
      final Map<String, String> body = fieldsOf(
        await builder.build(
          ClubRegistrationDetails(fields: fieldsWith(), club: club),
        ),
      );

      expect(body[AuthRequestFields.firstName], 'مروان');
      expect(body[AuthRequestFields.lastName], 'ياسر');
      expect(body[AuthRequestFields.registrationEmail], 'mmaasnnas@gmail.com');
      expect(body[AuthRequestFields.phoneNumber], '500000005');
      expect(body[AuthRequestFields.password], 'Str0ng!Pass');
      expect(body[AuthRequestFields.gender], '0');
      expect(body[AuthRequestFields.clubId], clubGuid);
    });

    // B2: three call sites currently send three different junk values
    // ("ClubId", "1", "<phone>Id"). One named constant now.
    test('sends the single named FCM placeholder, not a junk value', () async {
      final Map<String, String> body = fieldsOf(
        await builder.build(
          ClubRegistrationDetails(fields: fieldsWith(), club: club),
        ),
      );

      expect(
        body[AuthRequestFields.fcmToken],
        AuthRequestFields.unlinkedFcmToken,
      );
      expect(body[AuthRequestFields.fcmToken], isNot('ClubId'));
      expect(body[AuthRequestFields.fcmToken], isNot('1'));
    });

    test('the phone is sent verbatim, with no country code added (B9)', () async {
      final Map<String, String> body = fieldsOf(
        await builder.build(
          ClubRegistrationDetails(fields: fieldsWith(), club: club),
        ),
      );

      expect(body[AuthRequestFields.phoneNumber], '500000005');
    });
  });

  group('scout registration', () {
    test('sends no ClubId — scout registration is club-less by design', () async {
      final FormData form = await builder.build(
        ScoutRegistrationDetails(fields: fieldsWith()),
      );

      expect(fieldsOf(form).containsKey(AuthRequestFields.clubId), isFalse);
    });

    test('sends the same FCM placeholder as club registration', () async {
      final Map<String, String> body = fieldsOf(
        await builder.build(ScoutRegistrationDetails(fields: fieldsWith())),
      );

      expect(
        body[AuthRequestFields.fcmToken],
        AuthRequestFields.unlinkedFcmToken,
      );
    });
  });

  group('photo', () {
    test('is omitted when the user picked none', () async {
      await builder.build(ScoutRegistrationDetails(fields: fieldsWith()));

      verifyNever(() => imageCompressor.toCompressedMultipart(any()));
    });

    test('is compressed via the injected compressor, not inline', () async {
      when(() => imageCompressor.toCompressedMultipart('/tmp/photo.jpg'))
          .thenAnswer(
        (_) async => MultipartFile.fromString('x', filename: 'p.jpg'),
      );

      final FormData form = await builder.build(
        ScoutRegistrationDetails(
          fields: fieldsWith(photoPath: '/tmp/photo.jpg'),
        ),
      );

      verify(() => imageCompressor.toCompressedMultipart('/tmp/photo.jpg'))
          .called(1);
      expect(form.files.map((e) => e.key), contains(AuthRequestFields.photo));
    });
  });
}
