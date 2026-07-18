class ClubTrainee {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? accountNumber;
  final String? photoPath;
  final String? gender;

  const ClubTrainee({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.accountNumber,
    this.photoPath,
    this.gender,
  });

  factory ClubTrainee.fromJson(Map<String, dynamic> json) {
    return ClubTrainee(
      // Tolerant: the backend sends `id` as a number on some endpoints (as
      // ClubPlayer already handles). Coerce instead of `as String`, which threw
      // and dropped the whole trainees list to a generic error.
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      accountNumber: json['accountNumber'] as String?,
      photoPath: json['photoPath'] as String?,
      gender: json['gender'] as String?,
    );
  }
}