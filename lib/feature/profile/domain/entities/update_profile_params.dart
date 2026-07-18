import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/gender.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';

/// The fields `Club/UpdateProfile` accepts (multipart/form-data).
///
/// [gender] is a domain [Gender], written to the wire as its **int**
/// `apiValue` — the deliberate asymmetry of this endpoint: gender is *written*
/// as an int (0/1) but *read back* as an Arabic string. [phone] is a validated
/// [PhoneNumber] value object, so an invalid number cannot reach this far.
///
/// [imagePath] is a newly-picked local file, or `null` to keep the current
/// photo — the data source sends the `Photo` part only when it is present, so a
/// coach who edits their name without touching the picture keeps it.
final class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.gender,
    this.imagePath,
  });

  final String firstName;
  final String lastName;
  final PhoneNumber phone;
  final Gender gender;
  final String? imagePath;

  @override
  List<Object?> get props => <Object?>[
    firstName,
    lastName,
    phone,
    gender,
    imagePath,
  ];
}
